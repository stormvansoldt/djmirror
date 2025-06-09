import QtQuick
import CSI 1.0

import "../../../../Defines" as Defines

// dimensions are set in CenterOverlay.qml

CenterOverlay {
    id: keylock

    property real screenScale: prefs.screenScale

    property int deckId: 0

    Defines.Margins { id: customMargins }

    //--------------------------------------------------------------------------------------------------------------------
    AppProperty { id: keyValue;   path: "app.traktor.decks." + (deckId+1) + ".track.key.adjust" }
    AppProperty { id: keyId;      path: "app.traktor.decks." + (deckId+1) + ".track.key.final_id" }
    AppProperty { id: keyEnable;  path: "app.traktor.decks." + (deckId+1) + ".track.key.lock_enabled" }
    AppProperty { id: keyDisplay; path: "app.traktor.decks." + (deckId+1) + ".track.key.resulting.precise" }
    
    property real key: keyValue.value * 12
    property int offset: (key.toFixed(2) - key.toFixed(0)) * 100.0
    property var keyColor: keyEnable.value && keyId.value >= 0 ? colors.musicalKeyColors[keyId.value] : colors.colorWhite

    //--------------------------------------------------------------------------------------------------------------------
    
    // Función para ajustar la clave
    function adjustKey(increment) {
        var currentKey = keyValue.value || 0
        var newKey = currentKey + (increment / 12)
        
        keyValue.value = newKey
    }
    
    // Función para resetear la clave
    function resetKey() {
        keyValue.value = 0
    }
    
    // Función para activar/desactivar el keylock
    function toggleKeylock() {
        keyEnable.value = !keyEnable.value
    }

    //--------------------------------------------------------------------------------------------------------------------

    // Contenedor principal para KEY y controles
    Item {
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.margins: 14 * screenScale
        width: Math.max(topRow.width, keyText.width, bottomRow.width) + (20 * screenScale)

        // Fila superior de botones
        Row {
            id: topRow
            anchors.top: parent.top
            anchors.topMargin: 12 * screenScale
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: 8 * screenScale

            // Botón +1 semitono
            Rectangle {
                width: 40 * screenScale
                height: 20 * screenScale
                radius: 2 * screenScale
                color: colors.colorGrey40
                border.color: colors.colorWhite
                border.width: 1

                Text {
                    anchors.centerIn: parent
                    text: "+1"
                    font.pixelSize: fonts.middleFontSize * screenScale
                    font.family: prefs.normalFontName
                    color: colors.colorWhite
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: keylock.adjustKey(1)
                    onPressed: parent.color = colors.colorGrey60
                    onReleased: parent.color = colors.colorGrey40
                }
            }

            // Botón +0.5 semitono
            Rectangle {
                width: 40 * screenScale
                height: 20 * screenScale
                radius: 2 * screenScale
                color: colors.colorGrey40
                border.color: colors.colorWhite
                border.width: 1

                Text {
                    anchors.centerIn: parent
                    text: "+0.5"
                    font.pixelSize: fonts.middleFontSize * screenScale
                    font.family: prefs.normalFontName
                    color: colors.colorWhite
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: keylock.adjustKey(0.5)
                    onPressed: parent.color = colors.colorGrey60
                    onReleased: parent.color = colors.colorGrey40
                }
            }

            // Botón -0.5 semitono
            Rectangle {
                width: 40 * screenScale
                height: 20 * screenScale
                radius: 2 * screenScale
                color: colors.colorGrey40
                border.color: colors.colorWhite
                border.width: 1

                Text {
                    anchors.centerIn: parent
                    text: "-0.5"
                    font.pixelSize: fonts.middleFontSize * screenScale
                    font.family: prefs.normalFontName
                    color: colors.colorWhite
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: keylock.adjustKey(-0.5)
                    onPressed: parent.color = colors.colorGrey60
                    onReleased: parent.color = colors.colorGrey40
                }
            }

            // Botón -1 semitono
            Rectangle {
                width: 40 * screenScale
                height: 20 * screenScale
                radius: 2 * screenScale
                color: colors.colorGrey40
                border.color: colors.colorWhite
                border.width: 1

                Text {
                    anchors.centerIn: parent
                    text: "-1"
                    font.pixelSize: fonts.middleFontSize * screenScale
                    font.family: prefs.normalFontName
                    color: colors.colorWhite
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: keylock.adjustKey(-1)
                    onPressed: parent.color = colors.colorGrey60
                    onReleased: parent.color = colors.colorGrey40
                }
            }
        }

        // Headline
        Text {
            anchors.right: keyText.left
            anchors.rightMargin: 15 * screenScale
            anchors.verticalCenter: keyText.verticalCenter

            font.pixelSize: fonts.largeFontSize * screenScale
            font.family: prefs.normalFontName

            color: colors.colorCenterOverlayHeadline
            text: "KEY"
        }

        // Key notation
        Text {
            id: keyText
            anchors.centerIn: parent

            font.pixelSize: fonts.extraLargeFontSize * screenScale
            font.family: prefs.normalFontName

            color: keylock.keyColor
            opacity: (keyDisplay.value == "") ? 0 : 1
            text: utils.convertToKeyNotation(keyDisplay.value, prefs.keyNotation)
        }

        // Key value
        Text {
            anchors.left: keyText.right
            anchors.leftMargin: 15 * screenScale
            anchors.verticalCenter: keyText.verticalCenter

            font.pixelSize: fonts.middleFontSize * screenScale
            font.family: prefs.normalFontName
            font.capitalization: Font.AllUppercase

            color: colors.colorGrey104
            text: ((key < 0) ? "" : "+") + key.toFixed(2).toString()
        }

        // Fila inferior de botones
        Row {
            id: bottomRow
            anchors.top: keyText.bottom
            anchors.topMargin: 2 * screenScale
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: 8 * screenScale

            // Botón LOCK
            Rectangle {
                width: 40 * screenScale
                height: 20 * screenScale
                radius: 2 * screenScale
                color: (keyEnable.value) ? colors.colorGrey72 : colors.colorGrey40
                border.color: colors.colorWhite
                border.width: 1

                Text {
                    anchors.centerIn: parent
                    text: "LOCK"
                    font.pixelSize: fonts.middleFontSize * screenScale
                    font.family: prefs.normalFontName
                    color: colors.colorWhite
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: keylock.toggleKeylock()
                    onPressed: parent.color = colors.colorGrey60
                    onReleased: parent.color = keyEnable.value ? colors.colorGrey72 : colors.colorGrey40
                }
            }

            // Botón RESET
            Rectangle {
                width: 40 * screenScale
                height: 20 * screenScale
                radius: 2 * screenScale
                color: colors.colorGrey40
                border.color: colors.colorWhite
                border.width: 1

                Text {
                    anchors.centerIn: parent
                    text: "RESET"
                    font.pixelSize: fonts.middleFontSize * screenScale
                    font.family: prefs.normalFontName
                    color: colors.colorWhite
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: keylock.resetKey()
                    onPressed: parent.color = colors.colorGrey60
                    onReleased: parent.color = colors.colorGrey40
                }
            }
        }
    }
}
