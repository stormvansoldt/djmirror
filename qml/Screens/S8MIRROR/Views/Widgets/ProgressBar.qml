import QtQuick

import '../../../Defines' as Defines

Item {
  id: progressBarContainer

  property real screenScale: prefs.screenScale

  property color progressBarColorIndicatorLevel // set from outside
  property real  value:         0.0
  property bool  drawAsEnabled: true

  property alias progressBarWidth:           progressBar.width
  property alias progressBarHeight:          progressBarContainer.height
  property alias progressBarBackgroundColor: progressBar.color // set from outside

  Defines.Colors { id: colors}

  // Función para actualizar la posición del thumb
  function updateThumbPosition() {
    if (!progressBar || !valueIndicator || !indicatorThumb) return
    
    var val = Math.max(Math.min(value, 1.0), 0.0)
    valueIndicator.width = val * progressBar.width
    indicatorThumb.x = valueIndicator.width - (indicatorThumb.width / 2)
  }

  onValueChanged: updateThumbPosition()
  onWidthChanged: updateThumbPosition()

  height: 6 * screenScale
  width:  120 * screenScale

  // Progress Background
  Rectangle {
    id: progressBar

    anchors.left: parent.left
    anchors.top:  parent.top
    height:       parent.height 
    width:        102 * screenScale  // Escalar ancho por defecto

    color:        colors.colorWhite09 // set in BottomInfoDetails

    onWidthChanged: updateThumbPosition()

    // Progress Level
    Rectangle {
      id: valueIndicator
      width:          0 // set in parent
      anchors.top:    parent.top
      anchors.bottom: parent.bottom
      anchors.left:   parent.left
      color:          progressBarContainer.progressBarColorIndicatorLevel
      visible:        drawAsEnabled ? true : false

      onWidthChanged: updateThumbPosition()
    }

    // Progress Indicator Thumb
    Rectangle {
      id: indicatorThumb
      color: colors.colorWhite 
      width: 2 * screenScale
      height: parent.height
      anchors.top: parent.top
      anchors.bottom: parent.bottom
      x: -width / 2 // Posición inicial centrada en 0
      visible: drawAsEnabled

      Behavior on x {
        enabled: progressBar.width > 0  // Solo activar la animación cuando el ancho sea válido
        NumberAnimation { 
          duration: 50
          easing.type: Easing.OutCubic
        }
      }
    }
  }

  // Asegurar que la posición se actualice después de que el componente esté listo
  Component.onCompleted: {
    Qt.callLater(updateThumbPosition)
  }
}
