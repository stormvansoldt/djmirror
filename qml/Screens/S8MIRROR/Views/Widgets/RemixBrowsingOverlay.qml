import QtQuick
import QtQuick.Layouts 1.1
import "../Views"
import "../ViewModels"

//----------------------------------------------------------------------------------------------------------------------
//  Remix Deck Overlay - for sample volume and filter value editing
//----------------------------------------------------------------------------------------------------------------------


Item {
  id: display

  property real screenScale: prefs.screenScale

  //to be set when using the object
  property var    deckInfo: ({})
  property int    slotId:    1

  property var slot: deckInfo.getSlot(slotId)
  property int activeCellIdx: slot.activeCellIdx

  property var topCell:    slot.getCell(activeCellIdx - 1)
  property var middleCell: slot.getCell(activeCellIdx )
  property var bottomCell: slot.getCell(activeCellIdx + 1)

  function isValid( cell )      { return typeof cell !== "undefined"; }
  function isActiveCell( cell ) { if(isValid(cell)) return cell.cellId == slot.activeCellIdx; return false; }
  function getName( cell )      { 
    if(isValid(cell)) {
      return getIsEmpty(cell) ? "Cell " + cell.cellId : cell.name;
    }
    return "Empty cell ";
  }
    
  function getIsLoop( cell )    { if(isValid(cell)) return cell.isLooped;  return ""; }
  function getColor( cell )     { if(isValid(cell)) return cell.color; return "grey"; }
  function getIsEmpty( cell )   { if(isValid(cell)) return cell.isEmpty; return true;}
  function getIconColor( cell ) {
    if(isValid(cell)) {
      return getIsEmpty( cell ) ? colors.colorDeckBrightGrey : getColor( cell );  
    }
    return colors.defaultBackground;
  }

  Colors {id: colors}
  Dimensions {id: dimensions}

  width  : 320 * screenScale
  height : 240 * screenScale

  // LAYOUT + DESIGN //
  property real infoBoxesWidth:   dimensions.infoBoxesWidth * screenScale
  property real secondRowHeight:  dimensions.secondRowHeight * screenScale
  property real remixCellWidth:   dimensions.thirdRowHeight * screenScale
  property real screenTopMargin:  (dimensions.screenTopMargin + 4) * screenScale
  property real screenLeftMargin: dimensions.screenLeftMargin * screenScale

  property real boxesRadius:  dimensions.cornerRadius * screenScale
  property real cellSpacing:  dimensions.spacing * screenScale
  property real textMargin:   9 * screenScale

  property variant lightGray: colors.colorDeckGrey
  property variant darkGray:  colors.colorDeckDarkGrey

  Rectangle {
    width: display.width
    height: display.height
    color: colors.defaultBackground

    Column {
      spacing: display.cellSpacing 
      anchors.top: parent.top
      anchors.topMargin: display.screenTopMargin
      anchors.left: parent.left
      anchors.leftMargin: display.screenLeftMargin

      Repeater {
        model: [display.topCell, display.middleCell, display.bottomCell]

        Rectangle {
          height:   display.remixCellWidth
          width:    dimensions.largeBoxWidth * screenScale
          radius:   dimensions.cornerRadius * screenScale
          color:    isActiveCell(modelData) ? colors.colorDeckGrey : colors.defaultBackground

          Row {
            spacing: display.textMargin
            visible:  isValid( modelData )

            RemixCell {
              cellColor                   : getIconColor( modelData )
              cellRadius                  : display.boxesRadius 
              cellSize                    : display.remixCellWidth
              isLoop                      : getIsLoop( modelData ) 
              withIcon                    : !getIsEmpty( modelData )
              screenScale                 : display.screenScale  // Pasar el factor de escala
            }

            Text { 
              text: getName(modelData)

              font.pixelSize: fonts.largeFontSizePlusPlus * screenScale
              font.family: prefs.normalFontName
              font.weight: Font.Normal

              color: colors.colorFontWhite

              anchors.verticalCenter: parent.verticalCenter
            }
          }
        }
      }
    }
  }
}
