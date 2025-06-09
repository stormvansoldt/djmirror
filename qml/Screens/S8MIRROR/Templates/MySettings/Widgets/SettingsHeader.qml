import QtQuick

Rectangle {
    id: header
    height: 30 * screenScale
    color: colors.colorGrey24
    
    property real screenScale: prefs.screenScale
    property string title: ""
    
    Text {
        anchors.centerIn: parent
        text: title

        font.pixelSize: fonts.largeFontSize * screenScale
        font.family: prefs.normalFontName
        
        color: colors.colorFontWhite
    }
} 