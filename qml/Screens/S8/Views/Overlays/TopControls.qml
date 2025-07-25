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

  //Defines.Prefs     { id: prefs } // No activar
  //Defines.Colors    { id: colors    } // No activar
  //Defines.Durations { id: durations } // No activar
  //Widgets.ActiveCue { id: activeCue } // No activar

  property string showHideState: "hide"
  property int  fxUnit: 0
  property int  yPositionWhenHidden: 0 - topInfoPanel.height - headerBlackLine.height - headerShadow.height // also hides black border & shadow
  property int  yPositionWhenShown: 0
  property string sizeState: "large" // small/large
  readonly property color barBgColor: "black"

  property int    deckId:                0   // deckId of the deck for which the footer content is displayed

  readonly property color  levelColor: colors.colorFxSlider
  readonly property color  headlineColor: "green"

  readonly property color  bgColor: colors.colorFxHeaderBg
  readonly property color  bgColorLight: colors.colorFxHeaderLightBg
  
  color: colors.footerBackgroundBlue


  height: (sizeState == "small") ? 45 : 69 // includes grey panel and black border with shadow at the bottom
  anchors.left:  parent.left
  anchors.right: parent.right

  // dark grey background
  Rectangle {
    id: topInfoDetailsPanelDarkBg
    anchors {
      top: parent.top
      left:  parent.left
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
      width: 120
      color: topInfoPanel.bgColorLight
    }
  }
  
  // dividers
  Rectangle {
    id: fxInfoDivider1
    width: 1;
    color: colors.colorDivider
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.leftMargin: 240
    height: (sizeState == "small") ? 43 : 63
  }

  Rectangle {
    id: fxInfoDivider2
    width: 1;
    color: colors.colorDivider
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.leftMargin: 360
    height: (sizeState == "small") ? 43 : 63
  }

  // Info Details
  Rectangle {
    id: topInfoDetailsPanel

    height: parent.height
    clip: true
    width: parent.width
    color: "transparent"

    anchors.left: parent.left
    anchors.leftMargin: 1

    AppProperty { id: fxDryWet;      path: "app.traktor.fx." + (fxUnit + (prefs.s12Mode ? (deckId > 1 ? 3 : 1) : 1)) + ".dry_wet"          }
    
    AppProperty { id: fxParam1;      path: "app.traktor.fx." + (fxUnit + (prefs.s12Mode ? (deckId > 1 ? 3 : 1) : 1)) + ".parameters.1"      }
    AppProperty { id: fxKnob1name;   path: "app.traktor.fx." + (fxUnit + (prefs.s12Mode ? (deckId > 1 ? 3 : 1) : 1)) + ".knobs.1.name"      }
    
    AppProperty { id: fxParam2;      path: "app.traktor.fx." + (fxUnit + (prefs.s12Mode ? (deckId > 1 ? 3 : 1) : 1)) + ".parameters.2"      }
    AppProperty { id: fxKnob2name;   path: "app.traktor.fx." + (fxUnit + (prefs.s12Mode ? (deckId > 1 ? 3 : 1) : 1)) + ".knobs.2.name"      }
    
    AppProperty { id: fxParam3;      path: "app.traktor.fx." + (fxUnit + (prefs.s12Mode ? (deckId > 1 ? 3 : 1) : 1)) + ".parameters.3"      }
    AppProperty { id: fxKnob3name;   path: "app.traktor.fx." + (fxUnit + (prefs.s12Mode ? (deckId > 1 ? 3 : 1) : 1)) + ".knobs.3.name"      }
    
    AppProperty { id: fxOn;          path: "app.traktor.fx." + (fxUnit + (prefs.s12Mode ? (deckId > 1 ? 3 : 1) : 1)) + ".enabled"          }
    AppProperty { id: fxButton1;     path: "app.traktor.fx." + (fxUnit + (prefs.s12Mode ? (deckId > 1 ? 3 : 1) : 1)) + ".buttons.1"         }
    AppProperty { id: fxButton1name; path: "app.traktor.fx." + (fxUnit + (prefs.s12Mode ? (deckId > 1 ? 3 : 1) : 1)) + ".buttons.1.name"    }
    AppProperty { id: fxButton2;     path: "app.traktor.fx." + (fxUnit + (prefs.s12Mode ? (deckId > 1 ? 3 : 1) : 1)) + ".buttons.2"         }
    AppProperty { id: fxButton2name; path: "app.traktor.fx." + (fxUnit + (prefs.s12Mode ? (deckId > 1 ? 3 : 1) : 1)) + ".buttons.2.name"    }
    AppProperty { id: fxButton3;     path: "app.traktor.fx." + (fxUnit + (prefs.s12Mode ? (deckId > 1 ? 3 : 1) : 1)) + ".buttons.3"         }
    AppProperty { id: fxButton3name; path: "app.traktor.fx." + (fxUnit + (prefs.s12Mode ? (deckId > 1 ? 3 : 1) : 1)) + ".buttons.3.name"    }

    AppProperty { id: fxUnitMode;    path: "app.traktor.fx." + (fxUnit + (prefs.s12Mode ? (deckId > 1 ? 3 : 1) : 1)) + ".type"             } // fxUnitMode -> fxSelect1.description else "DRY/WET"
    AppProperty { id: fxSelect1;     path: "app.traktor.fx." + (fxUnit + (prefs.s12Mode ? (deckId > 1 ? 3 : 1) : 1)) + ".select.1"         } // fxUnitMode -> fxKnob1name.value
    AppProperty { id: fxSelect2;     path: "app.traktor.fx." + (fxUnit + (prefs.s12Mode ? (deckId > 1 ? 3 : 1) : 1)) + ".select.2"         } // fxUnitMode -> fxKnob2name.value
    AppProperty { id: fxSelect3;     path: "app.traktor.fx." + (fxUnit + (prefs.s12Mode ? (deckId > 1 ? 3 : 1) : 1)) + ".select.3"         } // fxUnitMode -> fxKnob3name.value

    AppProperty { id: patternPlayerSound; path: "app.traktor.fx." + (fxUnit + 1) + ".pattern_player.current_sound" }

    Row {
      TopInfoDetails {
        id: topInfoDetails1
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
    height:      (sizeState == "small") ? 0.5 : 1
  }

  Rectangle {
    id: headerShadow
    anchors.left:  parent.left
    anchors.right: parent.right
    anchors.top:   headerBlackLine.bottom
    height:        1
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
}


