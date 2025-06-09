import QtQuick
import QtQuick.Window 2.15
import Qt5Compat.GraphicalEffects

import './../../Views/Widgets' as Widgets

Rectangle {
    id: touchControlPanelRound

    property real screenScale: prefs.screenScale
    
    // Estado de la ventana para actualizar iconos
    property string windowState: "normal" // Sincronizar con MirrorWindow

    // Señales del panel de control
    signal viewSelected()
    signal deckSelected()
    signal loadSelected()
    signal playSelected()
    signal fxSelected()
    signal settingsSelected()
    signal windowMaximizeSelected()

    // Añadir borde y gradiente para mejorar apariencia
    border.width: 1 * screenScale
    border.color: colors.colorGrey128
    
    // Gradiente para efecto de iluminación
    gradient: Gradient {
        GradientStop { position: 0.0; color: colors.colorGrey56 }
        GradientStop { position: 1.0; color: colors.colorGrey32 }
    }

    Row {
        spacing: 6 * screenScale
        anchors.centerIn: parent
        
        // Añadir padding para que los botones no queden tan pegados a los bordes
        anchors.margins: 10 * screenScale
        
        // Agregar una animación a la aparición de los botones
        Behavior on opacity {
            NumberAnimation {
                duration: 150
                easing.type: Easing.OutQuad
            }
        }
        
        Widgets.TouchButtonRound {
            id: loadButton
            text: "Load"
            icon: "📂"
            
            // Cambiar colores según estado activo con colores del tema
            property bool isActive: false
            color: colors.colorGrey64
            
            // Sobreescribir propiedades cuando está activo
            border.color: isActive ? colors.colorMixerFXBlue : colors.colorGrey88
            gradient: Gradient {
                GradientStop { position: 0.0; color: isActive ? Qt.lighter(colors.colorMixerFXBlue, 1.2) : colors.colorGrey80 }
                GradientStop { position: 1.0; color: isActive ? colors.colorMixerFXBlue : colors.colorGrey56 }
            }
            
            onClicked: {
                loadSelected()
                viewButton.isActive = false
                deckButton.isActive = false
                loadButton.isActive = true
                settingsButton.isActive = false
                maximizeButton.isActive = false
                fxButton.isActive = false
                playButton.isActive = false
            }
        }
        
        Widgets.TouchButtonRound {
            id: viewButton
            text: "View"
            icon: "👁️"
            
            // Cambiar colores según estado activo con colores del tema
            property bool isActive: false
            color: colors.colorGrey64
            
            // Sobreescribir propiedades cuando está activo
            border.color: isActive ? colors.colorMixerFXBlue : colors.colorGrey88
            gradient: Gradient {
                GradientStop { position: 0.0; color: isActive ? Qt.lighter(colors.colorMixerFXBlue, 1.2) : colors.colorGrey80 }
                GradientStop { position: 1.0; color: isActive ? colors.colorMixerFXBlue : colors.colorGrey56 }
            }
            
            onClicked: {
                viewSelected()
                viewButton.isActive = true
                deckButton.isActive = false
                loadButton.isActive = false
                settingsButton.isActive = false
                maximizeButton.isActive = false
                fxButton.isActive = false
                playButton.isActive = false
            }
        }   

        Widgets.TouchButtonRound {
            id: deckButton
            text: "Deck"
            icon: "📀"
            
            // Cambiar colores según estado activo con colores del tema
            property bool isActive: false
            color: colors.colorGrey64
            
            // Sobreescribir propiedades cuando está activo
            border.color: isActive ? colors.colorMixerFXBlue : colors.colorGrey88
            gradient: Gradient {
                GradientStop { position: 0.0; color: isActive ? Qt.lighter(colors.colorMixerFXBlue, 1.2) : colors.colorGrey80 }
                GradientStop { position: 1.0; color: isActive ? colors.colorMixerFXBlue : colors.colorGrey56 }
            }
            
            onClicked: {
                deckSelected()
                viewButton.isActive = false
                deckButton.isActive = true
                loadButton.isActive = false
                settingsButton.isActive = false
                maximizeButton.isActive = false
                fxButton.isActive = false
                playButton.isActive = false
            }
        }

        Widgets.TouchButtonRound {
            id: playButton
            text: play.value ? "Stop" : "Play"
            icon: play.value ? "⏹️" : "▶️"
            
            // Cambiar colores según estado activo con colores del tema
            property bool isActive: play.value
            color: colors.colorGrey64
            
            // Sobreescribir propiedades cuando está activo
            border.color: isActive ? colors.colorMixerFXBlue : colors.colorGrey88
            gradient: Gradient {
                GradientStop { position: 0.0; color: isActive ? Qt.lighter(colors.colorMixerFXBlue, 1.2) : colors.colorGrey80 }
                GradientStop { position: 1.0; color: isActive ? colors.colorMixerFXBlue : colors.colorGrey56 }
            }
            
            onClicked: {
                playSelected()
                viewButton.isActive = false
                deckButton.isActive = false
                loadButton.isActive = false
                settingsButton.isActive = false
                maximizeButton.isActive = false
                fxButton.isActive = false
                playButton.isActive = true
            }
        }

        Widgets.TouchButtonRound {
            id: fxButton
            text: "FX"
            icon: "🎛️"
            
            // Cambiar colores según estado activo con colores del tema
            property bool isActive: false
            color: colors.colorGrey64
            
            // Sobreescribir propiedades cuando está activo
            border.color: isActive ? colors.colorMixerFXBlue : colors.colorGrey88
            gradient: Gradient {
                GradientStop { position: 0.0; color: isActive ? Qt.lighter(colors.colorMixerFXBlue, 1.2) : colors.colorGrey80 }
                GradientStop { position: 1.0; color: isActive ? colors.colorMixerFXBlue : colors.colorGrey56 }
            }
            
            onClicked: {
                fxSelected()
                viewButton.isActive = false
                deckButton.isActive = false
                loadButton.isActive = false
                settingsButton.isActive = false
                maximizeButton.isActive = false
                fxButton.isActive = true
                playButton.isActive = false
            }
        }

        Widgets.TouchButtonRound {
            id: settingsButton
            text: "Config"
            icon: "⚙️"
            
            // Cambiar colores según estado activo con colores del tema
            property bool isActive: false
            color: colors.colorGrey64
            
            // Sobreescribir propiedades cuando está activo
            border.color: isActive ? colors.colorMixerFXBlue : colors.colorGrey88
            gradient: Gradient {
                GradientStop { position: 0.0; color: isActive ? Qt.lighter(colors.colorMixerFXBlue, 1.2) : colors.colorGrey80 }
                GradientStop { position: 1.0; color: isActive ? colors.colorMixerFXBlue : colors.colorGrey56 }
            }
            
            onClicked: {
                settingsSelected()
                viewButton.isActive = false
                deckButton.isActive = false
                loadButton.isActive = false
                settingsButton.isActive = true
                maximizeButton.isActive = false
                fxButton.isActive = false
                playButton.isActive = false
            }
        }


        Widgets.TouchButtonRound {
            id: maximizeButton
            text: touchControlPanelRound.windowState === "normal" ? "Max" : "Normal"
            icon: touchControlPanelRound.windowState === "normal" ? "🔼" : "🔄"
            
            // Cambiar colores según estado activo con colores del tema
            property bool isActive: false
            color: colors.colorGrey64
            
            // Sobreescribir propiedades cuando está activo
            border.color: isActive ? colors.colorMixerFXBlue : colors.colorGrey88
            gradient: Gradient {
                GradientStop { position: 0.0; color: isActive ? Qt.lighter(colors.colorMixerFXBlue, 1.2) : colors.colorGrey80 }
                GradientStop { position: 1.0; color: isActive ? colors.colorMixerFXBlue : colors.colorGrey56 }
            }
            
            onClicked: {
                windowMaximizeSelected()
                viewButton.isActive = false
                deckButton.isActive = false
                loadButton.isActive = false
                settingsButton.isActive = false
                maximizeButton.isActive = true
                fxButton.isActive = false
                playButton.isActive = false
            }
        }
    }
} 
