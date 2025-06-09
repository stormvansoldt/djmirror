import QtQuick
import Qt5Compat.GraphicalEffects


import '../../Widgets' as Widgets

// The DisplayButtonArea is a stripe on the left/right border of the screen andcontains two DisplayButtons
// showing the state of the actual buttons to the left/right of the main screen.
/// \todo figure out if the button area is a) always visible or b) visible on touching the button

Rectangle {
  id: buttonArea

  property real screenScale: 1.9

  property bool isLeftRow
  property int  scrollPosition
  property int  textAngle
  property string topButtonText
  property string bottomButtonText
  property alias  showHideState: showHide.state
  property string contentState
  property bool   isTopHighlighted:    false
  property bool   isBottomHighlighted: false

  // contains grey background, black border & glow

  width:  38

  // opacity: 0
  anchors.topMargin: 31
  anchors.bottomMargin: 31
  anchors.top: parent.top
  anchors.bottom: parent.bottom
  color: colors.colorBlack

  function rgba(r,g,b,a) { return Qt.rgba( r/255. , g/255. , b/255. , a/255. ) }

  // grey area
  Rectangle {
    id:                   buttonAreaBg
    anchors.fill:         parent
    color:                colors.colorFxHeaderBg
    anchors.margins:      2
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
    anchors.rightMargin:    2
    anchors.leftMargin:     2
    height:                 3
    anchors.verticalCenter: parent.verticalCenter
    color:                  colors.colorBlack
    visible:                (content.state != "ScrollBar")
  }

  Text {
    id:                 text1
    text:               topButtonText
    rotation:           -90
    color:              isTopHighlighted ? colors.colorGrey232 : colors.colorGrey80

    font.pixelSize:     fonts.miniFontSizePlusPlus
    font.family:        prefs.normalFontName

    horizontalAlignment: Text.AlignHCenter
    verticalAlignment:  Text.AlignVCenter

    anchors.bottom:     parent.verticalCenter

    anchors.left:       parent.left
    anchors.top:        parent.top
    anchors.right:      parent.right
    anchors.topMargin:  2
    anchors.leftMargin: 5

    opacity:            1
  }

  Text {
    id:                 text2
    text:               bottomButtonText
    rotation:           -90
    color:              isBottomHighlighted ? colors.colorGrey232 : colors.colorGrey80

    font.pixelSize:     fonts.miniFontSizePlusPlus
    font.family:        prefs.normalFontName

    horizontalAlignment: Text.AlignHCenter
    verticalAlignment:   Text.AlignVCenter

    anchors.top:        parent.verticalCenter

    anchors.left:       parent.left
    anchors.right:      parent.right
    anchors.bottom:     parent.bottom
    anchors.leftMargin: 5
    anchors.topMargin:  -2
    opacity:            1
  }

  // deck position indicators
  ScrollBar {
    id: scrollBar
    anchors.fill: parent
    currentPosition: parent.scrollPosition
  }

  Image {
    id:                 magnifierPlus
    source:             "./../../Images/Overlay_PlusIcon" + colors.inverted + ".png"
    width:              sourceSize.width
    height:             sourceSize.height
    anchors.top:        parent.top
    anchors.left:       parent.left 
    anchors.topMargin:  44
    anchors.leftMargin: 9
    opacity:            0.3 // set in state
  }

  Image {
    id:                 magnifierMinus
    source:             "./../../Images/Overlay_MinusIcon" + colors.inverted + ".png"
    width:              sourceSize.width
    height:             sourceSize.height
    anchors.top:        parent.top
    anchors.left:       parent.left 
    anchors.topMargin:  148
    anchors.leftMargin: 9
    opacity:            0.3 // set in state
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
