import QtQuick
import Qt5Compat.GraphicalEffects

//----------------------------------------------------------------------------------------------------------------------
// EMPTY DECK - Componente que muestra la visualización de un deck vacío
//
// CARACTERÍSTICAS PRINCIPALES:
//
// 1. Fondo
//    - Color: colors.defaultBackground
//    - Ocupa todo el espacio disponible del padre
//
// 2. Imagen Central
//    - Fuente: "../../Images/EmptyDeck.png"
//    - Márgenes: 15px superior e inferior
//    - Modo de relleno: PreserveAspectFit
//    - Invisible por defecto (manejada por ColorOverlay)
//
// 3. Overlay de Color
//    - Color: #252525 (gris oscuro)
//    - Aplica tinte sobre la imagen base
//    - Visible por defecto
//
// PROPIEDADES:
// - deckColor: Color del deck (por defecto "black")
//
// NOTAS:
// - La imagen base se mantiene invisible y se muestra a través del ColorOverlay
// - El diseño mantiene proporciones originales de la imagen
//----------------------------------------------------------------------------------------------------------------------

Item {
  anchors.fill: parent
  property color deckColor: "black"
  property real screenScale: prefs.screenScale

  Rectangle {
    id: background
    color: colors.defaultBackground
    anchors.fill: parent
  }

  Image {
    id: emptyTrackDeckImage
    anchors.fill: parent
    anchors.bottomMargin: 15 * screenScale  // Escalar márgenes
    anchors.topMargin: 15 * screenScale
    visible: false // visibility is handled by emptyTrackDeckImageColorOverlay
    source: "../../Images/EmptyDeck.png"
    fillMode: Image.PreserveAspectFit
  } 

  // Function Deck Color
  ColorOverlay {
    id: emptyTrackDeckImageColorOverlay
    anchors.fill: emptyTrackDeckImage
    visible: true
    color: "#252525"
    source: emptyTrackDeckImage
  }
}

