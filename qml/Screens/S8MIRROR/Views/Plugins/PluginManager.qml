import QtQuick
import QtQuick.Window 2.15
import CSI 1.0

// Sistema de gestión de plugins para Traktor Pro 4
// Permite cargar plugins dinámicamente desde la carpeta Plugins

QtObject {
    id: pluginManager
    
    // Propiedades del sistema de plugins
    property var loadedPlugins: []
    property bool pluginsEnabled: true
    property int updateCounter: 0  // Contador para forzar actualizaciones de interfaz

    property real screenScale: 1.0

    // Ruta de plugins
    property string pluginsPath: "./Plugins"  // La ruta relativa puede ser problemática
    
    // Función para inicializar la ruta de plugins
    function initializePluginPath(baseViewPath) {
        if (baseViewPath && baseViewPath !== "") {
            // Simplificamos la ruta para evitar problemas de resolución
            pluginsPath = baseViewPath;
            prefs.log("INFO", "Ruta de plugins simplificada: " + pluginsPath);
            return true;
        }
        prefs.log("INFO", "Error: No se pudo inicializar la ruta de plugins");
        return false;
    }
    
    // Función para cargar todos los plugins disponibles
    function loadAllPlugins() {
        prefs.log("INFO", "Cargando todos los plugins");
        if (!pluginsEnabled) {
            prefs.log("INFO", "Plugins desactivados");
            return 0;
        }
        
        var availablePlugins = getPluginsInfo();

        var pluginsLoaded = 0;
        
        prefs.log("INFO", "Intentando cargar " + availablePlugins.length + " plugins");
        
        for (var i = 0; i < availablePlugins.length; i++) {
            var pluginName = availablePlugins[i].fileName;
            prefs.log("INFO", "Intentando cargar plugin (" + (i+1) + "/" + availablePlugins.length + "): " + pluginName);
            
            if (loadPlugin(pluginName)) {
                pluginsLoaded++;
                prefs.log("INFO", "Plugin cargado con éxito: " + pluginName);
            } else {
                prefs.log("ERROR", "Fallo al cargar plugin: " + pluginName);
            }
        }
        
        prefs.log("INFO", "Total de plugins cargados: " + pluginsLoaded + " de " + availablePlugins.length);
        return pluginsLoaded;
    }
    
    // Cargar un plugin específico
    function loadPlugin(pluginName) {
        // Cargar el plugin directamente usando resolvedUrl
        try {
            // Usar ruta relativa simple sin duplicados
            var pluginPath = "" + pluginName + "/Plugin.qml";
            prefs.log("INFO", "Intentando cargar plugin con ruta: " + pluginPath);
            
            // Crear el componente
            var component = Qt.createComponent(pluginPath);
            
            if (component.status === Component.Ready) {
                // Crear instancia del plugin
                var plugin = component.createObject(null);
                
                if (plugin) {
                    // Configurar propiedades del plugin
                    plugin.prefs = prefs;
                    plugin.screenScale = pluginManager.screenScale;
                            
                    // Ejecutar método onLoad
                    if (typeof plugin.onLoad === "function") {
                        plugin.onLoad();
                    }
                    
                    // Inicializar en la vista con posición mejorada
                    if (typeof plugin.initializeInView === "function") {
                        plugin.initializeInView(mirrorWindow);
                        prefs.log("INFO", "Plugin inicializado en vista correctamente");

                        // Añadir el plugin al array de plugins cargados
                        loadedPlugins.push({
                            name: plugin.name || "Unknown",
                            instance: plugin,
                            version: plugin.version || "1.0",
                            author: plugin.author || "Unknown",
                            fileName: plugin.fileName || "Unknown",
                            description: plugin.description || "Unknown"
                        });
                        
                        return true;
                    }
                } else {
                    prefs.log("ERROR", "No se pudo crear instancia del plugin");
                }
            } else if (component.status === Component.Error) {
                prefs.log("ERROR", "Error al cargar componente: " + component.errorString());
            }
        } catch (e) {
            prefs.log("ERROR", "Excepción al cargar plugin manualmente: " + e);
        }

        return false;
    }
    
    // Inicializar un plugin específico en una vista
    function initializePluginInView(pluginName, view) {
        prefs.log("INFO", "Inicializando plugin en vista: " + pluginName);

        for (var i = 0; i < loadedPlugins.length; i++) {
            var plugin = loadedPlugins[i];
            if (plugin.fileName === pluginName) {
                if (typeof plugin.instance.initializeInView === "function") {
                    plugin.instance.initializeInView(view);
                    return true;
                }
            }
        }
        return false;
    }
    
    // Inicializar todos los plugins en una vista
    function initializeAllPluginsInView(view) {
        prefs.log("INFO", "Inicializando todos los plugins en vista: " + view);
        if (!view) {
            return 0;
        }
        
        var count = 0;
        
        if (loadedPlugins.length === 0) {
            return 0;
        }
        
        for (var i = 0; i < loadedPlugins.length; i++) {
            var plugin = loadedPlugins[i];
     
            if (typeof plugin.instance.initializeInView === "function") {
                try {
                    plugin.instance.initializeInView(view);
                    count++;
                } catch (e) {
                    prefs.log("ERROR", "Error al inicializar plugin en vista: " + e);
                }
            } else {
                prefs.log("ERROR", "El plugin " + plugin.fileName + " no tiene el método initializeInView");
            }
        }

        return count;
    }
    
    // Descargar un plugin específico
    function unloadPlugin(pluginName) {
        prefs.log("INFO", "Descargando plugin: " + pluginName);

        for (var i = 0; i < loadedPlugins.length; i++) {
            var plugin = loadedPlugins[i];
            if (plugin.fileName === pluginName) {
                if (typeof plugin.instance.onUnload === "function") {
                    plugin.instance.onUnload();
                }
                loadedPlugins.splice(i, 1);
                return true;
            }
        }
        return false;
    }
    
    // Descargar todos los plugins
    function unloadAllPlugins() {
        prefs.log("INFO", "Descargando todos los plugins");

        for (var i = 0; i < loadedPlugins.length; i++) {
            var plugin = loadedPlugins[i];
            if (typeof plugin.instance.onUnload === "function") {
                plugin.instance.onUnload();
            }
        }
        loadedPlugins = [];
    }
    
    // Obtener información de un plugin por nombre
    function getPluginInfo(pluginName) {
        prefs.log("INFO", "Obteniendo información del plugin: " + pluginName);
        for (var i = 0; i < loadedPlugins.length; i++) {
            if (loadedPlugins[i].fileName === pluginName) {
                return loadedPlugins[i];
            }
        }

        return null;
    }
    
    // Verificar si un plugin está cargado
    function isPluginLoaded(pluginName) {
        prefs.log("INFO", "Verificando si el plugin está cargado: " + pluginName);

        return getPluginInfo(pluginName) !== null;
    }
    
    // Obtener lista de todos los plugins cargados
    function getLoadedPluginsInfo() {
        prefs.log("INFO", "Obteniendo lista de plugins cargados");
        var info = [];
        for (var i = 0; i < loadedPlugins.length; i++) {
            info.push({
                name: loadedPlugins[i].name,
                version: loadedPlugins[i].version,
                author: loadedPlugins[i].author,
                fileName: loadedPlugins[i].fileName,
                description: loadedPlugins[i].description
            });
        }
        prefs.log("INFO", "Plugins cargados: " + loadedPlugins.length);
        prefs.log("INFO", "Información de plugins: " + JSON.stringify(info));
        return info;
    }

    // Obtener lista de plugins (cargados y no cargados)
    function getPluginsInfo() {
        // TODO: Leer desde prefs.plugins.list

        // Lista simplificada de plugins para probar
        var availablePlugins = [ 
            {
                name: "Example Plugin 1",
                version: "0.0.0",
                author: "Unloaded",
                fileName: "ExamplePlugin",
                description: "Example plugin for testing"
            },
        ];

        // Buscamos los plugins cargados y los reemplazamos por los no cargados
        for (var i = 0; i < loadedPlugins.length; i++) {
            for (var j = 0; j < availablePlugins.length; j++) {
                if (loadedPlugins[i].fileName === availablePlugins[j].fileName) {
                    availablePlugins[j] = loadedPlugins[i];
                }
            }
        }

        return availablePlugins;
    }

    // Aumentar contador para forzar actualización
    function forceUpdate() {
        prefs.log("INFO", "Forzando actualización de plugins");

        updateCounter++;

        prefs.log("INFO", "Forzando actualización de plugins: " + updateCounter);

        return updateCounter;
    }
} 