import QtQuick
import Traktor.Gui 1.0 as Traktor

/**
 * @brief Componente que dibuja un triángulo equilátero
 * 
 * Este componente utiliza Traktor.Polygon para crear un triángulo personalizable.
 * El triángulo se dibuja apuntando hacia abajo, con la base en la parte superior.
 * 
 * @property {color} color - Color de relleno del triángulo. Por defecto usa "black"
 * @property {int} borderWidth - Ancho del borde del triángulo. Por defecto es 0 (sin borde)
 * @property {color} borderColor - Color del borde del triángulo. Por defecto es "transparent"
 * @property {bool} antialiasing - Propiedad alias para habilitar/deshabilitar el antialiasing
 * 
 * Ejemplo de uso:
 * ```qml
 * Triangle {
 *     width: 20
 *     height: 10
 *     color: "red"
 *     borderWidth: 1
 *     borderColor: "black"
 * }
 * ```
 */

Item {
  property color color:        "black"
  property int   borderWidth:  0
  property color borderColor:  "transparent"

  property alias antialiasing: triangle.antialiasing

  clip: false

  Traktor.Polygon {
    id: triangle
    anchors.centerIn: parent
    color:            parent.color

    border.width:     parent.borderWidth
    border.color:     parent.borderColor

    opacity:          1.0
    clip:             false
    visible:          parent.visible

    points:           [ Qt.point(0, 0), Qt.point(parent.width, 0), Qt.point(0.5* parent.width, parent.height)]
  }
}
