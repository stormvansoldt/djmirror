import QtQuick
import Qt5Compat.GraphicalEffects
import CSI 1.0

import '../../Widgets' as Widgets

// The DisplayButtonArea is a stripe on the left/right border of the screen andcontains two DisplayButtons
// showing the state of the actual buttons to the left/right of the main screen.
/// \todo figure out if the button area is a) always visible or b) visible on touching the button

Rectangle {
  id: buttonArea

  property real screenScale: prefs.screenScale

  property bool isLeftRow
  property int  scrollPosition
  property int  textAngle
  property string topButtonText
  property string bottomButtonText
  property alias  showHideState: showHide.state
  property string contentState
  property bool   isTopHighlighted:    false
  property bool   isBottomHighlighted: false

  // Señales para zoom
  signal zoomInRequested()
  signal zoomOutRequested()

  // Señales para scrollPosition
  signal scrollUp(int oldPosition, int newPosition)
  signal scrollDown(int oldPosition, int newPosition)

  // Añadir propiedades para el zoom
  property int currentZoom: 7  // valor inicial del zoom
  property int minZoom: 0
  property int maxZoom: 9

  property int deckId: 1  // Deck ID por defecto, debería ser configurado externamente
  property string settingsPath: ""
  property string propertiesPath: ""

  // contains grey background, black border & glow

  width:  38 * screenScale

  // opacity: 0
  anchors.topMargin: 31 * screenScale
  anchors.bottomMargin: 31 * screenScale
  anchors.top: parent.top
  anchors.bottom: parent.bottom
  color: colors.colorBlack

  function rgba(r,g,b,a) { return Qt.rgba( r/255. , g/255. , b/255. , a/255. ) }

  // UPPER DECK (A OR B) ---------------------------------------------------------------------------------------------
  MappingProperty { id: deckZoomLevel;     path:   settingsPath + ".top.waveform_zoom"   }

  // grey area
  Rectangle {
    id:                   buttonAreaBg
    anchors.fill:         parent
    color:                colors.colorFxHeaderBg
    anchors.margins:      2 * screenScale
    // anchors.topMargin:    1
    // anchors.rightMargin:  1
    // anchors.bottomMargin: 1
    // anchors.leftMargin:   1
  }

  // divider
  Rectangle {
    id:                     buttonAreaDivider
    anchors.left:           parent.left
    anchors.right:          parent.right
    anchors.rightMargin:    2 * screenScale
    anchors.leftMargin:     2 * screenScale
    height:                 3 * screenScale
    anchors.verticalCenter: parent.verticalCenter
    color:                  colors.colorBlack
    visible:                (content.state != "ScrollBar")
  }

  Text {
    id:                 text1
    text:               topButtonText
    rotation:           -90
    color:              isTopHighlighted ? colors.colorGrey232 : colors.colorGrey80

    font.pixelSize:     fonts.miniFontSizePlusPlus * screenScale
    font.family:        prefs.normalFontName

    horizontalAlignment: Text.AlignHCenter
    verticalAlignment:  Text.AlignVCenter

    anchors.bottom:     parent.verticalCenter

    anchors.left:       parent.left
    anchors.top:        parent.top
    anchors.right:      parent.right
    anchors.topMargin:  2 * screenScale
    anchors.leftMargin: 5 * screenScale

    opacity:            1
  }

  Text {
    id:                 text2
    text:               bottomButtonText
    rotation:           -90
    color:              isBottomHighlighted ? colors.colorGrey232 : colors.colorGrey80

    font.pixelSize:     fonts.miniFontSizePlusPlus * screenScale
    font.family:        prefs.normalFontName

    horizontalAlignment: Text.AlignHCenter
    verticalAlignment:   Text.AlignVCenter

    anchors.top:        parent.verticalCenter

    anchors.left:       parent.left
    anchors.right:      parent.right
    anchors.bottom:     parent.bottom
    anchors.leftMargin: 5 * screenScale
    anchors.topMargin:  -2 * screenScale
    opacity:            1
  }

  // deck position indicators
  ScrollBar {
    id: scrollBar
    anchors.fill: parent
    currentPosition: buttonArea.scrollPosition

    onScrollUp: {
      buttonArea.scrollUp(oldPosition, newPosition)
    }

    onScrollDown: {
      buttonArea.scrollDown(oldPosition, newPosition)
    }
  }

  Image {
    id:                 magnifierPlus
    source:             "./../../Images/Overlay_PlusIcon" + colors.inverted + ".png"
    width:              sourceSize.width * screenScale
    height:             sourceSize.height * screenScale
    anchors.top:        parent.top
    anchors.left:       parent.left 
    anchors.topMargin:  44 * screenScale
    anchors.leftMargin: 9 * screenScale
    opacity:            0.3 // set in state
    fillMode: Image.PreserveAspectFit

    MouseArea {
      enabled: (magnifierPlus.opacity === 0.3) && (contentState === "Magnifiers")
      anchors.fill: parent
      anchors.topMargin: -30 * screenScale
      anchors.bottomMargin: -30 * screenScale
      onClicked: {
        if (currentZoom > minZoom) {
          currentZoom--
          // Actualizar el zoom en Traktor
          deckZoomLevel.value = currentZoom
          // Emitir señal de zoom out
          zoomOutRequested()
        }
      }
    }
  }

  Image {
    id:                 magnifierMinus
    source:             "./../../Images/Overlay_MinusIcon" + colors.inverted + ".png"
    width:              sourceSize.width * screenScale
    height:             sourceSize.height * screenScale
    anchors.top:        parent.top
    anchors.left:       parent.left 
    anchors.topMargin:  148 * screenScale
    anchors.leftMargin: 9 * screenScale
    opacity:            0.3 // set in state
    fillMode: Image.PreserveAspectFit

    MouseArea {
      enabled: (magnifierMinus.opacity === 0.3) && (contentState === "Magnifiers")
      anchors.fill: parent
      anchors.topMargin: -30 * screenScale
      anchors.bottomMargin: -30 * screenScale      
      onClicked: {
        if (currentZoom < maxZoom) {
          currentZoom++
          // Actualizar el zoom en Traktor
          deckZoomLevel.value = currentZoom
          // Emitir señal de zoom in
          zoomInRequested()
        }
      }
    } 
  }

  //------------------------------------------------------------------------------------------------------------------
  //  STATES
  //------------------------------------------------------------------------------------------------------------------
  Item {
    id: showHide
    state: "hide"

    states: [
    State {
      name: "hide"
      PropertyChanges { target: buttonArea;   opacity: 0 }
      },
      State {
        name: "show"
        PropertyChanges { target: buttonArea;   opacity: 1 }
      }
    ]

    transitions: [
      Transition {
        from: "hide"; to: "show";
        NumberAnimation { properties: "opacity"; easing.type: Easing.InOutQuad; duration: 100 }
      },
      Transition {
        from: "show"; to: "hide";
        NumberAnimation { properties: "opacity"; easing.type: Easing.InOutQuad; duration: 100 }
      }
    ]
  }

  Item {
    id: content
    state: contentState
    states: [
      State {
        // remix deck indicators
        name: "ScrollBar"
        PropertyChanges { target: scrollBar; opacity: 1 }
        PropertyChanges { target: text1;     opacity: 0 }
        PropertyChanges { target: text2;     opacity: 0 }
        PropertyChanges { target: magnifierPlus; opacity: 0 }
        PropertyChanges { target: magnifierMinus; opacity: 0 }
      },
      State {
        name: "TextArea"
        PropertyChanges { target: scrollBar; opacity: 0 }
        PropertyChanges { target: text1;     opacity: 1 }
        PropertyChanges { target: text2;     opacity: 1 }
        PropertyChanges { target: magnifierPlus; opacity: 0 }
        PropertyChanges { target: magnifierMinus; opacity: 0 }
      },
      State {
        name: "Magnifiers"
        PropertyChanges { target: scrollBar; opacity: 0 }
        PropertyChanges { target: text1;     opacity: 0 }
        PropertyChanges { target: text2;     opacity: 0 }
        PropertyChanges { target: magnifierPlus; opacity: 0.3 }
        PropertyChanges { target: magnifierMinus; opacity: 0.3 }
      }
    ]
  }
}
