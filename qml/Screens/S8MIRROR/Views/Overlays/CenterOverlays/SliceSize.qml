import CSI 1.0
import QtQuick

import '../../../../Defines' as Defines


// dimensions are set in CenterOverlay.qml

CenterOverlay {
  id: sliceSize

  property real screenScale: prefs.screenScale

  property int deckId: 0
  
  property var beatString: (sliceSizeIndex.value > 1) ? "BEATS" : "BEAT"

  Defines.Margins {id: customMargins }

  //--------------------------------------------------------------------------------------------------------------------

  AppProperty { id: sliceSizeIndex; path: "app.traktor.decks." + (deckId+1) + ".freeze.slice_size_in_measures"; }

  //--------------------------------------------------------------------------------------------------------------------

  Text {
    anchors.top:              parent.top
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.topMargin:        customMargins.topMarginCenterOverlayHeadline * screenScale  // Escalar margen

    font.pixelSize:           fonts.largeFontSize * screenScale  
    font.family:              prefs.normalFontName

    color:                    colors.colorCenterOverlayHeadline
  	text:   "SLICE SIZE"
  }

  Text {
    anchors.top:              parent.top
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.topMargin:        53 * screenScale  // Escalar margen

    font.pixelSize:           fonts.extraLargeFontSizePlus * screenScale  
    font.family:              prefs.normalFontName

    color:                    colors.colorWhite  
    text:  sliceSizeIndex.value + "  " + beatString
  }
}
