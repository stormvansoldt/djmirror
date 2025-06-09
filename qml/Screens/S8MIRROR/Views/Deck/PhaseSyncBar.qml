import QtQuick 2.0

//--------------------------------------------------------------------------------------------------------------------
//  PHASE SYNC BAR
//--------------------------------------------------------------------------------------------------------------------

Rectangle {
  property real screenScale: prefs.screenScale

  property double currentPhase: 0

  width: 300 * screenScale  // Escalar ancho
  height: 4 * screenScale   // Escalar altura
  color: "#444444"

  Rectangle {
    width: computeWidth(parent.width, currentPhase) 
    height: parent.height
    x: (currentPhase < 0) ? parent.width/2 - width : parent.width/2
    color: colors.colorDeckBlueDark

    function computeWidth(w, value) { 
      if (value < 0) value = value * -1;
      return w * value / 2.0; 
    }

    Rectangle {// bright line in the phase bar
      height: parent.height
      width: 1 * screenScale  // Escalar ancho
      color: colors.colorDeckBlueBright
      x: (currentPhase < 0) ? 0 : parent.width - (1 * screenScale)  // Ajustar posición con el ancho escalado
    }
  }
  Rectangle {// white line: center indicator
    height: parent.height
    width: 1 * screenScale  // Escalar ancho
    color: "white"
    anchors.centerIn: parent
  }
  Rectangle {// white line: right quater indicator
    height: parent.height
    width: 1 * screenScale  // Escalar ancho
    color: "white"
    x: parent.width*3/4
  }
  Rectangle {// white line: left quater indicator
    height: parent.height
    width: 1 * screenScale  // Escalar ancho
    color: "white"
    x: parent.width/4
  }
}
