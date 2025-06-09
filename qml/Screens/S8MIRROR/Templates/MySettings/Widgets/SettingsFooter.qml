import QtQuick

Rectangle {
    id: footer
    property real screenScale: prefs.screenScale
    property bool isLastSection: settingsView.currentSection === settingsView.sections.length - 1

    // Agregar señal de salida
    signal exitSettingsRequested()

    height: 45 * screenScale
    color: colors.colorGrey24
    
    Row {
        anchors.fill: parent
        anchors.margins: 4 * screenScale
        anchors.horizontalCenter: parent.horizontalCenter
        layoutDirection: Qt.LeftToRight
        spacing: (width - (3 * (width * 0.25))) / 2

        // Botón Anterior con texto
        Rectangle {
            id: prevButton
            width: parent.width * 0.25
            height: parent.height - (8 * screenScale)
            radius: 4 * screenScale
            color: prevMouseArea.pressed ? colors.colorGrey40 : colors.colorGrey32
            anchors.verticalCenter: parent.verticalCenter
            
            // Añadir borde iluminado
            border.width: 1 * screenScale
            border.color: prevMouseArea.pressed ? colors.colorBlue : "transparent"

            Row {
                anchors.centerIn: parent
                spacing: 3 * screenScale

                Text {
                    text: "◀️"  // Icono mejorado para "anterior"
                    font.pixelSize: fonts.miniFontSizePlus * 1.3 * screenScale
                    font.family: prefs.normalFontName
                    color: colors.colorFontWhite
                    anchors.verticalCenter: parent.verticalCenter
                }

                Text {
                    text: "Previous"
                    font.pixelSize: fonts.miniFontSize * screenScale
                    font.family: prefs.normalFontName
                    color: colors.colorFontWhite
                    anchors.verticalCenter: parent.verticalCenter
                }
            }

            MouseArea {
                id: prevMouseArea
                anchors.fill: parent
                onClicked: settingsView.navigateLeft()
                
                // Añadir efectos al presionar/soltar
                onPressed: {
                    prevButton.scale = 0.97
                }
                onReleased: {
                    prevButton.scale = 1.0
                }
            }
            
            // Añadir animación de escala
            Behavior on scale {
                NumberAnimation { duration: 50 }
            }
        }

        // Botón de Salir (antes Refresh)
        Rectangle {
            id: exitButton
            width: parent.width * 0.25
            height: parent.height - (8 * screenScale)
            radius: 4 * screenScale
            color: refreshMouseArea.pressed ? colors.colorGrey40 : colors.colorGrey32
            anchors.verticalCenter: parent.verticalCenter
            
            // Añadir borde iluminado
            border.width: 1 * screenScale
            border.color: refreshMouseArea.pressed ? colors.colorBlue : "transparent"

            Row {
                anchors.centerIn: parent
                spacing: 3 * screenScale

                Text {
                    text: "🚪"  // Icono mejorado para "salir"
                    font.pixelSize: fonts.miniFontSizePlus * 1.3 * screenScale
                    font.family: prefs.normalFontName
                    color: colors.colorFontWhite
                    anchors.verticalCenter: parent.verticalCenter
                }

                Text {
                    id: exitText
                    text: "Exit"
                    font.pixelSize: fonts.miniFontSize * screenScale
                    font.family: prefs.normalFontName
                    color: colors.colorFontWhite
                    anchors.verticalCenter: parent.verticalCenter
                }
            }

            MouseArea {
                id: refreshMouseArea
                anchors.fill: parent
                onClicked: {
                    // Luego emitir señal para salir - IMPORTANTE!
                    footer.exitSettingsRequested()
                }
                
                // Añadir efectos al presionar/soltar
                onPressed: {
                    exitButton.scale = 0.97
                }
                onReleased: {
                    exitButton.scale = 1.0
                }
            }
            
            // Añadir animación de escala
            Behavior on scale {
                NumberAnimation { duration: 50 }
            }
        }

        // Botón Siguiente con texto
        Rectangle {
            id: nextButton
            width: parent.width * 0.25
            height: parent.height - (8 * screenScale)
            radius: 4 * screenScale
            color: isLastSection ? colors.colorGrey16 : (nextMouseArea.pressed ? colors.colorGrey40 : colors.colorGrey32)
            opacity: isLastSection ? 0.5 : 1.0
            anchors.verticalCenter: parent.verticalCenter
            
            // Añadir borde iluminado
            border.width: isLastSection ? 0 : (1 * screenScale)
            border.color: nextMouseArea.pressed ? colors.colorBlue : "transparent"
            
            Row {
                anchors.centerIn: parent
                spacing: 3 * screenScale

                Text {
                    text: "Next"
                    font.pixelSize: fonts.miniFontSize * screenScale
                    font.family: prefs.normalFontName
                    color: colors.colorFontWhite
                    opacity: isLastSection ? 0.5 : 1.0
                    anchors.verticalCenter: parent.verticalCenter
                }

                Text {
                    text: "▶️"  // Icono mejorado para "siguiente"
                    font.pixelSize: fonts.miniFontSizePlus * 1.3 * screenScale
                    font.family: prefs.normalFontName
                    color: colors.colorFontWhite
                    opacity: isLastSection ? 0.5 : 1.0
                    anchors.verticalCenter: parent.verticalCenter
                }
            }

            MouseArea {
                id: nextMouseArea
                anchors.fill: parent
                enabled: !isLastSection
                onClicked: settingsView.navigateRight()
                
                // Añadir efectos al presionar/soltar
                onPressed: {
                    if (!isLastSection)
                        nextButton.scale = 0.97
                }
                onReleased: {
                    if (!isLastSection)
                        nextButton.scale = 1.0
                }
            }
            
            // Añadir animación de escala
            Behavior on scale {
                NumberAnimation { duration: 50 }
            }
        }
    }
} 

