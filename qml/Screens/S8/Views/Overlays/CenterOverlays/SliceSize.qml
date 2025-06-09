import CSI 1.0
import QtQuick

import '../../../../Defines' as Defines


// dimensions are set in CenterOverlay.qml

CenterOverlay {
  id: sliceSize

  Defines.Margins {id: customMargins }

  property int  deckId:    0
  property var beatString: (sliceSizeIndex.value > 1) ? "BEATS" : "BEAT"

  //--------------------------------------------------------------------------------------------------------------------

  AppProperty { id: sliceSizeIndex; path: "app.traktor.decks." + (deckId+1) + ".freeze.slice_size_in_measures"; }

  //--------------------------------------------------------------------------------------------------------------------

  Text {
    anchors.top:              parent.top
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.topMargin:        customMargins.topMarginCenterOverlayHeadline

    font.pixelSize:           fonts.largeFontSize
    font.family:              prefs.normalFontName

    color:                    colors.colorCenterOverlayHeadline
  	text:   "SLICE SIZE"
  }

  Text {
    anchors.top:              parent.top
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.topMargin:        53

    font.pixelSize:           fonts.extraLargeFontSizePlus
    font.family:              prefs.normalFontName

    color:                    colors.colorWhite  
    text:  sliceSizeIndex.value + "  " + beatString
  }
}
