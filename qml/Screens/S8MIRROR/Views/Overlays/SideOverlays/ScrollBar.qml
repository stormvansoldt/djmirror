import QtQuick
import Qt5Compat.GraphicalEffects
import CSI 1.0
import Traktor.Gui 1.0 as Traktor

import '../../Widgets' as Widgets

// The DisplayButtonArea is a stripe on the left/right border of the screen andcontains two DisplayButtons
// showing the state of the actual buttons to the left/right of the main screen.
/// \todo figure out if the button area is a) always visible or b) visible on touching the button


Item {
  id: scrollBar

  property real screenScale: prefs.screenScale

  property int currentPosition: 0
  property int maxPosition: 7  // 8 posiciones (0-7) ya que se mueve de dos en dos

  // Señales para navegación
  signal scrollUp(int oldPosition, int newPosition)
  signal scrollDown(int oldPosition, int newPosition)

  anchors.fill: parent
  anchors.verticalCenter: parent.verticalCenter
  
  // Contenedor principal de las barras
  Column {
    id: barContainer
    spacing: 3 * screenScale
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.verticalCenter: parent.verticalCenter

    Repeater {
      model: 8
      Rectangle {
        id: bar
        width: 6 * screenScale
        height: 17 * screenScale
        color: (scrollBar.currentPosition == index) ? colors.colorWhite : colors.colorGrey40

        // MouseArea para cada barra individual
        MouseArea {
          anchors.fill: parent
          onClicked: {
            if (scrollBar.currentPosition !== index) {
              var oldPosition = scrollBar.currentPosition
              scrollBar.currentPosition = index
              
              // Emitir señales en el orden correcto
              if (index > oldPosition) {
                scrollDown(oldPosition, index)
              } else if (index < oldPosition) {
                scrollUp(oldPosition, index)
              }
              
              prefs.log("INFO", "Bar clicked - Old position: " + oldPosition + ", New position: " + index)
            }
          }
        }
      }
    }
  }

  // Flecha arriba
  Widgets.Triangle { 
    id : arrowUp
    width: 10 * screenScale
    height: 9 * screenScale
    anchors.top: parent.top
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.topMargin: 12 * screenScale
    color: colors.colorGrey40
    rotation: 180
    antialiasing: true

    MouseArea {
      anchors.fill: parent
      onClicked: {
        if (currentPosition > 0) {
          var oldPosition = currentPosition
          currentPosition--
          // Emitir señales en el orden correcto
          scrollUp(oldPosition, currentPosition)
          prefs.log("INFO", "Arrow Up - Old position: " + oldPosition + ", New position: " + currentPosition)
        }
      }
    }
  }

  // Flecha abajo
  Widgets.Triangle { 
    id : arrowDown
    width: 10 * screenScale
    height: 9 * screenScale
    anchors.bottom: parent.bottom
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.bottomMargin: 13 * screenScale
    color: colors.colorGrey40
    rotation: 0
    antialiasing: true

    MouseArea {
      anchors.fill: parent
      onClicked: {
        if (currentPosition < maxPosition) {
          var oldPosition = currentPosition
          currentPosition++
          // Emitir señales en el orden correcto
          scrollDown(oldPosition, currentPosition)
          prefs.log("INFO", "Arrow Down - Old position: " + oldPosition + ", New position: " + currentPosition)
        }
      }
    }
  }
}

