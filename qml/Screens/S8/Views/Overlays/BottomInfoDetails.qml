import QtQuick
import CSI 1.0

import '../Widgets' as Widgets

import 'FxUnitHelpers.js' as FxUnitHelpers


Rectangle {
  id: bottomInfoDetails
  
  property string remixDeckPropertyPath: "app.traktor.decks." + (deckId + 1) + ".remix." 

  property int    midiId: 0
  property bool showSampleName: true

  AppProperty { id: sequencerOn;  path: "app.traktor.decks." + (deckId + 1) + ".remix.sequencer.on" }
  AppProperty { id: sequencerPlayerRow;  path: "app.traktor.decks." + (deckId + 1) + ".remix.players." + (column + 1) + ".sequencer.selected_cell" }

  property string samplePath: remixDeckPropertyPath + "cell.columns."   + (column + 1) + ".rows." + (sequencerOn.value && screen.flavor != ScreenFlavor.S5 ? sequencerPlayerRow.value + 1 : activePlayerRow.value + 1)

  property string stemDeckPropertyPath : "app.traktor.decks." + (deckId + 1) + ".stems."
  property string playerPath: isStemDeck ? stemDeckPropertyPath + (column + 1) : remixDeckPropertyPath + "players." + (column + 1)
  property string namePath:   isStemDeck ? playerPath + ".name"                : samplePath + ".name"

  property string fxUnitPath: "app.traktor.fx.1" 
  property string buttonLabel: "ON"

  property double sliderHeight: 0

  property int    column: 0

  property bool   isEnabled: false
  property bool   indicatorEnabled: isEnabled && (bottomInfoSampleName.name != "")
  property bool   isOn: active.value
  
  // If markActive is true, this cell will be "highlighted" to show the user that it is active
  // Currently the highlight is done by underlining the label
  property alias  markActive: bottomInfoTextUnderline.visible
  
  readonly property string finalLabel:       (column == 0) ? FxUnitHelpers.fxUnitFirstParameterLabel(fxUnitMode, fxSelect1) : name.description
  readonly property int    macroEffectChar:  0x00B6
  readonly property bool   isMacroFx:        (finalLabel.charCodeAt(0) == macroEffectChar)

  AppProperty { id: stemColorId;     path: stemDeckPropertyPath  + (index + 1) + ".color_id"  }
  AppProperty { id: activePlayerRow; path: remixDeckPropertyPath + "players." + (index + 1) + ".active_cell_row" }
  AppProperty { id: parameter;       path: playerPath + ".filter_value"                }
  AppProperty { id: active;          path: playerPath + ".filter_on"                   } 
  AppProperty { id: name  ;          path: fxUnitPath + ".name"                        }
  AppProperty { id: fxButtonName;    path: fxUnitPath + ".buttons." + column + ".name" }
  AppProperty { id: fxUnitMode;      path: fxUnitPath + ".type"                        }
  AppProperty { id: fxSelect1;       path: fxUnitPath + ".select.1"                    }
  AppProperty { id: fxColumnSelect;  path: fxUnitPath + ".select." + column            }

  // Propiedades de color
  property color colorText: isStemDeck && (state != "FX") && (state != "MIDI") ? 
                          colors.palette(1.0, stemColorId.value) : 
                          colors.colorFontFxHeader
  property color colorTextDisabled: colors.colorGrey88

  property color colorButtonEnabled: isOn ? 
                                   (state != "FX" ? colors.colorWhite : colors.colorOrange) : 
                                   colors.colorBlack
  property color colorButtonDisabled: "transparent"
  property color colorButtonText: isOn ? colors.colorBlack : colors.colorGrey88
  
  property color colorDivider: colors.colorDivider
  property color colorValue: colors.colorWhite
  property color colorLockedButton: selectedCellLock.value ? levelColor : colors.colorBlack
  property color colorLockedText: selectedCellLock.value ? colors.colorBlack : colors.colorGrey88

  // Propiedades de color para el progress bar
  // sets the background color for all different progress bar types (normal/bipolar/statebar)
  property color sliderBgColor: colors.colorFxSliderBackground
  property color levelColor // set from outside

  // Color de fondo
  property color bgColor    // set from outside
  color:  bgColor

  Item {
    id: bottomInfoDetailsPanel // prevents text to show up beneath the progress bars on size change animation

    anchors.top: parent.top
    anchors.left: parent.left
   
    height: parent.height - (bottomInfoDetails.sliderHeight) - 3
    width: parent.width
    clip: true

    // sample name / headline
    Text {
      id: bottomInfoSampleName
      property string labelText: "" // updated via states
      
      anchors.top:        parent.top
      anchors.left:       parent.left
      anchors.topMargin:  (sizeState == "large") ? 21 : 2
      
      // "Manually" align the text to the right if needed. "horizontalAlignment" is not used, as that would
      // require the width span the full width of the parent (which interferes with the underline rect below).
      anchors.leftMargin: 8 + ((column > 1 && sizeState != "large") ? (102 - width) : 0)

      visible: (sizeState == "large") || (isStemDeck && ( bottomInfoPanel.contentState != "FX" ) )

      text:                labelText
      color:               bottomInfoDetails.colorText

      font.pixelSize:      fonts.miniFontSizePlus
      font.capitalization: Font.AllUppercase
      font.family:         prefs.normalFontName

      elide:               Text.ElideRight
    }
    
    // Used to underline the bottomInfoSampleName
    Rectangle {
      id: bottomInfoTextUnderline
      
      color: bottomInfoDetails.colorText
      height: 1
      
      anchors.top: bottomInfoSampleName.bottom
      anchors.topMargin: -1
      anchors.left: bottomInfoSampleName.left
      anchors.right: bottomInfoSampleName.right
      
      visible: false
    }

    // value
    Item {
      anchors.top: parent.top
      anchors.topMargin: 40
      anchors.left: parent.left
      anchors.leftMargin: 8

      height: 20

      Text {
        id: valueString
        anchors.verticalCenter: parent.verticalCenter
        text: isEnabled ? ( toPercent ? Math.floor(parameter.description * 100 + 0.1) + "%" : parameter.description ) : ""
        color: bottomInfoDetails.colorValue

        font.family: prefs.normalFontName // is monospaced
        font.pixelSize: fonts.largeFontSizePlus
       
        property bool toPercent: false
      }
    }

    // button
    Rectangle {
      id: bottomInfoFilterButton
      anchors.right: parent.right
      anchors.rightMargin: 10
      anchors.top: parent.top
      anchors.topMargin: 42
      width: 30
      height: 15                                                           // on                                     on & !fx            on & fx               off        disabled
      color: isEnabled && (bottomInfoFilterButtonText.text != "") ? 
             bottomInfoDetails.colorButtonEnabled : 
             bottomInfoDetails.colorButtonDisabled

      radius: 1

      Text {
        id: bottomInfoFilterButtonText
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        text: isEnabled ? buttonLabel : ""
        color: bottomInfoDetails.colorButtonText

        font.capitalization: Font.AllUppercase
        font.pixelSize: fonts.miniFontSize
      }
    }
  }

  // divider
  Rectangle {
    id: bottomInfoDivider
    readonly property int dividerHeight: 57

    width:          1
    height:         dividerHeight*( parent.height - bottomInfoPanel.smallStateHeight )/(bottomInfoPanel.bigStateHeight - bottomInfoPanel.smallStateHeight)  
    anchors.bottom: parent.bottom
    anchors.right:  parent.right
    color:          bottomInfoDetails.colorDivider
    visible:       !(column == 0 && bottomInfoDetails.state == "FX")
  }

  // progress bar starting at the left border (= 0)
  Widgets.ProgressBar {
    id: slider1
    progressBarWidth: 102
    progressBarHeight: bottomInfoDetails.sliderHeight

    anchors.bottom: parent.bottom
    anchors.left: parent.left
    anchors.leftMargin: 8
    anchors.bottomMargin: 3

    value:  (bottomInfoDetails.state == "PITCH") ? (0.5*parameter.value + 0.5) : (parameter.value != undefined ? parameter.value : 0.0)
    visible: (!(parameter.valueRange.isDiscrete && isEnabled) ) && (!slider3.visible)

    drawAsEnabled: indicatorEnabled

    progressBarColorIndicatorLevel: parent.levelColor
    progressBarBackgroundColor: parent.sliderBgColor //set in parent
  }

  // state bar for displaying discrete values 
  Widgets.StateBar {
    id: slider2

    height: bottomInfoDetails.sliderHeight

    barColor: parent.levelColor
    barBgColor: parent.sliderBgColor //set in parent

    width: 102 

    anchors.bottom: parent.bottom
    anchors.left: parent.left    
    anchors.leftMargin: 8
    anchors.bottomMargin: 3

    stateCount:   (bottomInfoDetails.state == "FX") ? parameter.valueRange.steps : 0
    currentState: (bottomInfoDetails.state == "FX") ? ((parameter.valueRange.steps - 1) * parameter.value) : 0
    visible:      (bottomInfoDetails.state == "FX") ? (parameter.valueRange.isDiscrete && isEnabled && (bottomInfoSampleName.name != "")) : false
  }

  // progress bar starting at the center (= 0)
  Widgets.BipolarBar {
    id: slider3
    progressBarWidth: 102
    progressBarHeight: bottomInfoDetails.sliderHeight
    progressBarColorIndicatorLevel: parent.levelColor
    progressBarBackgroundColor: parent.sliderBgColor //set in parent
 
    anchors.bottom: parent.bottom
    anchors.bottomMargin: 3
    anchors.left: parent.left
    anchors.leftMargin: 8

    value:         (bottomInfoDetails.state == "PITCH") ? (0.5*parameter.value + 0.5) : (parameter.value != undefined ? parameter.value : 0.0)
    visible:       (bottomInfoDetails.state == "PITCH") ||  (bottomInfoDetails.state == "FILTER")
    drawAsEnabled: indicatorEnabled
  }

  MappingProperty { id: selectedCellLock; path: screen.propertiesPath + ".sequencer_sample_lock" }

  // locked button
  Rectangle {
    id: lockedButton
    anchors.bottom: parent.bottom
    anchors.bottomMargin: 3
    anchors.left: parent.left
    anchors.leftMargin: 8

    width: 102
    height: bottomInfoDetails.sliderHeight
    color: bottomInfoDetails.colorLockedButton

    radius: 1
    visible:       (bottomInfoDetails.state == "SAMPLE")

    Text {
      anchors.horizontalCenter: parent.horizontalCenter
      anchors.verticalCenter: parent.verticalCenter
      text: "LOCKED"
      color: bottomInfoDetails.colorLockedText
      visible: (sizeState == "large")

      font.pixelSize: fonts.miniFontSize
      font.capitalization: Font.AllUppercase
      font.family:         prefs.normalFontName
    }
  }

  state: "EMPTY"
  states: [
    State {
      name: "EMPTY"
      PropertyChanges { target: active;                     path:      ""    }
      PropertyChanges { target: parameter;                  path:      ""    }
      PropertyChanges { target: valueString;                toPercent: false }
      PropertyChanges { target: valueString;                font.pixelSize: fonts.largeFontSizePlus }
      PropertyChanges { target: name;                       path:      ""    }
      PropertyChanges { target: bottomInfoSampleName;       labelText: ""    }
      PropertyChanges { target: bottomInfoFilterButtonText; text:      ""    }
      PropertyChanges { target: bottomInfoDetails;          isEnabled: false } 
    },
    State {
      name: "FX"
      PropertyChanges { target: active;                     path:      (column == 0) ? (fxUnitPath + ".enabled") : (fxUnitPath + ".buttons." + column )  }
      PropertyChanges { target: parameter;                  path:      (column == 0) ? (fxUnitPath + ".dry_wet") : (fxUnitPath + ".parameters." + column ) }
      PropertyChanges { target: valueString;                toPercent: false }
      PropertyChanges { target: valueString;                font.pixelSize: fonts.largeFontSizePlus }
      PropertyChanges { target: name;                       path:      (column == 0) ? (fxUnitPath + ".enabled") : (fxUnitPath + ".knobs."      + column + ".name") }
      PropertyChanges { target: bottomInfoSampleName;       labelText: isMacroFx ? finalLabel.substr(1) : finalLabel }
      PropertyChanges { target: bottomInfoFilterButtonText; text:      (column == 0) ? (fxUnitMode.value ? "ON" : "") : fxButtonName.value }
      PropertyChanges { target: bottomInfoDetails;          isEnabled: (column == 0) ? ((!fxUnitMode.value) || fxSelect1.value)  : (fxColumnSelect.value || (fxUnitMode.value && fxSelect1.value)) } 
    },
    State {
      name: "FILTER"
      PropertyChanges { target: parameter;                  path:      playerPath + ".filter_value"                  }
      PropertyChanges { target: valueString;                toPercent: false                                         }
      PropertyChanges { target: valueString;                font.pixelSize: fonts.largeFontSizePlus                 }
      PropertyChanges { target: active;                     path:      playerPath + ".filter_on"                     }
      PropertyChanges { target: name;                       path:      namePath                                      }
      PropertyChanges { target: bottomInfoSampleName;       labelText: showSampleName ? name.description : "FILTER"  }
      PropertyChanges { target: bottomInfoFilterButtonText; text:      (name.description != "") ? "ON" : ""          } 
      PropertyChanges { target: bottomInfoDetails;          isEnabled: (name.description != "")                      }
    },
    State {
      name: "PITCH"
      PropertyChanges { target: parameter;                  path:      samplePath + ".pitch"                         }
      PropertyChanges { target: valueString;                toPercent: false                                         }
      PropertyChanges { target: valueString;                font.pixelSize: fonts.largeFontSizePlus                 }
      PropertyChanges { target: active;                     path:      playerPath + ".key_lock"                      }
      PropertyChanges { target: name;                       path:      namePath                                      }
      PropertyChanges { target: bottomInfoSampleName;       labelText: showSampleName ? name.description : "PITCH"   }
      PropertyChanges { target: bottomInfoFilterButtonText; text:      (name.description != "") ? "ON" : ""          }
      PropertyChanges { target: bottomInfoDetails;          isEnabled: (name.description != "")                      }
    },
    State {
      name: "FX SEND"
      PropertyChanges { target: parameter;                  path:      playerPath + ".fx_send"                       }
      PropertyChanges { target: valueString;                toPercent: false                                         }
      PropertyChanges { target: valueString;                font.pixelSize: fonts.largeFontSizePlus                 }
      PropertyChanges { target: active;                     path:      playerPath + ".fx_send_on"                    }
      PropertyChanges { target: name;                       path:      namePath                                      }
      PropertyChanges { target: bottomInfoSampleName;       labelText: showSampleName ? name.description : "FX SEND" }
      PropertyChanges { target: bottomInfoFilterButtonText; text:      (name.description != "") ? "ON" : ""          }
      PropertyChanges { target: bottomInfoDetails;          isEnabled: (name.description != "")                      }
    },
    State {
      name: "MIDI"
      PropertyChanges { target: parameter;                  path:      "app.traktor.midi.knobs."   + midiId          }
      PropertyChanges { target: valueString;                toPercent: false                                         }
      PropertyChanges { target: valueString;                font.pixelSize: fonts.largeFontSizePlus                 }
      PropertyChanges { target: active;                     path:      "app.traktor.midi.buttons." + midiId          }
      PropertyChanges { target: name;                       path:      ""                                            }
      PropertyChanges { target: bottomInfoSampleName;       labelText: "MIDI " + midiId                              }
      PropertyChanges { target: bottomInfoFilterButtonText; text:      "ON"                                          }
      PropertyChanges { target: bottomInfoDetails;          isEnabled: true                                          }
    },
    State {
      name: "VOLUME"
      PropertyChanges { target: parameter;                  path:      playerPath + ".volume"                        }
      PropertyChanges { target: valueString;                toPercent: true                                          }
      PropertyChanges { target: valueString;                font.pixelSize: fonts.largeFontSizePlus                 }
      PropertyChanges { target: active;                     path:      ""                                            }
      PropertyChanges { target: name;                       path:      namePath                                      }
      PropertyChanges { target: bottomInfoSampleName;       labelText: showSampleName ? name.description : "VOLUME"  }
      PropertyChanges { target: bottomInfoFilterButtonText; text:      ""                                            }
      PropertyChanges { target: bottomInfoDetails;          isEnabled: (name.description != "")                      }
    }
    , State {
      name: "SAMPLE"
      PropertyChanges { target: parameter;                  path:      playerPath + ".sequencer.selected_cell"       }
      PropertyChanges { target: valueString;                toPercent: false                                         }
      PropertyChanges { target: valueString;                font.pixelSize: fonts.middleFontSize                     }
      PropertyChanges { target: active;                     path:      ""                                            }
      PropertyChanges { target: name;                       path:      namePath                                      }
      PropertyChanges { target: bottomInfoSampleName;       labelText: showSampleName ? name.description : "SAMPLE"  }
      PropertyChanges { target: bottomInfoFilterButtonText; text:      ""                                            }
      PropertyChanges { target: bottomInfoDetails;          isEnabled: (name.description != "")                      }
    }
  ]
}

