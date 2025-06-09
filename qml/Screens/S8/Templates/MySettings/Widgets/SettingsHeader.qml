import QtQuick

Rectangle {
    id: header
    height: 30
    color: colors.colorGrey24
    
    property string title: ""
    
    Text {
        anchors.centerIn: parent
        text: title

        font.pixelSize: fonts.largeFontSize
        font.family: prefs.normalFontName
        
        color: colors.colorFontWhite
    }
} 