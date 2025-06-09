import QtQuick

/**
 * @brief Componente que visualiza la calificación de una pista mediante barras verticales
 * 
 * Este componente muestra la calificación de una pista usando dos grupos de barras verticales:
 * - Barras grandes: Representan la calificación actual
 * - Barras pequeñas: Representan las estrellas restantes hasta el máximo
 * 
 * @property {int} rating - Valor de la calificación (valores posibles: -1, 0, 51, 102, 153, 204, 255)
 * @property {color} bigLineColor - Color de las barras grandes que representan la calificación actual
 * @property {color} smallLineColor - Color de las barras pequeñas que representan las estrellas restantes
 * @property {Object} ratingMap - Mapeo de valores numéricos a número de estrellas (-1,0→0, 51→1, 102→2, 153→3, 204→4, 255→5)
 * @property {int} nrRatings - Número máximo de estrellas posibles (5)
 * 
 * El componente tiene un tamaño predeterminado de 20x13 píxeles.
 * 
 * Ejemplo de uso:
 * ```qml
 * TrackRating {
 *     rating: 153 // Mostrará 3 barras grandes
 *     bigLineColor: "white"
 *     smallLineColor: "gray"
 * }
 * ```
 */

Item {
  id: trackRating

  property real screenScale: prefs.screenScale

  property int              rating: 0
  property color            bigLineColor:   colors.colorWhite // set from outside
  property color            smallLineColor: colors.colorWhite // set from outside  
  readonly property variant ratingMap:      { '-1' : 0, '0' : 0, '51': 1, '102': 2, '153' : 3, '204' : 4, '255': 5 }
  readonly property int     nrRatings: 5

  // Dimensiones escaladas
  width:  20 * screenScale
  height: 13 * screenScale
  
  //--------------------------------------------------------------------------------------------------------------------

  Rectangle {
    id: largeLineContainer
    anchors.left:           parent.left
    anchors.verticalCenter: parent.verticalCenter
    height:                 parent.height
    width:                  rowLarge.width + (2 * screenScale)
    color:                  colors.colorBlack28
    visible:                trackRating.rating > 0 // -1 is also possible if rating has never been set!
    Row {
      id: rowLarge
      anchors.left:       parent.left
      anchors.top:        parent.top
      anchors.leftMargin: 1 * screenScale
      height:             parent.height
      spacing:            2 * screenScale
      Repeater {
        model: (ratingMap[trackRating.rating] === undefined) ? 0 : ratingMap[trackRating.rating]
        Rectangle {
          width:                  2 * screenScale
          height:                 largeLineContainer.height - (2 * screenScale)
          anchors.verticalCenter: rowLarge.verticalCenter
          color:                  trackRating.bigLineColor 
        }
      }
    }
  }

  //--------------------------------------------------------------------------------------------------------------------

  Rectangle {
    id: smallLineContainer
    anchors.right:          parent.right
    anchors.verticalCenter: parent.verticalCenter
    height:                 parent.height - (8 * screenScale)
    width:                  rowSmall.width + (2 * screenScale)
    color:                  colors.colorBlack28
    visible:                ratingMap[trackRating.rating] < nrRatings

    Row {
      id: rowSmall
      anchors.left:       parent.left
      anchors.top:        parent.top
      anchors.leftMargin: 1 * screenScale
      height:             parent.height
      spacing:            2 * screenScale
      Repeater {
        model: (ratingMap[trackRating.rating] === undefined) ? nrRatings : (nrRatings - ratingMap[trackRating.rating])
        Rectangle {
          width:                  2 * screenScale
          height:                 smallLineContainer.height - (2 * screenScale)
          anchors.verticalCenter: rowSmall.verticalCenter
          color:                  trackRating.smallLineColor
        }
      }
    }
  }
}
