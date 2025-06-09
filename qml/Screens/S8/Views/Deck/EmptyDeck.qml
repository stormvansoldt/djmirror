import QtQuick
import Qt5Compat.GraphicalEffects

Item {
    anchors.fill: parent

    property string deckSizeState: "large"
    property color deckColor: colors.deckColors.emptyDeck.background

    // Empty Deck Image
    Image {
        id: emptyTrackDeckImage
        anchors.fill: parent
        anchors.bottomMargin: 30
        anchors.topMargin: 30
        visible: false // visibility is handled by emptyTrackDeckImageColorOverlay

        source: "../../../Images/EmptyDeck.png"
        fillMode: Image.PreserveAspectFit
    }

    // Function Deck Color
    ColorOverlay {
        id: emptyTrackDeckImageColorOverlay
        anchors.fill: emptyTrackDeckImage
        visible: !(deckSizeState == "small")
        color: colors.deckColors.emptyDeck.overlay
        source: emptyTrackDeckImage
    }
}
