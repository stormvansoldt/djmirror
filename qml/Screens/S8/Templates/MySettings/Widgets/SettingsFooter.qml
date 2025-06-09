import QtQuick

Rectangle {
    id: footer
    height: 30
    color: colors.colorGrey24
    
    Column {
        anchors.centerIn: parent
        spacing: 2

        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            text: "DISPLAY BUTTONS > 4/8: Navigate   2/3: Change Value   SHIFT+5: Exit"

            font.pixelSize: fonts.miniFontSize
            font.family: prefs.normalFontName

            color: colors.colorFontWhite
        }

        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            text: "SHIFT+5: Refresh other display decks"

            font.pixelSize: fonts.miniFontSize
            font.family: prefs.normalFontName

            color: colors.colorFontWhite
        }
    }
} 
