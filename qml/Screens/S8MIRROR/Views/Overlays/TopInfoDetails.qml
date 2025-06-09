import CSI 1.0
import QtQuick

import '../Widgets' as Widgets
import '../../../Defines' as Defines

Item {
  id: fxInfoDetails

  property real screenScale: prefs.screenScale

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

  width:  120 * screenScale  // Escalar ancho
  height: (sizeState == "small") ? (45 * screenScale) : (51 * screenScale)  // Escalar altura

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

  // Añadir propiedad para calcular el ancho de las barras
  property real barWidth: width - (16 * screenScale) // Ancho total menos márgenes (8 por cada lado)

  // Level indicator for knobs
  Widgets.ProgressBar {
    id: slider
    progressBarHeight: (sizeState == "small") ? (6 * screenScale) : (9 * screenScale)
    progressBarWidth: barWidth  // Usar ancho proporcional
    anchors.left: parent.left
    anchors.top: parent.top
    anchors.topMargin: 3 * screenScale
    anchors.leftMargin: 8 * screenScale

    value: parameter.value
    visible: !(parameter.valueRange.isDiscrete && fxEnabled)
    drawAsEnabled: indicatorEnabled

    progressBarColorIndicatorLevel: parent.levelColor
    progressBarBackgroundColor: parent.sliderBgColor
  }

  // stepped progress bar
  Widgets.StateBar {
    id: slider2
    height: (sizeState == "small") ? (6 * screenScale) : (9 * screenScale)
    width: barWidth  // Usar ancho proporcional
    anchors.left: parent.left
    anchors.top: parent.top
    anchors.leftMargin: 8 * screenScale
    anchors.topMargin: 3 * screenScale

    stateCount: parameter.valueRange.steps
    currentState: (parameter.valueRange.steps - 1.0 + 0.2) * parameter.value
    visible: parameter.valueRange.isDiscrete && fxEnabled && label.length > 0

    barColor: parent.levelColor
    barBgColor: parent.sliderBgColor
  }

  // Diverse Elements
  Item {
    id: fxInfoDetailsPanel

    height: 100 * screenScale  // Escalar altura
    width: parent.width

    Rectangle {
      id: macroIconDetails
      anchors.top:          parent.top
      anchors.left:         parent.left
      anchors.leftMargin:   8 * screenScale
      anchors.topMargin:    50 * screenScale

      width:                12 * screenScale  // Escalar dimensiones
      height:               11 * screenScale
      radius:               1 * screenScale
      visible:              isMacroFx 
      color:                fxInfoDetails.colorMacroBackground

      Text {
        anchors.fill:       parent
        anchors.topMargin:  -1 * screenScale
        anchors.leftMargin: 1 * screenScale
        text:               "M"

        font.pixelSize:     fonts.miniFontSize * screenScale
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
      anchors.topMargin:   (sizeState == "small") ? (32 * screenScale) : (48 * screenScale)

      font.pixelSize:      (sizeState == "small") ? fonts.miniFontSize * screenScale : fonts.miniFontSizePlus * screenScale
      font.family:         prefs.normalFontName
      font.capitalization: Font.AllUppercase

      anchors.leftMargin:  isMacroFx ? (24 * screenScale) : (8 * screenScale)
      anchors.rightMargin: 9 * screenScale
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
      anchors.leftMargin: 8 * screenScale

      font.pixelSize:     (sizeState == "small") ? fonts.largeFontSize * screenScale : fonts.largeFontSizePlus * screenScale
      font.family:        prefs.normalFontName // is monospaced  

      anchors.topMargin:  (sizeState == "small") ? (13 * screenScale) : (22 * screenScale)
    }

    // button
    Rectangle {
      id: fxInfoFilterButton 
      width: 30 * screenScale  // Mantener ancho fijo para el botón
      height: (sizeState == "small") ? (13 * screenScale) : (15 * screenScale)
      
      color:          fxInfoDetails.fxEnabled ? fxInfoDetails.colorButtonEnabled : fxInfoDetails.colorButtonDisabled
      visible:        buttonLabel.length > 0
      radius:         1 * screenScale
      anchors.right:  parent.right
      anchors.rightMargin: 9 * screenScale
      anchors.top:    parent.top
      anchors.topMargin: (sizeState == "small") ? (15 * screenScale) : (24 * screenScale)

      Text {
        id: fxInfoFilterButtonText
        text: fxInfoDetails.finalButtonLabel
        color: fxInfoDetails.colorButtonText

        font.pixelSize: fonts.miniFontSize * screenScale
        font.family:    prefs.normalFontName
        font.capitalization: Font.AllUppercase

        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
      }
    }
  }
}

