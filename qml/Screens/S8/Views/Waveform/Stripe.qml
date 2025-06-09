import CSI 1.0
import QtQuick
import Traktor.Gui 1.0 as Traktor

import '../Widgets' as Widgets

//------------------------------------------------------------------------------------------------------------------
// STRIPE - Componente que muestra la forma de onda completa de la pista con marcadores
//
// Características principales:
// 1. Visualización
//    - Muestra la forma de onda completa de la pista en formato condensado
//    - Utiliza una matriz de colores para diferentes frecuencias (bajas, medias, altas)
//    - Ajusta los colores según el tamaño de la pantalla
//
// 2. Indicadores de Posición
//    - Indicador de posición actual con caja y marcador central
//    - Indicador de posición Flux para modo Flux
//    - Área oscurecida para la parte reproducida
//    - Marcadores de minutos
//
// 3. Marcadores
//    - Hotcues (hasta 8)
//    - Cue point activo
//    - Advertencia de fin de pista
//
// 4. Funcionalidad
//    - Cálculo de posiciones relativas
//    - Conversión de samples a posiciones en la vista
//    - Ajuste automático de tamaños y posiciones
//
// 5. Propiedades Principales
//    - deckId: ID del deck (0-3)
//    - windowSampleWidth: Ancho de la ventana en samples
//    - speed: Velocidad de parpadeo para advertencias
//    - waveformColors: Colores para la forma de onda
//------------------------------------------------------------------------------------------------------------------

Traktor.Stripe {
  id: stripe

  property int           deckId:            0
  property int           windowSampleWidth: 122880  

  readonly property int  speed:             900 // blink speed
  readonly property real warningOpacity:    0.45
  readonly property int  indicatorBoxWidth: (windowSampleWidth / Math.max(1, propTrackSampleLength.value)) * width
  readonly property var  waveformColors:   colors.getDefaultWaveformColors()

  readonly property bool isSmallScreen: screen.width === 320

  readonly property real colorFactor: 1.6

  //--------------------------------------------------------------------------------------------------------------------

  function calcLightColor(c) {
      return Qt.rgba(
          Math.min(1.0, c.r * colorFactor),
          Math.min(1.0, c.g * colorFactor),
          Math.min(1.0, c.b * colorFactor),
          c.a
      );
  }

  colorMatrix {
    high1: isSmallScreen ? calcLightColor(waveformColors.high1) : waveformColors.high1
    high2: isSmallScreen ? calcLightColor(waveformColors.high2) : waveformColors.high2
    mid1: isSmallScreen ? calcLightColor(waveformColors.mid1) : waveformColors.mid1
    mid2: isSmallScreen ? calcLightColor(waveformColors.mid2) : waveformColors.mid2
    low1: isSmallScreen ? calcLightColor(waveformColors.low1) : waveformColors.low1
    low2: isSmallScreen ? calcLightColor(waveformColors.low2) : waveformColors.low2
    background: colors.colorBgEmpty
  }

  //--------------------------------------------------------------------------------------------------------------------
  AppProperty { id: trackLength;           path: "app.traktor.decks." + (deckId + 1) + ".track.content.track_length" }
  AppProperty { id: propTrackSampleLength; path: "app.traktor.decks." + (deckId + 1) + ".track.content.sample_count"     }

  //--------------------------------------------------------------------------------------------------------------------
  // SAMPLE TO STRIPE
  //--------------------------------------------------------------------------------------------------------------------
  function sampleToStripe(sampleValue) {
    return sampleValue/trackLength.value * stripe.width
  }

  //--------------------------------------------------------------------------------------------------------------------
  // TRACK END WARNING
  //--------------------------------------------------------------------------------------------------------------------
  Rectangle {
    id: trackEndWarningOverlay

    AppProperty { id: trackEndWarning; path: "app.traktor.decks." + (deckId+1) + ".track.track_end_warning" }

    anchors.top:         posIndicatorBox.top
    anchors.bottom:      posIndicatorBox.bottom
    anchors.left:        parent.left
    anchors.right:       posIndicatorBox.horizontalCenter
    anchors.topMargin:    2
    anchors.bottomMargin: 2 
    anchors.rightMargin:  2  

    color:               colors.colorRed
    opacity:             0 // initial state
    visible:            (trackEndWarning.value) ? true : false

    Timer {
      id: timer
      property bool  blinker: false

      interval: speed
      repeat:   true
      running:  trackEndWarning.value

      onTriggered: { 
        trackEndWarningOverlay.opacity = (blinker) ? warningOpacity : 0;
        blinker = !blinker;
      }
    }
  }

  //--------------------------------------------------------------------------------------------------------------------
  // HOTCUES
  //--------------------------------------------------------------------------------------------------------------------
  Repeater {
    id: hotcues
    model: 8
    Widgets.Hotcue {
      property int roundedX: sampleToStripe(pos.value)  // ensures that the flags are drawn "on the pixel" 

      AppProperty { id: pos;    path: "app.traktor.decks." + (parent.deckId + 1 ) + ".track.cue.hotcues." + (index + 1) + ".start_pos" }
      AppProperty { id: length; path: "app.traktor.decks." + (view.deckId   + 1 ) + ".track.cue.hotcues." + (index + 1) + ".length"    }

      anchors.top:     parent.top
      anchors.bottom:  parent.bottom
      x:               roundedX
      hotcueLength:    sampleToStripe(length.value)
      showHead:       (stripe.deckSizeState != "small") ? true : false;
      hotcueId:        index + 1
    }
  }

  //--------------------------------------------------------------------------------------------------------------------
  // ACTIVE CUE
  //--------------------------------------------------------------------------------------------------------------------
  Widgets.ActiveCue {
    property int roundedX: sampleToStripe(activePos.value)  // ensures that the flags are drawn "on the pixel" 

    AppProperty { id: activePos;    path: "app.traktor.decks." + (parent.deckId+1) + ".track.cue.active.start_pos" }
    AppProperty { id: aciveLength;  path: "app.traktor.decks." + (parent.deckId+1) + ".track.cue.active.length"   }
    x:               roundedX         
    isSmall:         true
    anchors.bottom:  parent.bottom
    anchors.bottomMargin: 2
    activeCueLength: sampleToStripe(aciveLength.value)
    clip:            false
  }

  
  //--------------------------------------------------------------------------------------------------------------------
  // POSITION INDICATOR BOX
  //--------------------------------------------------------------------------------------------------------------------  
  Rectangle {
    id: posIndicatorBox

    property int roundedX:  (relativePlayPos * (parent.width - posIndicator.width) - 0.5*width)
    readonly property real relativePlayPos: Math.max(Math.min(elapsedTime.value / trackLength.value, 1.0), 0)

    AppProperty { id: elapsedTime; path: "app.traktor.decks." + (deckId+1) + ".track.player.elapsed_time" }
    x:                 roundedX            
    anchors.top:       parent.top
    height:            parent.height
    width:             Math.max (parent.indicatorBoxWidth - (1 - parent.indicatorBoxWidth%2) , 5) // 
    
    radius:            1
    color:             colors.colorRedPlaymarker06 
    border.color:      colors.colorRedPlaymarker75
    border.width:      1
    antialiasing:      false

    Rectangle {
      id: posIndicatorShadow
      anchors.horizontalCenter: posIndicator.horizontalCenter
      anchors.verticalCenter:   posIndicator.verticalCenter
      width: 3
      height: posIndicator.height + 2
      color: colors.colorBlack50
    }

    Rectangle {
      id: posIndicator
      anchors.horizontalCenter: parent.horizontalCenter
      anchors.top:              parent.top
      anchors.bottom:           parent.bottom
      anchors.topMargin:        2
      anchors.bottomMargin:     2
      antialiasing:             false

      color: colors.colorRedPlaymarker
      width: 1      
    }
  }

  //--------------------------------------------------------------------------------------------------------------------
  // FLUX POSITION INDICATOR
  //--------------------------------------------------------------------------------------------------------------------
  Rectangle {
    id: fluxPosIndicator

    property int roundedX:  fluxPosIndicator.relativePlayPos * (stripe.width - 1)
    readonly property real relativePlayPos: propFluxPosition.value / trackLength.value

    anchors.top:       parent.top
    anchors.topMargin: 2

    height:            24
    width:             1
    x:                 roundedX     

    antialiasing:             false

    AppProperty { id: propFluxPosition; path: "app.traktor.decks." + (deckId + 1) + ".track.player.flux_position" }
    AppProperty { id: propFluxState;    path: "app.traktor.decks." + (deckId + 1) + ".flux.state" }

    visible: propFluxState.value == 2
    color:   colors.colorBluePlaymarker 

    Rectangle {
      id: fluxPosIndicatorShadow
      anchors.horizontalCenter: fluxPosIndicator.horizontalCenter
      anchors.verticalCenter: fluxPosIndicator.verticalCenter
      width: 3
      height: fluxPosIndicator.height + 2
      color: colors.colorBlack50
    }
  }

  //--------------------------------------------------------------------------------------------------------------------
  // DARKENED ALREADY PLAYED BOX
  //--------------------------------------------------------------------------------------------------------------------
  Rectangle
  {
    id: darkenAlreadyPlayedBox

    anchors.top:       parent.top
    anchors.left:      parent.left
    height:            parent.height
    width:             Math.max(Math.min(elapsedTime.value / trackLength.value, 1), 0) * parent.width
    
    radius:            1
    color:             colors.colorBlack66
    antialiasing:      false
  }

  //--------------------------------------------------------------------------------------------------------------------
  // MINUTE MARKERS
  //--------------------------------------------------------------------------------------------------------------------  
  Repeater {
    id: minuteMarkers
    model: Math.floor(trackLength.value / 60)

    Rectangle {
      anchors.bottom:  parent.bottom
      x:               sampleToStripe(60 * (index + 1)) - 1
      width:           3
      height:          stripe.height
      color:           colors.colorBlack
    }

    Rectangle {
      anchors.bottom:  parent.bottom
      x:               sampleToStripe(60 * (index + 1))
      width:           1
      height:          stripe.height
      color:           colors.colorWhite
    }
  }
}
