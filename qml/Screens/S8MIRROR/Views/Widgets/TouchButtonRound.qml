import QtQuick
import QtQuick.Window 2.15
import Qt5Compat.GraphicalEffects

//--------------------------------------------------------------------------------------------------------------------
// Botón de carga para interfaz táctil
Rectangle {
  id: touchButtonRound

  property real screenScale: prefs.screenScale

  property string text: ""
  property string icon: ""
  property bool isActive: false
  
  // Señales para los eventos del botón
  signal clicked()
  signal pressed()
  signal released()


  width: 40 * screenScale
  height: 40 * screenScale
  radius: width / 2
  color: isActive ? colors.colorMixerFXBlue : colors.colorGrey64
  opacity: 0.85
  z: 10 // Para asegurar que está por encima

  // Añadir un borde sutil para mejorar la definición visual
  border.width: 1 * screenScale
  border.color: isActive ? colors.colorMixerFXBlue : colors.colorGrey88

  // Añadir gradiente para efecto de iluminación
  gradient: Gradient {
      GradientStop { position: 0.0; color: isActive ? Qt.lighter(colors.colorMixerFXBlue, 1.1) : colors.colorGrey80 }
      GradientStop { position: 1.0; color: isActive ? Qt.darker(colors.colorMixerFXBlue, 1.1) : colors.colorGrey56 }
  }

  // Contenedor para centrar icono y texto
  Item {
    anchors.centerIn: parent
    width: parent.width * 0.8
    height: parent.height * 0.8

    // Icono del botón
    Text {
      id: iconText
      anchors.horizontalCenter: parent.horizontalCenter
      anchors.top: parent.top
      anchors.topMargin: 3 * screenScale
      text: touchButtonRound.icon
      color: colors.colorWhite
      font.pixelSize: fonts.miniFontSizePlus * 1.3 * screenScale
      font.bold: true
      visible: touchButtonRound.icon !== ""
      opacity: 0.95
    }

    // Texto del botón
    Text {
      anchors.horizontalCenter: parent.horizontalCenter
      anchors.bottom: parent.bottom
      anchors.bottomMargin: 3 * screenScale
      text: touchButtonRound.text
      color: colors.colorWhite
      font.pixelSize: fonts.miniFontSizePlus * 0.85 * screenScale
      font.bold: true
      font.family: prefs.normalFontName
    }
    
    // Mejorar el efecto de iluminación en la parte inferior
    Rectangle {
        id: highlight
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: -0.8 * screenScale
        width: parent.width * 0.4
        height: parent.height * 0.08
        radius: (width / 2) * 0.8
        color: colors.colorWhite
        opacity: 0.12
    }
  }

  MouseArea {
    anchors.fill: parent
    onClicked: {
      touchButtonRound.clicked()
    }
    onPressed: {
      touchButtonRound.pressed()
      touchButtonRound.opacity = 0.7
      touchButtonRound.scale = 0.95 // Escalar ligeramente hacia abajo para efecto de pulsación
      highlight.opacity = 0.1
    }
    onReleased: {
      touchButtonRound.released()
      touchButtonRound.opacity = 0.85
      touchButtonRound.scale = 1.0 // Restaurar escala
      highlight.opacity = 0.25
    }
  }

  // Añadir animación al cambiar de estado y escala
  Behavior on color {
      ColorAnimation { 
          duration: 150
          easing.type: Easing.OutQuad
      }
  }
  
  Behavior on scale {
      NumberAnimation {
          duration: 100
          easing.type: Easing.OutCubic
      }
  }
}
