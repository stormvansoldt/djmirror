import QtQuick
import '../Widgets' as Widgets

//----------------------------------------------------------------------------------------------------------------------
// STEM DECK - Vista principal para el modo Stems
//
// CARACTERÍSTICAS PRINCIPALES:
//
// 1. Estructura Base
//    - Dimensiones fijas: 320x240 px
//    - Contiene un TrackDeck base y un StemOverlay
//
// 2. TrackDeck
//    - Componente base que hereda la información del deck
//    - Ocupa todo el espacio disponible
//    - Muestra la visualización principal del deck
//
// 3. StemOverlay
//    - Capa superior para controles Stem
//    - Visible solo cuando stems están activos (isStemsActive)
//    - Anclado a la parte superior izquierda
//    - Hereda la información del deck
//
// PROPIEDADES:
// - deckInfo: Objeto que contiene la información del deck y sus stems
//   * isStemsActive: Boolean que indica si el modo stems está activo
//
// NOTAS:
// - El componente combina la visualización tradicional de deck con controles stem
// - La visibilidad del overlay se gestiona automáticamente según el estado de stems
//----------------------------------------------------------------------------------------------------------------------

Item {
  id: display

  // MODEL PROPERTIES
  property var deckInfo: ({})

  width  : 320
  height : 240

  TrackDeck {
    id: trackScreen
    deckInfo: display.deckInfo
    anchors.fill: parent
  }

  // STEM OVERLAY
  Widgets.StemOverlay {
    visible: display.deckInfo.isStemsActive
    anchors.top:  parent.top
    anchors.left: parent.left
    deckInfo: display.deckInfo
  }
}
