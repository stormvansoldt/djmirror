import QtQuick

//----------------------------------------------------------------------------------------------------------------------
// KNOB LABEL BAR
//
Item {
  id: knobLabelBar

  width: 100
  height: 80

  property real value: 0.2

  onValueChanged: {
    if ( value > 1.0 ) value = 1.0
    if ( value < 0.0 ) value = 0.0
  }

  // Value Indicator
  ProgressBar {   id: valueBar
    value: knobLabelBar.value
    anchors {
      bottom:  parent.bottom
      left:  parent.left
      right:  parent.right
    }
  }
}