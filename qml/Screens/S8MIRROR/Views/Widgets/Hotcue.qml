import QtQuick
import Traktor.Gui 1.0 as Traktor
import Qt5Compat.GraphicalEffects
import CSI 1.0

import '../../../Defines' as Defines


//----------------------------------------------------------------------------------------------------------------------
//  HOTCUE - Componente para mostrar diferentes tipos de marcadores en la pista
//
//  ELEMENTOS PRINCIPALES Y COLORES:
//
//  1. Marcador Simple (flagpole)
//     - Color: hotcueColor (configurable)
//     - Borde: colors.colorBlack50
//
//  2. Tipos de Marcadores:
//     a. Grid
//        - Color: colors.hotcue.grid
//        - Forma: Bandera rectangular con poste
//        - Texto negro con ID del hotcue
//
//     b. Hotcue
//        - Color: colors.hotcue.hotcue
//        - Forma: Bandera pentagonal
//        - Texto negro con ID del hotcue
//
//     c. Fade In/Out
//        - Color: colors.hotcue.fade
//        - Forma: Bandera trapezoidal
//        - Texto negro con ID del hotcue
//
//     d. Load
//        - Color: colors.hotcue.load
//        - Forma: Círculo con poste
//        - Texto negro con ID del hotcue
//
//     e. Loop
//        - Color: colors.hotcue.loop
//        - Forma: Par de banderas rectangulares
//        - Texto negro con ID del hotcue
//
//  3. Características Comunes:
//     - Borde: colors.colorBlack50 (ancho: 2px)
//     - Texto: colors.colorBlack
//     - Fuente: fonts.miniFontSizePlusPlus
//     - Antialiasing activado
//
//  4. Variantes de Tamaño:
//     - Small: Versión compacta (smallHead: true)
//     - Large: Versión grande (smallHead: false)
//
//  ESTADOS:
//  - off: Marcador oculto
//  - grid/hotcue/fadeIn/fadeOut/load/loop: Diferentes tipos de marcadores
//
//  NOTAS:
//  - Los colores específicos se definen en colors.hotcue
//  - Cada tipo tiene su propia forma y comportamiento
//  - El componente se adapta automáticamente según el estado
//  - El hotcue puede usarse para mostrar todos los diferentes tipos de hotcues. El cambio de tipo se realiza mediante el 'hotcue state'.
//  - El número mostrado en el hotcue puede establecerse mediante hotcueId.
//
//----------------------------------------------------------------------------------------------------------------------


Item {
  id : hotcue

  property real screenScale: prefs.screenScale

  Defines.Colors { id: colors }
  Defines.Font   { id: fonts  }

  property bool   showHead:     true
  property bool   smallHead:    true 
  property color  hotcueColor:  "transparent" 
  property int    hotcueId:     0
  property int    hotcueLength: 0
  property int    topMargin:    6 * screenScale

  // Propiedades de color
  property color colorBackground: "transparent"
  property color colorBorder: colors.colorBlack50

  property color colorText: colors.colorFontBlack
  
  // Colores específicos por tipo
  property color colorGrid: colors.hotcue.grid
  property color colorHotcue: colors.hotcue.hotcue
  property color colorFade: colors.hotcue.fade
  property color colorLoad: colors.hotcue.load
  property color colorLoop: colors.hotcue.loop

  // Color actual según estado
  property color currentColor: {
    switch(hotcueState) {
      case "grid": return colorGrid
      case "hotcue": return colorHotcue
      case "fadeIn":
      case "fadeOut": return colorFade
      case "load": return colorLoad
      case "loop": return colorLoop
      default: return colorBackground
    }
  }

  readonly property double borderWidth:       2 * screenScale
  readonly property bool   useAntialiasing:   true
  readonly property int    smallCueHeight:    height
  readonly property int    smallCueTopMargin: -4 * screenScale
  readonly property int    largeCueHeight:    height
  readonly property var    hotcueMarkerTypes: { 0: "hotcue", 1: "fadeIn", 2: "fadeOut", 3: "load", 4: "grid", 5: "loop" }
  readonly property string hotcueState:       ( exists.value && type.value != -1) ? hotcueMarkerTypes[type.value] : "off"

  AppProperty { id: type;   path: "app.traktor.decks." + (parent.deckId+1) + ".track.cue.hotcues." + hotcue.hotcueId + ".type"   }
  AppProperty { id: active; path: "app.traktor.decks." + (parent.deckId+1) + ".track.cue.hotcues." + hotcue.hotcueId + ".active" }
  AppProperty { id: exists; path: "app.traktor.decks." + (parent.deckId+1) + ".track.cue.hotcues." + hotcue.hotcueId + ".exists" }

  height:  parent.height
  clip: false // true

  //--------------------------------------------------------------------------------------------------------------------
  // If the hotcue should only be represented as a single line, use 'flagpole'

  Rectangle {
    id: flagpole
    anchors.bottom: parent.bottom
    anchors.horizontalCenter: parent.horizontalCenter
    height: parent.height
    width: 3 * screenScale
    border.width: 1 * screenScale
    border.color: hotcue.currentColor
    color: hotcue.currentColor
    visible: !showHead && (smallHead == true)
  }

  //--------------------------------------------------------------------------------------------------------------------
  // cue loader loads the different kinds of hotcues depending on their type (-> states at end of file)

  Item {
    anchors.top:              parent.top
    anchors.horizontalCenter: parent.horizontalCenter
    height:                   smallHead ? 44 * screenScale : (parent.height)
    width:                    40 * screenScale
    clip: false // true
    visible:                  hotcue.showHead
    Loader { 
      id: cueLoader 
      anchors.fill: parent
      active:       true
      visible:      true
      clip: false // true
    }
  }


  // GRID --------------------------------------------------------------------------------------------------------------

  Component {
    id: gridComponentSmall
    Traktor.Polygon {
      anchors.top:        cueLoader.top
      anchors.left:       cueLoader.horizontalCenter
      anchors.topMargin:  hotcue.smallCueTopMargin
      anchors.leftMargin: -8 * screenScale

      antialiasing:       useAntialiasing

      color:              hotcue.currentColor
      border.width:       borderWidth
      border.color:       hotcue.colorBorder

      points: [ Qt.point(0 , 10 * screenScale)
              , Qt.point(0 , 0)
              , Qt.point(13 * screenScale, 0) 
              , Qt.point(13 * screenScale, 10 * screenScale)
              , Qt.point(7 * screenScale , 14 * screenScale)
              , Qt.point(7 * screenScale , hotcue.smallCueHeight)
              , Qt.point(6 * screenScale , hotcue.smallCueHeight)
              , Qt.point(6 * screenScale , 14 * screenScale)
              ]
      Text { 
        anchors.top:        parent.top
        anchors.left:       parent.left
        anchors.leftMargin: 4 * screenScale
        anchors.topMargin: -1 * screenScale
        color:              hotcue.colorText
        text:               hotcue.hotcueId

        font.pixelSize:     fonts.miniFontSizePlusPlus * screenScale
        font.family:        prefs.cueFontName
      }
    }
  }

  Component {
    id: gridComponentLarge
    Traktor.Polygon {
      anchors.top:        cueLoader.top
      anchors.left:       cueLoader.horizontalCenter
      anchors.leftMargin: -10 * screenScale 
      anchors.topMargin:  -1 * screenScale
      antialiasing:       useAntialiasing

      color:              hotcue.currentColor
      border.width:       borderWidth
      border.color:       hotcue.colorBorder
      points: [ Qt.point(0 , 12 * screenScale)
              , Qt.point(0 , 0)
              , Qt.point(15 * screenScale, 0) 
              , Qt.point(15 * screenScale, 12 * screenScale)
              , Qt.point(8 * screenScale , 17 * screenScale)
              , Qt.point(8 * screenScale , hotcue.largeCueHeight)
              , Qt.point(7 * screenScale , hotcue.largeCueHeight)
              , Qt.point(7 * screenScale , 17 * screenScale)
              ]
      Text { 
        anchors.top:        parent.top
        anchors.left:       parent.left
        anchors.leftMargin: 5 * screenScale
        color:              hotcue.colorText
        text:               hotcue.hotcueId

        font.pixelSize:     fonts.miniFontSizePlusPlus * screenScale
        font.family:        prefs.cueFontName
      }
    }
  }

  // CUE ----------------------------------------------------------------------------------------------------------------

  Component {
    id: hotcueComponentSmall
    Traktor.Polygon {
      anchors.top:        cueLoader.top
      anchors.left:       cueLoader.horizontalCenter
      anchors.topMargin:  hotcue.smallCueTopMargin
      anchors.leftMargin: -2 * screenScale
      antialiasing:       useAntialiasing

      color:              hotcue.currentColor
      border.width:       borderWidth
      border.color:       hotcue.colorBorder
      points: [ Qt.point(0 , 0)
              , Qt.point(12 * screenScale, 0)
              , Qt.point(15 * screenScale, 5.5 * screenScale)
              , Qt.point(12 * screenScale, 11 * screenScale)
              , Qt.point(1 * screenScale, 11 * screenScale)
              , Qt.point(1 * screenScale, hotcue.smallCueHeight)
              , Qt.point(0 , hotcue.smallCueHeight) 
              ]
      Text {
        anchors.top:        parent.top; 
        anchors.left:       parent.left; 
        anchors.leftMargin: 4 * screenScale
        anchors.topMargin:  -1 * screenScale
        color:              hotcue.colorText; 
        text:               hotcue.hotcueId; 

        font.pixelSize:     fonts.miniFontSizePlusPlus * screenScale
        font.family:        prefs.cueFontName
      }
    }
  }

  Component {
    id: hotcueComponentLarge
    Traktor.Polygon {
      anchors.top:        cueLoader.top
      anchors.left:       cueLoader.horizontalCenter
      anchors.leftMargin: -3 * screenScale
      anchors.topMargin:  -1 * screenScale
      antialiasing:       useAntialiasing

      color:              hotcue.currentColor 
      border.width:       borderWidth
      border.color:       hotcue.colorBorder
      points: [ Qt.point(0 , 0)
              , Qt.point(14 * screenScale, 0)
              , Qt.point(19 * screenScale, 6.5 * screenScale)
              , Qt.point(14 * screenScale, 13 * screenScale)
              , Qt.point(1 * screenScale, 13 * screenScale)
              , Qt.point(1 * screenScale, hotcue.largeCueHeight) 
              , Qt.point(0 , hotcue.largeCueHeight) 
              ]
      Text {
        anchors.top:        parent.top;         
        anchors.left:       parent.left; 
        anchors.leftMargin: 5 * screenScale
        color:              hotcue.colorText; 
        text:               hotcue.hotcueId; 

        font.pixelSize:     fonts.miniFontSizePlusPlus * screenScale
        font.family:        prefs.cueFontName
      }
    }
  }



  // FADE IN -----------------------------------------------------------------------------------------------------------

  Component {
    id: fadeInComponentSmall
    Traktor.Polygon {
      anchors.top:         cueLoader.top
      anchors.right:       cueLoader.right 
      anchors.topMargin:   hotcue.smallCueTopMargin
      anchors.rightMargin: -1 * screenScale
      antialiasing:        useAntialiasing

      color:               hotcue.currentColor   
      border.width:        borderWidth
      border.color:        hotcue.colorBorder
      points: [ Qt.point(-0.4 * screenScale, 11 * screenScale)
              , Qt.point(5 * screenScale , 0)
              , Qt.point(17 * screenScale, 0) 
              , Qt.point(17 * screenScale, hotcue.smallCueHeight)
              , Qt.point(16 * screenScale, hotcue.smallCueHeight)
              , Qt.point(16 * screenScale, 11 * screenScale)
              ]

      Text {
        anchors.top:        parent.top
        anchors.left:       parent.left
        anchors.topMargin:  -1 * screenScale
        anchors.leftMargin: borderWidth + 6 * screenScale
        color:              hotcue.colorText 
        text:               hotcue.hotcueId; 

        font.pixelSize:     fonts.miniFontSizePlusPlus * screenScale
        font.family:        prefs.cueFontName
      }
    }
  }

  Component {
    id: fadeInComponentLarge
    Traktor.Polygon {
      anchors.top:         cueLoader.top
      anchors.left:        cueLoader.horizontalCenter
      anchors.topMargin:   -1 * screenScale
      anchors.leftMargin:  -23 * screenScale
      antialiasing:        useAntialiasing

      color:               hotcue.currentColor   
      border.width:        borderWidth
      border.color:        hotcue.colorBorder
      points: [ Qt.point(-0.4 * screenScale , 13 * screenScale)
              , Qt.point(6 * screenScale , 0)
              , Qt.point(20 * screenScale, 0) 
              , Qt.point(20 * screenScale, hotcue.largeCueHeight)
              , Qt.point(19 * screenScale, hotcue.largeCueHeight)
              , Qt.point(19 * screenScale, 13 * screenScale)
              ]

      Text {
        anchors.top:        parent.top
        anchors.left:       parent.left
        anchors.leftMargin: 9 * screenScale
        color:              hotcue.colorText
        text:               hotcue.hotcueId; 

        font.pixelSize:     fonts.miniFontSizePlusPlus * screenScale
        font.family:        prefs.cueFontName
      }
    }
  }

  // FADE OUT ----------------------------------------------------------------------------------------------------------

  Component {
    id: fadeOutComponentSmall
    Traktor.Polygon {
      anchors.top:        cueLoader.top
      anchors.left:       cueLoader.horizontalCenter 
      anchors.topMargin:  hotcue.smallCueTopMargin
      anchors.leftMargin: -2 * screenScale
      antialiasing:       useAntialiasing

      color:              hotcue.currentColor   
      border.width:       borderWidth
      border.color:       hotcue.colorBorder
      points: [ Qt.point(0, 0)
              , Qt.point(12 * screenScale, 0)
              , Qt.point(17 * screenScale, 11 * screenScale)
              , Qt.point(1 * screenScale, 11 * screenScale)
              , Qt.point(1 * screenScale, hotcue.smallCueHeight)
              , Qt.point(0, hotcue.smallCueHeight)
              ]
      Text { 
        anchors.top:        parent.top
        anchors.left:       parent.left
        anchors.leftMargin: 4.5 * screenScale
        anchors.topMargin:  -1 * screenScale
        color:              hotcue.colorText; 
        text:               hotcue.hotcueId; 

        font.pixelSize:     fonts.miniFontSizePlusPlus * screenScale
        font.family:        prefs.cueFontName
      }
    }
  }

  Component {
    id: fadeOutComponentLarge
    Traktor.Polygon {
      anchors.top:        cueLoader.top
      anchors.left:       cueLoader.horizontalCenter
      anchors.leftMargin: -3 * screenScale
      anchors.topMargin:  -1 * screenScale
      antialiasing:       useAntialiasing

      color:              hotcue.currentColor   
      border.width:       borderWidth
      border.color:       hotcue.colorBorder
      points: [ Qt.point(0, 0)
              , Qt.point(14 * screenScale, 0)
              , Qt.point(20 * screenScale, 13 * screenScale)
              , Qt.point(1 * screenScale, 13 * screenScale)
              , Qt.point(1 * screenScale, hotcue.largeCueHeight)
              , Qt.point(0, hotcue.largeCueHeight)
              ]
      Text { 
        anchors.top:        parent.top
        anchors.left:       parent.left
        anchors.leftMargin: 6 * screenScale
        color:              hotcue.colorText 
        text:               hotcue.hotcueId

        font.pixelSize:     fonts.miniFontSizePlusPlus * screenScale
        font.family:        prefs.cueFontName
      }
    }
  }

  // LOAD --------------------------------------------------------------------------------------------------------------
  Component {
    id: loadComponentSmall
    Item {
      anchors.top:               cueLoader.top
      anchors.topMargin:         hotcue.smallCueTopMargin
      anchors.horizontalCenter:  cueLoader.horizontalCenter
      clip: false // true

      // pole border
      Rectangle {
        anchors.top:              circle.bottom
        anchors.horizontalCenter: circle.horizontalCenter
        anchors.leftMargin:       4 * screenScale
        width:                    3 * screenScale
        height:                   18 * screenScale
        color:                    hotcue.colorBorder
      }
      
      // round head
      Rectangle {
        id: circle
        anchors.top:               parent.top
        anchors.horizontalCenter:  parent.horizontalCenter
        anchors.topMargin:         -1 * screenScale
        color:                     hotcue.currentColor
        width:                     15 * screenScale 
        height:                    width
        radius:                    0.5*width
        border.width:              1 * screenScale
        border.color:              hotcue.colorBorder

        Text {
          anchors.top:        parent.top
          anchors.left:       parent.left
          anchors.leftMargin: 4 * screenScale
          anchors.topMargin:  0
          color:              hotcue.colorText 
          text:               hotcue.hotcueId

          font.pixelSize:     fonts.miniFontSizePlusPlus * screenScale
          font.family:        prefs.cueFontName
        }
      }
            // pole
      Rectangle {
        anchors.top:              circle.bottom
        anchors.horizontalCenter: circle.horizontalCenter
        anchors.leftMargin:       5 * screenScale
        anchors.topMargin:        -1 * screenScale
        width:                    1 * screenScale
        height:                   18 * screenScale
        color:                    hotcue.currentColor
      }
    }
  }

  Component {
    id: loadComponentLarge
    Item {
      anchors.top:        cueLoader.top
      anchors.left:       cueLoader.horizontalCenter
      anchors.leftMargin: -21 * screenScale 
      anchors.topMargin:  -2 * screenScale
      height:             cueLoader.height
      clip: false // true

      // pole border
      Rectangle {
        anchors.top:              circle.bottom
        anchors.horizontalCenter: circle.horizontalCenter
        anchors.leftMargin:       4 * screenScale
        width:                    3 * screenScale
        height:                   hotcue.height - circle.height + 1 * screenScale
        color:                    hotcue.colorBorder
      }
      
      // round head
      Rectangle {
        id: circle
        anchors.top:              parent.top
        anchors.topMargin:        -1 * screenScale
        anchors.horizontalCenter: parent.horizontalCenter
        color:                    hotcue.currentColor
        width:                    19 * screenScale 
        height:                   width
        radius:                   0.5*width
        border.width:             borderWidth
        border.color:             hotcue.colorBorder

        Text {
          anchors.top:        parent.top
          anchors.left:       parent.left
          anchors.leftMargin: 6 * screenScale
          anchors.topMargin:  2 * screenScale
          color:              hotcue.colorText
          text:               hotcue.hotcueId

          font.pixelSize:     fonts.miniFontSizePlusPlus * screenScale
          font.family:        prefs.cueFontName
        }
      }

      // pole
      Rectangle {
        anchors.top:              circle.bottom
        anchors.horizontalCenter: circle.horizontalCenter
        anchors.topMargin:        -2 * screenScale
        anchors.leftMargin:       5 * screenScale
        width:                    1 * screenScale
        height:                   hotcue.height - circle.height + 2 * screenScale
        color:                    hotcue.currentColor
      }
    }
  }

  // LOOP --------------------------------------------------------------------------------------------------------------

  Component {
    id: loopComponentSmall

    Item {
      clip: false // true
      anchors.top:              cueLoader.top
      anchors.topMargin:        hotcue.smallCueTopMargin
      anchors.left:             cueLoader.left
      Traktor.Polygon {
        anchors.top:        parent.top
        anchors.left:       parent.horizontalCenter
        anchors.leftMargin: -15 * screenScale 
        antialiasing: true
        color:             hotcue.currentColor   
        border.width:       borderWidth
        border.color:       hotcue.colorBorder
        points: [ Qt.point(0 , 11 * screenScale)
                , Qt.point(0 , 0)
                , Qt.point(14 * screenScale, 0)
                , Qt.point(14 * screenScale, hotcue.smallCueHeight)
                , Qt.point(13 * screenScale, hotcue.smallCueHeight)
                , Qt.point(13 * screenScale, 11 * screenScale)
                ]

        Text { 
          anchors.top:        parent.top
          anchors.left:       parent.left
          anchors.leftMargin: 4 * screenScale
          anchors.topMargin: -1 * screenScale
          color:              hotcue.colorText
          text:               hotcue.hotcueId

          font.pixelSize:     fonts.miniFontSizePlusPlus * screenScale
          font.family:        prefs.cueFontName
        }
      }

      Traktor.Polygon {
        anchors.top:        parent.top
        anchors.left:       parent.horizontalCenter 
        anchors.leftMargin: hotcueLength -1 * screenScale
        // anchors.topMargin:  hotcue.topMargin
        antialiasing: useAntialiasing

        color:             hotcue.currentColor   
        border.width:       borderWidth
        border.color:       hotcue.colorBorder
        points: [ Qt.point(0, 0)
                , Qt.point(14 * screenScale, 0)
                , Qt.point(14 * screenScale, 11 * screenScale)
                , Qt.point(1 * screenScale, 11 * screenScale)
                , Qt.point(1 * screenScale, hotcue.smallCueHeight) 
                , Qt.point(0, hotcue.smallCueHeight)
                ]
      }
    }
  }

  Component {
    id: loopComponentLarge
    Item {
      anchors.top:          cueLoader.top
      anchors.left:         cueLoader.left
      anchors.topMargin:    -1 * screenScale
      anchors.leftMargin:   -1 * screenScale
      clip: false // true
      Traktor.Polygon {
        anchors.top:        parent.top
        anchors.left:       parent.horizontalCenter
        anchors.leftMargin: -17 * screenScale 
        antialiasing:       true
        color:              hotcue.currentColor   
        border.width:       borderWidth 
        border.color:       hotcue.colorBorder
  
        points: [ Qt.point(0 , 13 * screenScale)
                , Qt.point(0 , 0)
                , Qt.point(16 * screenScale, 0)
                , Qt.point(16 * screenScale, hotcue.largeCueHeight)
                , Qt.point(15 * screenScale, hotcue.largeCueHeight)
                , Qt.point(15 * screenScale, 13 * screenScale)
                ]

        Text { 
          anchors.top:        parent.top
          anchors.left:       parent.left
          anchors.leftMargin: 5 * screenScale
          color:              hotcue.colorText 
          text:               hotcue.hotcueId

          font.pixelSize:     fonts.miniFontSizePlusPlus * screenScale
          font.family:        prefs.cueFontName
        }
      }

      Traktor.Polygon {
        anchors.top:        parent.top
        anchors.left:       parent.horizontalCenter 
        anchors.leftMargin: hotcueLength -1 * screenScale
        antialiasing:       useAntialiasing

        color:              hotcue.currentColor   
        border.width:       borderWidth
        border.color:       hotcue.colorBorder
        points: [ Qt.point(0, 0)
                , Qt.point(16 * screenScale, 0)
                , Qt.point(16 * screenScale, 13 * screenScale)
                , Qt.point(1 * screenScale, 13 * screenScale)
                , Qt.point(1 * screenScale, hotcue.largeCueHeight)
                , Qt.point(0, hotcue.largeCueHeight)
                ]
      }
    }
  }

  //-------------------------------------------------------------------------------------------------------------------- 

  state: hotcueState
  states: [
    State {
      name: "off";
      PropertyChanges { target: hotcue;      visible:         false   }
    },
    State {
      name: "grid";
      PropertyChanges { target: cueLoader;   sourceComponent: smallHead ? gridComponentSmall : gridComponentLarge }
      PropertyChanges { target: hotcue;      visible:         true   }
    },
    State {
      name: "hotcue";
      PropertyChanges { target: cueLoader;   sourceComponent: smallHead ? hotcueComponentSmall : hotcueComponentLarge  }
      PropertyChanges { target: hotcue;      visible:         true   }
    },
    State {
      name: "fadeIn";
      PropertyChanges { target: cueLoader;   sourceComponent: smallHead ? fadeInComponentSmall : fadeInComponentLarge }
      PropertyChanges { target: hotcue;      visible:         true   }
    },
    State {
      name: "fadeOut";
      PropertyChanges { target: cueLoader;   sourceComponent: smallHead ? fadeOutComponentSmall  : fadeOutComponentLarge }
      PropertyChanges { target: hotcue;      visible:         true   }
    },
    State {
      name: "load";
      PropertyChanges { target: cueLoader;   sourceComponent: smallHead ? loadComponentSmall : loadComponentLarge }
      PropertyChanges { target: hotcue;      visible:         true   }
    },
    State {
       name: "loop";
      PropertyChanges { target: cueLoader;   sourceComponent: smallHead ? loopComponentSmall  : loopComponentLarge }
      PropertyChanges { target: hotcue;      visible:         true   }
    } 
  ]       
}
