import CSI 1.0
import QtQuick

//----------------------------------------------------------------------------------------------------------------------
// LOOP SIZE
//
// ELEMENTOS PRINCIPALES Y COLORES:
//
// 1. Fondo del Tamaño del Loop (loopSizeBackground)
//    - Forma: Círculo
//    - Color: colors.colorBlack85
//    - Anclado al centro del contenedor
//
// 2. Borde del Tamaño del Loop (loopLengthBorder)
//    - Forma: Círculo
//    - Color del borde: colors.colorGreen
//    - Color de fondo: "transparent"
//
// 3. Texto del Tamaño del Loop
//    - Texto: Representa el tamaño del loop (e.g., "1", "2", "4", etc.)
//    - Color: colors.colorGreen
//    - Fuente: fonts.extraLargeFontSizePlus (ajustable según el tamaño del loop)
//
// NOTAS:
// - El componente muestra el tamaño del loop actual.
// - El tamaño de la fuente se ajusta dinámicamente según el valor del loop.
// - Los colores y dimensiones están diseñados para resaltar el tamaño del loop.
//----------------------------------------------------------------------------------------------------------------------

Item {
  anchors.fill: parent

  property real screenScale: prefs.screenScale

  AppProperty { id: loopActive; path: "app.traktor.decks." + (parent.deckId+1) + ".loop.active" }
  AppProperty { id: loopSizePos; path: "app.traktor.decks." + (parent.deckId+1) + ".loop.size"; }

  property int deckId: 0


  Rectangle {
    id:       loopSizeBackground
    width:    59 * screenScale  // Escalar ancho
    height:   width
    radius:   width * 0.5
    color:    colors.colorBlack85
    Behavior on opacity { NumberAnimation { duration: blinkFreq; easing.type: Easing.Linear} }
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.verticalCenter:   parent.verticalCenter
    Rectangle {
      id:       loopLengthBorder
      anchors.horizontalCenter: parent.horizontalCenter
      anchors.verticalCenter:   parent.verticalCenter
      width:  loopSizeBackground.width - (2 * screenScale)  // Escalar margen
      height: width
      radius: width * 0.5
      color: "transparent"
      border.color: colors.colorGreen
      border.width: 2 * screenScale  // Escalar ancho del borde
    }
  }

  Text {
    readonly property variant loopText: ["/32", "/16", "1/8", "1/4", "1/2", "1", "2", "4", "8", "16", "32"]
    text: loopText[loopSizePos.value]

    color: colors.colorFontGreen

    font.pixelSize: fonts.extraLargeFontSizePlus * screenScale
    font.family: prefs.normalFontName

    anchors.fill: loopSizeBackground
    anchors.rightMargin: 2 * screenScale  // Escalar márgenes
    anchors.topMargin: 1 * screenScale
    horizontalAlignment: Text.AlignHCenter
    verticalAlignment:   Text.AlignVCenter
    onTextChanged: {
      if (loopSizePos.value < 5) {
        font.pixelSize = 22 * screenScale  // Escalar tamaño de fuente pequeño
      } else if ( loopSizePos.value > 8 ){
        font.pixelSize = 32 * screenScale  // Escalar tamaño de fuente grande
      } else {
        font.pixelSize = fonts.extraLargeFontSizePlus * screenScale
      }
    }
  }
}
