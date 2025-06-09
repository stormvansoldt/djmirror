import QtQuick
import CSI 1.0

//------------------------------------------------------------------------------------------------------------------
//  SLICER - Componente que gestiona la visualización de segmentos en la forma de onda
//
//  Características principales:
//  - Visualiza una colección de segmentos (slices) sobre la forma de onda
//  - Permite ajustar el zoom y márgenes de visualización
//  - Se integra con las propiedades del deck de Traktor
//  - Soporta diferentes estilos de stem
//
//  Propiedades principales:
//  - deckId: ID del deck asociado (0-3)
//  - zoom_factor: Factor de zoom para la visualización (default: 0.9 o 90%)
//  - slicer_path: Ruta base para las propiedades del slicer
//  - stemStyle: Estilo del stem (track/stem)
//
//  Propiedades del slicer:
//  - enabled: Estado de activación del slicer
//  - slice_start: Tiempo de inicio en segundos
//  - slice_width: Ancho de cada slice en segundos
//  - slice_count: Número total de slices
//
//  Elementos visuales:
//  - slices (Row):
//    * Contenedor principal de los slices
//    * Distribuye el espacio equitativamente
//    * Gestiona márgenes según zoom_factor
//
//  - slice_repeater (Repeater):
//    * Genera los componentes Slice individuales
//    * Cantidad basada en slice_count
//
//  Cálculos importantes:
//  - boxWidth: Ancho individual de cada slice (width / slice_count)
//  - margins: Márgenes laterales basados en zoom_factor
//
//  Integración:
//  - Se conecta con las propiedades del deck mediante AppProperty
//  - Actualiza la visualización según cambios en el estado del slicer
//  - Propaga propiedades relevantes a los slices individuales
//------------------------------------------------------------------------------------------------------------------

Item {
  id: slice_view

  property real screenScale: prefs.screenScale

  property int    deckId
  property real   zoom_factor:  0.9 // 90%
  property string slicer_path:  "app.traktor.decks." + (deckId+1) + ".freeze"
  
  
  property int    stemStyle:    StemStyle.track

  property bool   enabled:       propEnabled.value
  property real   slice_start:   propSliceStart.value // in seconds
  property real   slice_width:  propSliceWidth.value  // in seconds
  property int    slice_count:   propSliceCount.value

  AppProperty { id: propEnabled;     path: slicer_path + ".enabled" }
  AppProperty { id: propSliceCount; path: slicer_path + ".slice_count" }
  AppProperty { id: propSliceStart; path: slicer_path + ".slice_start_in_sec" }
  AppProperty { id: propSliceWidth; path: slicer_path + ".slice_width_in_sec" }
  
  //--------------------------------------------------------------------------------------------------------------------

  Row {
    id: slices
    property real boxWidth: width / slice_count
    property real margins: parent.width * ((1.0-parent.zoom_factor)/2.0) 

    opacity: parent.enabled
    anchors.fill: parent
    anchors.topMargin: -1 * screenScale
    anchors.leftMargin: margins - (1 * screenScale)
    anchors.rightMargin: margins

    Repeater {
      id: slice_repeater
      model: slice_view.slice_count
      Slice {
        height: slices.height
        width: slices.boxWidth
        slice_index: index
        last_slice: index + 1 == slice_count
        slicer_path: slice_view.slicer_path
        stemStyle: slice_view.stemStyle
      }
    }
  }
}
