import QtQuick
import Traktor.Gui 1.0 as Traktor

import '../Widgets' as Widgets

//------------------------------------------------------------------------------------------------------------------
//  BROWSER HEADER - Muestra la ruta de navegación actual del browser
//
//  Características principales:
//  - Visualiza la ruta de navegación actual con separadores
//  - Muestra el deck seleccionado (A/B/C/D)
//  - Implementa elipsis (...) cuando la ruta es muy larga
//  - Adapta colores según el deck activo
//
//  Propiedades principales:
//  - currentDeck: Índice del deck actual (0-3)
//  - nodeIconId: ID del icono de nodo actual
//  - itemColor: Color base de los elementos
//  - pathStrings: Ruta completa separada por " | "
//  - stringList: Array con elementos de la ruta
//  - maxTextWidth: Ancho máximo para cada elemento de texto
//
//  Elementos visuales:
//  - browserHeaderBg (Rectangle):
//    * Fondo del header
//    * Color según tema
//
//  - textContainer (Item):
//    * Contiene el flujo de texto de la ruta
//    * Gestiona espaciado con letra del deck
//
//  - dots (Item):
//    * Muestra "..." cuando la ruta no cabe completa
//    * Aparece/desaparece automáticamente
//
//  - textFlow (Flow):
//    * Organiza elementos de texto de derecha a izquierda
//    * Contiene separadores entre elementos
//
//  - deckLetter (Text):
//    * Muestra la letra del deck actual (A/B/C/D)
//    * Color según deck seleccionado
//
//  Estados:
//  - show: Muestra el header (height: 17)
//  - hide: Oculta el header (height: 0)
//
//  Funciones:
//  - updateStringList(): Calcula cuántos elementos de la ruta pueden mostrarse
//    * Considera el ancho máximo disponible
//    * Ajusta la visualización de elipsis
//------------------------------------------------------------------------------------------------------------------


// Encabezado del navegador
Item {
  id: header

  property int            currentDeck:    0
  property int            nodeIconId:     0
  
  readonly property color itemColor: colors.colorWhite19
  property int            highlightIndex: 0
  
  readonly property var   letters:        ["A", "B", "C", "D"]

  property string         pathStrings:    ""      // the complete path in one string given by QBrowser with separator " | "
  property var            stringList:    [""]     // list of separated path elements (calculated in "updateStringList")
  property int            stringListModelSize: 0  // nr of entries which can be displayed in the header ( calc in updateStringList)
  readonly property int   maxTextWidth:   150    // if a single text path block is bigger than this: ElideMiddle
  readonly property int   arrowContainerWidth: 18 // width of the graphical separator arrow. includes left / right spacing
  readonly property int   fontSize: fonts.miniFontSizePlusPlus

  clip:          true
  anchors.left:  parent.left
  anchors.right: parent.right
  anchors.top:   parent.top
  height:        18 // set in state

  onPathStringsChanged: { updateStringList(textLengthDummy) }
  
  //--------------------------------------------------------------------------------------------------------------------
  // NOTE: text item used within the 'updateStringList' function to determine how many of the stringList items can be fit 
  //       in the header!
  // IMPORTANT EXTRA NOTE: all texts in the header should have the same Capitalization and font size settings as the "dummy"
  //                       as the dummy is used to calculate the number of text blocks fitting into the header.
  //--------------------------------------------------------------------------------------------------------------------
  Text {
    id: textLengthDummy
    visible: false

    font.capitalization: Font.AllUppercase
    font.pixelSize: header.fontSize
    font.family: prefs.normalFontName
  }

  // caculates the number of entries to be displayed in the header 
  function updateStringList(dummy) {
    var sum   = 0
    var count = 0

    stringList = pathStrings.split(" | ")

    for (var i = 0; i < stringList.length; ++i) {
      dummy.text = header.stringList[stringList.length - i - 1]

      sum += (dummy.width) > maxTextWidth ? header.maxTextWidth : dummy.width
      sum += arrowContainerWidth

      if (sum > (textContainter.width - header.arrowContainerWidth)) { 
        header.stringListModelSize = count
        return
      }
      count++
    }
    header.stringListModelSize = stringList.length;
  }

  //--------------------------------------------------------------------------------------------------------------------
  // Color de fondo
  Rectangle {
    id: browserHeaderBg
    anchors.left:  parent.left
    anchors.right: parent.right
    anchors.top:   parent.top
    height:        18
    color:         colors.colorBrowserHeader //colors.colorGrey24
  }

  //--------------------------------------------------------------------------------------------------------------------
  // Contenedor de texto
  Item {
   id: textContainter
    readonly property int spaceToDeckLetter: 20
    anchors.top:         parent.top
    anchors.bottom:      parent.bottom
    anchors.left:        parent.left
    anchors.right:       deckLetter.left
    anchors.leftMargin:   3
    anchors.rightMargin: spaceToDeckLetter
    clip:                true

    // Los puntos aparecen en el lado izquierdo del navegador en caso de que el camino completo no se ajuste al encabezado.
    Item {
      id: dots
      anchors.left:       parent.left
      anchors.top:        parent.top
      anchors.leftMargin: (stringListModelSize < stringList.length) ? 0 : -width
      visible:            (stringListModelSize < stringList.length)
      width:              30

      Text {
        anchors.left:        parent.left
        anchors.top:         parent.top
        text:                "..."

        font.capitalization: Font.AllUppercase
        font.pixelSize:      header.fontSize
        font.family:         prefs.normalFontName

        color:               colors.colorFontBrowserHeader
      } 
    }

    // Flujo de texto
    Flow {
      id: textFlow
      layoutDirection: Qt.RightToLeft 

      anchors.top:    parent.top
      anchors.bottom: parent.bottom
      anchors.left:   dots.right

      Repeater {
        model: stringListModelSize
        Item {
          id: textContainer
          property string displayTxt: (stringList[stringList.length - index - 1] == undefined) ? "" : stringList[stringList.length - index - 1]
          
          width: headerPath.width + arrowContainerWidth
          height: 20

          // arrows
          // the graphical separator between texts anchors on the left side of each text block. The space of "arrowContainerWidth" is reserved for that
          Widgets.TextSeparatorArrow {
            color:               colors.colorGrey80
            visible:             true
            anchors.top:         parent.top
            anchors.right:       headerPath.left
            anchors.topMargin:   4
            anchors.rightMargin: 6 // left margin is set via "arrowContainerWidth"
          }

          Text {
            id: dummy
            // NOTE: dummyTextPath is only used to get the displayWidth of the strings. (otherwise dynamic text sizes are hard/impossible)
            text:                displayTxt
            visible:             false 

            font.capitalization: Font.AllUppercase
            font.pixelSize:      header.fontSize
            font.family:         prefs.normalFontName
          }

          Text {
            id: headerPath
            // dummy.width is determined by the string contained in it and ceil to whole pixels (ceil instead of round to avoid unwanted elides)
            width:               (dummy.width > maxTextWidth) ? maxTextWidth : Math.ceil(dummy.width)
            elide:               Text.ElideMiddle
            text:                displayTxt
            visible:             true

            color:               (index == 0) ?  ((header.currentDeck < 2) ? colors.colorDeckBright : colors.colorFontWhite)  : colors.colorGrey88
            
            font.capitalization: Font.AllUppercase
            font.pixelSize:      header.fontSize
            font.family:         prefs.normalFontName
          }
        }
      } 
    }
  }

  //--------------------------------------------------------------------------------------------------------------------
  // Letra del deck
  Text {
    id: deckLetter
    anchors.right: parent.right
    anchors.top:   parent.top
    height:        parent.height
    width:         parent.height

    text:                header.letters[header.currentDeck]

    font.capitalization: Font.AllUppercase
    font.pixelSize:      header.fontSize
    font.family:         prefs.normalFontName

    color:               (header.currentDeck < 2) ? colors.colorDeckBright : colors.colorFontWhite
  }

  //--------------------------------------------------------------------------------------------------------------------
  // Borde y sombra negros
  Rectangle {
    id: browserHeaderBlackBottomLine
    anchors.left:  parent.left
    anchors.right: parent.right
    anchors.top:   browserHeaderBg.bottom 
    height:        2
    color:         colors.colorBlack
  }

   Rectangle {    
    id: browserHeaderBottomGradient
    anchors.left:  parent.left
    anchors.right: parent.right
    anchors.top:   browserHeaderBlackBottomLine.bottom 
    height:  3
    gradient: Gradient {
      GradientStop { position: 0.0; color: colors.colorBlack38 }
      GradientStop { position: 1.0; color: colors.colorBlack0 }
    }
  }

  //--- -----------------------------------------------------------------------------------------------------------------
  // Estados
  state: "show"  
  states: [
    State {
      name: "show"
      PropertyChanges{target: header; height: 17}
    },
    State {
      name: "hide"
      PropertyChanges{target: header; height: 0}
    }
  ]
}
