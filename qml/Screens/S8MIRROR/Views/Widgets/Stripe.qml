import CSI 1.0
import QtQuick
import Traktor.Gui 1.0 as Traktor

/**
 * @brief Componente que muestra la forma de onda simplificada de una pista
 * 
 * Este componente extiende Traktor.Stripe para mostrar una vista general de la pista,
 * incluyendo hotcues, posición actual, tiempo transcurrido y advertencias de fin de pista.
 * 
 * @component Traktor.Stripe
 * @property {Object} hotcuesModel - Modelo de datos para los hotcues
 * @property {int} trackLength - Duración total de la pista en segundos
 * @property {real} elapsedTime - Tiempo transcurrido de reproducción
 * @property {bool} trackEndWarning - Indica si debe mostrarse la advertencia de fin de pista
 * @property {Object} waveformColors - Colores para la forma de onda (obtenidos de colors.getDefaultWaveformColors)
 * 
 * Subcomponentes:
 * 1. Sombra de tiempo transcurrido:
 *    - Rectángulo semitransparente que cubre el área reproducida
 * 
 * 2. Hotcues:
 *    - Repeater que muestra hasta 8 hotcues
 *    - Posición calculada según trackLength
 * 
 * 3. Cue activo:
 *    - Muestra el hotcue actualmente seleccionado
 *    - Incluye indicador de longitud si es un loop
 * 
 * 4. Advertencia de fin de pista:
 *    - Overlay rojo parpadeante
 *    - Se activa cuando trackEndWarning es true
 * 
 * 5. Indicador de posición:
 *    - Línea vertical que muestra la posición actual
 *    - Color: rgba(255, 56, 26, 255)
 * 
 * Ejemplo de uso:
 * ```qml
 * Stripe {
 *     hotcuesModel: deckHotcues
 *     trackLength: 360  // 6 minutos
 *     elapsedTime: 120 // 2 minutos
 *     trackEndWarning: remainingTime < 30
 * }
 * ```
 */

Traktor.Stripe {
  id: stripe

  property real screenScale: prefs.screenScale

  property var hotcuesModel:  {}

  property int           trackLength: 0
  property real          elapsedTime: 0

  property bool          trackEndWarning: false
  readonly property var  waveformColors:   colors.getDefaultWaveformColors()

  readonly property real colorFactor: 1.6

  deckId:        0
  
  //-----------------------------------------------------Traktor Stripe Props--------------------------------------------

  function calcLightColor(c) {
      return Qt.rgba(
          Math.min(1.0, c.r * colorFactor),
          Math.min(1.0, c.g * colorFactor),
          Math.min(1.0, c.b * colorFactor),
          c.a
      );
  }

  colorMatrix {
    high1: calcLightColor(waveformColors.high1)
    high2: calcLightColor(waveformColors.high2)
    mid1: calcLightColor(waveformColors.mid1)
    mid2: calcLightColor(waveformColors.mid2)
    low1: calcLightColor(waveformColors.low1)
    low2: calcLightColor(waveformColors.low2)
    background: colors.colorBgEmpty
  }

  //--------------------------------------------------------------------------------------------------------------------
  // ELAPSED TIME SHADOW
  //--------------------------------------------------------------------------------------------------------------------
  Rectangle {
      id: elapsedTimeShadow

      anchors.left: parent.left
      width: posIndicator.x
      height: posIndicator.height

      color: colors.rgba(0,0,0,175)
  }

  //--------------------------------------------------------------------------------------------------------------------
  // HOTCUES
  //--------------------------------------------------------------------------------------------------------------------
  Repeater {
    id: hotcues
  
    model: 8
    Hotcue {
      property int roundedX: (hotcuesModel.array[index].position/trackLength) * stripe.width  

      anchors.top:     parent.top
      anchors.bottom:  parent.bottom
      x:               roundedX + (3 * screenScale)  // Escalar el offset
      hotcueLength:    (hotcuesModel.array[index].length/trackLength) * stripe.width 
      hotcueId:        index + 1
      exists:          hotcuesModel.array[index].exists
      type:            hotcuesModel.array[index].type
      smallHead:       false
      height: parent.height  // Asegurar que el hotcue ocupe toda la altura del Stripe
      anchors.bottom: parent.bottom
    }
  }

  //--------------------------------------------------------------------------------------------------------------------
  // ACTIVE CUE
  //--------------------------------------------------------------------------------------------------------------------
  ActiveCue {
    property int roundedX: (hotcuesModel.activeHotcue.position / parent.trackLength) * stripe.width

    x:               roundedX + (2 * screenScale)  // Escalar el offset
    isSmall:         false
    anchors.bottom:  posIndicator.bottom
    anchors.bottomMargin: 8 * screenScale  // Escalar el margen
    activeCueLength: (hotcuesModel.activeHotcue.length / trackLength) * stripe.width
    clip: false // true
    type:            hotcuesModel.activeHotcue.type 
  }

  //--------------------------------------------------------------------------------------------------------------------
  // TRACK END WARNING
  //--------------------------------------------------------------------------------------------------------------------
  Rectangle {
    id: trackEndWarningOverlay

    anchors.left: parent.left
    width:  posIndicator.x
    height: posIndicator.height

    color:               colors.colorRedPlaymarker
    opacity:             0 // initial state
    visible:             trackEndWarning

    Timer {
      id: timer
      property bool blinker: false

      interval: 700
      repeat:   true
      running: trackEndWarning

      onTriggered: { 
        trackEndWarningOverlay.opacity = (blinker) ? 0.35 : 0;
        blinker = !blinker;
      }
    }
  }


  //--------------------------------------------------------------------------------------------------------------------
  // POSITION INDICATOR
  //--------------------------------------------------------------------------------------------------------------------
  Rectangle {
    id: posIndicator

    readonly property real relativePlayPos: elapsedTime / trackLength

    x:                 relativePlayPos * stripe.width
    anchors.bottom:    parent.bottom
    height:            parent.height
    width:             2 * screenScale  // Escalar el ancho del indicador
    color:             colors.rgba(255, 56, 26, 255) 
    opacity:           1
  }
}

