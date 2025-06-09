import QtQuick

Rectangle {
  property color  cellColor   : "black"
  property color  textColor   : "white"
  property real   screenScale : 2.0
  property int    cellSize    : 65 * screenScale
  property int    cellRadius  : 5 * screenScale
  property bool   isLoop      : false
  property bool   withIcon    : true
  property int    slotId      : -1
  property var    deckInfo

  signal cellClicked(int slotId)

  id                          : cell
  color                       : cellColor
  width                       : cellSize
  height                      : cellSize
  radius                      : cellRadius

  Image {
    id: remixCellImage
    anchors.centerIn:     parent
    width:                cellSize*0.65    
    visible:              withIcon
    source:               isLoop ? "../../Images/RemixAssets/Sample_Loop.png" : "../../Images/RemixAssets/Sample_OneShot.png"
    fillMode:             Image.PreserveAspectFit
  } 
}
