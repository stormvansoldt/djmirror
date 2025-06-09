import QtQuick
import QtQuick.Layouts 1.1
import '../Views'

//----------------------------------------------------------------------------------------------------------------------
//  Remix Deck Overlay - for sample volume and filter value editing
//----------------------------------------------------------------------------------------------------------------------


Item {
  id: display

  Colors { id: colors }
  Dimensions { id: dimensions }
  
  // MODEL PROPERTIES //
  property var deckInfo: ({})
  property int slotId: 1 //should be always a valid slot
  property real screenScale: prefs.screenScale

  // fetch data
  property var slot: deckInfo.getSlot(slotId)
  property var activeCellIdx: slot.activeCellIdx
  property var activeCell: slot.getCell(activeCellIdx)

  // Dimensiones principales escaladas
  width: 320 * screenScale
  height: 240 * screenScale
 
  // LAYOUT + DESIGN //
  property real infoBoxesWidth: dimensions.infoBoxesWidth * screenScale
  property real firstRowHeight: dimensions.firstRowHeight * screenScale
  property real secondRowHeight: dimensions.secondRowHeight * screenScale
  property real remixCellWidth: dimensions.thirdRowHeight * screenScale
  property real screenTopMargin: dimensions.screenTopMargin * screenScale
  property real screenLeftMargin: dimensions.screenLeftMargin * screenScale

  property real boxesRadius: 5 * screenScale
  property real cellSpacing: dimensions.spacing * screenScale
  property real textMargin: 13 * screenScale

  property variant lightGray: colors.colorDeckGrey
  property variant darkGray: colors.colorDeckDarkGrey

  ColumnLayout {
    spacing: display.cellSpacing
    anchors.top: parent.top
    anchors.topMargin: display.screenTopMargin
    anchors.left: parent.left
    anchors.leftMargin: display.screenLeftMargin

    DeckHeader {
      title: display.activeCell.name
      height: display.firstRowHeight
      width: 2*display.infoBoxesWidth + display.cellSpacing
    }

    RowLayout {
      spacing: display.cellSpacing

      // VOLUME LABEL //
      Rectangle {
        height: display.firstRowHeight
        width: display.infoBoxesWidth
        color: !display.slot.muted ? display.activeCell.midColor : colors.darkerColor(display.activeCell.midColor, 0.5)
        radius: display.boxesRadius

        Text {
          text: "Volume"
          font.pixelSize: fonts.largeFontSizePlusPlus * screenScale
          font.family: prefs.normalFontName
          font.weight: Font.Normal
          color: !display.slot.muted ? prefs.colorFontWhite : prefs.colorFontGrey
          anchors.fill: parent
          horizontalAlignment: Text.AlignHCenter
          verticalAlignment: Text.AlignVCenter
        }
      }

      // FILTER LABEL //
      Rectangle {
        height: display.firstRowHeight
        width: display.infoBoxesWidth
        color: display.slot.filterOn ? display.activeCell.midColor : colors.darkerColor(display.activeCell.midColor, 0.5)
        radius: display.boxesRadius

        Text {
          text: "Filter"
          font.pixelSize: fonts.largeFontSizePlusPlus * screenScale
          font.family: prefs.normalFontName
          font.weight: Font.Normal
          color: display.slot.filterOn ? prefs.colorFontWhite : prefs.colorFontGrey
          anchors.fill: parent
          anchors.rightMargin: display.textMargin
          anchors.leftMargin: display.textMargin
          horizontalAlignment: Text.AlignHCenter
          verticalAlignment: Text.AlignVCenter
        }
      }
    }

    RowLayout {
      spacing: display.cellSpacing
      
      // VOLUME SLIDER //
      Slider {
        width: display.infoBoxesWidth
        height: display.secondRowHeight
        min: 0
        max: 1
        value: display.slot.volume
        radius: dimensions.cornerRadius * screenScale

        backgroundColor: !display.slot.muted ? display.activeCell.midColor : colors.darkerColor(display.activeCell.midColor, 0.5)
        sliderColor: !display.slot.muted ? display.activeCell.brightColor : display.activeCell.midColor
        cursorColor: !display.slot.muted ? "white" : "grey"
      }

      // FILTER SLIDER //
      Slider {
        width: display.infoBoxesWidth
        height: display.secondRowHeight
        value: display.slot.filterValue
        min: 0
        max: 1
        centered: true
        radius: dimensions.cornerRadius * screenScale

        backgroundColor: display.slot.filterOn ? display.activeCell.midColor : colors.darkerColor(display.activeCell.midColor, 0.5)
        sliderColor: display.slot.filterOn ? display.activeCell.brightColor : display.activeCell.midColor
        cursorColor: display.slot.filterOn ? "white" : "grey"
        centerColor: colors.defaultBackground
      }
    }
  }
}
