import CSI 1.0
import QtQuick

import '../../../Defines' as Defines
import '../../../../Defines'

//------------------------------------------------------------------------------------------------------------------
//  SLICE - Componente que representa un segmento individual en el modo Slicer/Freeze
//
//  Características principales:
//  - Visualiza segmentos individuales de la forma de onda
//  - Soporta dos modos: Freeze y Loop (Slicer)
//  - Muestra indicadores visuales de estado activo y rango
//  - Incluye numeración y marcadores de bordes
//  - Se adapta a diferentes estilos de stem
//
//  Propiedades principales:
//  - slice_index: Índice del segmento actual
//  - last_slice: Indica si es el último segmento
//  - first_slice: Indica si es el primer segmento
//  - stemStyle: Estilo del stem (track/stem)
//  - active: Indica si el segmento está actualmente activo
//  - in_range: Indica si está dentro del rango seleccionado
//  - freeze_mode: Indica si está en modo Freeze (true) o Loop (false)
//
//  Elementos visuales:
//  - backgroundColor (Rectangle):
//    * Fondo base del segmento
//    * Verde en modo Loop, transparente en modo Freeze
//
//  - slice_rect (Rectangle):
//    * Overlay de color para destacar estados
//    * Incluye animación de fade para feedback visual
//
//  - left_marker/right_marker (Rectangle):
//    * Marcadores verticales en bordes
//    * Color varía según estado y modo
//
//  - slice_box (Rectangle):
//    * Caja inferior con número de segmento
//    * Altura adaptativa según stemStyle
//
//  Estados de color:
//  - Modo Freeze:
//    * Inactivo: Gris claro
//    * Activo: Color brillante del deck
//    * Marcadores: Gris medio
//
//  - Modo Loop:
//    * Inactivo: Verde tenue
//    * Activo: Verde brillante
//    * En rango: Verde medio
//    * Marcadores: Verde o mezcla verde-gris
//
//  Funciones principales:
//  - update_colors(): Actualiza todos los colores según estado
//  - box_color(): Determina color de la caja según estado
//  - marker_color(): Determina color de marcadores
//  - text_color(): Determina color del número
//
//  Animaciones:
//  - fade_animation: Efecto de desvanecimiento al activar slice
//    * Duración: 250ms
//    * Curva: OutCubic
//------------------------------------------------------------------------------------------------------------------

Item {

  Defines.Colors { id: colors }
  Defines.Font { id: fonts }

  property int  slice_index // index of this slice
  property bool last_slice // whether we are the last slice in the row

  property bool first_slice: slice_index == 0 // whether we are the first slice in the row
  property int stemStyle: StemStyle.track

  property string slicer_path

  property int current_slice: propCurrentSlice.value
  property int first_slice_in_range: propFirstSliceInRange.value
  property int last_slice_in_range: propLastSliceInRange.value

  property bool active: slice_index == current_slice
  property bool in_range: slice_index >= first_slice_in_range && slice_index <= last_slice_in_range
  property bool on_beat: false // not implemented
  property bool freeze_mode: propSlicerMode.value == 0

  //--------------------------------------------------------------------------------------------------------------------

  AppProperty { id: propCurrentSlice;      path: slicer_path + ".current_slice"; }
  AppProperty { id: propFirstSliceInRange; path: slicer_path + ".first_slice_in_range"; }
  AppProperty { id: propLastSliceInRange;  path: slicer_path + ".last_slice_in_range"; }
  AppProperty { id: propSlicerMode;        path: slicer_path + ".is_slicer_mode"; }
  AppProperty { 
    id: propLastActive; 
    path: slicer_path + ".last_activated_slice"; 
    onValueChanged: { if ( value === slice_index ) fade_animation.trigger(); }
  }

  //--------------------------------------------------------------------------------------------------------------------

  Component.onCompleted: update_colors();
  onActiveChanged:       update_colors();
  onIn_rangeChanged:     update_colors();
  onFreeze_modeChanged:  update_colors();

  //--------------------------------------------------------------------------------------------------------------------
  
  Rectangle {
    id: backgroundColor
    anchors.fill:         parent
    anchors.bottomMargin: (stemStyle == StemStyle.track) ? 17 : 12

    anchors.leftMargin:   1
    color:                freeze_mode ? "transparent" : colors.colorGreen12 // slice background is colored green in loop mode
  }

  //--------------------------------------------------------------------------------------------------------------------

  Rectangle {
    id: slice_rect
    property real fade: 0

    anchors.fill: parent
    anchors.bottomMargin: 17
    anchors.leftMargin:   1
    // this color is added on top of the  slice color ( in slice mode it turns from transparent to blue , in loop mode
    // the green color brightens up by 20%)
    color:        parent.freeze_mode ? colors.colorDeckBlueBright20 : colors.colorGreen08  
    opacity:      parent.freeze_mode ? fade : (parent.in_range ? 1 : 0)                    // highlighting mechanism

    PropertyAnimation { 
      id: fade_animation

      function trigger() {
        stop();
        slice_rect.fade = 1;
        start();
      }

      target: slice_rect
      property: "fade"
      from: 1
      to: 0
      duration: 250
      easing.type: Easing.OutCubic
    }
  }

  //--------------------------------------------------------------------------------------------------------------------

  function update_colors() {
    left_marker.color  = marker_color(first_slice);
    right_marker.color = marker_color(last_slice);
    slice_box.color    = box_color();
    slice_number.color = text_color();
  }

  // this function caclulates the color of the box beneath the waveform depending on the current slice state
  function box_color() {
    if ( freeze_mode ) {
      // should the colors here be deck dependent? 
      return active ? colors.colorDeckBright : colors.colorGrey16 // freeze box bg color (active/inactive)
    }

    if ( active )   return colors.colorGreen;     //  currently active loop slice
    if ( in_range ) return colors.colorGreen50;   //  loopslices in selected range
    return  colors.colorGreen12                   //  inactive loop slices
  }

  function marker_color(edge) {
    if ( freeze_mode ) {
      return colors.colorGrey48;                  // freeze marker color
    } else {
      if ( edge )    return colors.colorGreen;    // edge marker color in loop mode (invisible in freeze mode)
      if ( on_beat ) return colors.colorBlack;              // not implemented yet
      return colors.colorGreenGreyMix;            // marker color in loop mode
    }
  }

  function text_color() {
    if ( freeze_mode && !active ) {
      return colors.colorFontBlue;                    // freeze box text color
    }

    if ( !freeze_mode && !active ) {
      return colors.colorFontGreen;                   // loop box text color
    }

    return colors.colorFontBlack;                     // text color when slice is active
  }

  //--------------------------------------------------------------------------------------------------------------------

  Rectangle {
    id: left_marker
    width: 1
    height: parent.height
    // color set in function
  }

  Rectangle {
    id: right_marker
    width: 1
    height: parent.height
    x: parent.width
    visible: parent.last_slice
    // color set in function
  }

  // box at bottom of slice
  Rectangle {
    id: slice_box

    property int box_height: (stemStyle == StemStyle.track) ? 13 : 9
    height: box_height

    anchors.fill: parent
    anchors.leftMargin: 3
    anchors.rightMargin: 2
    anchors.topMargin: parent.height - box_height
    // color set above

    Text {
      id: slice_number
      text: slice_index + 1

      anchors.horizontalCenter: slice_box.horizontalCenter
      anchors.verticalCenter: slice_box.verticalCenter

      font.pixelSize: fonts.miniFontSize
      font.family: prefs.normalFontName
      font.bold: true
    }
  }
}

