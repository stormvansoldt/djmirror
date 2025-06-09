import QtQuick
import QtQuick.Window 2.15
import Qt5Compat.GraphicalEffects

import './../../Views/Widgets' as Widgets
 
Rectangle {
    id: controlPanel

    property real screenScale: prefs.screenScale

    // Referencias a los elementos que vamos a controlar
    property var topControls
    property var bottomControls
    property var leftButtonArea
    property var rightButtonArea
    property var softTakeoverKnobs
    property var softTakeoverFaders
    property var mainBottomControls

    property string screenState: ""

    // Color de fondo con gradiente
    gradient: Gradient {
        GradientStop { position: 0.0; color: "#1a1a2e" }  // Azul oscuro
        GradientStop { position: 1.0; color: "#16213e" }  // Azul más oscuro
    }

    // Bordes modernos
    radius: 8 * screenScale  // Bordes más redondeados
    border.color: "#4d5bf9"  // Borde azul brillante
    border.width: 1.5 * screenScale
    
    // Por defecto está oculto
    visible: false
    
    // Título del panel con estilo más moderno
    Rectangle {
        id: titleBar
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        height: 40 * screenScale
        radius: parent.radius
        gradient: Gradient {
            GradientStop { position: 0.0; color: "#4d5bf9" }  // Azul brillante
            GradientStop { position: 1.0; color: "#3a45e1" }  // Azul medio
        }
        
        // Recortamos la parte inferior para que solo los bordes superiores sean redondeados
        Rectangle {
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            height: parent.radius
            color: parent.gradient.stops[1].color
        }
        
        Text {
            id: panelTitle
            anchors.centerIn: parent
            text: "PANEL DE CONTROL"
            color: "#ffffff"
            font.pixelSize: 18 * screenScale
            font.bold: true
            font.family: prefs.mediumFontName
        }
    }

    // Contenido del panel
    Flickable {
        anchors.top: titleBar.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.margins: 10 * screenScale
        contentHeight: mainColumn.height
        clip: false // true
        
        Column {
            id: mainColumn
            width: parent.width
            spacing: 10 * screenScale

            // Botones
            Row {
                width: parent.width
                spacing: 10 * screenScale
                
                Widgets.TouchButton {
                    width: (parent.width - 10 * screenScale) / 2
                    height: 40 * screenScale
                    text: "Keys"
                    icon: "◀"
                    isActive: leftButtonArea.showHideState === "show"
                    onClicked: {
                        leftButtonArea.showHideState = leftButtonArea.showHideState === "show" ? "hide" : "show"
                    }
                }
                
                Widgets.TouchButton {
                    width: (parent.width - 10 * screenScale) / 2
                    height: 40 * screenScale
                    text: "Zoom"
                    isActive: rightButtonArea.showHideState === "show"
                    icon: "▶"
                    onClicked: {
                        rightButtonArea.showHideState = rightButtonArea.showHideState === "show" ? "hide" : "show"
                    }
                }
            }

            // Botones
            Row {
                width: parent.width
                spacing: 10 * screenScale

                Widgets.TouchButton {
                    width: (parent.width - 10 * screenScale) / 2
                    height: 40 * screenScale
                    text: "Takeover Knobs"
                    icon: "🎛️"
                    isActive: softTakeoverKnobs.visible
                    onClicked: {
                        softTakeoverKnobs.visible = !softTakeoverKnobs.visible
                    }
                }
                
                Widgets.TouchButton {
                    width: (parent.width - 10 * screenScale) / 2
                    height: 40 * screenScale
                    text: "Takeover Faders"
                    icon: "🎛️"
                    isActive: softTakeoverFaders.visible
                    onClicked: {
                        softTakeoverFaders.visible = !softTakeoverFaders.visible
                    }
                }
            }

            // Botones
            Row {
                width: parent.width
                spacing: 10 * screenScale            
                Widgets.TouchButton {
                    width: (parent.width - 10 * screenScale) / 2
                    height: 40 * screenScale
                    text: screenState === "BrowserView" ? "Deck" : "Browser"
                    icon: "🌐"
                    isActive: screenState === "BrowserView"
                    onClicked: {
                        showBrowserView()
                    }
                }
                
                Widgets.TouchButton {
                    width: (parent.width - 10 * screenScale) / 2
                    height: 40 * screenScale
                    text: "Ocultar Todo"
                    icon: "👀"
                    isActive: false
                    onClicked: {
                        // Ocultar todos los elementos
                        topControls.showHideState = "hide"
                        bottomControls.sizeState = "hide"
                        mainBottomControls.sizeState = "hide"
                        leftButtonArea.showHideState = "hide"
                        rightButtonArea.showHideState = "hide"
                        softTakeoverKnobs.visible = false
                        softTakeoverFaders.visible = false
                    }
                }
            }
        }
    }
} 
