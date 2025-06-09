import QtQuick
import CSI 1.0
import Traktor.Gui 1.0 as Traktor

//------------------------------------------------------------------------------------------------------------------
// REMIX STRIPE - Componente que muestra la forma de onda para celdas de Remix Deck
//
// Características principales:
// 1. Visualización
//    - Muestra la forma de onda de samples/loops cargados en celdas de Remix Deck
//    - Utiliza matriz de colores configurable según el color de la celda
//    - Ajusta brillo de colores según tamaño de pantalla
//
// 2. Estados
//    - Trackload: Detecta si hay sample/loop cargado
//    - Mute: Ajusta opacidad cuando la celda está muteada
//    - Loop: Muestra overlay verde cuando está en modo loop
//
// 3. Indicadores
//    - Marcador de posición de reproducción
//    - Soporte para samples de memoria y archivos
//
// 4. Propiedades Principales
//    - deckId: ID del deck (0-3)
//    - xPosition: Posición horizontal de la celda
//    - propertyPath: Ruta base para propiedades del sample
//    - waveformColors: Colores según ID de color de la celda
//------------------------------------------------------------------------------------------------------------------

Rectangle {
    property int xPosition: 1
    property int deckId: 0
    property string propertyPath // set outside
    readonly property bool trackIsLoaded: ((trackLength.value != 0) && ((primaryKey.value != 0) || isMemoryOnly.value))
    readonly property var waveformColors: colors.getWaveformColors(activeCellColorId.value)

    clip: true
    width: 0
    height: 0
    color: colors.palette(0, 0)

    //--------------------------------------------------------------------------------------------------------------------
    // Propiedades del Sample/Loop
    //--------------------------------------------------------------------------------------------------------------------
    AppProperty { id: activeCellColorId;  path: activeSamplePath + ".color_id" }
    AppProperty { id: playPosition; path: propertyPath + ".play_position"                     }
    AppProperty { id: trackLength;  path: propertyPath + ".content.track_length"              }
    AppProperty { id: volume;       path: propertyPath + ".level"                             }  
    AppProperty { id: primaryKey;   path: propertyPath + ".content.entry_key";                }
    AppProperty { id: isMemoryOnly; path: propertyPath + ".content.is_memory_only";           } 
    AppProperty { id: timeStamp;    path: propertyPath + ".content.memory_audio_time_stamp"   }
    AppProperty { id: deckIsInLoop; path: "app.traktor.decks." + (deckId+1) + ".loop.active"; }
    AppProperty { id: muted; path: propertyPath  + ".muted"
      onValueChanged: {
        waveform.opacity = value ? 0.3 : 1; playPositionIndicator.opacity = value ? 0.3 : 1; 
      }
    }

    //--------------------------------------------------------------------------------------------------------------------
    // Forma de onda
    //--------------------------------------------------------------------------------------------------------------------
    Traktor.Stripe {
        id: waveform
        anchors.fill: parent
        audioStreamKey: isMemoryOnly.value ? ["MemoryStreamKey", timeStamp.value] : ["PrimaryKey", primaryKey.value]
        deckId: parent.deckId
        playerId: xPosition - 1
        visible: trackIsLoaded

        function calcLightColor(c, colorFactor) {
            return Qt.rgba(Math.min(1.0, colorFactor * c.r), Math.min(1.0, colorFactor * c.g), Math.min(1.0, colorFactor * c.b), Math.min(1.0, colorFactor * c.a));
        }

        function lightColor(c) {
            return calcLightColor(c, 1.6);
        }

        colorMatrix.high1: screen.width === 320 ? lightColor(waveformColors.high1) : waveformColors.high1
        colorMatrix.high2: screen.width === 320 ? lightColor(waveformColors.high2) : waveformColors.high2
        colorMatrix.mid1: screen.width === 320 ? lightColor(waveformColors.mid1) : waveformColors.mid1
        colorMatrix.mid2: screen.width === 320 ? lightColor(waveformColors.mid2) : waveformColors.mid2
        colorMatrix.low1: screen.width === 320 ? lightColor(waveformColors.low1) : waveformColors.low1
        colorMatrix.low2: screen.width === 320 ? lightColor(waveformColors.low2) : waveformColors.low2
        colorMatrix.background: colors.colorBgEmpty
    }

    //--------------------------------------------------------------------------------------------------------------------
    // Indicador de posición de reproducción
    //--------------------------------------------------------------------------------------------------------------------
    Rectangle {
        id: playPositionIndicator
        width: 3
        height: parent.height + 2
        color: colors.colorRedPlaymarker
        visible: trackIsLoaded
        // calculate the position of the indicator: 'waveform rectangle width' * currentPlayPosition/trackLength
        x: (trackLength.value != 0) ? waveform.width * (playPosition.value / trackLength.value) - 1 : 0  // -1 is a fix for 1px shadow border

        anchors.verticalCenter: parent.verticalCenter

        border {
            color: colors.colorBlack50
            width: 1
        }
    }

    //--------------------------------------------------------------------------------------------------------------------
    // Overlay de Loop
    //--------------------------------------------------------------------------------------------------------------------
    Rectangle {
        id: loop_overlay
        visible: deckIsInLoop.value == 1
        anchors.fill: waveform
        color: "#44007700"
    }
}
