import QtQuick
import CSI 1.0

import '../Widgets' as Widgets


//----------------------------------------------------------------------------------------------------------------------
//  FOOTER
//----------------------------------------------------------------------------------------------------------------------

Rectangle {
  id: bottomInfoPanel
  
  property real screenScale: prefs.screenScale

  property int    midiId:                0
  property int    deckId:                0   // deckId of the deck for which the footer content is displayed
  property int    focusDeckId:           0   // deckId of the deck currently focused on screen 
  property int    fxUnit:                0
  property string propertiesPath:        ""
  property bool   isRemixDeck:           false
  property bool   isStemDeck:            false
  property bool   hasDeckControls:       isRemixDeck || isStemDeck
  property bool   isInEditMode:          false
  property string contentState:          ""
  property string sizeState:             "small"
  property string previousSizeState:     "small"  // Para recordar el estado anterior

  property color  levelColor:            contentState == "FX" ? colors.colorFxSlider : ( isUpperDeck && contentState != "MIDI" ? colors.colorDeckBright : colors.colorGrey72  )
  property color  headlineColor:         contentState == "FX" ? colors.colorFxSlider : ( isUpperDeck && contentState != "MIDI" ? colors.colorDeckBright : colors.colorGrey232 )
  color:          (isUpperDeck && contentState != "FX" && contentState != "MIDI") ?  colors.footerBackgroundBlue : colors.colorBgEmpty

  readonly property bool    isUpperDeck:      deckId < 2

  readonly property int     smallStateHeight: (showPerformanceFooter || isInEditMode || isStemDeck) ? (27 * screenScale) : 0  // Escalar altura
  readonly property int     bigStateHeight  : 81 * screenScale  // Escalar altura

  readonly property bool    showPerformanceFooter: (screen.flavor != ScreenFlavor.S5)
  readonly property bool    hasContent: fxUnitsEnabled.value || hasDeckControls || useMIDIControls.value

  visible:        (showPerformanceFooter || isInEditMode || isStemDeck)

  anchors.left:   parent.left
  anchors.right:  parent.right
  anchors.bottom: parent.bottom
  height:         smallStateHeight  
  anchors.horizontalCenter: parent.horizontalCenter
  width: Math.min(parent.width, 480 * screenScale)

  //--------------------------------------------------------------------------------------------------------------------

  AppProperty { id: fxUnitsEnabled; path : "app.traktor.fx.4fx_units" }
  MappingProperty { id: useMIDIControls; path: "mapping.settings.use_midi_controls" }

  // Temporizador para volver al tamaño anterior después de un tiempo
  Timer {
    id: resizeTimer
    interval: 2000  // 2 segundos
    running: false
    repeat: false
    onTriggered: {
      sizeState = previousSizeState
    }
  }

  // Función para mostrar temporalmente el panel en tamaño grande
  function showLarge() {
    if (sizeState != "large") {
      previousSizeState = sizeState
      sizeState = "large"
    }
    resizeTimer.restart()
  }

  //--------------------------------------------------------------------------------------------------------------------

  Behavior on height { NumberAnimation { duration: durations.overlayTransition } }

  function getColumnIndex(state, columnIdx) {
    if (state == "SLOT 1")
      return 0;
    if (state == "SLOT 2")
      return 1;
    if (state == "SLOT 3")
      return 2;
    if (state == "SLOT 4")
      return 3;

    return columnIdx;
  }

  function getColumnState(state, columnIdx) {
    if (state == "SLOT 1" || state == "SLOT 2" || state == "SLOT 3" || state == "SLOT 4") {
      switch (columnIdx) {
        case 0:
          return "SAMPLE";
        case 1:
          return "FILTER";
        case 2:
          return "PITCH";
        case 3:
          return "FX SEND";
      }
    }

    return state;
  }
  
  // Row containing the progress bars + info texts
  Row { 
    id: bottomPanelRow
    property double sliderHeight: 12 * screenScale  // Escalar altura del slider

    Behavior on sliderHeight { NumberAnimation { duration: durations.overlayTransition } }

    anchors.fill: parent
    anchors.leftMargin: 1 * screenScale  // Escalar margen
    visible: !isInEditMode

    Repeater {
      model: 4
      BottomInfoDetails { 
        id: bottomInfoDetails
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        width: (parent.width - (parent.anchors.leftMargin * 2)) / 4  // Distribuir el espacio equitativamente
        fxUnitPath: "app.traktor.fx." + (fxUnit + 1)
        midiId: bottomInfoPanel.midiId + (index + 1)
        markActive: stemSelected
        onParameterValueChanged: bottomInfoPanel.showLarge()
        onActiveValueChanged: bottomInfoPanel.showLarge()

        column:         getColumnIndex(bottomInfoPanel.contentState, index)
        levelColor:     bottomInfoPanel.levelColor
        bgColor:        (index==0 && contentState == "FX" && sizeState == "large") ? colors.colorFxHeaderLightBg : colors.colorFxHeaderBg

        sliderHeight:   bottomPanelRow.sliderHeight
        showSampleName: !(bottomInfoPanel.contentState == "SLOT 1" || bottomInfoPanel.contentState == "SLOT 2" ||
                          bottomInfoPanel.contentState == "SLOT 3" || bottomInfoPanel.contentState == "SLOT 4")
        state:          getColumnState(bottomInfoPanel.contentState, index)
        
        // If in stem deck on an S5, check if the current stem is selected (usually via the pads)
        MappingProperty { id: stemSelectorMode; path: propertiesPath + ".stem_selector_mode." + (index + 1) }
        property bool stemSelected: bottomInfoPanel.isStemDeck ? ( stemSelectorMode.value === undefined ? false : stemSelectorMode.value ) : false
      }
    }
  }
  
  // headline showing the current mode of the bottom controls. 
  Text { 
    id: headline
    text:                     contentState
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.top:              parent.top
    anchors.topMargin:        2 * screenScale  // Escalar margen
    visible:                  bottomInfoPanel.hasContent
    opacity:                  bottomInfoPanel.hasContent ? 1.0 : 0.0
    color:                    bottomInfoPanel.headlineColor

    font.pixelSize:           fonts.miniFontSizePlus * screenScale  
    font.family:              prefs.normalFontName
  }

  // Arrows
  Widgets.Triangle {
    id : leftArrow
    anchors.left:       parent.left
    anchors.top:        parent.top
    anchors.leftMargin: 3 * screenScale  // Escalar márgenes
    anchors.topMargin:  7 * screenScale
    width:              9 * screenScale  // Escalar dimensiones
    height:             5 * screenScale
    opacity:            1 
    color:              colors.colorGrey40
    rotation:           90
    visible:            hasDeckControls && !isInEditMode && (sizeState == "large")
    antialiasing:       false
    Behavior on opacity { NumberAnimation { duration: 30 } }
  }

  Widgets.Triangle {
    id : rightArrow
    anchors.right:       parent.right
    anchors.top:         parent.top
    anchors.rightMargin: 3 * screenScale  // Escalar márgenes
    anchors.topMargin:   7 * screenScale
    width:               9 * screenScale  // Escalar dimensiones
    height:              5 * screenScale
    opacity:             1 
    color:               colors.colorGrey40
    rotation:            -90
    visible:             hasDeckControls && !isInEditMode && (sizeState == "large")
    antialiasing:        false
    Behavior on opacity { NumberAnimation { duration: 30 } }
  }

  function showLine() {
    if (bottomInfoPanel.contentState == "FX") return false
    if (bottomInfoPanel.contentState == "MIDI") return false
    if (singleDeckView.value && (deckId != focusDeckId) && (bottomInfoPanel.contentState != "FX")) return true
    if (!singleDeckView.value &&  isUpperDeck) return true
    return false
  }

  // line on top of the bottomControls - shows up when controlled deck is not in Screen focus.
  Rectangle {
    id: topLine
    MappingProperty { id: singleDeckView;   path: propertiesPath + ".deck_single"; }

    anchors.top:   parent.top

    anchors.left:  parent.left
    anchors.right: parent.right
    color:        headlineColor
    visible:      showLine()
    height: 1 * screenScale  // Escalar altura
  }

  BeatgridFooter {
    id: beatgrid
    anchors.fill: parent
    visible:      isInEditMode
    deckId:       parent.focusDeckId
  }

  // black border on top
  Rectangle {
    id: footerBlackLine
    anchors.bottom: bottomPanelRow.top
    width:          parent.width
    height:         1 * screenScale  // Escalar altura
    color:          colors.colorBlack
    visible:        true // set in state (invisible in "hide" state)
  }

  // Monitorear cambios en variables importantes
  onDeckIdChanged: showLarge()
  onFxUnitChanged: showLarge()
  onContentStateChanged: showLarge()

  //------------------------------------------------------------------------------------------------------------------
  //  STATES
  //------------------------------------------------------------------------------------------------------------------
  state: sizeState 
  states: [
    State {
      name: "hide"
      PropertyChanges { target: bottomInfoPanel; height:       0;                 }
      PropertyChanges { target: bottomPanelRow;  sliderHeight: 0                  }
    },
    State {
      name: "small"
      PropertyChanges { target: bottomInfoPanel; height:       smallStateHeight    } 
      PropertyChanges { target: bottomInfoPanel; height:       0                   }
      PropertyChanges { target: bottomPanelRow;  sliderHeight: 6 * screenScale     }
    },
    State {
      name: "large"
      PropertyChanges { target: bottomInfoPanel; height:       0;                  }
      PropertyChanges { target: bottomInfoPanel; height:       bigStateHeight      }
      PropertyChanges { target: bottomPanelRow;  sliderHeight: 9 * screenScale     }
    }
  ]
}
