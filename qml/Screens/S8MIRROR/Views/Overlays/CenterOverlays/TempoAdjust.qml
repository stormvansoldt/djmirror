import QtQuick
import CSI 1.0

import '../../../../Defines' as Defines


// dimensions are set in CenterOverlay.qml

CenterOverlay {
  id: tempoAdjust

  property real screenScale: prefs.screenScale

  Defines.Margins { id: customMargins }

  property int deckId: 0

  readonly property bool isSyncedToOtherDeck: (masterDeckId.value != deckId) && isSynced.value
  readonly property bool isSyncedToMasterClock: (masterDeckId.value == -1) && isSynced.value
  
  //--------------------------------------------------------------------------------------------------------------------

  AppProperty { id: isSynced;   path: "app.traktor.decks." + (deckId+1) + ".sync.enabled" }
  AppProperty { id: stableBpm;  path: "app.traktor.decks." + (deckId+1) + ".tempo.true_bpm" }
  AppProperty { id: baseBpm;    path: "app.traktor.decks." + (deckId+1) + ".tempo.base_bpm" }
  AppProperty { id: tempoAdjustment; path: "app.traktor.decks." + (deckId+1) + ".tempo.adjust" }
  
  AppProperty { id: masterDeckId;   path: "app.traktor.masterclock.source_id" }
  AppProperty { id: masterClockBpm; path: "app.traktor.masterclock.tempo" }
  
  //--------------------------------------------------------------------------------------------------------------------

  function titleForBPMOverlay(masterId, synced)
  {
    if ((masterId == -1) && synced) {
      return "MASTER CLOCK BPM";
    }
    else if (masterId == deckId) {
      return "MASTER BPM";
    }
    else if (synced) {
      return "SYNCED BPM";
    }
    else {
      return "BPM";
    }
  }

  // Función para ajustar el tempo
  function adjustTempo(increment) {
    if (!isSyncedToMasterClock && !isSyncedToOtherDeck) {
      var currentAdjust = tempoAdjustment.value || 0
      var newAdjust = currentAdjust + increment

      tempoAdjustment.value = newAdjust
    }
  }

  // Función para resetear el tempo
  function resetTempo() {
    if (!isSyncedToMasterClock && !isSyncedToOtherDeck) {
      tempoAdjustment.value = 0
    }
  }

  //--------------------------------------------------------------------------------------------------------------------

  // Contenedor principal para BPM y controles
  Item {
    anchors.top: parent.top
    anchors.bottom: parent.bottom
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.margins: 14 * screenScale
    width: Math.max(topRow.width, bpmText.width, bottomRow.width) + (20 * screenScale)

    // Fila superior de botones
    Row {
      id: topRow
      anchors.top: parent.top
      anchors.topMargin: 12 * screenScale
      anchors.horizontalCenter: parent.horizontalCenter
      spacing: 8 * screenScale
      visible: !isSyncedToMasterClock && !isSyncedToOtherDeck

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
          text: "+10%"
          font.pixelSize: fonts.middleFontSize * screenScale
          font.family: prefs.normalFontName
          color: colors.colorWhite
        }

        MouseArea {
          anchors.fill: parent
          onClicked: tempoAdjust.adjustTempo(0.1)
          onPressed: parent.color = colors.colorGrey60
          onReleased: parent.color = colors.colorGrey40
        }
      }

      // Botón +1%
      Rectangle {
        width: 40 * screenScale
        height: 20 * screenScale
        radius: 2 * screenScale
        color: colors.colorGrey40
        border.color: colors.colorWhite
        border.width: 1

        Text {
          anchors.centerIn: parent
          text: "+1%"
          font.pixelSize: fonts.middleFontSize * screenScale
          font.family: prefs.normalFontName
          color: colors.colorWhite
        }

        MouseArea {
          anchors.fill: parent
          onClicked: tempoAdjust.adjustTempo(0.01)
          onPressed: parent.color = colors.colorGrey60
          onReleased: parent.color = colors.colorGrey40
        }
      }

      // Botón -1%
      Rectangle {
        width: 40 * screenScale
        height: 20 * screenScale
        radius: 2 * screenScale
        color: colors.colorGrey40
        border.color: colors.colorWhite
        border.width: 1

        Text {
          anchors.centerIn: parent
          text: "-1%"
          font.pixelSize: fonts.middleFontSize * screenScale
          font.family: prefs.normalFontName
          color: colors.colorWhite
        }

        MouseArea {
          anchors.fill: parent
          onClicked: tempoAdjust.adjustTempo(-0.01)
          onPressed: parent.color = colors.colorGrey60
          onReleased: parent.color = colors.colorGrey40
        }
      }

      // Botón -10%
      Rectangle {
        width: 40 * screenScale
        height: 20 * screenScale
        radius: 2 * screenScale
        color: colors.colorGrey40
        border.color: colors.colorWhite
        border.width: 1

        Text {
          anchors.centerIn: parent
          text: "-10%"
          font.pixelSize: fonts.middleFontSize * screenScale
          font.family: prefs.normalFontName
          color: colors.colorWhite
        }

        MouseArea {
          anchors.fill: parent
          onClicked: tempoAdjust.adjustTempo(-0.1)
          onPressed: parent.color = colors.colorGrey60
          onReleased: parent.color = colors.colorGrey40
        }
      }
    }

    // headline
    Text {
      anchors.right: bpmText.left
      anchors.rightMargin: 15 * screenScale
      anchors.verticalCenter: bpmText.verticalCenter

      font.pixelSize:           fonts.largeFontSize * screenScale
      font.family:              prefs.normalFontName

      color:                    colors.colorCenterOverlayHeadline
      text: titleForBPMOverlay(masterDeckId.value, isSynced.value)
    }

    // BPM central
    Text {
      id: bpmText
      readonly property real dispBpm: isSyncedToMasterClock ? masterClockBpm.value : stableBpm.value
      anchors.centerIn: parent

      font.pixelSize: fonts.extraLargeFontSizePlus * screenScale
      font.family: prefs.normalFontName

      color: colors.colorWhite    
      text: dispBpm.toFixed(2).toString()
    }

    // Porcentaje actual
    Text {
      id: percentText
      anchors.left: bpmText.right
      anchors.leftMargin: 15 * screenScale
      anchors.verticalCenter: bpmText.verticalCenter
      font.pixelSize: fonts.middleFontSize * screenScale
      font.family: prefs.normalFontName
      color: colors.colorGrey72
      text: (tempoAdjustment.value * 100).toFixed(1) + "%"
      visible: !isSyncedToMasterClock && !isSyncedToOtherDeck
    }

    // Fila inferior de botones
    Row {
      id: bottomRow
      anchors.top: bpmText.bottom
      anchors.topMargin: 2 * screenScale
      anchors.horizontalCenter: parent.horizontalCenter
      spacing: 4 * screenScale
      visible: !isSyncedToMasterClock && !isSyncedToOtherDeck

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
          onClicked: tempoAdjust.resetTempo()
          onPressed: parent.color = colors.colorGrey60
          onReleased: parent.color = colors.colorGrey40
        }
      }
    }
  }
}
