import CSI 1.0
import QtQuick
import QtQml
import Traktor.Gui 1.0 as Traktor

import './../' as Templates
import './../../Views/Browser' as BrowserView
import './../../Views/Widgets' as Widgets

 

//----------------------------------------------------------------------------------------------------------------------
//                                            BROWSER VIEW
//
// Vista principal del navegador de Traktor que permite explorar y cargar pistas.
//
// Características principales:
//  - Conectado al QBrowser de Traktor para recibir el modelo de datos
//  - Navegación fluida por la biblioteca
//  - Soporte para ordenamiento personalizado
//  - Indicadores visuales de compatibilidad de key/BPM
//  - Modo de desplazamiento rápido
//
// Propiedades principales:
//  - isActive: Estado de activación del browser
//  - pageSize: Número de items visibles (7 o 9 según preferencias)
//  - focusColor: Color de resaltado según deck seleccionado
//  - sortingId/Direction: Control de ordenamiento
//
// Componentes principales:
//  1. ListView (contentList):
//     - Muestra la lista de elementos navegables
//     - Soporta scroll suave y selección
//     - Delegates personalizados por tipo de item
//
//  2. BrowserHeader:
//     - Muestra ruta de navegación actual
//     - Indicador de deck seleccionado
//     - Iconos de estado
//
//  3. BrowserFooter:
//     - Controles de ordenamiento
//     - Información adicional
//     - Estado de filtros
//
//  4. ScrollBar:
//     - Indicador visual de posición
//     - Animaciones suaves
//     - Color según deck activo
//
// Funcionalidades:
//  - Navegación por nodos (enterNode/exitNode)
//  - Scroll rápido con centrado automático
//  - Animaciones fluidas de UI
//  - Obtención de key del deck master
//  - Soporte para debug
//
// Comportamiento:
//  - Muestra/oculta scrollbar automáticamente
//  - Adapta layout según preferencias
//  - Mantiene selección visible
//  - Soporta modo zebra para listas cortas
//----------------------------------------------------------------------------------------------------------------------

Templates.View {
  id: qmlBrowser

  property string propertiesPath: ""
  property bool  isActive:      false
  property bool  enterNode:     false
  property bool  exitNode:      false
  property int   increment:     0
  property color focusColor:    (screen.focusDeckId < 2) ? colors.colorDeckBright : "white" 
  property int   speed:         150
  property real  sortingKnobValue:  0
  property int   pageSize:          prefs.displayMoreItems ? 9 : 7
  property int   fastScrollCenter:  3

  readonly property int  maxItemsOnScreen: prefs.displayMoreItems ? 9 : 7

  // This is used by the footer to change/display the sorting!
  property alias sortingId:         browser.sorting
  property alias sortingDirection:  browser.sortingDirection
  property alias isContentList:     browser.isContentList

  anchors.fill: parent

  // Mapping property
  //MappingProperty { id: browserViewMode; path: "mapping.state.browser_view_mode" }

  // App properties
  AppProperty { id: deckAKeyDisplay; path: "app.traktor.decks.1.track.key.resulting.quantized" }
  AppProperty { id: deckBKeyDisplay; path: "app.traktor.decks.2.track.key.resulting.quantized" }
  AppProperty { id: deckCKeyDisplay; path: "app.traktor.decks.3.track.key.resulting.quantized" }
  AppProperty { id: deckDKeyDisplay; path: "app.traktor.decks.4.track.key.resulting.quantized" }
  AppProperty { id: masterDeckId; path: "app.traktor.masterclock.source_id" }

  //--------------------------------------------------------------------------------------------------------------------
  // On increment changed
  onIncrementChanged: {
    if (qmlBrowser.increment != 0) {
      var newValue = clamp(browser.currentIndex + qmlBrowser.increment, 0, contentList.count - 1);
  
      // center selection if user is _fast scrolling_ but we're at the _beginning_ or _end_ of the list
      if(qmlBrowser.increment >= pageSize) {
        var centerTop = fastScrollCenter;

        if(browser.currentIndex < centerTop) {          
          newValue = centerTop;
        }
      }
      if(qmlBrowser.increment <= (-pageSize)) {
        var centerBottom = contentList.count - 1 - fastScrollCenter;

        if(browser.currentIndex > centerBottom) {          
          newValue = centerBottom;
        }
      }
      
      browser.changeCurrentIndex(newValue);
      qmlBrowser.increment = 0;
      doScrolling();
    }      
  }

  //--------------------------------------------------------------------------------------------------------------------
  // On exit node
  onExitNodeChanged: {
    if (qmlBrowser.exitNode) {
      browser.exitNode()
    }
    
    //showHeaderFooterAnimated(false); // see comment at function declaration
    qmlBrowser.exitNode = false;
  }

  //--------------------------------------------------------------------------------------------------------------------
  // On enter node
  onEnterNodeChanged: {
    if (qmlBrowser.enterNode) {
      var movedDown = browser.enterNode(screen.focusDeckId, contentList.currentIndex);
      if (movedDown) { 
        browser.relocateCurrentIndex()
      }
    }
    //showHeaderFooterAnimated(false); // see comment at function declaration
    qmlBrowser.enterNode = false;
  }

  // Clamps a value between a minimum and a maximum
  function clamp(val, min, max){
    return Math.max(min, Math.min(val, max));
  }

  //--------------------------------------------------------------------------------------------------------------------
  // Behavior on scrolling
  //
  // On Scrolling, show scrolling-bar and hide header/footer. After some seconds, go back to initial state.
  //--------------------------------------------------------------------------------------------------------------------

  // Do scrolling
  function doScrolling() { 
    scrollbar.opacity = 1; 
    //hideHeaderFooterAnimated(true); // see comment at function declaration
    opacityTimer.restart(); 
  }

  //--------------------------------------------------------------------------------------------------------------------

  Timer {
    id: opacityTimer
    interval: 800  // duration of the scrollbar opacity
    repeat:   false
  
    onTriggered: { 
      scrollbar.opacity = 0; 
      //showHeaderFooterAnimated(true); // see comment at function declaration
    }
  }


  //--------------------------------------------------------------------------------------------------------------------
  // VIEWS / ITEMS
  //--------------------------------------------------------------------------------------------------------------------

  // Browser
  Traktor.Browser {
    id: browser;
    isActive: qmlBrowser.isActive
  }
 
  //--------------------------------------------------------------------------------------------------------------------
  //  LIST VIEW -- NEEDS A MODEL CONTAINING THE LIST OF ITEMS TO SHOW AND A DELEGATE TO DEFINE HOW ONE ITEM LOOKS LIKE
  //-------------------------------------------------------------------------------------------------------------------

  // zebra filling up the rest of the list if smaller than maxItemsOnScreen (= 8 entries)
  Grid {
    anchors.top:            contentList.top
    //anchors.topMargin:      contentList.topMargin + contentList.contentHeight + 1 // +1 = for spacing
    anchors.right:          parent.right
    anchors.left:           parent.left
    //anchors.leftMargin:     3
    columns:                1
    spacing:                1  

    Repeater {
      model: (contentList.count < qmlBrowser.maxItemsOnScreen) ? (qmlBrowser.maxItemsOnScreen - contentList.count) : 0
      Rectangle { 
        color: ((contentList.count + index) % 2 == 0) ? colors.colorGrey08 : "transparent"
        width: qmlBrowser.width; 
        //height: prefs.displayMoreItems ? 25 : 32
      }
    }
  }

  //--------------------------------------------------------------------------------------------------------------------
  // Content list
  ListView {
    id: contentList
    anchors.top:              browserHeader.bottom
    anchors.left:             parent.left
    anchors.right:            parent.right
    verticalLayoutDirection: ListView.TopToBottom
    // the top/bottom margins are applied only at the beginning/end of the list in order to show half entries while scrolling 
    // and keep the list delegates in the same position always.

    // the commented out margins caused browser anchor problems leading to a disappearing browser! check later !?
    anchors.topMargin:        3 // ( (contentList.count <  qmlBrowser.maxItemsOnScreen ) || (currentIndex < 4                     )) ? 17 : 0
    height:                   (qmlBrowser.pageSize * (prefs.displayMoreItems ? 26 : 33)) - 1 // adjust for spacing
    clip:                     true
    spacing:                  1
    preferredHighlightBegin:  parseInt((height / 2) - (prefs.displayMoreItems ? 12.5 : 16)) 
    preferredHighlightEnd:    preferredHighlightBegin + (prefs.displayMoreItems ? 25 : 32)
    highlightRangeMode:       ListView.ApplyRange
    highlightMoveDuration:    0
    delegate:                 BrowserView.ListDelegate  {id: listDelegate; screenFocus: screen.focusDeckId; }
    model:                    browser.dataSet
    currentIndex:             browser.currentIndex 
    focus:                    true 
    cacheBuffer:              0
  }

  //--------------------------------------------------------------------------------------------------------------------
  // Scrollbar
  Widgets.ScrollBar {
    id: scrollbar
    flickable:    contentList
    opacity:      0
    handleColor:  parent.focusColor
    Behavior on opacity { NumberAnimation { duration: (opacity == 0) ? 0 : speed; } }
  }


  //--------------------------------------------------------------------------------------------------------------------
  // Browser header
  BrowserView.BrowserHeader {
    id: browserHeader
    nodeIconId:     browser.iconId
    currentDeck:    screen.focusDeckId
    state:          "show"
    pathStrings:    browser.currentPath 

    Behavior on height { NumberAnimation { duration: speed; } }
  }

  //--------------------------------------------------------------------------------------------------------------------
  // Browser footer
  BrowserView.BrowserFooter {
    id: browserFooter
    state:        "show"
    propertiesPath: qmlBrowser.propertiesPath
    sortingKnobValue: qmlBrowser.sortingKnobValue

    Behavior on height { NumberAnimation { duration: speed; } }
  }


  //--------------------------------------------------------------------------------------------------------------------
  // NOTE: Supress show/hide for now, but KEEP this code. 
  //       The "come back" is planned for a later release!
  //--------------------------------------------------------------------------------------------------------------------
  // Shows the header and footer
  function showHeaderFooterAnimated(animated) {
    var defaultSpeed = qmlBrowser.speed;
    qmlBrowser.speed = (animated) ? qmlBrowser.speed : 0
    browserHeader.state = "show"
    browserFooter.state = "show"
    qmlBrowser.speed = defaultSpeed;
  }

  //--------------------------------------------------------------------------------------------------------------------

  // Hides the header and footer
  function hideHeaderFooterAnimated(animated) {
    var defaultSpeed = qmlBrowser.speed;
    qmlBrowser.speed = (animated) ? qmlBrowser.speed : 0
    browserHeader.state = "hide"
    browserFooter.state = "hide"
    qmlBrowser.speed = defaultSpeed;
  }

  // Obtains the master key from the master deck
  function getMasterKey() {
    switch (masterDeckId.value) {
      case 0: return deckAKeyDisplay.value;
      case 1: return deckBKeyDisplay.value;
      case 2: return deckCKeyDisplay.value;
      case 3: return deckDKeyDisplay.value;
    }

    return "";
  }
}

