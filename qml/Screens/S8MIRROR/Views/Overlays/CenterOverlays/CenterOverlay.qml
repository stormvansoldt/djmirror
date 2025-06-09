import CSI 1.0
import QtQuick
import Qt5Compat.GraphicalEffects

Rectangle {
    id: overlay

    property real screenScale: prefs.screenScale

    // overlay size & position
    color: "transparent"
    width: 296 * screenScale  // Escalar ancho
    height: 147 * screenScale  // Escalar altura
    anchors.centerIn: parent
    anchors.verticalCenterOffset: -19 * screenScale  // Escalar offset

    //------------------------------------------------------------------------------------------------------------------
    // background with border, inner glow & drop shadow
    //------------------------------------------------------------------------------------------------------------------
    Item { // bugfix for clipped drop shadow / glow
        id: container
        anchors.centerIn: parent
        width: border.width + (2 * rectShadow.radius)
        height: border.height + (2 * rectShadow.radius)

        Rectangle {
            id: border
            width: overlay.width
            height: overlay.height
            anchors.centerIn: parent
            color: colors.colorBlack69
            border.color: colors.colorGrey40
            border.width: 1 * screenScale  // Escalar ancho del borde
            radius: 4 * screenScale  // Escalar radio
        }
    }

    // outer glow
    Glow {
        id: rectShadow
        anchors.fill: source
        cached: true
        radius: 6.0 * screenScale  // Escalar radio del glow
        samples: 12
        color: colors.colorBlack75
        source: container
        smooth: true
    }

    Rectangle {
        id: innerGlow
        width: overlay.width - (2 * screenScale)  // Escalar margen
        height: overlay.height - (2 * screenScale)  // Escalar margen
        anchors.centerIn: parent
        color: "transparent"
        border.color: colors.colorGrey08
        border.width: 1 * screenScale  // Escalar ancho del borde
        radius: 3 * screenScale  // Escalar radio
    }
}
