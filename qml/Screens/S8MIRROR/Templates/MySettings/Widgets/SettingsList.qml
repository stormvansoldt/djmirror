import QtQuick

Item {
    id: settingsListContainer
    property real screenScale: prefs.screenScale
    property alias currentIndex: settingsList.currentIndex
    property alias model: settingsList.model

    // Función auxiliar para actualizar la selección
    function updateSelection(index) {
        if (index !== undefined) {
            settingsList.currentIndex = index
            settingsView.currentOption = index
        }
    }

    // Función para obtener el tamaño de fuente escalado
    function getScaledFontSize(baseSize) {
        return baseSize * screenScale
    }

    ListView {
        id: settingsList
        anchors.fill: parent
        anchors.margins: 10 * screenScale
        clip: false // true
        spacing: 5 * screenScale
        
        // Habilitar el comportamiento de flick/swipe
        flickableDirection: Flickable.VerticalFlick
        boundsBehavior: Flickable.StopAtBounds
        
        // Ajustar la física del scroll
        maximumFlickVelocity: 2500
        flickDeceleration: 1500
        
        delegate: Item {
            id: delegateItem
            property int itemIndex: index
            width: parent.width
            height: model.proptype === "help" ? 30 * screenScale : 40 * screenScale
            //color: colors.colorGrey16
            //radius: 2 * screenScale

            // Efecto de hover
            Rectangle {
                anchors.fill: parent

                color: colors.colorGrey32
                radius: parent.radius
                opacity: mouseArea.containsMouse || decrementArea.containsMouse || incrementArea.containsMouse || switchArea.containsMouse ? 0.3 : 0
                
                Behavior on opacity {
                    NumberAnimation { duration: 150 }
                }
            }
            
            Row {
                anchors.fill: parent
                anchors.margins: 10 * screenScale
                spacing: 10 * screenScale
                
                // Nombre de la opción
                Text {
                    width: model.proptype === "help" ? parent.width * 0.3 : parent.width * 0.58
                    text: name
                    color: colors.colorFontWhite
                    font.pixelSize: model.proptype === "help" ? 
                        getScaledFontSize(fonts.miniFontSizePlusPlus) :
                        getScaledFontSize(fonts.middleFontSize)
                    font.family: prefs.mediumFontName
                    anchors.verticalCenter: parent.verticalCenter
                    elide: Text.ElideRight
                }
                
                Item {
                    width: model.proptype === "help" ? parent.width * 0.6 : parent.width * 0.38
                    height: parent.height

                    // Controles de valor numéricos/enumerados
                    Row {
                        visible: model.proptype !== "help" && model.proptype !== "boolean"
                        anchors.right: parent.right
                        anchors.verticalCenter: parent.verticalCenter
                        spacing: 8 * screenScale

                        // Botón decrementar
                        Rectangle {
                            id: decrementButton
                            width: 30 * screenScale
                            height: 30 * screenScale
                            radius: 2 * screenScale
                            color: decrementArea.pressed ? colors.colorGrey40 : colors.colorGrey24

                            Text {
                                anchors.centerIn: parent
                                text: "-"
                                font.pixelSize: getScaledFontSize(fonts.largeFontSize)
                                font.family: prefs.mediumFontName
                                color: colors.colorFontWhite                               
                            }

                            MouseArea {
                                id: decrementArea
                                anchors.fill: parent
                                hoverEnabled: true
                                preventStealing: true
                                propagateComposedEvents: true
                                onEntered: updateSelection(delegateItem.itemIndex)
                                onPressed: {
                                    settingsList.interactive = false
                                    decrementButton.color = colors.colorGrey40
                                    mouse.accepted = true
                                }
                                onClicked: {
                                    settingsView.toggleOption("decrement")
                                }
                                onReleased: {
                                    settingsList.interactive = true
                                    decrementButton.color = colors.colorGrey24
                                }
                            }
                        }

                        // Valor actual
                        Rectangle {
                            width: 80 * screenScale
                            height: 30 * screenScale
                            color: colors.colorGrey24
                            radius: 2 * screenScale

                            Text {
                                anchors.centerIn: parent
                                text: model.propvalue
                                color: {
                                    switch(model.proptype) {
                                        case "enumwave": return colors.colorFontBlue
                                        case "enumcolor": return colors.colorFontBlue
                                        case "enumtheme": return colors.colorFontBlue
                                        case "font": return colors.colorFontGreen
                                        case "number": return colors.colorFontOrange
                                        default: return colors.colorFontYellow
                                    }
                                }
                                font.pixelSize: getScaledFontSize(fonts.middleFontSize)
                                font.family: prefs.mediumFontName
                            }
                        }

                        // Botón incrementar
                        Rectangle {
                            id: incrementButton
                            width: 30 * screenScale
                            height: 30 * screenScale
                            radius: 2 * screenScale
                            color: incrementArea.pressed ? colors.colorGrey40 : colors.colorGrey24

                            Text {
                                anchors.centerIn: parent
                                text: "+"
                                font.pixelSize: getScaledFontSize(fonts.largeFontSize)
                                font.family: prefs.mediumFontName
                                color: colors.colorFontWhite
                            }

                            MouseArea {
                                id: incrementArea
                                anchors.fill: parent
                                hoverEnabled: true
                                preventStealing: true
                                propagateComposedEvents: true
                                onEntered: updateSelection(delegateItem.itemIndex)
                                onPressed: {
                                    settingsList.interactive = false
                                    incrementButton.color = colors.colorGrey40
                                    mouse.accepted = true
                                }
                                onClicked: {
                                    settingsView.toggleOption("increment")
                                }
                                onReleased: {
                                    settingsList.interactive = true
                                    incrementButton.color = colors.colorGrey24
                                }
                            }
                        }
                    }
                    
                    // Switch personalizado para booleanos
                    Rectangle {
                        visible: model.proptype === "boolean"
                        width: 50 * screenScale
                        height: 26 * screenScale
                        radius: height/2
                        anchors.right: parent.right
                        anchors.verticalCenter: parent.verticalCenter
                        color: colors.colorGrey24
                        
                        Rectangle {
                            anchors.fill: parent
                            anchors.margins: 2 * screenScale
                            radius: height/2
                            color: model.propvalue === "ON" ? colors.colorGreenActive : colors.colorRed
                            opacity: switchArea.pressed ? 0.5 : 0.3
                        }
                        
                        Rectangle {
                            width: 20 * screenScale
                            height: 20 * screenScale
                            radius: width/2
                            anchors.verticalCenter: parent.verticalCenter
                            x: model.propvalue === "ON" ? parent.width - width - (3 * screenScale) : (3 * screenScale)
                            color: model.propvalue === "ON" ? colors.colorGreenActive : colors.colorRed
                            
                            Behavior on x {
                                NumberAnimation { duration: 150 }
                            }
                        }

                        MouseArea {
                            id: switchArea
                            anchors.fill: parent
                            hoverEnabled: true
                            preventStealing: true
                            onEntered: updateSelection(delegateItem.itemIndex)
                            onPressed: {
                                settingsList.interactive = false
                                mouse.accepted = true
                            }
                            onClicked: {
                                settingsView.toggleOption("increment")
                            }
                            onReleased: {
                                settingsList.interactive = true
                            }
                        }
                    }

                    // Texto para elementos de ayuda
                    Text {
                        visible: model.proptype === "help"
                        anchors.right: parent.right
                        anchors.verticalCenter: parent.verticalCenter
                        text: model.propvalue
                        color: colors.colorFontYellow
                        font.pixelSize: getScaledFontSize(fonts.miniFontSize)
                        font.family: prefs.mediumFontName
                        horizontalAlignment: Text.AlignRight
                    }
                }
            }

            MouseArea {
                id: mouseArea
                anchors.fill: parent
                anchors.rightMargin: model.proptype === "boolean" ? 200 * screenScale : 
                                   model.proptype !== "help" ? 200 * screenScale : 0
                hoverEnabled: true
                onEntered: {
                    if (model.proptype !== "help") {
                        updateSelection(delegateItem.itemIndex)
                    }
                }
            }
        }
    }
} 
