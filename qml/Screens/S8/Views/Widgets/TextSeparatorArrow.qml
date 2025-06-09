import QtQuick
import Traktor.Gui 1.0 as Traktor

/**
 * @brief Componente que dibuja una flecha como separador de texto
 * 
 * Este componente crea una pequeña flecha usando Traktor.Polygon.
 * Se utiliza típicamente como separador visual entre elementos de texto.
 * 
 * Dimensiones:
 * - Ancho: 6px
 * - Alto: 7px
 * 
 * @component Traktor.Polygon
 * @property {bool} antialiasing - Deshabilitado por defecto para bordes nítidos
 * @property {color} color - Color de relleno de la flecha (negro por defecto)
 * @property {color} border.color - Color del borde (verde por defecto, no visible)
 * @property {int} border.width - Ancho del borde (0 por defecto)
 * 
 * Puntos que forman la flecha:
 * - [0,0] -> Esquina superior izquierda
 * - [3,0] -> Punto superior medio
 * - [6,3.5] -> Punta de la flecha
 * - [3,7] -> Punto inferior medio
 * - [0,7] -> Esquina inferior izquierda
 * - [3,3.5] -> Punto central izquierdo
 * 
 * Ejemplo de uso:
 * ```qml
 * TextSeparatorArrow {
 *     color: "white"
 * }
 * ```
 */

Traktor.Polygon {
  antialiasing: false
  color:        "black" 
  border.color: "green"
  border.width: 0
  points:       [ Qt.point(0, 0), Qt.point(3, 0), Qt.point(6, 3.5), Qt.point(3, 7), Qt.point(0, 7), Qt.point(3, 3.5) ]
}

