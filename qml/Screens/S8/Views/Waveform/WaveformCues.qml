import CSI 1.0
import QtQuick
import Traktor.Gui 1.0 as Traktor
import Qt5Compat.GraphicalEffects

import '../Widgets' as Widgets


//----------------------------------------------------------------------------------------------------------------------
// WAVEFORM CUES - Componente para mostrar marcadores y loops en la forma de onda
//
// Características principales:
// 1. Loops
//    - Overlay coloreado para el área del loop
//    - Líneas punteadas superior e inferior (opcional)
//    - Marcadores laterales que delimitan el loop
//    - Efecto de brillo animado en las líneas punteadas
//
// 2. Hotcues
//    - Soporte para 8 hotcues
//    - Posicionamiento preciso en la forma de onda
//    - Visualización adaptativa según tamaño del deck
//    - Muestra nombre y color identificativo
//
// 3. Active Cue
//    - Marcador especial para el cue point activo
//    - Visible solo en modo normal (no small)
//    - Se oculta cuando el slicer está activo
//
// 4. Posicionamiento
//    - Usa WaveformTranslator para seguimiento preciso
//    - Conversión de samples a posición en pantalla
//    - Soporte para diferentes sample rates
//
// Propiedades principales:
// - deckId: ID del deck (0-3)
// - forceHideLoop: Fuerza ocultamiento del loop
// - waveformPosition: Referencia a la posición en la forma de onda
//----------------------------------------------------------------------------------------------------------------------


Item {
  id: view

  property int  deckId: 0
  property bool forceHideLoop: false 
  property var  waveformPosition

  anchors.fill: parent

  property int cueType:   activeCueType.value
  property int cueStart:  activeCueStart.value * sampleRate.value
  property int cueLength: activeCueLength.value * sampleRate.value

  property int  loop_length: samples_to_waveform_x(cueLength)
  property bool is_looping:  ( cueType == 5 ) && ( loopActive.value == true ) 

  // test begin
  property var highOpacity: 1
  property var lowOpacity: 0.25
  property var blinkFreq: 500

  // test end

  function samples_to_waveform_x( sample_pos ) { return (sample_pos / waveformPosition.sampleWidth) * waveformPosition.viewWidth; }


  //--------------------------------------------------------------------------------------------------------------------

  AppProperty { id: sampleRate;      path: "app.traktor.decks." + (deckId+1) + ".track.content.sample_rate" }
  AppProperty { id: loopActive;      path: "app.traktor.decks." + (deckId+1) + ".loop.active"          }
  AppProperty { id: isInActiveLoop;  path: "app.traktor.decks." + (deckId+1) + ".loop.is_in_active_loop" }
  AppProperty { id: activeCueType;   path: "app.traktor.decks." + (deckId+1) + ".track.cue.active.type"        }
  AppProperty { id: activeCueStart;  path: "app.traktor.decks." + (deckId+1) + ".track.cue.active.start_pos"   }
  AppProperty { id: activeCueLength; path: "app.traktor.decks." + (deckId+1) + ".track.cue.active.length"      }
  AppProperty { id: activePos;       path: "app.traktor.decks." + (deckId+1) + ".track.cue.active.start_pos"   }
  AppProperty { id: loopSizePos;     path: "app.traktor.decks." + (deckId+1) + ".loop.size"                    }

  //--------------------------------------------------------------------------------------------------------------------
  // Loop Overlay & Marker
  //--------------------------------------------------------------------------------------------------------------------

  Traktor.WaveformTranslator {
    followTarget: waveformPosition
    pos:          cueStart
    visible:      is_looping && !forceHideLoop
    anchors.fill: view

    property int deckId: view.deckId
    readonly property int lineWidthAdjustment: -1

    Rectangle {                             // loop coloring
      color:  colors.colorLoopOverlay       // sets the loop bg color
      x:      parent.lineWidthAdjustment
      height: view.height
      y:      0
      width:  samples_to_waveform_x(cueLength)

      // Línea punteada superior
      Row {
          visible: prefs.showLoopDottedLines && parent.visible
          anchors.top: parent.top
          anchors.left: parent.left
          anchors.right: parent.right
          height: 2
          spacing: 2
          clip: true
          Repeater {
              model: Math.ceil(parent.width / 3)
              Rectangle {
                  width: 1
                  height: 1
                  color: colors.colorLoopMarker
              }
          }
      }

      // Línea punteada inferior
      Row {
          visible: prefs.showLoopDottedLines && parent.visible
          anchors.bottom: parent.bottom
          anchors.left: parent.left
          anchors.right: parent.right
          height: 2
          spacing: 2
          clip: true
          Repeater {
              model: Math.ceil(parent.width / 3)
              Rectangle {
                  width: 1
                  height: 1
                  color: colors.colorLoopMarker
              }
          }
      }
    }

    Rectangle {                             // left marker
      id: loopMarkerLeft
      color: colors.colorLoopMarker
      opacity: 1
      x:       parent.lineWidthAdjustment
      y:       0
      height:  view.height 
      width:   1
    }

    Rectangle {                             // right marker
      id: loopMarkerRight
      color:   colors.colorLoopMarker
      opacity: 1
      x:       samples_to_waveform_x(cueLength) + parent.lineWidthAdjustment
      y:       0
      height:  view.height 
      width:   1
    }
  }

  //--------------------------------------------------------------------------------------------------------------------
  // Hot Cues
  //--------------------------------------------------------------------------------------------------------------------

  Repeater {
    id: hotcues
    model: 8

    Traktor.WaveformTranslator {
      property int deckId: view.deckId

      AppProperty { id: pos;    path: "app.traktor.decks." + (view.deckId+1) + ".track.cue.hotcues." + (index + 1) + ".start_pos" }

      followTarget: waveformPosition
      pos:          pos.value * sampleRate.value // pos in samples

      Widgets.Hotcue {
        AppProperty { id: length; path: "app.traktor.decks." + (view.deckId+1) + ".track.cue.hotcues." + (index + 1) + ".length"    }
        anchors.topMargin: 3
        height:            view.height
        showHead:          trackDeck.deckSizeState != "small"
        smallHead:         false
        hotcueLength:      samples_to_waveform_x(length.value* sampleRate.value)
        hotcueId:          index + 1
      }
    }
  }

  //--------------------------------------------------------------------------------------------------------------------
  // Active Cue
  //--------------------------------------------------------------------------------------------------------------------

  Traktor.WaveformTranslator {
    id: activeCue
    property int deckId: view.deckId
    followTarget: waveformPosition
    pos: cueStart
    visible: trackDeck.trackIsLoaded && (trackDeck.deckSizeState != "small") && !slicer.enabled
    anchors.fill: parent

    Widgets.ActiveCue {
      clip: false
      anchors.bottomMargin: 8
      anchors.bottom: parent.bottom
      height: 20
      width: 20
      x: 0
      activeCueLength: samples_to_waveform_x(cueLength)
      isSmall: false
    }
  }
}
