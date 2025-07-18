import QtQuick 2.0
Item {
  id: knobLabelBar

  property real screenScale: prefs.screenScale

  property alias value: valueBar.value
  property alias label: labelText.text

  width: 100 * screenScale
  height: 60 * screenScale
  
  //--------------------------------------------------------------------------------------------------------------------

  ProgressBar {   id: valueBar
    anchors {
      bottom: parent.bottom
      bottomMargin: (2 * height) - (2 * screenScale)
      left:   parent.left
      right:  parent.right
    }
  }

  //--------------------------------------------------------------------------------------------------------------------

  Text {
   id: valueText

    anchors {
      bottom:  valueBar.top;  bottomMargin: 5 * screenScale
      horizontalCenter:  parent.horizontalCenter
    }

    text: knobLabelBar.value.toLocaleString( Qt.locale("en_US") )
    color: '#eee'

    font {
      family: "Arial"
      pixelSize: 16 * screenScale
    }
  }

  //--------------------------------------------------------------------------------------------------------------------

  Text {
   id: labelText

    anchors {
      bottom:  valueText.top
      bottomMargin: 5 * screenScale
      horizontalCenter:  parent.horizontalCenter
    }

    text:  'my label'
    color: '#eee'

    font {
      family: 'Arial'
      pixelSize: 16 * screenScale
    }
  }
}
