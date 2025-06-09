import CSI 1.0
import QtQuick
import Qt5Compat.GraphicalEffects

import '../Widgets' as Widgets

Item {
  id: softTakeoverFaders

  property real screenScale: prefs.screenScale
    
  height: 81 * screenScale  // Escalar altura
  anchors.left:  parent.left
  anchors.right: parent.right
  
  // Añadir property para controlar visibilidad y por defecto el control está oculto
  visible: false
  
  // Temporizador para ocultar después de un tiempo
  Timer {
    id: hideTimer
    interval: 2000  // 2 segundos
    running: false
    repeat: false
    onTriggered: {
      softTakeoverFaders.visible = false
    }
  }
  
  // Función para mostrar el control temporalmente
  function showControl() {
    visible = true
    hideTimer.restart()
  }

  // dark grey background
  Rectangle {
    anchors.fill: parent
    color: colors.colorFxHeaderBg
  }

  // dividers
  Repeater {
    model: 3
    Rectangle {
      width: 1 * screenScale  // Escalar ancho
      height: 75 * screenScale  // Escalar altura
      color: colors.colorDivider
      anchors.bottom: parent.bottom
      anchors.left: parent.left
      anchors.leftMargin: (index + 1) * (120 * screenScale)  // Escalar margen
    }
  }

  // faders
  MappingProperty { 
    id: fader_active1
    path: propertiesPath +  ".softtakeover.faders.1.active"
    onValueChanged: softTakeoverFaders.showControl()
  }
  
  MappingProperty { 
    id: fader_active2
    path: propertiesPath +  ".softtakeover.faders.2.active"
    onValueChanged: softTakeoverFaders.showControl()
  }
  
  MappingProperty { 
    id: fader_active3
    path: propertiesPath +  ".softtakeover.faders.3.active"
    onValueChanged: softTakeoverFaders.showControl()
  }
  
  MappingProperty { 
    id: fader_active4
    path: propertiesPath +  ".softtakeover.faders.4.active"
    onValueChanged: softTakeoverFaders.showControl()
  }
  
  MappingProperty { 
    id: fader_inputPosition1
    path: propertiesPath +  ".softtakeover.faders.1.input"
    onValueChanged: softTakeoverFaders.showControl()
  }
  
  MappingProperty { 
    id: fader_inputPosition2
    path: propertiesPath +  ".softtakeover.faders.2.input"
    onValueChanged: softTakeoverFaders.showControl()
  }
  
  MappingProperty { 
    id: fader_inputPosition3
    path: propertiesPath +  ".softtakeover.faders.3.input"
    onValueChanged: softTakeoverFaders.showControl()
  }
  
  MappingProperty { 
    id: fader_inputPosition4
    path: propertiesPath +  ".softtakeover.faders.4.input"
    onValueChanged: softTakeoverFaders.showControl()
  }
  
  MappingProperty { 
    id: fader_outputPosition1
    path: propertiesPath +  ".softtakeover.faders.1.output"
    onValueChanged: softTakeoverFaders.showControl()
  }
  
  MappingProperty { 
    id: fader_outputPosition2
    path: propertiesPath +  ".softtakeover.faders.2.output"
    onValueChanged: softTakeoverFaders.showControl()
  }
  
  MappingProperty { 
    id: fader_outputPosition3
    path: propertiesPath +  ".softtakeover.faders.3.output"
    onValueChanged: softTakeoverFaders.showControl()
  }
  
  MappingProperty { 
    id: fader_outputPosition4
    path: propertiesPath +  ".softtakeover.faders.4.output"
    onValueChanged: softTakeoverFaders.showControl()
  }

  property variant fader_inputPosition: [fader_inputPosition1.value,    fader_inputPosition2.value,    fader_inputPosition3.value,    fader_inputPosition4.value   ]
  property variant fader_outputPosition:[fader_outputPosition1.value,   fader_outputPosition2.value,   fader_outputPosition3.value,   fader_outputPosition4.value  ]
  property variant fader_active:        [fader_active1.value,           fader_active2.value,           fader_active3.value,           fader_active4.value          ]

  Row {
    Repeater {
      model: 4

      Item {
        width: softTakeoverFaders.width / 4
        height: softTakeoverFaders.height

        Widgets.Fader {
          anchors.centerIn: parent
          internalValue:  fader_inputPosition[index]
          hardwareValue:  fader_outputPosition[index]
          mismatch:       fader_active[index]
        }
      }
    }
  }

  // black border & shadow
  Rectangle {
    id: headerBlackLine
    anchors.bottom: softTakeoverFaders.top
    width:          parent.width
    height:         1 * screenScale  // Escalar altura
    color:          colors.colorBlack
  }
}


