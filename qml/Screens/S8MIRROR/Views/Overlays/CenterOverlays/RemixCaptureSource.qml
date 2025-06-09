import CSI 1.0
import QtQuick

import '../../../../Defines' as Defines

// dimensions are set in CenterOverlay.qml

CenterOverlay {
  id: captureSource

  Defines.Margins { id: customMargins }

  property real screenScale: prefs.screenScale

  property int  deckId:    0

  //--------------------------------------------------------------------------------------------------------------------

  AppProperty { id: captureSrcIndex; path: "app.traktor.decks." + (deckId+1) + ".capture_source"; }

  //--------------------------------------------------------------------------------------------------------------------

  Text {
    anchors.top:              parent.top
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.topMargin:        customMargins.topMarginCenterOverlayHeadline * screenScale

    font.pixelSize:           fonts.largeFontSize * screenScale
    font.family:              prefs.normalFontName

    color:                    colors.colorCenterOverlayHeadline
    text:                     "CAPTURE"
  }

  Text {
    anchors.top:              parent.top
  	anchors.horizontalCenter: parent.horizontalCenter
    anchors.topMargin:        47 * screenScale

  	font.pixelSize:           fonts.extraLargeFontSizePlusPlus * screenScale
    font.family:              prefs.normalFontName
    font.capitalization:      Font.AllUppercase

  	color:                    (deckId > 1) ? colors.colorWhite : colors.colorDeckBright
    text:                     captureSrcIndex.description
  }
}
