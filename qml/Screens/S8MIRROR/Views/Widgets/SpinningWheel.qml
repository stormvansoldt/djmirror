import QtQuick
import Qt5Compat.GraphicalEffects

Item {
  property color textColor: colors.colorFontBlack
  property int   circleWidth: 3 * screenScale
  property bool  spinning: false
  property real screenScale: prefs.screenScale
  
  width: 32 * screenScale
  height: width
  anchors.topMargin: -1 * screenScale
  anchors.leftMargin: -1 * screenScale

  Rectangle {
    id: gradientContainer
    width:  parent.width
    height: parent.height
    color:  "transparent"
    clip: false // true
    radius: width * 0.5
    border.width: 2 * screenScale
    border.color: textColor
  }

  // ConicalGradient {
  //   id: loopGradient2
  //   anchors.fill: gradientContainer

  //   angle: 0.0
  //   RotationAnimation on rotation {
  //     loops:    Animation.Infinite
  //     from:     0
  //     to:       360
  //     duration: 500
  //   }
  //   gradient: Gradient {
  //     GradientStop {position: 1.0; color: textColor}
  //     GradientStop {position: 0.0; color: "transparent"}
  //   }
  // }
  
  // Rectangle {
  //   id: outerCover
  //   width: 46 * screenScale
  //   height: width
  //   radius: width * 0.5
  //   color: spinning ? "transparent" : textColor
  //   border.color: "black"
  //   border.width: 8 * screenScale
  //   anchors.horizontalCenter: gradientContainer.horizontalCenter
  //   anchors.verticalCenter: gradientContainer.verticalCenter
  // }

  // Rectangle {
  //   id: innerCover
  //   width: 26 * screenScale
  //   height: width
  //   radius: width * 0.5
  //   color: "black"
  //   anchors.horizontalCenter: gradientContainer.horizontalCenter
  //   anchors.verticalCenter: gradientContainer.verticalCenter
  // }
}
