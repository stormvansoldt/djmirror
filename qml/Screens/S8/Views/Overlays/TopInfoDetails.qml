import CSI 1.0
import QtQuick

import '../Widgets' as Widgets
import '../../../Defines' as Defines

Item {
  id: fxInfoDetails

  //Defines.Prefs     { id: prefs } // No activar

  property AppProperty parameter         // set from outside

  property bool        isOn:             false
  property string      label:            "DRUMLOOP"
  property string      buttonLabel:      "HP ON"
  property bool        fxEnabled:        false
  property bool        indicatorEnabled: fxEnabled && label.length > 0
  property string      finalValue:       fxEnabled ? parameter.description : ""
  property string      finalLabel:       fxEnabled ? label : ""
  property string      finalButtonLabel: fxEnabled ? buttonLabel : ""
  property string      sizeState:        "large"

  readonly property int macroEffectChar:  0x00B6
  readonly property bool isMacroFx: (finalLabel.charCodeAt(0) == macroEffectChar)

  width:  120
  height: (sizeState == "small") ? 45 : 51

  // Propiedades de color
  property color colorText: isOn ? colors.colorWhite : colors.colorFontFxHeader
  property color colorTextDisabled: colors.colorGrey88
  property color colorMacroBackground: "red" //colors.colorGrey216
  property color colorMacroText: "green" //colors.colorBlack

  property color colorButtonEnabled: isOn ? colors.colorOrange : colors.colorBlack
  property color colorButtonDisabled: "transparent"
  //property color colorButtonText: fxEnabled ? colors.colorBlack : colors.colorGrey88
  property color colorButtonText: isOn ? colors.colorBlack : colors.colorGrey88

  // Propiedades de color para el progress bar
  // sets the background color for all different progress bar types (normal/bipolar/statebar)
  property color sliderBgColor         // set from outside
  property color levelColor            // set from outside

  // Color de fondo (no se usa)
  property color barBgColor            // set from outside

  // Level indicator for knobs
  Widgets.ProgressBar {
    id: slider
    progressBarHeight:  (sizeState == "small") ? 6 : 9
    progressBarWidth:   102
    anchors.left:       parent.left
    anchors.top:        parent.top
    anchors.topMargin:  3
    anchors.leftMargin: 8

    value:              parameter.value
    visible:            !(parameter.valueRange.isDiscrete && fxEnabled)

    drawAsEnabled:      indicatorEnabled

    progressBarColorIndicatorLevel: parent.levelColor
    progressBarBackgroundColor: parent.sliderBgColor //set in parent
  }

  // stepped progress bar
  Widgets.StateBar {
    id: slider2
    height:  (sizeState == "small") ? 6 : 9
    width:              102
    anchors.left:       parent.left
    anchors.top:        parent.top
    anchors.leftMargin: 8
    anchors.topMargin:  3

    stateCount:   parameter.valueRange.steps
    currentState: (parameter.valueRange.steps - 1.0 + 0.2) * parameter.value // +.2 to make sure we round in the right direction
    visible:      parameter.valueRange.isDiscrete && fxEnabled && label.length > 0

    barColor: parent.levelColor
    barBgColor: parent.sliderBgColor //set in parent
  }

  // Diverse Elements
  Item {
    id: fxInfoDetailsPanel

    height: 100
    width: parent.width

    Rectangle {
      id: macroIconDetails
      anchors.top:          parent.top
      anchors.left:         parent.left
      anchors.leftMargin:   8
      anchors.topMargin:    50

      width:                12
      height:               11
      radius:               1
      visible:              isMacroFx 
      color:                fxInfoDetails.colorMacroBackground

      Text {
        anchors.fill:       parent
        anchors.topMargin:  -1
        anchors.leftMargin: 1
        text:               "M"

        font.pixelSize:     fonts.miniFontSize
        font.family:        prefs.normalFontName

        color:              fxInfoDetails.colorMacroText
      }
    }

    // fx name
    Text {
      id: fxInfoSampleName
      text:                isMacroFx ? finalLabel.substr(1) : finalLabel
      color:               colors.colorFontFxHeader

      anchors.top:         parent.top
      anchors.left:        parent.left
      anchors.right:       parent.right
      anchors.topMargin:   (sizeState == "small") ? 32 : 48

      font.pixelSize:      fonts.scale((sizeState == "small") ? fonts.miniFontSize : fonts.miniFontSizePlus)
      font.family:        prefs.normalFontName
      font.capitalization: Font.AllUppercase

      anchors.leftMargin:  isMacroFx ? 24 : 8
      anchors.rightMargin: 9
      elide:               Text.ElideRight
    }

    // value
    Text {
      id: fxInfoValueLarge
      text:               finalValue
      color:              fxInfoDetails.fxEnabled ? fxInfoDetails.colorText : fxInfoDetails.colorTextDisabled
      visible:            label.length > 0
      anchors.top:        parent.top
      anchors.left:       parent.left
      anchors.leftMargin: 8

      font.pixelSize:     (sizeState == "small") ? fonts.largeFontSize : fonts.largeFontSizePlus
      font.family:        prefs.normalFontName // is monospaced  

      anchors.topMargin:  (sizeState == "small") ? 13 : 22
    }

    // button
    Rectangle {
      id: fxInfoFilterButton 
      width: 30
      
      color:          fxInfoDetails.fxEnabled ? fxInfoDetails.colorButtonEnabled : fxInfoDetails.colorButtonDisabled
      visible:        buttonLabel.length > 0
      radius:         1
      anchors.right:  parent.right
      anchors.rightMargin: 9
      anchors.top:    parent.top
      height: (sizeState == "small") ? 13 : 15
      anchors.topMargin: (sizeState == "small") ? 15 : 24

      Text {
        id: fxInfoFilterButtonText
        text: fxInfoDetails.finalButtonLabel
        color: fxInfoDetails.colorButtonText

        font.pixelSize: fonts.miniFontSize
        font.family:    prefs.normalFontName
        font.capitalization: Font.AllUppercase

        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
      }
    }
  }
}

