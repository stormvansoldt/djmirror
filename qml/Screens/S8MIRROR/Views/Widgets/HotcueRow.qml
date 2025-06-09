import CSI 1.0
import QtQuick


//----------------------------------------------------------------------------------------------------------------------
//  HOTCUE ROW - Fila de 8 hotcues con nombres y colores
//
//  ELEMENTOS PRINCIPALES Y COLORES:
//
//  1. Contenedor de Hotcue (Rectangle)
//     - Color: "transparent"
//     - Anclado al fondo del padre
//
//  2. Texto del Hotcue
//     - Colores:
//       * Activo: colors.colorGrey232
//       * Inactivo: colors.colorGrey24
//     - Fuente: fonts.miniFontSize
//     - Alineación: Centrada horizontal y verticalmente
//     - Texto:
//       * Con nombre: nombre recortado
//       * Sin nombre: número de índice + 1
//       * No existe: símbolo "▲"
//
//  3. Línea Indicadora
//     - Colores:
//       * Activo: colors.hotcueColors[index + 1]
//       * Inactivo: colors.colorGrey24
//     - Anclada al fondo del contenedor
//
//  NOTAS:
//  - Muestra 8 hotcues en una fila horizontal
//  - Cada hotcue tiene su propio color identificativo
//  - Los nombres se truncan con elipsis si son muy largos
//  - El estado se controla mediante AppProperties
//
//----------------------------------------------------------------------------------------------------------------------


Item {
  id: hotcue_row

  property real screenScale: prefs.screenScale
  
  // Propiedades de color
  property color colorBackground: "transparent"

  property color colorTextActive: colors.colorGrey232
  property color colorTextInactive: colors.colorGrey24
  property color colorIndicatorInactive: colors.colorGrey24

  // Función auxiliar para obtener el color del indicador según el índice
  function getHotcueColor(index) {
    return colors.hotcueColors[index + 1]
  }

  Repeater {
    id: hotcues
    model: 8

    Rectangle {
      // Propiedades del hotcue
      property string nameTrimmed: name.value.trim()
      property bool   hasName:     (nameTrimmed != "" && nameTrimmed != "n.n.")

      // Propiedades de color específicas del hotcue
      property color currentTextColor: exists.value ? 
                                     hotcue_row.colorTextActive : 
                                     hotcue_row.colorTextInactive

      property color currentIndicatorColor: exists.value ? 
                                          hotcue_row.getHotcueColor(index) : 
                                          hotcue_row.colorIndicatorInactive

      // AppProperties para estado y nombre
      AppProperty { 
        id: exists
        path: "app.traktor.decks." + (deckId + 1) + ".track.cue.hotcues." + (index + 1) + ".exists" 
      }
      AppProperty { 
        id: name
        path: "app.traktor.decks." + (deckId + 1) + ".track.cue.hotcues." + (index + 1) + ".name"   
      }

      // Posicionamiento y tamaño
      anchors.left:              parent.left
      anchors.leftMargin:        (5 + 60 * index) * screenScale
      anchors.bottom:            parent.bottom
      width:                     50 * screenScale
      height:                    17 * screenScale
      color:                     hotcue_row.colorBackground

      // Texto del hotcue
      Text {
        anchors.fill:            parent
        anchors.topMargin:       1 * screenScale
        color:                   parent.currentTextColor

        font.pixelSize:          fonts.miniFontSize * screenScale
        font.family:             prefs.normalFontName

        horizontalAlignment:     Text.AlignHCenter
        verticalAlignment:       Text.AlignVCenter
        elide:                   Text.ElideMiddle
        text:                    exists.value ? (hasName ? nameTrimmed : (index + 1)) : "▲"
      }

      // Línea indicadora
      Rectangle {
        anchors.left:            parent.left
        anchors.bottom:          parent.bottom
        width:                   parent.width
        height:                  2 * screenScale
        color:                   parent.currentIndicatorColor
      }
    }
  }
}
