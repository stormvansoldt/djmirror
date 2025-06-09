import QtQuick
import CSI 1.0

import '../../../../Defines' as Defines


// dimensions are set in CenterOverlay.qml

CenterOverlay {
  id: swingAdjust

  property real screenScale: prefs.screenScale

  Defines.Margins { id: customMargins }
  
  property int  deckId: 0


  //--------------------------------------------------------------------------------------------------------------------
  AppProperty { id: swing;    path: "app.traktor.decks." + (deckId+1) + ".remix.sequencer.swing"; }

  //--------------------------------------------------------------------------------------------------------------------

  // Función para ajustar el valor de swing
  function adjustSwing(increment) {
    var newValue = swing.value + increment
    // Verificar que el valor esté dentro del rango permitido (0-100)
    if (newValue >= 0 && newValue <= 100) {
      swing.value = newValue
    }
  }

  //--------------------------------------------------------------------------------------------------------------------

  // Contenedor principal para Swing y controles
  Item {
    anchors.top: parent.top
    anchors.bottom: parent.bottom
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.margins: 14 * screenScale
    width: Math.max(topRow.width, swingText.width, bottomRow.width) + (20 * screenScale)

    // Fila superior de botones
    Row {
      id: topRow
      anchors.top: parent.top
      anchors.topMargin: 12 * screenScale
      anchors.horizontalCenter: parent.horizontalCenter
      spacing: 8 * screenScale

      // Botón +10%
      Rectangle {
        width: 40 * screenScale
        height: 20 * screenScale
        radius: 2 * screenScale
        color: colors.colorGrey40
        border.color: colors.colorWhite
        border.width: 1

        Text {
          anchors.centerIn: parent
          text: "+10"
          font.pixelSize: fonts.middleFontSize * screenScale
          font.family: prefs.normalFontName
          color: colors.colorWhite
        }

        MouseArea {
          anchors.fill: parent
          onClicked: swingAdjust.adjustSwing(10)
          onPressed: parent.color = colors.colorGrey60
          onReleased: parent.color = colors.colorGrey40
        }
      }

      // Botón +1
      Rectangle {
        width: 40 * screenScale
        height: 20 * screenScale
        radius: 2 * screenScale
        color: colors.colorGrey40
        border.color: colors.colorWhite
        border.width: 1

        Text {
          anchors.centerIn: parent
          text: "+1"
          font.pixelSize: fonts.middleFontSize * screenScale
          font.family: prefs.normalFontName
          color: colors.colorWhite
        }

        MouseArea {
          anchors.fill: parent
          onClicked: swingAdjust.adjustSwing(1)
          onPressed: parent.color = colors.colorGrey60
          onReleased: parent.color = colors.colorGrey40
        }
      }

      // Botón -1
      Rectangle {
        width: 40 * screenScale
        height: 20 * screenScale
        radius: 2 * screenScale
        color: colors.colorGrey40
        border.color: colors.colorWhite
        border.width: 1

        Text {
          anchors.centerIn: parent
          text: "-1"
          font.pixelSize: fonts.middleFontSize * screenScale
          font.family: prefs.normalFontName
          color: colors.colorWhite
        }

        MouseArea {
          anchors.fill: parent
          onClicked: swingAdjust.adjustSwing(-1)
          onPressed: parent.color = colors.colorGrey60
          onReleased: parent.color = colors.colorGrey40
        }
      }

      // Botón -10
      Rectangle {
        width: 40 * screenScale
        height: 20 * screenScale
        radius: 2 * screenScale
        color: colors.colorGrey40
        border.color: colors.colorWhite
        border.width: 1

        Text {
          anchors.centerIn: parent
          text: "-10"
          font.pixelSize: fonts.middleFontSize * screenScale
          font.family: prefs.normalFontName
          color: colors.colorWhite
        }

        MouseArea {
          anchors.fill: parent
          onClicked: swingAdjust.adjustSwing(-10)
          onPressed: parent.color = colors.colorGrey60
          onReleased: parent.color = colors.colorGrey40
        }
      }
    }

    // Título
    Text {
      anchors.right: swingText.left
      anchors.rightMargin: 15 * screenScale
      anchors.verticalCenter: swingText.verticalCenter

      font.pixelSize: fonts.largeFontSize * screenScale
      font.family: prefs.normalFontName

      color: colors.colorCenterOverlayHeadline
      text: "SWING"
    }

    // Valor de swing
    Text {
      id: swingText
      anchors.centerIn: parent

      font.pixelSize: fonts.extraLargeFontSizePlus * screenScale
      font.family: prefs.normalFontName

      color: colors.colorWhite    
      text: swing.description
    }

    // Fila inferior de botones
    Row {
      id: bottomRow
      anchors.top: swingText.bottom
      anchors.topMargin: 2 * screenScale
      anchors.horizontalCenter: parent.horizontalCenter
      spacing: 8 * screenScale

      // Botón RESET
      Rectangle {
        width: 40 * screenScale
        height: 20 * screenScale
        radius: 2 * screenScale
        color: colors.colorGrey40
        border.color: colors.colorWhite
        border.width: 1

        Text {
          anchors.centerIn: parent
          text: "RESET"
          font.pixelSize: fonts.middleFontSize * screenScale
          font.family: prefs.normalFontName
          color: colors.colorWhite
        }

        MouseArea {
          anchors.fill: parent
          onClicked: swing.value = 0 // Resetear a 0 (sin swing)
          onPressed: parent.color = colors.colorGrey60
          onReleased: parent.color = colors.colorGrey40
        }
      }
    }
  }
}
