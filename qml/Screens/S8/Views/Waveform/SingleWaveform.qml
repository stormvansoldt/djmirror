import CSI 1.0
import QtQuick
import Qt5Compat.GraphicalEffects
import Traktor.Gui 1.0 as Traktor

//----------------------------------------------------------------------------------------------------------------------
// SINGLE WAVEFORM - Componente para visualización de forma de onda individual
//
// CARACTERÍSTICAS PRINCIPALES:
//
// 1. Propiedades Base
//    - deckId: ID del deck (0-3)
//    - streamId: ID del stream de audio
//    - sampleWidth: Ancho de muestra
//    - waveformColors: Colores para la forma de onda
//    - waveformPosition: Posición en la forma de onda
//
// 2. Forma de Onda Principal (Traktor.Waveform)
//    - Matriz de colores ajustable según tamaño de pantalla
//    - Colores para frecuencias altas, medias y bajas
//    - Factor de brillo aumentado (1.6x) para pantallas pequeñas
//    - Optimización de capa con suavizado y antialiasing
//
// 3. Colorización de Forma de Onda
//    - Se aplica durante loops activos
//    - Visible solo cuando hay un loop activo y su longitud es > 0
//    - Transición suave de opacidad
//    - Optimización de capa con suavizado
//
// PROPIEDADES CALCULADAS:
// - isSmallScreen: Detecta si la pantalla es pequeña (320px)
// - colorFactor: Factor de multiplicación para brillo (1.6)
// - audioStreamKey: Clave para el stream de audio basada en primaryKey
//
// NOTAS:
// - Usa layer.enabled para mejor rendimiento
// - Ajusta colores automáticamente según tamaño de pantalla
//----------------------------------------------------------------------------------------------------------------------

Item {
  id: view

  property int deckId:          0
  property int streamId:        0 
  property int sampleWidth:     0  

  property var waveformColors:  colors.getDefaultWaveformColors()
  property var waveformPosition 

  readonly property bool isSmallScreen: screen.width === 320

  readonly property real colorFactor: 1.6

  readonly property var audioStreamKey: (primaryKey.value == 0) ? ["MixerDeckKey", view.deckId] 
                                                                : ["PrimaryKey", primaryKey.value, streamId]
  //--------------------------------------------------------------------------------------------------------------------

  AppProperty { id: primaryKey; path: "app.traktor.decks." + (deckId + 1) + ".track.content.entry_key" }
  
  //--------------------------------------------------------------------------------------------------------------------
  // WAVEFORM
  //--------------------------------------------------------------------------------------------------------------------
  Traktor.Waveform {
    id: waveform
    anchors.fill:     parent
    deckId:           view.deckId
    waveformPosition: view.waveformPosition
    
    colorMatrix.high1: waveformColors.high1
    colorMatrix.high2: waveformColors.high2
    colorMatrix.mid1 : waveformColors.mid1
    colorMatrix.mid2 : waveformColors.mid2
    colorMatrix.low1 : waveformColors.low1
    colorMatrix.low2 : waveformColors.low2

    audioStreamKey:  (!view.visible) ? ["PrimaryKey", 0] : view.audioStreamKey

    // TODO: Revisar los comportamientos de antialiasing y smooth
    // Mejorar la calidad de renderizado
    clip: prefs.enhancedWaveform
    antialiasing: prefs.enhancedWaveform
    smooth: prefs.enhancedWaveform
    layer.smooth: prefs.enhancedWaveform
  }

  //--------------------------------------------------------------------------------------------------------------------
  // WAVEFORM COLORIZATION
  //--------------------------------------------------------------------------------------------------------------------
  WaveformColorize { 
    id: waveformColorize
    anchors.fill:  parent
    loop_start:    waveformCues.cueStart
    loop_length:   waveformCues.loop_length
    visible:       waveformCues.is_looping && waveformCues.loop_length > 0
    opacity:       visible ? 1.0 : 0.0

    waveform:         waveform
    waveformPosition: view.waveformPosition

    // TODO: Revisar los comportamientos de antialiasing y smooth
    // Mejorar la calidad de renderizado
    clip: prefs.enhancedWaveform
    antialiasing: prefs.enhancedWaveform
    smooth: prefs.enhancedWaveform
    layer.smooth: prefs.enhancedWaveform
  }
}
