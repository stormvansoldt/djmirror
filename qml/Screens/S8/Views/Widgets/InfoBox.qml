import QtQuick

//----------------------------------------------------------------------------------------------------------------------
//  INFO BOX - Caja de información con título y contenido
//
//  ELEMENTOS PRINCIPALES Y COLORES:
//
//  1. Fondo (Background)
//     - Color: configurable via widget.color
//     - Ocupa todo el espacio del contenedor
//
//  2. Título
//     - Color: widget.color
//     - Fuente: Roboto Normal, 10px
//
//  3. Contenido
//     - Color: widget.color
//     - Fuente: Roboto, tamaño configurable (default: 30px)
//     - Estilo:
//       * Normal: sin outline
//       * Highlight: con outline del mismo color
//
//  PROPIEDADES:
//  - title: Texto del título
//  - text: Texto del contenido
//  - active: Controla la opacidad del fondo
//  - highlight: Activa/desactiva el outline del contenido
//  - color: Color principal del componente
//  - fontSize: Tamaño de fuente del contenido
//  - alignment: Alineación horizontal de textos
//
//  NOTAS:
//  - Diseño flexible que se adapta al contenido
//  - El título siempre es más pequeño y semi-transparente
//  - El contenido puede resaltarse con outline
//
//----------------------------------------------------------------------------------------------------------------------

Item {
  id: widget

  property string title: ''
  property string text:  ''
  property bool active: false
  property bool highlight: false
  property color color: 'white'
  //property int fontSize: 30
  property int alignment: Text.AlignCenter

  // Background
  Rectangle {
    color: widget.color
    anchors.fill: parent
    opacity: widget.active ? 0.15 : 0.00
  }

  // Title
  Text {
    id: title
    opacity: 0.5
    text: widget.title

    font.pixelSize: fonts.miniFontSize
    font.family: prefs.normalFontName
    font.weight: Font.Normal

    color: colors.colorFontWhite

    horizontalAlignment: widget.alignment

    anchors.top: parent.top
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.bottom: content.top
    anchors.topMargin: 5
    anchors.leftMargin: 10
    anchors.rightMargin: 10
  }

  // Content
  Text {
    id: content
    text: widget.text

    font.pixelSize: fonts.extraLargeFontSize
    font.family: prefs.normalFontName

    verticalAlignment: Text.AlignBottom
    horizontalAlignment: widget.alignment

    color: colors.colorFontWhite

    style: widget.highlight ? Text.Outline : Text.Normal
    styleColor: widget.color

    anchors.top: title.top
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.bottom: parent.bottom
    anchors.bottomMargin: 5
    anchors.leftMargin: 10
    anchors.rightMargin: 10
  }
}