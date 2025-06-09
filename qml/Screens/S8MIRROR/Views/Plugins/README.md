# Sistema de Plugins para Traktor Pro 4

Este sistema permite extender la funcionalidad de las pantallas de Traktor Pro 4 mediante plugins personalizados.

## Estructura de directorios

```
Screens/
├─ S8MIRROR/
│ ├─ Views/
│ │ └─ Plugins/ # Directorio principal de plugins
│ │ ├─ PluginManager.qml # Gestor del sistema de plugins
│ │ ├─ PluginSettings.qml # Vista de configuración de plugins
│ │ └─ ExamplePlugin/ # Plugin de ejemplo
│ │ ├─ Plugin.qml # Implementación del plugin
│ │ └─ PluginOverlay.qml # Componentes visuales del plugin
│ └─ TuPlugin/ # Tu plugin personalizado
│ ├─ Plugin.qml # Implementación principal
│ └─ ... # Otros archivos del plugin
```

## Cómo crear un plugin

Para crear un plugin, sigue estos pasos:

1. Crea una carpeta para tu plugin en `Screens/S8MIRROR/Views/Plugins/TuPlugin/`
2. Crea un archivo `Plugin.qml` que implemente la estructura base de un plugin
3. Opcionalmente, crea un `PluginOverlay.qml` para la interfaz visual
4. Añade los componentes visuales y funcionales necesarios

### Ejemplo básico

```qml
import QtQuick
import QtQuick.Window 2.15

// Mi plugin personalizado
QtObject {
    id: miPlugin
    
    // Información del plugin (requerido)
    property string name: "Mi Plugin"
    property string version: "1.0.0"
    property string author: "Tu Nombre"
    property string description: "Descripción de tu plugin"
    
    // Estado (requerido)
    property bool isEnabled: true
    property bool isInitialized: false
    
    // Referencias importantes
    property var currentView: null
    property var overlayInstance: null
    property var prefs: null
    property real screenScale: 1.0
    
    // Se llama al cargar el plugin
    function onLoad() {
        prefs.log("INFO", "[" + name + "] Plugin cargado");
    }
    
    // Se llama al inicializar el plugin en una vista
    function initializeInView(view) {
        if (!view) return;
        
        currentView = view;
        
        try {
            // Cargar el overlay si existe
            var component = Qt.createComponent("PluginOverlay.qml");
            if (component.status === Component.Ready) {
                overlayInstance = component.createObject(currentView, {
                    "screenScale": screenScale
                });
                isInitialized = true;
            }
        } catch (e) {
            prefs.log("ERROR", "[" + name + "] Error al inicializar: " + e);
        }
    }
    
    // Se llama al descargar el plugin
    function onUnload() {
        if (overlayInstance) {
            overlayInstance.destroy();
            overlayInstance = null;
        }
        isInitialized = false;
        prefs.log("INFO", "[" + name + "] Plugin descargado");
    }
}
```

## Ciclo de vida de un plugin

1. **Carga**: El `PluginManager` carga los plugins disponibles al iniciar o cuando se solicita
2. **Inicialización**: Cada plugin se inicializa en la vista activa con `initializeInView()`
3. **Ejecución**: El plugin responde a eventos y realiza su funcionalidad
4. **Descarga**: Al desactivar el plugin o mediante el gestor, se llama a `onUnload()`

## Gestión de plugins

Los plugins se pueden gestionar desde la interfaz de configuración (`PluginSettings.qml`):

- Ver plugins instalados y su estado
- Activar/desactivar plugins individualmente
- Recargar todos los plugins
- Ver información detallada de cada plugin

## Mejores prácticas

- Usa `Qt.createComponent()` para cargar componentes dinámicamente
- Organiza tu código en archivos separados para mantenerlo limpio
- Asegúrate de liberar recursos en `onUnload()`
- Usa el sistema de logging a través de `prefs.log()`
- Maneja correctamente los errores en la carga e inicialización
- Adapta tu interfaz usando la propiedad `screenScale`

## Ejemplos incluidos

- **ExamplePlugin**: Plugin de ejemplo que muestra información del deck actual
  - Implementa un overlay interactivo
  - Demuestra el uso de efectos visuales
  - Muestra cómo manejar eventos y actualizaciones
  - Incluye animaciones y efectos visuales

## Limitaciones

- Los plugins se cargan en tiempo de ejecución
- Las funcionalidades disponibles están limitadas al contexto de QML
- Los plugins deben ser compatibles con la versión actual de Traktor Pro 4
- El rendimiento debe ser considerado, especialmente en overlays complejos 