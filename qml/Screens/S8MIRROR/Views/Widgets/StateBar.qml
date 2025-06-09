import CSI 1.0
import QtQuick

import '../../../Defines' as Defines


// StateBar fits 'state count' elements into a bar of a given width and spacing. Take care that 'width > stateCount*spacing'
Item {
  id: stateBarContainer

  property real screenScale: prefs.screenScale
  
  property int   spacing: 2 * screenScale  // Escalar el espaciado
  property int   stateCount: 5  // No necesita escalado (es un contador)
  property int   currentState: 2  // No necesita escalado (es un índice)
  property color barColor:     colors.colorIndicatorLevelOrange  // default value. set from outside
  property color barBgColor:   colors.colorGrey24                // default value. set from outside

  property alias          stateBarHeight: stateBarContainer.height
  readonly property real  stateBarWidth:  width/stateCount - spacing

  Defines.Colors { id: colors}

  Row {
    id: boxRow
    anchors.fill: parent
    anchors.leftMargin: 0.5 * stateBarContainer.spacing
    spacing:            stateBarContainer.spacing 
    Repeater {
      model: stateCount
      Rectangle {
        width:  stateBarWidth 
        height: stateBarHeight
        color:  (index == currentState) ? barColor : barBgColor
      }
    }
  }
}
