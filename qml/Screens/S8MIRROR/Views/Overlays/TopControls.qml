import CSI 1.0
import QtQuick
import Qt5Compat.GraphicalEffects

import '../Widgets' as Widgets
import '../../../Defines' as Defines
import 'FxUnitHelpers.js' as FxUnitHelpers

//--------------------------------------------------------------------------------------------------------------------
//  FX CONTROLS
//--------------------------------------------------------------------------------------------------------------------

// The FxControls are located on the top of the screen and blend in if one of the top knobs is touched/changed

Rectangle {
  id: topInfoPanel

  property real screenScale: prefs.screenScale

  //Defines.Prefs     { id: prefs } // No activar
  //Defines.Colors    { id: colors    } // No activar
  //Defines.Durations { id: durations } // No activar
  //Widgets.ActiveCue { id: activeCue } // No activar

  property string showHideState: "hide"
  property int  fxUnit: 0

  property int  yPositionWhenHidden: 0 - topInfoPanel.height - headerBlackLine.height - headerShadow.height // also hides black border & shadow
  property int  yPositionWhenShown: 0
  property string sizeState: "small" // small/large
  readonly property color barBgColor: "black"

  property int    deckId:                0   // deckId of the deck for which the footer content is displayed

  readonly property color  levelColor: colors.colorFxSlider
  readonly property color  headlineColor: "green"

  readonly property color  bgColor: colors.colorFxHeaderBg
  readonly property color  bgColorLight: colors.colorFxHeaderLightBg
  
  color: colors.footerBackgroundBlue

  // Temporizador para ocultar el panel automáticamente después de 5 segundos
  Timer {
    id: hideTimer
    interval: 2000  // 2 segundos
    running: false
    repeat: false
    onTriggered: {
      showHideState = "hide"
    }
  }
  
  // Función para mostrar el panel y reiniciar el temporizador
  function showPanel() {
    showHideState = "show"
    hideTimer.restart()
  }

  height: (sizeState == "small") ? (45 * screenScale) : (69 * screenScale)
  anchors.left: parent.left
  anchors.right: parent.right

  // Propiedad para calcular el ancho de cada sección
  property real sectionWidth: width / 4

  // dark grey background
  Rectangle {
    id: topInfoDetailsPanelDarkBg
    anchors {
      top: parent.top
      left: parent.left
      right: parent.right
    }
    height: topInfoPanel.height
    color: topInfoPanel.bgColor

    // light grey background
    Rectangle {
      id: topInfoDetailsPanelLightBg
      anchors {
        top: parent.top
        left: parent.left
      }
      height: topInfoPanel.height
      width: sectionWidth  // Usar el ancho proporcional
      color: topInfoPanel.bgColorLight
    }
  }
  
  // dividers
  Rectangle {
    id: fxInfoDivider1
    width: 1 * screenScale
    color: colors.colorDivider
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.leftMargin: sectionWidth * 2  // Posicionar en el medio
    height: (sizeState == "small") ? (43 * screenScale) : (63 * screenScale)
  }

  Rectangle {
    id: fxInfoDivider2
    width: 1 * screenScale
    color: colors.colorDivider
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.leftMargin: sectionWidth * 3  // Posicionar a 3/4 del ancho
    height: (sizeState == "small") ? (43 * screenScale) : (63 * screenScale)
  }

  // Info Details
  Rectangle {
    id: topInfoDetailsPanel

    height: parent.height
    clip: false // true
    width: parent.width
    color: "transparent"

    anchors.left: parent.left
    anchors.leftMargin: 1 * screenScale

    AppProperty { id: fxDryWet;      path: "app.traktor.fx." + (fxUnit + (prefs.s12Mode ? (deckId > 1 ? 3 : 1) : 1)) + ".dry_wet"; onValueChanged: { showPanel(); } }
    
    AppProperty { id: fxParam1;      path: "app.traktor.fx." + (fxUnit + (prefs.s12Mode ? (deckId > 1 ? 3 : 1) : 1)) + ".parameters.1"; onValueChanged: { showPanel(); } }
    AppProperty { id: fxKnob1name;   path: "app.traktor.fx." + (fxUnit + (prefs.s12Mode ? (deckId > 1 ? 3 : 1) : 1)) + ".knobs.1.name"; onValueChanged: { showPanel(); } }
    
    AppProperty { id: fxParam2;      path: "app.traktor.fx." + (fxUnit + (prefs.s12Mode ? (deckId > 1 ? 3 : 1) : 1)) + ".parameters.2"; onValueChanged: { showPanel(); } }
    AppProperty { id: fxKnob2name;   path: "app.traktor.fx." + (fxUnit + (prefs.s12Mode ? (deckId > 1 ? 3 : 1) : 1)) + ".knobs.2.name"; onValueChanged: { showPanel(); } }
    
    AppProperty { id: fxParam3;      path: "app.traktor.fx." + (fxUnit + (prefs.s12Mode ? (deckId > 1 ? 3 : 1) : 1)) + ".parameters.3"; onValueChanged: { showPanel(); } }
    AppProperty { id: fxKnob3name;   path: "app.traktor.fx." + (fxUnit + (prefs.s12Mode ? (deckId > 1 ? 3 : 1) : 1)) + ".knobs.3.name"; onValueChanged: { showPanel(); } }
    
    AppProperty { id: fxOn;          path: "app.traktor.fx." + (fxUnit + (prefs.s12Mode ? (deckId > 1 ? 3 : 1) : 1)) + ".enabled"; onValueChanged: { showPanel(); } }
    AppProperty { id: fxButton1;     path: "app.traktor.fx." + (fxUnit + (prefs.s12Mode ? (deckId > 1 ? 3 : 1) : 1)) + ".buttons.1"; onValueChanged: { showPanel(); } }
    AppProperty { id: fxButton1name; path: "app.traktor.fx." + (fxUnit + (prefs.s12Mode ? (deckId > 1 ? 3 : 1) : 1)) + ".buttons.1.name"; onValueChanged: { showPanel(); } }
    AppProperty { id: fxButton2;     path: "app.traktor.fx." + (fxUnit + (prefs.s12Mode ? (deckId > 1 ? 3 : 1) : 1)) + ".buttons.2"; onValueChanged: { showPanel(); } }
    AppProperty { id: fxButton2name; path: "app.traktor.fx." + (fxUnit + (prefs.s12Mode ? (deckId > 1 ? 3 : 1) : 1)) + ".buttons.2.name"; onValueChanged: { showPanel(); } }
    AppProperty { id: fxButton3;     path: "app.traktor.fx." + (fxUnit + (prefs.s12Mode ? (deckId > 1 ? 3 : 1) : 1)) + ".buttons.3"; onValueChanged: { showPanel(); } }
    AppProperty { id: fxButton3name; path: "app.traktor.fx." + (fxUnit + (prefs.s12Mode ? (deckId > 1 ? 3 : 1) : 1)) + ".buttons.3.name"; onValueChanged: { showPanel(); } }

    AppProperty { id: fxUnitMode;    path: "app.traktor.fx." + (fxUnit + (prefs.s12Mode ? (deckId > 1 ? 3 : 1) : 1)) + ".type"; onValueChanged: { showPanel(); } } // fxUnitMode -> fxSelect1.description else "DRY/WET"
    AppProperty { id: fxSelect1;     path: "app.traktor.fx." + (fxUnit + (prefs.s12Mode ? (deckId > 1 ? 3 : 1) : 1)) + ".select.1"; onValueChanged: { showPanel(); } } // fxUnitMode -> fxKnob1name.value
    AppProperty { id: fxSelect2;     path: "app.traktor.fx." + (fxUnit + (prefs.s12Mode ? (deckId > 1 ? 3 : 1) : 1)) + ".select.2"; onValueChanged: { showPanel(); } } // fxUnitMode -> fxKnob2name.value
    AppProperty { id: fxSelect3;     path: "app.traktor.fx." + (fxUnit + (prefs.s12Mode ? (deckId > 1 ? 3 : 1) : 1)) + ".select.3"; onValueChanged: { showPanel(); } } // fxUnitMode -> fxKnob3name.value

    AppProperty { id: patternPlayerSound; path: "app.traktor.fx." + (fxUnit + 1) + ".pattern_player.current_sound" }

    // Monitores de cambios de valor para mostrar el panel
    property real lastDryWetValue: 0
    property real lastParam1Value: 0
    property real lastParam2Value: 0
    property real lastParam3Value: 0
    property bool lastOnValue: false
    property bool lastButton1Value: false
    property bool lastButton2Value: false  
    property bool lastButton3Value: false

    Row {
      TopInfoDetails {
        id: topInfoDetails1
        width: sectionWidth
        parameter: fxDryWet
        isOn: fxOn.value
        label: FxUnitHelpers.fxUnitFirstParameterLabel(fxUnitMode, fxSelect1)
        buttonLabel: fxUnitMode.value != FxType.Group ? "ON" : ""
        fxEnabled: (fxUnitMode.value == FxType.Group) || fxSelect1.value || (fxUnitMode.value == FxType.PatternPlayer)
        barBgColor: topInfoPanel.barBgColor
        sizeState: topInfoPanel.sizeState
        levelColor: topInfoPanel.levelColor
        sliderBgColor: colors.colorFxSliderBackground
      }
      
      TopInfoDetails {
        id: topInfoDetails2
        width: sectionWidth
        parameter: fxParam1
        isOn: fxButton1.value
        label: fxUnitMode.value != FxType.PatternPlayer ? fxKnob1name.value : patternPlayerSound.value
        buttonLabel: fxButton1name.value
        fxEnabled: (fxSelect1.value || (fxUnitMode.value && fxSelect1.value) ) || (fxUnitMode.value == FxType.PatternPlayer)
        barBgColor: topInfoPanel.barBgColor
        sizeState: topInfoPanel.sizeState
        levelColor: topInfoPanel.levelColor
        sliderBgColor: colors.colorFxSliderBackground
      }
      
      TopInfoDetails {
        id: topInfoDetails3
        width: sectionWidth
        parameter: fxParam2
        isOn: fxButton2.value
        label: fxKnob2name.value
        buttonLabel: fxButton2name.value
        fxEnabled: (fxSelect2.value || (fxUnitMode.value && fxSelect1.value) ) || (fxUnitMode.value == FxType.PatternPlayer)
        barBgColor: topInfoPanel.barBgColor
        sizeState: topInfoPanel.sizeState
        levelColor: topInfoPanel.levelColor
        sliderBgColor: colors.colorFxSliderBackground
      }
      
      TopInfoDetails {
        id: topInfoDetails4
        width: sectionWidth
        parameter: fxParam3
        isOn: fxButton3.value
        label: fxKnob3name.value
        buttonLabel: fxButton3name.value
        fxEnabled: (fxSelect3.value || (fxUnitMode.value && fxSelect1.value) ) || (fxUnitMode.value == FxType.PatternPlayer)
        barBgColor: topInfoPanel.barBgColor
        sizeState: topInfoPanel.sizeState
        levelColor: topInfoPanel.levelColor
        sliderBgColor: colors.colorFxSliderBackground
      }
    }
  }

  // black border & shadow
  Rectangle {
    id: headerBlackLine
    anchors.top: topInfoPanel.bottom
    width:       parent.width
    color:       colors.colorBlack
    height:      (sizeState == "small") ? (0.5 * screenScale) : (1 * screenScale)  // Escalar altura
  }

  Rectangle {
    id: headerShadow
    anchors.left:  parent.left
    anchors.right: parent.right
    anchors.top:   headerBlackLine.bottom
    height:        1 * screenScale  // Escalar altura
    gradient: Gradient {
      GradientStop { position: 1.0; color: colors.colorBlack0 }
      GradientStop { position: 0.0; color: colors.colorBlack63 }
    }
    visible: false
  }

  //------------------------------------------------------------------------------------------------------------------
  //  STATES
  //------------------------------------------------------------------------------------------------------------------

  Behavior on y { PropertyAnimation { duration: durations.overlayTransition;  easing.type: Easing.InOutQuad } }

  Item {
    id: showHide
    state: showHideState
    states: [
      State {
        name: "show";
        PropertyChanges { target: topInfoPanel;   y: yPositionWhenShown}
      },
      State {
        name: "hide";
        PropertyChanges { target: topInfoPanel;   y: yPositionWhenHidden}
      }
    ]
  }
  
  // Mostrar el panel cuando se cambie el fxUnit o deckId
  onFxUnitChanged: showPanel()
  onDeckIdChanged: showPanel()
  
  // Inicialización
  Component.onCompleted: {
    // Iniciar oculto y mostrar brevemente al cargarse
    showHideState = "hide"
    showPanel()
  }
}


