import CSI 1.0
import QtQuick

import '../' as Templates
import '../../Views/Deck' as View

//--------------------------------------------------------------------------------------------------------------------
// DECK VIEW contains two decks. An Upper Deck and a Lower Deck. For each deck a Header is attached containing 
// meta data information for the decks.
//
// The DECK VIEW fills the entire screen with exception of the footer (Bottom Controls) .
// --> a bottom margin with size of the footer is defined
//
// In this file we define how big the upper/lower deck appear on the screen depending on the current deck view mode.
// The different modes are: single deck A/B - dual deck A+C/B+D with different focuses (top or bottom)
// The type of each deck (e.g. TrackDeck, RemixDeck, LiveDeck, ... ) is defined in Deck.qml!
//
// Vista principal que contiene dos decks (superior e inferior).
// Maneja las transiciones y estados entre diferentes configuraciones de visualización.
//
// Modos disponibles:
// - Deck único A/B (vista completa)
// - Deck dual A+C/B+D (con foco superior o inferior)
//--------------------------------------------------------------------------------------------------------------------

Item {
  id: view

  property real screenScale: prefs.screenScale

  // Propiedades principales
  property variant deckIds:  [0,2]
  property int focusDeckId:  isUpperDeck ? deckIds[0] : deckIds[1] 
  property string settingsPath: ""
  property string propertiesPath: ""

  // Propiedades de desplazamiento para Remix Deck
  property int remixUpperDeckRowShift: 1  
  property int remixLowerDeckRowShift: 1

  // Estados y propiedades de foco
  property string focusState:   "TOP"
  property bool   isUpperDeck: focusState == "TOP" || focusState == "TOPbottom"

  // Aliases para estados de deck
  property alias  upperDeckState: upperDeck.deckContentState
  property alias  lowerDeckState: lowerDeck.deckContentState
  property string focusDeckState: isUpperDeck ? upperDeckState : lowerDeckState

  property alias upperDeckId: upperDeck.deckId
  property alias lowerDeckId: lowerDeck.deckId

  // Propiedades para manejo de advertencias
  property bool switchBackToSingleDeckViewAfterWarning: false;
  property bool deckFocusBeforeDeckViewWarningSwitch:   false;

  readonly property bool isDawDeckStyleFocus: focusDeckState == "Stem Deck" && (isUpperDeck && upperDeckStemStyle.value) || (!isUpperDeck && lowerDeckStemStyle.value)

  //--------------------------------------------------------------------------------------------------------------------
  // Properties defined by the designers
  readonly property int smallDeckHeight: 70 * screenScale  // Escalar altura
  readonly property int mediumDeckHeight: view.height - smallDeckHeight  
  readonly property int largeDeckHeight: view.height
  readonly property int speed: durations.deckTransition

  // Margenes del contenedor
  anchors.margins: 0

  // Propiedades de mapeo y aplicación
  MappingProperty { id: deckIsSingleProp;   path: propertiesPath + ".deck_single"; onValueChanged: { updateFocusStateId(); } }
  MappingProperty { id: deckFocusStateProp; path: propertiesPath + ".deck_focus";  onValueChanged: { updateFocusStateId(); } }

  AppProperty { id: upperDeckHeaderWarningActive; path: "app.traktor.informer.deckheader_message." + (deckIds[0]+1) + ".active"; onValueChanged: { onDeckHeaderWarningActive( deckIds[0], upperDeckHeaderWarningActive.value ); } } 
  AppProperty { id: lowerDeckHeaderWarningActive; path: "app.traktor.informer.deckheader_message." + (deckIds[1]+1) + ".active"; onValueChanged: { onDeckHeaderWarningActive( deckIds[1], lowerDeckHeaderWarningActive.value ); } } 

  function updateFocusStateId() {
    if ( !deckFocusStateProp.value ) {
      focusState = (deckIsSingleProp.value) ? "TOP" : "TOPbottom";
      screen.focusDeckContentState = upperDeck.deckContentState;
    }
    else {
      focusState = (deckIsSingleProp.value) ? "BOTTOM" : "topBOTTOM";
      screen.focusDeckContentState = lowerDeck.deckContentState;
    }
    if ( switchBackToSingleDeckViewAfterWarning & deckIsSingleProp.value ){
      switchBackToSingleDeckViewAfterWarning = false; // if somebody manually switches the deck during warnings we won't auto switch back
    }
  }

  //--------------------------------------------------------------------------------------------------------------------
  // Switching to split deck view if a warning occurs on an "invisible" deck / TP-8019
  function onDeckHeaderWarningActive( deckId, warningActive ) {
    if ( warningActive ) {
      var isVisible = !deckIsSingleProp.value | (focusDeckId == deckId);
      if ( !isVisible ){
        switchBackToSingleDeckViewAfterWarning = true;
        deckFocusBeforeDeckViewWarningSwitch   = deckFocusStateProp.value;
        deckIsSingleProp.value = false;
      }
    }
    else if ( switchBackToSingleDeckViewAfterWarning ){
      switchBackToSingleDeckViewAfterWarning = false;
      if ( deckFocusBeforeDeckViewWarningSwitch == deckFocusStateProp.value ) { // if somebody manually switches the deck focus during warnings we won't auto switch back
        deckIsSingleProp.value = true;
      }
    }
  }

  // DEBUG: Display deck info
  Rectangle {
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.right: parent.right
    height: 280
    color: "red"
    visible: false
    Text {
      anchors.centerIn: parent
      text: "focusDeckId: " + focusDeckId + "\n" +
            "deckIds: [" + deckIds[0] + "," + deckIds[1] + "]\n" +
            "isUpperDeck: " + isUpperDeck + "\n" +
            "focusState: " + focusState + "\n" +
            "upperZoom: " + upperDeckZoomLevel.value + "\n" +
            "lowerZoom: " + lowerDeckZoomLevel.value + "\n" +
            "deckFocusStateProp: " + deckFocusStateProp.value + "\n" +
            "settingsPath: " + settingsPath + "\n" +
            "upperZoomPath: " + upperDeckZoomLevel.path + "\n" +
            "lowerZoomPath: " + lowerDeckZoomLevel.path + "\n" +
            "propertiesPath: " + propertiesPath
      color: "white"
    }
    z: 1000
  }

  MappingProperty { id: propEditEnabled;   path: propertiesPath + ".edit_mode" }

  // UPPER DECK (A OR B) ---------------------------------------------------------------------------------------------
  MappingProperty { id: upperDeckZoomLevel;     path: settingsPath   + ".top.waveform_zoom" }
  MappingProperty { id: upperDeckShowLoopSize;  path: propertiesPath + ".top.show_loop_size"  }
  MappingProperty { id: upperDeckStemStyle;     path: propertiesPath + ".top.stem_deck_style" }

  Deck {
    id: upperDeck
    deckId:             deckIds[0]
    clip: false // true
    height:             smallDeckHeight
    y:                  0 // do not use anchors.top! We wanna animate y
    visible:            (height != 0)
    anchors.left:       parent.left
    anchors.right:      parent.right
    remixDeckRowShift:  remixUpperDeckRowShift

    zoomLevel: upperDeckZoomLevel.value
    showLoopSize: upperDeckShowLoopSize.value
    isInEditMode: propEditEnabled.value
    stemStyle: upperDeckStemStyle.value
    propertiesPath: view.propertiesPath

    onDeckContentStateChanged: {
      if ( isUpperDeck ) {
        screen.focusDeckContentState = upperDeck.deckContentState;
      }
    }
  }
  
  // LOWER DECK (C OR D) ---------------------------------------------------------------------------------------------
  MappingProperty { id: lowerDeckZoomLevel;     path: settingsPath   + ".bottom.waveform_zoom" }
  MappingProperty { id: lowerDeckShowLoopSize;  path: propertiesPath + ".bottom.show_loop_size"  }
  MappingProperty { id: lowerDeckStemStyle;     path: propertiesPath + ".bottom.stem_deck_style" }


  Deck {
    id: lowerDeck
    deckId:             deckIds[1]
    clip: false // true
    visible:            (height != 0)
    anchors.top:        upperDeck.bottom
    anchors.left:       parent.left
    anchors.right:      parent.right
    remixDeckRowShift:  remixLowerDeckRowShift

    zoomLevel: lowerDeckZoomLevel.value
    showLoopSize: lowerDeckShowLoopSize.value
    isInEditMode: propEditEnabled.value
    stemStyle: lowerDeckStemStyle.value
    propertiesPath: view.propertiesPath

    onDeckContentStateChanged: {
      if ( ! isUpperDeck ) {
        screen.focusDeckContentState = lowerDeck.deckContentState;
      }
    }
  }


  //--------------------------------------------------------------------------------------------------------------------
  // STATES (DECK SIZES)
  //--------------------------------------------------------------------------------------------------------------------
  
  // Estado actual del foco
  state: focusState

  // Definición de estados para diferentes configuraciones de visualización
  states: [ 
    State { 
      name: "TOP"; // Deck A or B single view     
      PropertyChanges { target: upperDeck; deckSize: "large";  height: largeDeckHeight; y: 0 } 
      PropertyChanges { target: lowerDeck; deckSize: "small";  height: 0; } 
    },
    State { 
      name: "TOPbottom"; // Deck A/C or B/D dual view (top focus)
      PropertyChanges { target: upperDeck; deckSize: "medium"; height: mediumDeckHeight; y: 0 }  
      PropertyChanges { target: lowerDeck; deckSize: "small";  height: smallDeckHeight;       } 
    },
    State { 
      name: "topBOTTOM"; // Deck A/C or B/D dual view (bottom focus) 
      PropertyChanges { target: upperDeck; deckSize: "small";  height: smallDeckHeight;  y: 0 } 
      PropertyChanges { target: lowerDeck; deckSize: "medium"; height: mediumDeckHeight;      } 
    },
    State { 
      name: "BOTTOM";  // Deck C or D single view  
      PropertyChanges { target: upperDeck; deckSize: "small";  height: 0;  y: 0     } 
      PropertyChanges { target: lowerDeck; deckSize: "large";  height: largeDeckHeight; } 
    }
  ]

  //--------------------------------------------------------------------------------------------------------------------
  // TRANSITIONS
  //--------------------------------------------------------------------------------------------------------------------
  transitions: [
    Transition { 
      from: "TOP";       to: "TOPbottom"; 
      SequentialAnimation {
        PropertyAction  { target: lowerDeck; property: "height"; value: smallDeckHeight} 
        NumberAnimation { target: upperDeck; property: "height"; duration: speed }  
      }
    },
    Transition { 
      from: "TOPbottom"; to: "TOP";       
      SequentialAnimation {
        NumberAnimation { target: upperDeck; property: "height"; duration: speed }  
        PropertyAction  { target: lowerDeck; property: "height"; value: 0} 
      }
    },
    Transition { 
      from: "TOPbottom"; to: "topBOTTOM"; 
      SequentialAnimation {
        PropertyAction  { target: upperDeck; property: "deckSize"; } 
        PropertyAction  { target: lowerDeck; property: "deckSize"; } 

        ParallelAnimation {
          NumberAnimation { target: upperDeck; property: "height"; duration: speed }  
          NumberAnimation { target: lowerDeck; property: "height"; duration: speed }  
        }
        PropertyAction  { target: upperDeck; property: "deckSize"; } 
      }
    },
    Transition { 
      from: "topBOTTOM"; to: "TOPbottom"; 
      SequentialAnimation {
        PropertyAction  { target: upperDeck; property: "deckSize"; } 
        PropertyAction  { target: lowerDeck; property: "deckSize"; } 
        ParallelAnimation {
          NumberAnimation { target: upperDeck; property: "height"; duration: speed }  
          NumberAnimation { target: lowerDeck; property: "height"; duration: speed }  
        }
        PropertyAction  { target: lowerDeck; property: "deckSize"; } 
      }
    },
    Transition { 
      from: "topBOTTOM"; to: "BOTTOM"; 
      SequentialAnimation {
        ParallelAnimation { 
          NumberAnimation { target: lowerDeck; property: "height";                 duration: speed }    
          NumberAnimation { target: upperDeck; property: "y"; to:-smallDeckHeight; duration: speed }  
        }
        PropertyAction  { target: upperDeck; property: "y";     } 
        PropertyAction  { target: upperDeck; property: "height" }
      }
    },
    Transition { 
      from: "BOTTOM";    to: "topBOTTOM"; 
      SequentialAnimation {
        PropertyAction  { target: upperDeck; property: "y"; value: -smallDeckHeight } 
        PropertyAction  { target: upperDeck; property: "height";                    } 
        ParallelAnimation { 
          NumberAnimation { target: lowerDeck; property: "height"; duration: speed }    
          NumberAnimation { target: upperDeck; property: "y";      duration: speed }  
        }
      }
    },
    Transition { 
      from: "BOTTOM";    to: "TOP";      
      SequentialAnimation { 
        PropertyAction  { target: upperDeck; property: "y"; value: -view.height } 
        PropertyAction  { target: upperDeck; property: "height"; value: view.height } 
        NumberAnimation { target: upperDeck; property: "y"; duration: speed }  
        PropertyAction  { target: lowerDeck; property: "height"; } 
        PropertyAction  { target: lowerDeck; property: "deckSize"; } 
      }
    },
    Transition { 
      from: "TOP";       to: "BOTTOM";    
      SequentialAnimation {
        PropertyAction  { target: lowerDeck; property: "height"; } 
        NumberAnimation { target: upperDeck; property: "y"; to:-view.height; duration: speed }   
        PropertyAction  { target: upperDeck; property: "height"; } 
        PropertyAction  { target: upperDeck; property: "y"; } 
        PropertyAction  { target: upperDeck; property: "deckSize"; } 
      }
    }
  ]

//--------------------------------------------------------------------------------------------------------------------  
// Funciones de zoom
//--------------------------------------------------------------------------------------------------------------------

  function zoomIn() {
    if (focusDeckId === deckIds[0]) {
      upperDeckZoomLevel.value = Math.min(upperDeckZoomLevel.value + 1, 100)
    } else if (focusDeckId === deckIds[1]) {
      lowerDeckZoomLevel.value = Math.min(lowerDeckZoomLevel.value + 1, 100)
    }
  }

  function zoomOut() {
    if (focusDeckId === deckIds[0]) {
      upperDeckZoomLevel.value = Math.max(upperDeckZoomLevel.value - 1, 0)
    } else if (focusDeckId === deckIds[1]) {
      lowerDeckZoomLevel.value = Math.max(lowerDeckZoomLevel.value - 1, 0)
    }
  }

//--------------------------------------------------------------------------------------------------------------------  
// Shortcuts para zoom
//--------------------------------------------------------------------------------------------------------------------

  Shortcut {
    sequence: "+"
    onActivated: zoomIn()
  }

  Shortcut {
    sequence: "-"
    onActivated: zoomOut()
  }
}
