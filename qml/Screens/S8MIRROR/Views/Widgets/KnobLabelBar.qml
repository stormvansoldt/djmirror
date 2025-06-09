import QtQuick

//----------------------------------------------------------------------------------------------------------------------
// KNOB LABEL BAR
//
Item {
  id: knobLabelBar

  property real screenScale: prefs.screenScale
  
  width: 100 * screenScale
  height: 80 * screenScale

  property real value: 0.2

  onValueChanged: {
    if (value > 1.0) value = 1.0
    if (value < 0.0) value = 0.0
  }

  // Value Indicator
  ProgressBar {
    id: valueBar
    value: knobLabelBar.value
    anchors {
      bottom: parent.bottom
      left: parent.left
      right: parent.right
    }
  }
}