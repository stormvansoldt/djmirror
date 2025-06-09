import QtQuick
import Qt5Compat.GraphicalEffects

// container
Rectangle {
  id: faderContainer

  property real screenScale: prefs.screenScale

  property double internalValue: 0.0
  property double hardwareValue: 0.0
  property bool   mismatch: false

  property variant scaleColor:    colors.colorGrey64
  property variant mismatchColor: colors.colorRed70
  property variant takeoverColor: colors.colorGrey96 //colors.colorGrey152
  property variant handleColor:   colors.colorGrey96 //colors.colorGrey152

  // Number of ticks between start/end tick
  property int tickCount:           4
  // Spacing between the central ticks
  property int interTickSpacing:    8 * screenScale
  // Spacing between the start/end ticks and the central ticks
  property int preTickSpacing:      10 * screenScale
  // Line width of the start/end ticks
  property int borderTickLineWidth: 2 * screenScale
  // Line width of the central ticks
  property int tickLineWidth:       1 * screenScale
 
  property int scaleHeight: (tickCount-1)*interTickSpacing + tickCount*tickLineWidth + 2*preTickSpacing


  opacity:        1
  width:          36 * screenScale
  height:         scaleHeight + 14 * screenScale
  color:          "transparent"

  // background
  Rectangle {
    id:           faderBg
    width:        24 * screenScale
    height:       scaleHeight
    anchors.verticalCenter: parent.verticalCenter
    anchors.horizontalCenter: parent.horizontalCenter
    color:        "transparent"

    // upper line
    Row {
      anchors.top:  parent.top
      spacing: 6 * screenScale
      Repeater {
        model:  2
        Rectangle {
          height:     borderTickLineWidth
          width:      9 * screenScale
          color:      scaleColor
        }
      }
    }

    // bottom line
    Row {
      anchors.bottom: parent.bottom
      spacing: 6 * screenScale
      Repeater {
        model:  2
        Rectangle {
          height:     borderTickLineWidth
          width:      9 * screenScale
          color:      scaleColor
        }
      }
    }

    // indicators left
    Column {
      anchors.left:       parent.left
      anchors.top:        parent.top
      anchors.topMargin:  preTickSpacing
      spacing:            interTickSpacing
      Repeater {
        model:  4
        Rectangle {
          height:     tickLineWidth
          width:      5 * screenScale
          color:      scaleColor
        }
      }
    }

    // indicators right
    Column {
      anchors.right:      parent.right
      anchors.top:        parent.top
      anchors.topMargin:  preTickSpacing
      spacing:            interTickSpacing
      Repeater {
        model:        4
        Rectangle {
          height:     tickLineWidth
          width:      5 * screenScale
          color:      scaleColor
        }
      }
    }

    // vertical lines
    Row {
      anchors.left: parent.left
      anchors.top: parent.top
      anchors.leftMargin: 9 * screenScale
      spacing: 4 * screenScale
      Repeater {
        model:  2
        Rectangle {
          width:          1 * screenScale
          height:         scaleHeight
          color:          scaleColor
        }
      }
    }

    // black vertical fill
    Rectangle {
      width:      4 * screenScale
      height:     scaleHeight
      anchors.left: parent.left
      anchors.leftMargin:   10 * screenScale
      color:      colors.colorBlack
    }
  }

  // takeoverPosition
  Item {
    width:        parent.width
    height:       16 * screenScale
    anchors.horizontalCenter: parent.horizontalCenter
    y:            (1 - hardwareValue)* (faderBg.height - 2 * screenScale)
    visible: mismatch
                  
    // handle line
    Rectangle {
      anchors.top:  parent.top
      anchors.left: parent.left
      height:       parent.height
      width:        2 * screenScale
      color:        takeoverColor 
      Rectangle { anchors.top:    parent.top;    anchors.left: parent.left; color: takeoverColor; height: 2 * screenScale; width: 6 * screenScale }
      Rectangle { anchors.bottom: parent.bottom; anchors.left: parent.left; color: takeoverColor; height: 2 * screenScale; width: 6 * screenScale }
    }
    Rectangle {
      anchors.top : parent.top
      anchors.right: parent.right
      height:       parent.height
      width:        2 * screenScale
      color:        takeoverColor 
      Rectangle { anchors.top:    parent.top;    anchors.right: parent.right; color: takeoverColor; height: 2 * screenScale; width: 6 * screenScale }
      Rectangle { anchors.bottom: parent.bottom; anchors.right: parent.right; color: takeoverColor; height: 2 * screenScale; width: 6 * screenScale }
    }
  }

  // handle
  Rectangle {
    id:           faderHandle
    y :           (1 - internalValue)* (faderBg.height - 2 * screenScale)
    width:        parent.width
    height:       16 * screenScale
    anchors.horizontalCenter: parent.horizontalCenter
    color:        colors.colorBlack
    border.width:  2 * screenScale
    border.color: faderContainer.mismatch ? mismatchColor : handleColor

    // handle line
    Rectangle {
      id:           faderHandleLine
      anchors.verticalCenter: parent.verticalCenter
      anchors.horizontalCenter: parent.horizontalCenter
      width:        parent.width -12 * screenScale
      height:       2 * screenScale
      color:        faderContainer.mismatch ? mismatchColor : handleColor
    }
  }
}
