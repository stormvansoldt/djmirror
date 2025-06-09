import CSI 1.0
import QtQuick
import Traktor.Gui 1.0 as Traktor

//----------------------------------------------------------------------------------------------------------------------
//  ACTIVE CUE - Componente que muestra los marcadores triangulares en la parte inferior de la waveform/stripe
//
//  ELEMENTOS PRINCIPALES Y COLORES:
//
//  1. Cue Principal (cue)
//     - Triángulo que marca el punto de cue
//     - Colores:
//       * Loop: colors.color07Bright (verde brillante)
//       * Normal: colors.colorWhite (blanco)
//       * Borde: colors.colorBlack50 (negro semi-transparente)
//
//  2. End Cue (endCueLoader)
//     - Triángulo que marca el final del loop
//     - Mismos colores que el cue principal
//
//  3. Tipos de Marcadores (hotcueMarkerTypes):
//     - hotcue: Punto de cue normal
//     - fadeIn: Punto de entrada de fade
//     - fadeOut: Punto de salida de fade
//     - load: Punto de carga
//     - grid: Punto de grid
//     - loop: Punto de loop
//
//  CARACTERÍSTICAS:
//  - Posición: Anclado a la parte inferior
//  - Antialiasing activado para mejor renderizado
//
//  NOTAS:
//  - Los triángulos se posicionan con márgenes negativos para alineación precisa
//  - El clip está desactivado para permitir que los triángulos sobresalgan
//  - La longitud del loop se controla con activeCueLength
//  - Asume que 'colors' existe en la jerarquía
//
//----------------------------------------------------------------------------------------------------------------------


// These are the triangle shaped cues at the bottom of the waveform/stripe. Two different sized triangle components can
// be loaded and switched using the 'isSmall' variable. 
Item {
  id: activeCue

  property real screenScale: prefs.screenScale

  property int  activeCueLength: 0
  property int  cueWidth: cue.width
  property bool isSmall: false

  readonly property var  hotcueMarkerTypes: {0: "hotcue", 1: "fadeIn", 2: "fadeOut", 3: "load", 4: "grid", 5: "loop" }
  property bool isLoop: (hotcueMarkerTypes[type.value] == "loop")
  property int type: -1

  anchors.top:    parent.top
  anchors.bottom: parent.bottom
  anchors.leftMargin:   -1 * screenScale
  width: 20 * screenScale
  clip:  false

  AppProperty { id: type;   path: "app.traktor.decks." + (parent.deckId+1) + ".track.cue.active.type"   }

  //--------------------------------------------------------------------------------------------------------------------

  Item {
    id: cue
    anchors.right:      parent.right
    anchors.left:       parent.left
    anchors.bottom:     parent.bottom
    height:             isSmall ? 7 * screenScale : 13 * screenScale
    width:              cueLoader.sourceComponent.width
    clip:               false

    Loader { 
      id: cueLoader 
      anchors.bottom: parent.bottom
      height:         parent.height
      width:          parent.width
      active:         true
      visible:        true
      clip:           false
      sourceComponent: isSmall ? smallCue : largeCue
    }
  }

  //--------------------------------------------------------------------------------------------------------------------

  Item {
    anchors.left:   cue.left
   // anchors.leftMargin: -1
    width:          parent.activeCueLength  + 1
    anchors.bottom: parent.bottom
    height:         7 * screenScale
    clip:           false

    Loader { 
      id: endCueLoader 
      anchors.left:    parent.right
      anchors.bottom:  parent.bottom
      height:          cue.height
      width:           cue.width
      active:          true
      visible:         isLoop
      clip:            false
      sourceComponent: isSmall ? smallCue : largeCue
    }
  }

  //--------------------------------------------------------------------------------------------------------------------
  // the small cue for the stripe is defined here. It is positioned such that its horizontal center lies on the left
  // anchor of the activeCue Item.
  Component {
    id: smallCue
    Traktor.Polygon {
      id: currentCueSmall

      anchors.bottomMargin: -2 * screenScale
      anchors.leftMargin: -7 * screenScale

      anchors.left:       parent.left
      anchors.bottom:     parent.bottom

      color:              activeCue.isLoop ? colors.color07Bright : colors.colorWhite

      border.width:       1 * screenScale
      border.color:       colors.colorBlack50
      antialiasing:       true
      points: [ 
        Qt.point(0, 7 * screenScale), 
        Qt.point(5.5 * screenScale, 0), 
        Qt.point(11 * screenScale, 7 * screenScale)
      ]
    }
  }

  //--------------------------------------------------------------------------------------------------------------------
  // the large cue for the stripe is defined here. It is positioned such that its horizontal center lies on the left
  // anchor of the activeCue Item.
  Component {
    id: largeCue
    Traktor.Polygon {
      id: currentCueLarge

      anchors.bottomMargin: -12 * screenScale
      anchors.leftMargin: -10 * screenScale

      anchors.left:       parent.left
      anchors.bottom:     parent.bottom

      color:              activeCue.isLoop ? colors.color07Bright : colors.colorWhite

      border.width:       1.5 * screenScale
      border.color:       colors.colorBlack50
      antialiasing:       true
      points: [ 
          Qt.point(13 * screenScale, 8 * screenScale), 
          Qt.point(0 , 8 * screenScale), 
          Qt.point(6.5 * screenScale , 0)
      ]
    }
  }
}
