import CSI 1.0
import QtQuick

import '../../../../Defines' as Defines


// dimensions are set in CenterOverlay.qml

CenterOverlay {
  id: quantizeAdjust

  property real screenScale: prefs.screenScale

  property int deckId: 0

  Defines.Margins {id: customMargins }

  //--------------------------------------------------------------------------------------------------------------------

  AppProperty { id: quantize;    path: "app.traktor.decks." + (deckId+1) + ".remix.quant_index"; }
  AppProperty { id: isQuantize;  path: "app.traktor.decks." + (deckId+1) + ".remix.quant"; }

  //--------------------------------------------------------------------------------------------------------------------

  // Función para ajustar el valor de cuantización
  function adjustQuantize(increment) {
    var newValue = quantize.value + increment
    // Verificar que el valor esté dentro del rango permitido (0-7)
    if (newValue >= 0 && newValue <= 7) {
      quantize.value = newValue
    }
  }
  
  // Función para activar/desactivar la cuantización
  function toggleQuantize() {
    isQuantize.value = !isQuantize.value
  }

  //--------------------------------------------------------------------------------------------------------------------

  // Contenedor principal para Quantize y controles
  Item {
    anchors.top: parent.top
    anchors.bottom: parent.bottom
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.margins: 14 * screenScale
    width: Math.max(topRow.width, quantizeText.width, bottomRow.width) + (20 * screenScale)

    // Fila superior de botones
    Row {
      id: topRow
      anchors.top: parent.top
      anchors.topMargin: 12 * screenScale
      anchors.horizontalCenter: parent.horizontalCenter
      spacing: 8 * screenScale

      // Botón incrementar cuantización
      Rectangle {
        width: 40 * screenScale
        height: 20 * screenScale
        radius: 2 * screenScale
        color: colors.colorGrey40
        border.color: colors.colorWhite
        border.width: 1

        Text {
          anchors.centerIn: parent
          text: "+"
          font.pixelSize: fonts.middleFontSize * screenScale
          font.family: prefs.normalFontName
          color: colors.colorWhite
        }

        MouseArea {
          anchors.fill: parent
          onClicked: quantizeAdjust.adjustQuantize(1)
          onPressed: parent.color = colors.colorGrey60
          onReleased: parent.color = colors.colorGrey40
        }
      }

      // Botón decrementar cuantización
      Rectangle {
        width: 40 * screenScale
        height: 20 * screenScale
        radius: 2 * screenScale
        color: colors.colorGrey40
        border.color: colors.colorWhite
        border.width: 1

        Text {
          anchors.centerIn: parent
          text: "-"
          font.pixelSize: fonts.middleFontSize * screenScale
          font.family: prefs.normalFontName
          color: colors.colorWhite
        }

        MouseArea {
          anchors.fill: parent
          onClicked: quantizeAdjust.adjustQuantize(-1)
          onPressed: parent.color = colors.colorGrey60
          onReleased: parent.color = colors.colorGrey40
        }
      }
    }

    // Título
    Text {
      anchors.right: quantizeText.left
      anchors.rightMargin: 15 * screenScale
      anchors.verticalCenter: quantizeText.verticalCenter

      font.pixelSize: fonts.largeFontSize * screenScale
      font.family: prefs.normalFontName

      color: colors.colorCenterOverlayHeadline
      text: "QUANTIZE"
    }

    // Valor de cuantización
    Text {
      id: quantizeText
      anchors.centerIn: parent

      font.pixelSize: fonts.extraLargeFontSizePlus * screenScale
      font.family: prefs.normalFontName

      color: colors.colorWhite    
      text: isQuantize.value ? quantize.description : "OFF"
    }

    // Fila inferior de botones
    Row {
      id: bottomRow
      anchors.top: quantizeText.bottom
      anchors.topMargin: 2 * screenScale
      anchors.horizontalCenter: parent.horizontalCenter
      spacing: 8 * screenScale

      // Botón activar/desactivar
      Rectangle {
        width: 90 * screenScale
        height: 20 * screenScale
        radius: 2 * screenScale
        color: isQuantize.value ? colors.colorGrey72 : colors.colorGrey40
        border.color: colors.colorWhite
        border.width: 1

        Text {
          anchors.centerIn: parent
          text: isQuantize.value ? "ON" : "OFF"
          font.pixelSize: fonts.middleFontSize * screenScale
          font.family: prefs.normalFontName
          color: colors.colorWhite
        }

        MouseArea {
          anchors.fill: parent
          onClicked: quantizeAdjust.toggleQuantize()
          onPressed: parent.color = colors.colorGrey60
          onReleased: parent.color = isQuantize.value ? colors.colorGrey72 : colors.colorGrey40
        }
      }
    }
  }
}
