import CSI 1.0
import QtQuick

import Traktor.Gui 1.0 as Traktor

import '../../../../Defines'
import '../Widgets' as Widgets
import '../../../Defines'


//----------------------------------------------------------------------------------------------------------------------
// WAVEFORM CONTAINER - Contenedor principal para la visualización de formas de onda
//
// ELEMENTOS PRINCIPALES:
//
// 1. Forma de Onda Simple (SingleWaveform)
//    - Márgenes: 3px izquierda/derecha
//    - Margen inferior: 11px en modo slicer
//    - Visible según el estado del deck
//
// 2. Forma de Onda Stem (StemWaveforms)
//    - Márgenes: 3px izquierda/derecha
//    - Margen inferior: 15px en modo slicer para deck stem
//    - Visible solo en modo stem
//
// 3. Vista de Beatgrid (BeatgridView)
//    - Márgenes: 3px izquierda/derecha
//    - Visible cuando no está en modo slicer o está en modo edición
//
// 4. Marcador de Reproducción (PlayMarker)
//    - Elementos:
//      * Rectángulo central:
//        - Ancho: 3px (configurable via prefs.playmarkerWidth)
//        - Colores:
//          > Reproduciendo: colors.colorRedPlaymarker
//          > Pausado: colors.colorGrey232
//        - Borde: colors.colorBlack31
//        - Opacidad: 1.0 reproduciendo, 0.4 pausado
//      * Triángulos superior e inferior:
//        - Dimensiones: 10x8 px
//        - Mismo color que el rectángulo central
//        - Efecto de brillo cuando está reproduciendo
//
// 5. Marcador de Flux
//    - Ancho: 3px
//    - Color: colors.colorBluePlaymarker
//    - Borde: colors.colorBlack31
//    - Opacidad: 1.0 activo, 0.0 inactivo
//
// 6. Indicadores de Color Stem
//    - Altura variable según modo:
//      * Slicer: [34, 33, 33, 33]px
//      * HotCueBar: [26, 26, 26, 26]px
//      * Normal: [30, 30, 30, 30]px
//
// EFECTOS VISUALES:
// - Transiciones suaves en cambios de estado (duración: durations.deckTransition)
// - Efecto de brillo pulsante en el playmarker durante la reproducción
// - Transiciones suaves en cambios de opacidad (100ms)
//
//----------------------------------------------------------------------------------------------------------------------

Item {
  id: view

  // Añadir la propiedad screenScale
  property real screenScale: prefs.screenScale

  property int    deckId:        0
  property string deckSizeState: "large"
  property int    sampleWidth:   0
  property bool   showLoopSize: false
  property bool   isInEditMode: false
  property string propertiesPath: ""

  readonly property bool trackIsLoaded: (primaryKey.value > 0)

  property          int    stemStyle:       StemStyle.track
  readonly property bool   isStemDeck: (deckType.value == DeckType.Stem && stemStyle == StemStyle.daw && deckSizeState == "large")

  // Nueva propiedad para el estado de reproducción
  property bool isPlaying: false
  property real playmarkerOpacity: isPlaying ? 1.0 : 0.4

  // Propiedad para detectar cambios en el estado de reproducción
  AppProperty { 
    id: propPlayState
    path: "app.traktor.decks." + (deckId + 1) + ".play"
    onValueChanged: {
      isPlaying = (value == 1)
    }
  }

  // Propiedad para detectar cambios en el tipo de deck
  AppProperty { 
    id: deckType
    path: "app.traktor.decks." + (deckId + 1) + ".type" 
    onValueChanged: {
      if (value == DeckType.Stem) {
        forceWaveformRefresh();
      }
    }
  }

  // Propiedad para detectar carga de track
  AppProperty {
    id: trackId
    path: "app.traktor.decks." + (deckId + 1) + ".track.content.entry_key"
    onValueChanged: {
      if (deckType.value == DeckType.Stem && value > 0) {
        forceWaveformRefresh();
      }
    }
  }
  
  // Función para forzar el refresco
  function forceWaveformRefresh() {
    // Pequeño delay para asegurar que los datos están disponibles
    refreshTimer.restart();
  }

  Timer {
    id: refreshTimer
    interval: 100
    repeat: false
    onTriggered: {
      // Forzar refresco de las ondas
      stemWaveform.visible = false;
      stemWaveform.visible = true;
      
      // Segundo refresco después de un momento
      secondRefreshTimer.restart();
    }
  }
  
  Timer {
    id: secondRefreshTimer
    interval: 500
    repeat: false
    onTriggered: {
      stemWaveform.visible = false;
      stemWaveform.visible = true;
    }
  }

  //--------------------------------------------------------------------------------------------------------------------

  AppProperty   { id: primaryKey;        path: "app.traktor.decks."   + (deckId + 1) + ".track.content.entry_key"  }
  AppProperty   { id: sampleRate;        path: "app.traktor.decks."   + (deckId + 1) + ".track.content.sample_rate"; onValueChanged: { updateLooping(); } }
  AppProperty   { id: propFluxState;     path: "app.traktor.decks."   + (deckId + 1) + ".flux.state"                 }
  AppProperty   { id: propFluxPosition;  path: "app.traktor.decks."   + (deckId + 1) + ".track.player.flux_position" }
  
  // If the playhead is in a loop, propIsLooping is TRUE and the loop becomes the active cue.
  AppProperty   { id: propIsLooping;     path: "app.traktor.decks." + (deckId + 1) + ".loop.is_in_active_loop";        onValueChanged: { updateLooping(); } }
  AppProperty   { id: propLoopStart;     path: "app.traktor.decks." + (deckId + 1) + ".track.cue.active.start_pos";    onValueChanged: { updateLooping(); } }
  AppProperty   { id: propLoopLength;    path: "app.traktor.decks." + (deckId + 1) + ".track.cue.active.length";       onValueChanged: { updateLooping(); } }


  //--------------------------------------------------------------------------------------------------------------------
  // WAVEFORM Position
  //------------------------------------------------------------------------------------------------------------------
  
  function slicer_zoom_width()          { return  slicer.slice_width * slicer.slice_count / slicer.zoom_factor * sampleRate.value;          }
  function slicer_pos_to_waveform_pos() { return (slicer.slice_start - (0.5 * slicer.slice_width * slicer.zoom_factor)) * sampleRate.value; }

  function updateLooping() {
    if (propIsLooping.value) {
      var loopStart  = propLoopStart.value  * sampleRate.value;
      var loopLength = propLoopLength.value * sampleRate.value;
      wfPosition.clampPlayheadPos(loopStart, loopLength);
    }
    else wfPosition.unclampPlayheadPos();
  }

  Traktor.WaveformPosition {
    id: wfPosition
    deckId: view.deckId
    followsPlayhead: !slicer.enabled && !beatgrid.editEnabled
    waveformPos:     beatgrid.editEnabled ? beatgrid.posOnEdit   : (slicer.enabled ? slicer_pos_to_waveform_pos() : (playheadPos -  0.5 * view.sampleWidth ))
    sampleWidth:     beatgrid.editEnabled ? beatgrid.widthOnEdit : (slicer.enabled ? slicer_zoom_width()          : view.sampleWidth)
    viewWidth:       singleWaveform.width

    Behavior on sampleWidth { PropertyAnimation { duration: 150; easing.type: Easing.OutCubic } }
    Behavior on waveformPos { PropertyAnimation { duration: 150; easing.type: Easing.OutCubic }  enabled: (slicer.enabled || beatgrid.editEnabled) }
  }


  //------------------------------------------------------------------------------------------------------------------
  // Single DAW WAVEFORM
  //--------------------------------------------------------------------------------------------------------------------
  SingleWaveform {
    id: singleWaveform

    deckId:        view.deckId
    sampleWidth:   view.sampleWidth

    waveformPosition: wfPosition

    anchors.top:   view.top
    anchors.left:  view.left
    anchors.right: view.right

    anchors.leftMargin:   0
    anchors.rightMargin:  0
    anchors.bottomMargin: (slicer.enabled) ? 11 * screenScale : 2 * screenScale

    clip: false // true
    visible: true        // changed in state
    height:  view.height // changed in state

    Behavior on anchors.bottomMargin { PropertyAnimation {  duration: durations.deckTransition } }
  }

  //------------------------------------------------------------------------------------------------------------------
  // STEM WAVEFORM
  //--------------------------------------------------------------------------------------------------------------------
  StemWaveforms {
    id: stemWaveform
    deckId: view.deckId
    sampleWidth: view.sampleWidth

    screenScale: view.screenScale
   
    waveformPosition: wfPosition

    anchors.top: singleWaveform.bottom
    anchors.left: view.left
    anchors.right: view.right
    anchors.bottom: view.bottom
    anchors.leftMargin: 0
    anchors.rightMargin: 0
    anchors.bottomMargin: (isStemDeck & slicer.enabled) ? 15 * screenScale : 0
    
    visible: false // set by viewSizeState
  }

  //--------------------------------------------------------------------------------------------------------------------
  //  Beatgrid
  //--------------------------------------------------------------------------------------------------------------------
  BeatgridView {
    id: beatgrid
    anchors.fill:  parent
    anchors.leftMargin:  0
    anchors.rightMargin: 0

    screenScale: view.screenScale

    waveformPosition: wfPosition
    propertiesPath:   view.propertiesPath
    trackId:          primaryKey.value
    deckId:           parent.deckId  
    visible:          (!slicer.enabled || beatgrid.editEnabled)
    editEnabled:      view.isInEditMode && (deckSizeState != "small")
    clip: false // true
  }

  //--------------------------------------------------------------------------------------------------------------------
  //  CuePoints
  //--------------------------------------------------------------------------------------------------------------------
  WaveformCues {
    id: waveformCues
    anchors.fill:        parent
    anchors.leftMargin:  0
    anchors.rightMargin: 0

    screenScale: view.screenScale

    deckId:            view.deckId
    waveformPosition:  wfPosition
    forceHideLoop:     slicer.enabled || !trackIsLoaded
  }


  //--------------------------------------------------------------------------------------------------------------------
  // Freeze/Slicer
  //--------------------------------------------------------------------------------------------------------------------
  Slicer {
    id: slicer
    anchors.fill:        parent
    anchors.leftMargin:  0
    anchors.rightMargin: 0
    anchors.topMargin:   1
    deckId:              view.deckId
    opacity:             (beatgrid.editEnabled) ? 0 : 1

    stemStyle:           view.isStemDeck ? view.stemStyle : StemStyle.track
  }

  // Flux marker
  Traktor.WaveformTranslator {
    Rectangle {
      id:    flux_marker
      x:     0
      y:    -4 * screenScale
      width: 3 * screenScale
      height: view.height
      color: colors.colorBluePlaymarker
      opacity: propFluxState.value == 2 ? 1.0 : 0.0  // Transición suave
      border.color: colors.colorBlack31
      border.width: 1
      visible: true  // Siempre visible, controlado por opacidad
    }

    followFluxPosition: true
    relativeToPlayhead: true
    pos:               0
    followTarget:      wfPosition
  }

  //--------------------------------------------------------------------------------------------------------------------
  //  PlayMarker
  //--------------------------------------------------------------------------------------------------------------------
  Traktor.WaveformTranslator {
    id: play_marker
    followTarget: wfPosition
    pos: 0
    relativeToPlayhead: true
    visible: view.trackIsLoaded

    Item {
        y: -1

        // Glow effect
        Item {
            id: glowEffect
            visible: prefs.showPlaymarkerGlow && isPlaying
            x: -1

            // Capa exterior (más grande)
            Rectangle {
                x: -2
                anchors.centerIn: playmarkerRect
                width: playmarkerRect.width + 2
                height: playmarkerRect.height
                color: colors.colorRedPlaymarker75
                opacity: 0.15
                radius: 4
            }

            // Capa media
            Rectangle {
                x: -1
                anchors.centerIn: playmarkerRect
                width: playmarkerRect.width + 1
                height: playmarkerRect.height
                color: colors.colorRedPlaymarker75
                opacity: 0.25
                radius: 3
            }

            // Capa interior
            Rectangle {
                x: 0
                anchors.centerIn: playmarkerRect
                width: playmarkerRect.width + 1
                height: playmarkerRect.height
                color: colors.colorRedPlaymarker75
                opacity: 0.35
                radius: 2
            }

            // Capa media
            Rectangle {
                x: 2
                anchors.centerIn: playmarkerRect
                width: playmarkerRect.width + 1
                height: playmarkerRect.height
                color: colors.colorRedPlaymarker75
                opacity: 0.25
                radius: 3
            }

            // Capa exterior (más grande)
            Rectangle {
                x: 3
                anchors.centerIn: playmarkerRect
                width: playmarkerRect.width + 2
                height: playmarkerRect.height
                color: colors.colorRedPlaymarker75
                opacity: 0.15
                radius: 4
            }

            SequentialAnimation on opacity {
                running: prefs.showPlaymarkerGlow && isPlaying
                loops: Animation.Infinite
                NumberAnimation { from: 0.5; to: 1; duration: 500; easing.type: Easing.InOutQuad }
                NumberAnimation { from: 1; to: 0.5; duration: 500; easing.type: Easing.InOutQuad }
            }
        }
            
        // Rectángulo central (playmarker)
        Rectangle {
            id: playmarkerRect

            property int sliceModeHeight: (stemStyle == StemStyle.track) ? 
                waveformContainer.height - (14 * screenScale) : waveformContainer.height - (10 * screenScale)
            
            y: 0
            width: 2 * screenScale
            height: (slicer.enabled && !beatgrid.editEnabled) ? 
                    sliceModeHeight - (2 * screenScale) : waveformContainer.height + (2 * screenScale)
            
            color: {
                if (!isPlaying) return colors.colorGrey232
                return colors.colorRedPlaymarker
            }

            opacity: playmarkerOpacity
            
            clip: false // true
        }

        // Triángulo superior
        Canvas {
            id: topTriangle
            width: 8 * screenScale
            height: 8 * screenScale
            y: 0
            x: ((playmarkerRect.width - width) / 2)
            opacity: playmarkerOpacity
           
            clip: false // true

            onPaint: {
                var ctx = getContext("2d")
                ctx.reset()
                ctx.beginPath()
                ctx.moveTo(0, 0)
                ctx.lineTo(width/2, height)
                ctx.lineTo(width, 0)
                ctx.closePath()
                ctx.fillStyle = playmarkerRect.color
                ctx.fill()
            }

            Connections {
                target: playmarkerRect
                function onColorChanged() {
                    topTriangle.requestPaint()
                }
            }
        }

        // Triángulo inferior
        Canvas {
            id: bottomTriangle
            width: 8 * screenScale
            height: 8 * screenScale
            y: playmarkerRect.height - (8 * screenScale)
            x: (playmarkerRect.width - width) / 2
            opacity: playmarkerOpacity

            clip: false // true

            onPaint: {
                var ctx = getContext("2d")
                ctx.reset()
                ctx.beginPath()
                ctx.moveTo(0, height)
                ctx.lineTo(width/2, 0)
                ctx.lineTo(width, height)
                ctx.closePath()
                ctx.fillStyle = playmarkerRect.color
                ctx.fill()
            }

            // Trigger repaint when color changes
            Connections {
                target: playmarkerRect
                function onColorChanged() {
                    bottomTriangle.requestPaint()
                }
            }
        }
    } 
  }

  //--------------------------------------------------------------------------------------------------------------------
  // Stem Color Indicators (Rectangles)
  //--------------------------------------------------------------------------------------------------------------------
  StemColorIndicators {
    id: stemColorIndicators
    deckId:          view.deckId
    anchors.fill:    stemWaveform
    visible:         stemWaveform.visible

    // Calcular la altura base dividiendo el alto total entre 4
    property real baseHeight: view.height / 4

    indicatorHeight: (slicer.enabled && !beatgrid.editEnabled) ? 
        [baseHeight * 0.7 * screenScale, baseHeight * 0.7 * screenScale, baseHeight * 0.7 * screenScale, baseHeight * 0.7 * screenScale] : 
        (prefs.displayHotCueBar) ? 
            [baseHeight * 0.5 * screenScale, baseHeight * 0.5 * screenScale, baseHeight * 0.5 * screenScale, baseHeight * 0.5 * screenScale] : 
            [baseHeight * 0.6 * screenScale, baseHeight * 0.6 * screenScale, baseHeight * 0.6 * screenScale, baseHeight * 0.6 * screenScale]
  }

  //--------------------------------------------------------------------------------------------------------------------
  // LoopSize Widgets
  //--------------------------------------------------------------------------------------------------------------------
  Widgets.LoopSize {
    id: loopSize
    anchors.topMargin: 1
    anchors.fill: parent
    visible: showLoopSize
  }

  //--------------------------------------------------------------------------------------------------------------------
  // States
  //------------------------------------------------------------------------------------------------------------------ 
  state: isStemDeck ? "stem" : "single"
  states: [
    State {
      name: "single";
      PropertyChanges { target: singleWaveform; height: view.height; }
      PropertyChanges { target: stemWaveform;   height: 0;           }
    },
    State {
      name: "stem";
      PropertyChanges { target: singleWaveform; height: 0           }
      PropertyChanges { target: stemWaveform;   height: view.height }
      PropertyChanges { target: stemWaveform;   anchors.bottomMargin: (isStemDeck & slicer.enabled) ? 15 * screenScale : 0 }
    }
  ]
  transitions: [
    Transition {
      from: "single"
      SequentialAnimation {
        PropertyAction  { target: stemWaveform;   property: "visible"; value: true; }
        ParallelAnimation {
          NumberAnimation { target: singleWaveform; property: "height";   duration: durations.deckTransition; }
          NumberAnimation { target: stemWaveform;   property: "height";  duration: durations.deckTransition; }
        }
        PropertyAction  { target: singleWaveform; property: "visible"; value: false; }
      }
    },
    Transition {
      from: "stem"
      SequentialAnimation {
        PropertyAction  { target: singleWaveform; property: "visible"; value: true; }
        ParallelAnimation {
          NumberAnimation { target: singleWaveform; property: "height";  duration: durations.deckTransition; }
          NumberAnimation { target: stemWaveform;   property: "height";  duration: durations.deckTransition; }
        }
        PropertyAction  { target: stemWaveform;   property: "visible"; value: false; }
      }
    }
  ]
}
