import QtQuick

ListView {
    id: settingsList
    clip: true
    spacing: 1
    
    property int currentIndex: 0

    delegate: Rectangle {
        width: parent.width
        height: 30
        color: model.highlight ? colors.colorGrey32 : "transparent"
        
        Row {
            anchors.fill: parent
            anchors.leftMargin: 10
            anchors.rightMargin: 20
            spacing: 4
            
            Text {
                width: model.proptype === "help" ? parent.width * 0.3 : parent.width * 0.6
                text: name

                color: colors.colorFontWhite

                font.pixelSize: model.proptype === "help" ? fonts.miniFontSizePlusPlus : fonts.middleFontSize
                font.family: prefs.normalFontName

                anchors.verticalCenter: parent.verticalCenter
                elide: Text.ElideRight
            }
            
            Item {
                width: model.proptype === "help" ? parent.width * 0.6 : parent.width * 0.4
                height: parent.height
                
                // Switch personalizado para booleanos
                Rectangle {
                    visible: model.proptype === "boolean"
                    width: 40
                    height: 16
                    radius: height/2
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    color: colors.colorGrey32
                    
                    // Borde del switch - ahora usa el mismo color que el estado
                    border.width: 1
                    border.color: model.propvalue === "ON" ? colors.colorGreenActive : colors.colorRed
                    
                    // Fondo del switch cuando está activo/inactivo
                    Rectangle {
                        anchors.fill: parent
                        anchors.margins: 1
                        radius: height/2
                        color: model.propvalue === "ON" ? colors.colorGreenActive : colors.colorRed
                        visible: true
                        opacity: 0.5
                    }
                    
                    // Círculo del switch
                    Rectangle {
                        width: 12
                        height: 12
                        radius: width/2
                        anchors.verticalCenter: parent.verticalCenter
                        x: model.propvalue === "ON" ? parent.width - width - 2 : 2
                        color: model.propvalue === "ON" ? colors.colorGreenActive : colors.colorRed
                        
                        // Borde del círculo usa el mismo color base
                        border.width: 1
                        border.color: model.propvalue === "ON" ? 
                                    Qt.darker(colors.colorGreenActive, 1.2) : 
                                    Qt.darker(colors.colorRed, 1.2)
                        
                        Behavior on x {
                            NumberAnimation { duration: 150 }
                        }
                    }
                }
                
                // Texto para otros tipos de valores
                Text {
                    visible: model.proptype !== "boolean"
                    width: parent.width
                    text: {
                        switch(model.proptype) {
                            case "enumwave":
                                return "" + model.propvalue
                            case "enumcolor":
                                return "" + model.propvalue
                            case "enumtheme":
                                return "" + model.propvalue
                            case "font":
                                return "" + model.propvalue
                            case "number":
                                return model.propvalue
                            default:
                                return "" + model.propvalue
                        }
                    }
                    color: {
                        switch(model.proptype) {
                            case "enumwave":
                                return colors.colorFontBlue
                            case "enumcolor":
                                return colors.colorFontBlue
                            case "enumtheme":
                                return colors.colorFontBlue                                
                            case "font":
                                return colors.colorFontGreen
                            case "number":
                                return colors.colorFontOrange
                            default:
                                return colors.colorFontYellow
                        }
                    }

                    font.pixelSize: model.proptype === "help" ? fonts.miniFontSizePlusPlus : fonts.middleFontSize
                    font.family: prefs.normalFontName

                    anchors.verticalCenter: parent.verticalCenter
                    horizontalAlignment: Text.AlignRight
                    elide: Text.ElideRight
                }
            }
        }
    }
} 
