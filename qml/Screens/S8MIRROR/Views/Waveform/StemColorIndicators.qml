import CSI 1.0
import QtQuick
import Qt5Compat.GraphicalEffects
import Traktor.Gui 1.0 as T

import '../Widgets' as Widgets
import '../../../../Defines'

//----------------------------------------------------------------------------------------------------------------------
// STEM COLOR INDICATORS - Componente para mostrar indicadores de color para stems
//
// CARACTERÍSTICAS PRINCIPALES:
//
// 1. Estructura Base
//    - Muestra 4 indicadores de color para stems
//    - Colores predefinidos: verde, azul, rojo y naranja
//    - Altura ajustable para cada indicador
//
// 2. Indicadores Laterales
//    - Rectángulos de color en ambos lados
//    - Ancho: 3px cada uno
//    - Separados por línea divisoria gris (colorGrey16)
//    - Fondo negro para ocultar beatgrid/cuePoints
//
// 3. Propiedades Configurables
//    - deckId: ID del deck
//    - stemCount: Número de stems (4 fijo)
//    - indicatorHeight: Array con alturas [36, 36, 36, 36]
//    - stemStyle: Estilo de visualización (track por defecto)
//
// NOTAS:
// - Incluye rectángulos negros (3px) en los bordes para ocultar elementos subyacentes
// - Cada indicador tiene su propia línea divisoria gris
// - Los colores se obtienen dinámicamente del sistema de color del deck
//----------------------------------------------------------------------------------------------------------------------

Item {
  id: view
  
  property int deckId
  readonly property int stemCount:  4
  readonly property var stemColors: ["green", "blue", "red", "orange"]
  property int  stemStyle:    StemStyle.track

  property var indicatorHeight: [36 , 36 , 36 , 36]
  
  // Constantes para dimensiones
  readonly property int indicatorWidth: 3
  readonly property int dividerWidth: 1
  
  //--------------------------------------------------------------------------------------------------------------------
  // Rectángulos de fondo para ocultar beatgrid/cuePoints - Ajustados a los bordes
  //--------------------------------------------------------------------------------------------------------------------
  Rectangle { 
    anchors.left: parent.left
    y: 0
    width: indicatorWidth
    height: view.height
    color: colors.colorBlack
  }
  Rectangle { 
    anchors.right: parent.right
    y: 0
    width: indicatorWidth
    height: view.height
    color: colors.colorBlack
  }

  //--------------------------------------------------------------------------------------------------------------------
  // Función auxiliar para calcular posición Y de cada indicador
  //--------------------------------------------------------------------------------------------------------------------
  function indicatorY(index) {
    var y = 0;
    for (var i=0; i<index; ++i) {
      y = y + indicatorHeight[i] + 1;
    }
    return y;
  }

  //--------------------------------------------------------------------------------------------------------------------
  // Repeater para crear los 4 indicadores de color - Con anclajes explícitos
  //--------------------------------------------------------------------------------------------------------------------
  Repeater {
    model: stemCount 

    Item {
      property color stemColor: colors.palette(1.0, stemColorId.value)
      AppProperty { id: stemColorId; path: "app.traktor.decks." + (deckId + 1) + ".stems." + (index + 1) + ".color_id" }

      anchors.left: parent.left
      anchors.right: parent.right
      height: indicatorHeight[index]
      y: indicatorY(index)

      // Indicador izquierdo
      Rectangle {
        id: colorRect1
        anchors.left: parent.left
        width: indicatorWidth
        height: parent.height
        color: stemColor
      }
      Rectangle {
        anchors.left: colorRect1.right
        width: dividerWidth
        height: parent.height
        color: colors.colorGrey16
      }

      // Indicador derecho
      Rectangle {
        id: colorRect2
        anchors.right: parent.right
        width: indicatorWidth
        height: parent.height
        color: stemColor
      }
      Rectangle {
        anchors.right: colorRect2.left
        width: dividerWidth
        height: parent.height
        color: colors.colorGrey16
      }
    }
  }
}
