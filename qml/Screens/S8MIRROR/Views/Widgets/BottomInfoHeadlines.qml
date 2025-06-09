import QtQuick

//----------------------------------------------------------------------------------------------------------------------
//  BOTTOM INFO HEADLINES - Componente para mostrar títulos con línea inferior
//
//  ELEMENTOS PRINCIPALES Y COLORES:
//
//  1. Contenedor Principal (bottomInfoHeadlines)
//     - Contiene texto y línea decorativa
//
//  2. Texto del Título
//     - Texto configurable (default: "FILTER")
//     - // TODO: Color: configurable via textColor (default: "white" #FFFFFF)
//     - Tamaño de fuente: 10px (escalado)
//
//  3. Línea Inferior (bottomInfoLine)
//     - Color: igual que el texto (textColor)
//     - Anclada a la parte inferior
//
//  PROPIEDADES:
//  - headlineText: Texto a mostrar
//  - textColor: Color para texto y línea
//
//  NOTAS:
//  - Componente simple para títulos con subrayado
//  - El color se aplica tanto al texto como a la línea
//  - La fuente se escala según el sistema
//
//----------------------------------------------------------------------------------------------------------------------

Item {
  id: bottomInfoHeadlines

  property string headlineText: "FILTER"
  property color textColor: colors.colorFontWhite
  property real screenScale: prefs.screenScale

  height: 13 * screenScale  // Escalar altura
  width: 157 * screenScale  // Escalar ancho

  Text {
    text: headlineText
    color: textColor

    font.pixelSize: fonts.miniFontSize * screenScale  
    font.family: prefs.normalFontName

    anchors.top: parent.top
    anchors.horizontalCenter: parent.horizontalCenter
  }

  Rectangle {
    id: bottomInfoLine

    height: 1 * screenScale  // Escalar altura de la línea
    color: textColor
    anchors.bottom: parent.bottom
    width: parent.width
  }
}
