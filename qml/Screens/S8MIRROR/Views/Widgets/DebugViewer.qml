import QtQuick
import QtQuick.Window 2.15
import Qt5Compat.GraphicalEffects

// Componente para mostrar los logs de depuración de prefs.debugResult
Rectangle {
    id: debugViewer
    
    // Propiedades requeridas
    required property real screenScale
    
    // Propiedades configurables
    property int maxHeight: 200 * screenScale
    property int minHeight: 30 * screenScale
    property bool autoHide: true
    property int autoHideDelay: 5000
    property bool pinned: false  // Si está fijado, no se ocultará automáticamente
    property bool showMinimized: false // Determina si se muestra o no la barra minimizada
    
    // Colores
    property color backgroundColor: "#1A1A1A"
    property color borderColor: "#333333"
    property color textColor: "#FFFFFF"
    property color headerColor: "#555555"
    
    // Estado interno
    property bool expanded: false // Iniciar contraído
    
    // Posicionamiento y estilo
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.bottom: parent.bottom
    height: expanded ? Math.min(contentColumn.height + (50 * screenScale), maxHeight) : (showMinimized ? minHeight : 0)
    opacity: expanded || showMinimized ? 1.0 : 0.0
    visible: expanded || showMinimized
    color: backgroundColor
    border.color: borderColor
    border.width: 2
    radius: 6 * screenScale
    
    // Animación de altura y opacidad
    Behavior on height {
        NumberAnimation { 
            duration: 200
            easing.type: Easing.OutQuad
        }
    }
    
    Behavior on opacity {
        NumberAnimation { 
            duration: 200 
            easing.type: Easing.OutQuad
        }
    }
    
    // Timer para ocultar automáticamente
    Timer {
        id: hideTimer
        interval: debugViewer.autoHideDelay
        running: debugViewer.autoHide && debugViewer.expanded && !debugViewer.pinned
        repeat: false
        onTriggered: {
            debugViewer.expanded = false
        }
    }
    
    // Contenido
    Item {
        id: contentArea
        anchors.fill: parent
        anchors.margins: 10 * screenScale
        clip: false // true
        
        // Barra de título
        Rectangle {
            id: header
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            height: 20 * screenScale
            color: headerColor
            radius: 4 * screenScale
            
            // Título
            Text {
                anchors.left: parent.left
                anchors.leftMargin: 10 * screenScale
                anchors.verticalCenter: parent.verticalCenter
                text: "Debug Log"
                font.pixelSize: 14 * screenScale
                font.bold: true
                color: textColor
            }
            
            // Botón de pin
            Rectangle {
                id: pinButton
                anchors.right: closeButton.left
                anchors.rightMargin: 10 * screenScale
                anchors.verticalCenter: parent.verticalCenter
                width: 20 * screenScale
                height: 20 * screenScale
                radius: 10 * screenScale
                color: debugViewer.pinned ? "#FFCC00" : "#555555"
                
                Text {
                    anchors.centerIn: parent
                    text: "📌"
                    font.pixelSize: 12 * screenScale
                    color: debugViewer.pinned ? "#000000" : "#FFFFFF"
                }
                
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        debugViewer.pinned = !debugViewer.pinned
                        if (debugViewer.pinned) {
                            hideTimer.stop()
                        } else {
                            hideTimer.restart()
                        }
                    }
                }
            }
            
            // Botón de cierre
            Rectangle {
                id: closeButton
                anchors.right: parent.right
                anchors.rightMargin: 5 * screenScale
                anchors.verticalCenter: parent.verticalCenter
                width: 20 * screenScale
                height: 20 * screenScale
                radius: 10 * screenScale
                color: "#FF3333"
                
                Text {
                    anchors.centerIn: parent
                    text: "✕"
                    font.pixelSize: 12 * screenScale
                    color: "#FFFFFF"
                }
                
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        expanded = false
                        showMinimized = false // Ocultar completamente
                    }
                }
            }
        }
        
        // Contenido principal (solo visible cuando está expandido)
        Flickable {
            id: scrollView
            anchors.top: header.bottom
            anchors.topMargin: 10 * screenScale
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            contentWidth: width
            contentHeight: contentColumn.height
            clip: false // true
            visible: debugViewer.expanded
            
            // Columna de texto
            Column {
                id: contentColumn
                width: parent.width
                spacing: 5 * screenScale
                
                // Mostrar los logs como texto
                Text {
                    id: logText
                    width: parent.width
                    text: prefs.debugResult || "No hay logs disponibles"
                    font.family: "Monospace"
                    font.pixelSize: 12 * screenScale
                    color: textColor
                    wrapMode: Text.Wrap
                }
            }
            
            // Barra de desplazamiento vertical
            Rectangle {
                id: scrollBar
                anchors.right: parent.right
                anchors.top: parent.top
                width: 8 * screenScale
                radius: 4 * screenScale
                color: "#555555"
                opacity: scrollView.moving ? 0.8 : 0.5
                
                // Altura y posición dinámicas
                height: Math.max(scrollView.height * (scrollView.height / scrollView.contentHeight), 30 * screenScale)
                y: scrollView.contentY * (scrollView.height / scrollView.contentHeight)
                
                // Ocultar si no es necesario
                visible: scrollView.contentHeight > scrollView.height
            }
        }
        
        // Texto para estado minimizado
        Text {
            anchors.centerIn: parent
            text: "Debug Log - Pulsa para expandir"
            font.pixelSize: 12 * screenScale
            color: textColor
            visible: !debugViewer.expanded && debugViewer.showMinimized
        }
    }
    
    // Hacer que todo el área sea clickeable para expandir/contraer
    MouseArea {
        anchors.fill: parent
        onClicked: {
            toggleExpand()
        }
    }
    
    // Función para alternar entre expandido y contraído
    function toggleExpand() {
        expanded = !expanded
        
        if (expanded) {
            showMinimized = true // Si se expande, asegurar que showMinimized sea true
            hideTimer.restart()
        } else {
            hideTimer.stop()
            // No ocultamos showMinimized para mantener la barra minimizada visible
        }
    }
    
    // Función para mostrar u ocultar completamente
    function toggleVisibility() {
        if (!expanded && !showMinimized) {
            // Si está completamente oculto, mostrar minimizado
            showMinimized = true
        } else if (!expanded && showMinimized) {
            // Si está minimizado, expandir
            expanded = true
            hideTimer.restart()
        } else {
            // Si está expandido, minimizar
            expanded = false
        }
    }
    
    // Mostrar el DebugViewer completamente (expandido)
    function show() {
        showMinimized = true
        expanded = true
        hideTimer.restart()
    }
    
    // Ocultar el DebugViewer completamente
    function hide() {
        expanded = false
        showMinimized = false
    }
        
    // Lógica para actualizar el visor cuando cambia debugResult
    property string lastDebugResult: ""
    
    // Inicializar
    Component.onCompleted: {
        debugViewer.expanded = false
        debugViewer.showMinimized = false // Ocultar completamente al inicio
    }
    
    Timer {
        interval: 500
        running: true
        repeat: true
        onTriggered: {
            if (prefs.debugResult !== debugViewer.lastDebugResult) {
                debugViewer.lastDebugResult = prefs.debugResult
                // No expandir automáticamente cuando hay nuevos logs
                // Solo actualizar el contenido
            }
        }
    }
} 