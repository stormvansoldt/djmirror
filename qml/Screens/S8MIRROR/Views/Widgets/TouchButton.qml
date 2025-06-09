import QtQuick

// Componente para botones táctiles
Rectangle {
    id: touchButton

    property real screenScale: prefs.screenScale

    property string text: ""
    property string icon: ""
    property bool isActive: false

    signal clicked()
    
    color: isActive ? "#007700" : (mouseArea.containsMouse ? "#444444" : "#333333")
    radius: 5 * screenScale
    border.color: isActive ? "#00FF00" : "#555555"
    border.width: 1

    Row {
        anchors.centerIn: parent
        spacing: 8 * screenScale
        
        Text {
            text: icon
            visible: icon !== ""
            color: isActive ? "#FFFFFF" : "#AAAAAA"
            font.pixelSize: fonts.middleFontSizePlus * screenScale
            anchors.verticalCenter: parent.verticalCenter
        }
        
        Text {
            text: touchButton.text
            color: isActive ? "#FFFFFF" : "#AAAAAA"
            font.pixelSize: fonts.middleFontSize * screenScale
            font.bold: isActive
            anchors.verticalCenter: parent.verticalCenter
        }
    }
    
    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        onClicked: parent.clicked()
    }
}
