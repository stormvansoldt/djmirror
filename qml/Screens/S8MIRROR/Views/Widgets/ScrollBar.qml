import QtQuick;

import '../../../Defines' as Defines


Rectangle {
  id: scrollbar;

  property Flickable flickable:  null
  property color handleColor: colors.colorWhite // set in handle
  property real screenScale: prefs.screenScale

  //--------------------------------------------------------------------------------------------------------------------

  readonly property real handlePos: flickable.contentY * handle.maximumY / (flickable.contentHeight - flickable.height)

  Defines.Colors { id: colors }

  opacity: 0
  width:   1 * screenScale  // Escalar ancho de la barra
  visible: (flickable.visibleArea.heightRatio < 1.0)

  color:                "transparent"
  anchors.top:          parent.top 
  anchors.right:        parent.right 
  anchors.bottom:       parent.bottom 
  anchors.rightMargin:  2 * screenScale  // Escalar margen derecho
  anchors.topMargin:    17 * screenScale   // Escalar margen superior
  anchors.bottomMargin: 17 * screenScale  // Escalar margen inferior

  
  //--------------------------------------------------------------------------------------------------------------------

  Rectangle {
    id: handle
    
    readonly property int  margin:   0
    readonly property real minimumY: margin
    readonly property real maximumY: parent.height - height - margin

    y:               Math.max( minimumY , Math.min( maximumY , scrollbar.handlePos ) )
    height:          Math.max(20 * screenScale, (flickable.visibleArea.heightRatio * scrollbar.height))  // Escalar altura mínima
    radius:          parent.radius
    anchors.left:    parent.left
    anchors.right:   parent.right
    anchors.margins: margin
    color:           parent.handleColor
  }

}
