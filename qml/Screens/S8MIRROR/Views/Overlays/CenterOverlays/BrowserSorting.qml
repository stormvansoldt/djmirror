import QtQuick
import CSI 1.0

import '../../../../Defines' as Defines

CenterOverlay {
  id: tempoAdjust
  
  Defines.Margins {id: customMargins }

  property real screenScale: prefs.screenScale
  
  property int deckId: 0

  //--------------------------------------------------------------------------------------------------------------------

  AppProperty { id: propSortId;   path: "app.traktor.browser.sort_id" }
  AppProperty { id: propSortDirection; path: "app.traktor.browser.sorting.direction" }

  function getText(id) {
    // the given numbers are determined by the EContentListColumns in Traktor
    switch (id) {
      case -1:  return "NONE"
      case 0:   return "#"
      case 2:   return "TITLE"
      case 3:   return "ARTIST"
      case 7:   return "RELEASE"
      case 9:   return "GENRE"
      case 5:   return "BPM"
      case 28:  return "KEY"
      case 22:  return "RATING"
      case 27:  return "IMPORT DATE"
      default:  break;
    }
    return "SORTED"
  }


  //--------------------------------------------------------------------------------------------------------------------

  // headline
  Text {
    anchors.top:              parent.top
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.topMargin:        11 * screenScale

    font.pixelSize:           fonts.largeFontSize * screenScale
    font.family:              prefs.normalFontName

    color:                    colors.colorCenterOverlayHeadline
    text:                     "SORT BY"
  }

  // value
  Text {
    id: sortingValue
    anchors.top:              parent.top
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.topMargin:        (text.length < 10) ? (45 * screenScale) : (53 * screenScale)

    font.pixelSize:           (text.length < 10) ? (fonts.extraLargeFontSizePlus * screenScale) : (fonts.extraLargeFontSize * screenScale)
    font.family:              prefs.normalFontName

    color:                    colors.colorWhite    
    text:                     getText( propSortId.value ) 
  }
}
