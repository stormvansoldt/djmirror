import QtQuick
import QtQuick.Window 2.15
import Qt5Compat.GraphicalEffects

// Vista para configurar y gestionar plugins
Rectangle {
    id: pluginSettings

    // Propiedades
    property var pluginManager: null
    property bool isActive: false
    
    property real screenScale: prefs.screenScale

    color: colors.colorBlack
    
    // Señales
    signal exitSettings()
    
    // Añadir consola para depuración
    Rectangle {
        id: debugConsole
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        height: 100 * screenScale
        color: "#000000"
        border.color: "#444444"
        border.width: 1 * screenScale
        clip: false // true
        
        Text {
            id: consoleText
            anchors.fill: parent
            anchors.margins: 5 * screenScale
            color: "#00FF00"
            font.family: "Consolas"
            font.pixelSize: 10 * screenScale
            text: "Estado de plugins:\n" + 
                  "     Plugins cargados: " + (pluginList ? pluginList.count : 0) + "\n" + 
                  "     Ruta de plugins: " + (pluginManager ? pluginManager.pluginsPath : "No disponible")
        }
    }
    
    // Fondo principal
    Rectangle {
        id: background
        anchors.fill: parent
        anchors.bottomMargin: debugConsole.height * screenScale
        color: colors.colorBlack
        opacity: 0.95
    }
    
    // Cabecera
    Rectangle {
        id: header
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        height: 40 * screenScale
        color: colors.colorBgEmpty
        
        Text {
            id: headerText
            text: "Plugins configuration"
            anchors.centerIn: parent
            font.family: font.fontFamily
            font.pixelSize: 18 * screenScale
            color: colors.colorWhite
        }
        
        // Botón para volver
        Rectangle {
            id: backButton
            width: 80 * screenScale
            height: 30 * screenScale
            radius: 4 * screenScale
            color: colors.colorBgEmpty
            border.width: 1 * screenScale
            border.color: colors.colorOrange
            
            anchors.right: parent.right
            anchors.rightMargin: 10 * screenScale
            anchors.verticalCenter: parent.verticalCenter
            
            Text {
                text: "Back"
                anchors.centerIn: parent
                font.family: font.fontFamily
                font.pixelSize: 14 * screenScale
                color: colors.colorWhite
            }
            
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    exitSettings();
                }
            }
        }
    }
    
    // Lista de plugins
    ListView {
        id: pluginList
        anchors.top: header.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        spacing: 6 * screenScale
        clip: false // true
        
        model: pluginManager ? pluginManager.getLoadedPluginsInfo() : []
        
        delegate: Rectangle {
            width: pluginList.width
            height: 70 * screenScale
            radius: 6 * screenScale
            color: colors.colorBgEmpty
            border.width: 1 * screenScale
            border.color: colors.colorGrayContrast
            
            // Información del plugin
            Column {
                anchors.left: parent.left
                anchors.top: parent.top
                anchors.right: toggleSwitch.left
                anchors.margins: 6 * screenScale
                spacing: 1 * screenScale
                
                Text {
                    text: modelData.name
                    font.family: font.fontFamily
                    font.pixelSize: 12 * screenScale
                    font.bold: true
                    color: colors.colorWhite
                }

                Text {
                    text: "File name: " + modelData.fileName
                    font.family: font.fontFamily
                    font.pixelSize: 8 * screenScale
                    color: colors.colorWhite
                }

                Text {
                    text: "Version: " + modelData.version
                    font.family: font.fontFamily
                    font.pixelSize: 8 * screenScale
                    color: colors.colorWhite
                }
                
                Text {
                    text: "Author: " + modelData.author
                    font.family: font.fontFamily
                    font.pixelSize: 8 * screenScale
                    color: colors.colorWhite
                }
            }
            
            // Switch para activar/desactivar
            Rectangle {
                id: toggleSwitch
                width: 60 * screenScale
                height: 30 * screenScale
                radius: 15 * screenScale
                color: pluginManager && pluginManager.isPluginLoaded(modelData.fileName) ? colors.colorGreen : colors.colorRed
                
                anchors.right: parent.right
                anchors.rightMargin: 15
                anchors.verticalCenter: parent.verticalCenter
                
                Rectangle {
                    width: 26 * screenScale
                    height: 26 * screenScale
                    radius: 13 * screenScale
                    color: colors.colorWhite
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    anchors.leftMargin: pluginManager && pluginManager.isPluginLoaded(modelData.fileName) ? 30 * screenScale : 4 * screenScale
                    
                    Behavior on anchors.leftMargin {
                        NumberAnimation { duration: 150 }
                    }
                }
                
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        if (pluginManager.isPluginLoaded(modelData.fileName)) {
                            pluginManager.unloadPlugin(modelData.fileName);
                        } else {
                            pluginManager.loadPlugin(modelData.fileName);
                        }

                        // Actualizar la vista
                        pluginList.model = pluginManager.getPluginsInfo();
                    }
                }
            }
        }
        
        // Mensaje cuando no hay plugins
        Text {
            anchors.centerIn: parent
            text: "No hay plugins cargados"
            font.family: font.fontFamily
            font.pixelSize: 16 * screenScale
            color: colors.colorGray
            visible: pluginList.count === 0
        }
    }
    
    // Botón para recargar plugins
    Rectangle {
        id: reloadButton
        width: 160 * screenScale
        height: 40 * screenScale
        radius: 6 * screenScale
        color: colors.colorOrange
        
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 20 * screenScale
        
        Text {
            text: "Recargar Plugins"
            anchors.centerIn: parent
            font.family: font.fontFamily
            font.pixelSize: 14 * screenScale
            color: colors.colorWhite
        }
        
        MouseArea {
            anchors.fill: parent
            onClicked: {
                if (pluginManager) {
                    prefs.log("INFO", "Desactivando todos los plugins");
                    pluginManager.unloadAllPlugins();
                    prefs.log("INFO", "Cargando todos los plugins");
                    pluginManager.loadAllPlugins();
                    prefs.log("INFO", "Finalizado el recargado de todos los plugins");

                    // Actualizar la vista
                    pluginList.model = pluginManager.getLoadedPluginsInfo();
                    prefs.log("INFO", "Finalizado el recargado de todos los plugins");

                }
            }
        }
    }
    
    // Al mostrar la vista, actualizar la lista
    onVisibleChanged: {
        if (visible && pluginManager) {
            prefs.log("INFO", "Actualizando lista de plugins");
            pluginList.model = pluginManager.getPluginsInfo();
        }
    }
} 