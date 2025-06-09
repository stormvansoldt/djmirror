import QtQuick
import Qt5Compat.GraphicalEffects

//----------------------------------------------------------------------------------------------------------------------
// NEW KNOBS
//
// ELEMENTOS PRINCIPALES Y COLORES:
//
// 1. Contenedor Principal (faderContainer)
//    - Propiedades:
//      * internalValue: Valor interno del knob
//      * hardwareValue: Valor del hardware
//      * mismatch: Indica si hay desajuste entre valores
//
// 2. Círculo Exterior (Arc)
//    - Color de la escala: scaleColor (default: colors.colorGrey64)
//    - Dos arcos con un gap central para marcar la posición media
//
// 3. Fondo del Knob (knob_BG)
//    - Color: colors.colorBlack
//    - Forma: Círculo
//
// 4. Knob Gris (knob_outercircle_grey)
//    - Color de borde: matchColor (default: colors.colorGrey96) o transparente si hay desajuste
//    - Indicador de valor: Color de borde o takeoverColor si hay desajuste
//    - Rotación basada en hardwareValue
//
// 5. Knob Rojo (knob_outercircle_red)
//    - Visible solo si hay desajuste
//    - Color de borde: mismatchColor (default: colors.colorRed70)
//    - Indicador de valor: mismatchColor
//    - Rotación basada en internalValue
//
// NOTAS:
// - El componente representa un knob con indicadores visuales para el valor actual y el valor de hardware.
// - Los colores cambian dinámicamente según el estado de desajuste.
// - La rotación de los indicadores se calcula en función de los valores proporcionados.
//
//----------------------------------------------------------------------------------------------------------------------


// container
Item {
  id: faderContainer
  property double internalValue: 0.0
  property double hardwareValue: 0.0
  property bool mismatch: false

  property variant scaleColor:      colors.colorGrey64
  property variant mismatchColor:   colors.colorRed70
  property variant matchColor:      colors.colorGrey96
  property variant takeoverColor:   colors.colorGrey64

  function rotationAngleForKnobValue(value) {
    return value * 300 + 30
  }

  opacity: 1
  width: 47
  height: width

  // outer circle, scale
  Item {
    width: 47
    height: width

    // the gap that marks the center position in the outer arc
    property real outerCenterGap: 0.01
    // how far the outer arc overshoots the start/end position
    property real outerOverrun: 0.015

    // Outside circle with gaps (graphical element)
    Arc {
      anchors.fill: parent
      lineWidth: 1.5
      strokeStyle: scaleColor
      startAngle: rotationAngleForKnobValue(-parent.outerOverrun)
      endAngle: rotationAngleForKnobValue(0.5 - parent.outerCenterGap)
      transform: Rotation {
        origin.x: width / 2
        origin.y: height / 2
        angle: 90
      }
    }
    Arc {
      anchors.fill: parent
      lineWidth: 1.5
      strokeStyle: scaleColor
      startAngle: rotationAngleForKnobValue(0.5 + parent.outerCenterGap)
      endAngle: rotationAngleForKnobValue(1.0 + parent.outerOverrun)
      transform: Rotation {
        origin.x: width / 2
        origin.y: height / 2
        angle: 90
      }
    }

    // KNOB black background
    Rectangle {
      id: knob_BG
      anchors.centerIn: parent
      width: 39
      height: width
      radius: width / 2
      color: colors.colorBlack
    }

    // GREY KNOB
    // outer circle, knob grey
    Rectangle {
      id: knob_outercircle_grey
      anchors.centerIn: parent
      width: 37
      height: width
      radius: width / 2
      color: "transparent"
      border.color: mismatch ? "transparent" : matchColor
      border.width: 2.5
      transform: Rotation {
        origin.x: 18.5
        origin.y: 18.5
        angle: rotationAngleForKnobValue(hardwareValue) + 180
      }
      // Value indicator
      Rectangle {
        width: 3
        height: 11
        color: mismatch ? takeoverColor : matchColor
        anchors.top: parent.top
        anchors.topMargin: 5
        anchors.horizontalCenter: parent.horizontalCenter
        antialiasing: true
      }
    }
    // RED KNOB
    // outer circle, knob red
    Rectangle {
      id: knob_outercircle_red
      anchors.centerIn: parent
      width: 37
      height: width
      radius: width / 2
      color: "transparent"
      visible: mismatch
      border.color: mismatchColor
      border.width: 2.5
      transform: Rotation {
        origin.x: 18.5
        origin.y: 18.5
        angle: rotationAngleForKnobValue(internalValue) + 180
      }

      // value indicator
      Rectangle {
        width: 3
        height: 11
        color: mismatchColor
        anchors.top: parent.top
        anchors.topMargin: 5
        anchors.horizontalCenter: parent.horizontalCenter
        antialiasing: true
      }
    }
  }
}
