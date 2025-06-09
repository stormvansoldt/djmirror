import QtQuick

/**
 * NO SE USA!!!!
 * @brief Ventana de error para problemas de Timecode
 * 
 * Muestra una ventana modal con un mensaje de error cuando hay problemas
 * con la señal de Timecode (por ejemplo, canal izquierdo faltante).
 * 
 * Estructura visual:
 * - Ventana semitransparente (300x160px)
 * - Título "TIMECODE"
 * - Ícono de error central
 * - Mensaje de error parpadeante
 * 
 * @component Rectangle
 * @property {number} width - Ancho de la ventana (300px)
 * @property {number} height - Alto de la ventana (160px)
 * @property {number} radius - Radio de las esquinas (7px)
 * @property {string} color - Color de fondo (#aa444444, semitransparente)
 * 
 * Subcomponentes:
 * 1. Ícono (symbol):
 *    - Cuadrado gris de 80x80px
 *    - Línea horizontal negra en el centro
 *    - Borde oscuro y esquinas redondeadas
 * 
 * 2. Textos:
 *    - Título "TIMECODE" (24px, blanco)
 *    - Mensaje de error (20px, rojo #f44)
 * 
 * Animación:
 * - El mensaje de error parpadea suavemente
 * - Frecuencia: 16ms
 * - Opacidad: varía entre 0.6 y 1.0 usando función coseno
 * 
 * Ejemplo de uso:
 * ```qml
 * TimeCodeError {
 *     anchors.centerIn: parent
 *     visible: timecodeErrorDetected
 * }
 * ```
 */

Rectangle {
  property real screenScale: prefs.screenScale

  // Dimensiones principales escaladas
  width:   300 * screenScale
  height:  160 * screenScale
  radius:  7 * screenScale
  color:  '#aa444444'
  border {
    width: 1 * screenScale
    color: '#aaa'
  }

  //--------------------------------------------------------------------------------------------------------------------
  //  ICON
  //--------------------------------------------------------------------------------------------------------------------

  Rectangle  {
    id:  symbol
    anchors.centerIn: parent
    width:  80 * screenScale
    height: 80 * screenScale
    radius: 6 * screenScale
    color:  '#888'
    border {
      width: 2 * screenScale
      color: '#111'
    }

    Rectangle  {
      anchors.centerIn: parent
      width: 60 * screenScale
      height: 2 * screenScale
      color: '#000'
    }
  }

  //--------------------------------------------------------------------------------------------------------------------
  //  TEXT FIELDS
  //--------------------------------------------------------------------------------------------------------------------

  Text  {
    anchors {
      horizontalCenter: symbol.horizontalCenter
      bottom:           symbol.top   
      bottomMargin:     6 * screenScale
    }

    font.pixelSize: fonts.largeFontSizePlusPlus * screenScale
    font.family: prefs.normalFontName

    text: "TIMECODE"
    color: prefs.colorFontWhite
  }


  Text  {
    id:  errorMessage
    anchors {
      horizontalCenter: symbol.horizontalCenter
      top:              symbol.bottom   
      topMargin:        7 * screenScale
    }

    font.pixelSize: fonts.largeFontSizePlus * screenScale
    font.family: prefs.normalFontName

    text: "LEFT CHANNEL MISSING"
    color: prefs.colorFontRed

    Timer {
      property  real  _angle: 0.0
      on_AngleChanged: errorMessage.opacity = 0.6 + 0.4*Math.cos( _angle )

      interval: 16
      running:  true
      repeat:   true

      onTriggered: _angle += 0.1
    }
  }
}
