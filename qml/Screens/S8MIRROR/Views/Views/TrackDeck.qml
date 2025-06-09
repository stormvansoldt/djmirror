import QtQuick
import QtQuick.Layouts 1.1

import '../Widgets' as Widgets

//----------------------------------------------------------------------------------------------------------------------
//  Track Screen View - UI de la pantalla para track
//
//  COMPONENTES PRINCIPALES:
//  1. DeckHeader: Muestra título de la pista
//  2. Primera Fila:
//     - BPM Display: Muestra BPM actual
//     - Key Display: Muestra tonalidad y ajustes
//  3. Segunda Fila:
//     - Time Display: Muestra tiempo restante
//     - Loop Display: Muestra tamaño del loop
//  4. Stripe: Muestra vista general de la pista
//
//  ESQUEMA DE COLORES:
//  1. Textos:
//     - BPM: colorFontWhite
//     - Key: Dinámico según estado
//     - Time: colorFontBlack/White según warning
//     - Loop: colorFontBlack o defaultTextColor según estado
//
//  2. Fondos:
//     - Principal: defaultBackground
//     - BPM Box: defaultBackground
//     - Key Box: Dinámico según estado
//     - Time Box: colorRed/colorDeckGrey
//     - Loop Box: loopActiveColor o colorDeckGrey
//
//  NOTAS:
//  - Los colores se definen en el objeto colors
//  - Algunos colores son dinámicos según el estado
//  - Se usan diferentes esquemas para estados activo/inactivo
//----------------------------------------------------------------------------------------------------------------------

Item {
  id: display
  
  // MODEL PROPERTIES //
  property var deckInfo: ({})
  property real screenScale: prefs.screenScale

  // Escalar todas las dimensiones
  property real boxesRadius: dimensions.cornerRadius * screenScale
  property real infoBoxesWidth: dimensions.infoBoxesWidth * screenScale
  property real firstRowHeight: dimensions.firstRowHeight * screenScale
  property real secondRowHeight: dimensions.secondRowHeight * screenScale
  property real spacing: dimensions.spacing * screenScale
  property real screenTopMargin: dimensions.screenTopMargin * screenScale
  property real screenLeftMargin: dimensions.screenLeftMargin * screenScale

  // Cache de colores (no necesitan escala)
  readonly property color backgroundColor: colors.defaultBackground
  readonly property color borderColor: colors.colorDeckDarkGrey
  readonly property color textColorWhite: colors.colorFontWhite
  readonly property color textColorBlack: colors.colorFontBlack

  // Cache de valores calculados para Key Display
  readonly property bool hasValidKey: deckInfo.hasKey && deckInfo.resultingKeyIdx >= 0
  readonly property color keyColor: hasValidKey ? 
                                  colors.musicalKeyColors[deckInfo.resultingKeyIdx] : 
                                  colors.colorBlack

  width: 320 * screenScale  // Escalar dimensiones base
  height: 240 * screenScale

  // Fondo optimizado
  Rectangle {
    id: displayBackground
    anchors.fill: parent
    color: display.backgroundColor
  }

  ColumnLayout {
    id: content
    spacing: display.spacing
    anchors {
      left: parent.left
      top: parent.top
      topMargin: display.screenTopMargin
      leftMargin: display.screenLeftMargin
    }

    // DECK HEADER optimizado
    Widgets.DeckHeader {
      id: deckHeader
      title: deckInfo.titleString
      height: display.firstRowHeight
      width: 2 * display.infoBoxesWidth + display.spacing
    }

    // FIRST ROW optimizado
    RowLayout {
      id: firstRow
      spacing: display.spacing

      // BPM DISPLAY optimizado
      Rectangle {
        id: bpmBox
        height: display.firstRowHeight
        width: display.infoBoxesWidth
        border {
          width: 2 * screenScale  // Escalar ancho del borde
          color: display.borderColor
        }
        color: display.backgroundColor
        radius: display.boxesRadius

        Text {
          anchors.fill: parent
          text: deckInfo.bpmString
          font {
            pixelSize: fonts.largeFontSizePlusPlus * screenScale  
            family: prefs.normalFontName
            weight: Font.Normal
          }
          color: display.textColorWhite
          horizontalAlignment: Text.AlignHCenter
          verticalAlignment: Text.AlignVCenter
        }
      }

      // KEY DISPLAY optimizado
      Item {
        id: keyDisplay
        height: display.firstRowHeight
        width: display.infoBoxesWidth

        // Cache de colores de fondo
        readonly property color bgKeyOn: deckInfo.hasKey ? 
                                       colors.opacity(display.keyColor, 0.3) : 
                                       colors.opacity(colors.colorEnabledCyan, 0.7)
        readonly property color bgKeyOnShift: deckInfo.hasKey ? 
                                            colors.opacity(display.keyColor, 0.5) : 
                                            colors.opacity(colors.colorEnabledCyan, 1.0)
        readonly property color backgroundColor: deckInfo.isKeyLockOn ? 
                                               (deckInfo.shift ? bgKeyOnShift : bgKeyOn) :
                                               (deckInfo.shift ? colors.colorDeckGrey : colors.colorDeckDarkGrey)

        // Cache de color de texto
        readonly property color textColor: deckInfo.isKeyLockOn ? display.keyColor : colors.colorWhite

        // Optimización de texto de key
        readonly property bool isKeyAdjusted: deckInfo.isKeyLockOn && 
                                            Math.abs(deckInfo.keyAdjustVal) > 0.01
        readonly property string keyLabelStr: deckInfo.hasKey ?
          (deckInfo.resultingKeyStr + (isKeyAdjusted && deckInfo.shift ? 
           "  " + deckInfo.keyAdjustIntText : "")) :
          (isKeyAdjusted ? deckInfo.keyAdjustFloatText : "No key")

        Rectangle {
          id: keyBackground
          anchors.fill: parent
          color: parent.backgroundColor
          radius: display.boxesRadius
        }

        Text {
          id: keyText
          anchors.fill: parent
          text: parent.keyLabelStr
          font.pixelSize: fonts.largeFontSizePlusPlus * screenScale  
          font.family: prefs.normalFontName
          color: parent.textColor
          horizontalAlignment: Text.AlignHCenter
          verticalAlignment: Text.AlignVCenter
        }
      }
    }

    // SECOND ROW //
    RowLayout {
      id: secondRow
      spacing: display.spacing

      // TIME DISPLAY //
      Item {
        id: timeBox
        width : display.infoBoxesWidth
        height: display.secondRowHeight

        Rectangle {
          anchors.fill: parent
          color:  trackEndBlinkTimer.blink ? colors.colorRed : colors.colorDeckGrey
          radius: display.boxesRadius
        }

        Text {
          text: deckInfo.remainingTimeString
          font.pixelSize: fonts.extraLargeFontSizePlus * screenScale  
          font.family: prefs.normalFontName
          color: trackEndBlinkTimer.blink ? colors.colorFontBlack: colors.colorFontWhite
          anchors.fill: parent
          horizontalAlignment: Text.AlignHCenter
          verticalAlignment: Text.AlignVCenter
        }

        Timer {
          id: trackEndBlinkTimer
          property bool  blink: false

          interval: 500
          repeat:   true
          running:  deckInfo.trackEndWarning

          onTriggered: {
            blink = !blink;
          }

          onRunningChanged: {
            blink = running;
          }
        }
      }

      // LOOP DISPLAY //
      Item {
        id: loopBox
        width : display.infoBoxesWidth
        height: display.secondRowHeight

        Rectangle {
          anchors.fill: parent

          color: deckInfo.loopActive ? (deckInfo.shift ? colors.loopActiveDimmedColor : colors.loopActiveColor) : (deckInfo.shift ? colors.colorDeckDarkGrey : colors.colorDeckGrey ) 

          radius: display.boxesRadius
        }

        Text {
          text: deckInfo.loopSizeString

          font.pixelSize: fonts.extraLargeFontSizePlus * screenScale  
          font.family: prefs.normalFontName

          color: deckInfo.loopActive ? colors.colorFontBlack : ( deckInfo.shift ? colors.defaultInvertedTextColor : colors.defaultTextColor )
          anchors.fill: parent
          horizontalAlignment: Text.AlignHCenter
          verticalAlignment: Text.AlignVCenter
        }
      }
    } // second row

    // STRIPE //
    Widgets.Stripe
    {
      deckId:  deckInfo.deckId - 1 // stripe uses zero based indices.
      visible: deckInfo.isLoaded

      // we apply -3 on the height and +3 on the topMargin,
      //because Widgets.Stripes has elements (the cues) that are
      //not taken into the height of the Stripe. They are 3pix outside
      //of the stripe.
      height: display.secondRowHeight
      width:  2*display.infoBoxesWidth + display.spacing - (6 * screenScale)  // Escalar offset
      Layout.leftMargin: 6 * screenScale  // Escalar margen

      hotcuesModel: deckInfo.hotcues
      trackLength:  deckInfo.trackLength
      elapsedTime:  deckInfo.elapsedTime
      audioStreamKey: ["PrimaryKey", deckInfo.primaryKey]
    }
  }
}
