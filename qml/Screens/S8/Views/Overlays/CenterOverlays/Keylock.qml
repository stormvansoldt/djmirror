import QtQuick
import CSI 1.0

import "../../../../Defines" as Defines

// dimensions are set in CenterOverlay.qml

CenterOverlay {
    id: keylock

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

    // Headline
    Text {
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.topMargin: customMargins.topMarginCenterOverlayHeadline

        font.pixelSize: fonts.largeFontSize
        font.family: prefs.normalFontName

        color: colors.colorCenterOverlayHeadline
        text: "KEY"
    }

    // Button
    Rectangle {
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.topMargin: 67
        anchors.leftMargin: 21
        width: 43
        height: 17
        color: (keyEnable.value) ? colors.colorWhite : colors.colorBlack
        radius: 1

        Text {
            anchors.centerIn: parent
            anchors.verticalCenterOffset: 1
            anchors.horizontalCenterOffset: -1

            font.pixelSize: fonts.miniFontSizePlusPlus
            font.family: prefs.normalFontName

            text: "LOCK"
            color: (keyEnable.value) ? colors.colorBlack : colors.colorGrey104
        }
    }

    // Key
    Text {
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.topMargin: 55

        font.pixelSize: fonts.extraLargeFontSize
        font.family: prefs.normalFontName

        color: keylock.keyColor
        opacity: (keyDisplay.value == "") ? 0 : 1
        text: utils.convertToKeyNotation(keyDisplay.value, prefs.keyNotation)
    }

    // Value
    Text {
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.topMargin: 67
        anchors.rightMargin: 20

        font.pixelSize: fonts.largeFontSize
        font.family: prefs.normalFontName
        font.capitalization: Font.AllUppercase

        color: colors.colorGrey104
        text: ((key < 0) ? "" : "+") + key.toFixed(2).toString()
    }

    // Footline
    Text {
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottomMargin: 14.0

        font.pixelSize: fonts.miniFontSizePlusPlus
        font.family: prefs.normalFontName

        color: colors.colorGrey104
        text: "Hold BACK to reset"
    }
}
