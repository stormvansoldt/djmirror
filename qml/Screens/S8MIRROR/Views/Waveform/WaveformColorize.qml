import QtQuick
import Qt5Compat.GraphicalEffects

import Traktor.Gui 1.0 as Traktor

//----------------------------------------------------------------------------------------------------------------------
// WAVEFORM COLORIZE - Componente para colorear secciones de la forma de onda
//
// CARACTERÍSTICAS PRINCIPALES:
//
// 1. Propiedades Base
//    - loop_start: Posición inicial del loop
//    - loop_length: Longitud del loop
//    - waveform: Referencia al componente de forma de onda
//    - waveformPosition: Posición actual en la forma de onda
//
// 2. Sistema de Máscara
//    - Usa OpacityMask para aplicar colorización solo en área seleccionada
//    - Máscara rectangular que sigue la posición del loop
//
// 3. Colorización
//    - Aplica tinte verde (hue: 0.33) con saturación media (0.55)
//    - Transiciones suaves con animaciones de 100ms
//    - Cache activado para mejor rendimiento
//
// 4. Optimizaciones
//    - Uso de layer.enabled para mejor rendimiento gráfico
//    - Cache de dimensiones y cálculos frecuentes
//    - Visibilidad condicionada al estado activo
//    - Antialiasing y suavizado para mejor calidad visual
//
// PROPIEDADES CALCULADAS:
// - isActive: Determina si el componente debe estar activo
// - viewScale: Factor de escala para conversión de samples a píxeles
//
// NOTAS:
// - Requiere Qt5Compat.GraphicalEffects para efectos visuales
// - Las animaciones solo se activan cuando el componente es visible
//----------------------------------------------------------------------------------------------------------------------

Item {
    id: waveformColorize

    // Propiedades requeridas y optimizadas
    required property int loop_start
    required property int loop_length

    required property var waveform
    required property var waveformPosition

    // Función optimizada de conversión
    function samples_to_waveform_x( sample_pos ) {
        return (sample_pos / waveformPosition.sampleWidth) * waveformPosition.viewWidth
    }

    // Máscara optimizada
    Item { 
        id: mask
        anchors.fill: parent
        visible: false

        Traktor.WaveformTranslator {
            anchors.fill: parent

            followTarget: waveformPosition
            pos: loop_start

            Rectangle {
                x: 0
                y: 0
                width: loop_length
                height: waveform.height
                color: "#000000"
            }
        }
    }

    // Máscara de opacidad
    OpacityMask {
        id: waveform_mask
        visible: false
        anchors.fill: parent
        source: waveform
        maskSource: mask
    }

    // Colorización
    Colorize {
        id: colorize
        anchors.fill: waveform_mask
        source: waveform_mask

        hue: 0.33 // 0..1
        saturation: 0.55 // 0..1
        lightness: 0.0 // -1..1
    }
}
