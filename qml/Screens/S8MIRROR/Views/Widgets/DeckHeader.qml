import QtQuick

//----------------------------------------------------------------------------------------------------------------------
//  DECK HEADER - Cabecera para mostrar el título del deck
//
//  ELEMENTOS PRINCIPALES Y COLORES:
//
//  1. Contenedor Principal (widget)
//     - Contiene el fondo y el texto del título
//
//  2. Fondo de la Cabecera (headerBg)
//     - Color: configurable via backgroundColor (default: colors.defaultBackground)
//     - Ocupa todo el espacio del contenedor
//
//  3. Texto del Título
//     - Color: colors.defaultTextColor
//     - Elipsis si el texto es muy largo
//
//  PROPIEDADES:
//  - title: Texto a mostrar
//  - backgroundColor: Color de fondo
//
//  NOTAS:
//  - Usa dimensiones predefinidas del sistema (dimensions)
//  - El texto se trunca con elipsis si excede el ancho
//  - Asume que 'colors' y 'dimensions' existen en la jerarquía
//
//----------------------------------------------------------------------------------------------------------------------

Item {
  id: widget

  property real screenScale: prefs.screenScale

  property string title: ''
  property color  backgroundColor: colors.defaultBackground
  
  height: dimensions.firstRowHeight * screenScale
  

  Rectangle {
    id           : headerBg
    color        : widget.backgroundColor
    anchors.fill : parent
    radius: dimensions.cornerRadius * screenScale
    
    // TRACK NAME // 
    Text
    {
      anchors.fill : parent
      anchors.leftMargin:   dimensions.titleTextMargin * screenScale
      anchors.rightMargin:  dimensions.titleTextMargin * screenScale

      font.family: prefs.normalFontName
      font.weight: Font.Normal
      font.pixelSize: fonts.largeFontSizePlus * screenScale

      color: colors.defaultTextColor

      verticalAlignment: Text.AlignVCenter
      elide: Text.ElideRight
      text: widget.title
    }
  }
}
