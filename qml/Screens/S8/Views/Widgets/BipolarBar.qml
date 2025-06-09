import QtQuick

import '../../../Defines' as Defines


//----------------------------------------------------------------------------------------------------------------------
//  BIPOLAR BAR - Barra de progreso bidireccional que crece desde el centro
//
//  ELEMENTOS PRINCIPALES Y COLORES:
//
//  1. Contenedor Principal (progressBarContainer)
//     - Controla el valor y estado general del componente
//
//  2. Barra de Progreso (progressBar)
//     - Color de fondo: colors.colorWhite
//
//  3. Indicadores de Valor
//     a. Indicador Izquierdo (leftValueIndicator)
//        - Color: colors.colorIndicatorLevelGrey
//
//     b. Indicador Derecho (rightValueIndicator)
//        - Color: colors.colorIndicatorLevelGrey
//
//  4. Marcador de Posición (indicatorThumb)
//     - Color: colors.colorWhite
//
//  PROPIEDADES DE COLOR:
//  - progressBarColorIndicatorLevel: Color de los indicadores (default: colorIndicatorLevelGrey)
//  - progressBarBackgroundColor: Color de fondo de la barra
//
//  NOTAS:
//  - Los indicadores solo son visibles cuando drawAsEnabled es true
//  - El valor se normaliza entre 0.0 y 1.0
//  - El punto central es 0.5
//  - Asume que 'colors' existe en la jerarquía
//
//----------------------------------------------------------------------------------------------------------------------

Item {

  id: progressBarContainer

  property alias progressBarWidth:  progressBar.width
  property alias progressBarHeight: progressBarContainer.height
  property color progressBarColorIndicatorLevel: colors.colorIndicatorLevelGrey
  property alias progressBarBackgroundColor: progressBar.color
  property real value: 0.0
  property bool drawAsEnabled: true

  Defines.Colors { id: colors}

  onValueChanged: {
    var val  = Math.max( Math.min(value, 1.0), 0.0)
    if ( val < 0.5 ) { 
      leftValueIndicator.width  = (0.5 - val) * (progressBar.width - 2)
      rightValueIndicator.width = 0
    } else {
      leftValueIndicator.width  = 0
      rightValueIndicator.width = (val - 0.5) * (progressBar.width - 2)
    }
  }

  height: 6
  width: 120

  // Progress Background
  Rectangle {
    id: progressBar
    anchors.left: parent.left
    anchors.top: parent.top
    height: parent.height
    width:  100 // set from outside
    color: colors.colorWhite // set from outside

    Rectangle {
      id: leftValueIndicator
      width: 0
      anchors.top: parent.top
      anchors.bottom: parent.bottom
      anchors.right: parent.horizontalCenter
      color: progressBarContainer.progressBarColorIndicatorLevel
      visible: drawAsEnabled ? true : false
    }

    Rectangle {
      id: rightValueIndicator
      width: 0
      anchors.top: parent.top
      anchors.bottom: parent.bottom
      anchors.left: parent.horizontalCenter
      color: progressBarContainer.progressBarColorIndicatorLevel
      visible: drawAsEnabled ? true : false
    }
    // Progress Indicator Thumb
    Rectangle {
      id: indicatorThumb
        color: colors.colorWhite // (progressBarContainer.progressBarColorIndicatorLevel != colors.colorWhite) ? colors.colorWhite : colors.colorBlack
        width: 2
        height: parent.height 
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: (leftValueIndicator.width > 0 ) ? leftValueIndicator.left : rightValueIndicator.right
        visible: drawAsEnabled ? true : false
    }
  }
}
