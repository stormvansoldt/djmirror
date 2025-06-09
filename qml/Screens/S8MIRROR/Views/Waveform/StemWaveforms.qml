import CSI 1.0
import QtQuick
import Qt5Compat.GraphicalEffects
import Traktor.Gui 1.0 as Traktor

import '../Widgets' as Widgets


Item {
  id: view
  
  property int    deckId:         0
  property int    sampleWidth:    0
  property var    waveformPosition 
  property real   screenScale:    1.0
  
  readonly property var colorIds: [stemColorId_1.value, stemColorId_2.value, stemColorId_3.value, stemColorId_4.value]
  
  // Calcular dimensiones
  readonly property real totalSpacing: 6 * screenScale // Espacio total entre ondas
  readonly property real waveformHeight: (height - totalSpacing) / 4 // Altura ajustada para cada onda
  readonly property real topMargin: 2 * screenScale // Margen superior para centrar todo el conjunto

  //--------------------------------------------------------------------------------------------------------------------
 
  AppProperty { id: stemColorId_1; path: "app.traktor.decks." + (deckId + 1) + ".stems.1.color_id" }
  AppProperty { id: stemColorId_2; path: "app.traktor.decks." + (deckId + 1) + ".stems.2.color_id" }
  AppProperty { id: stemColorId_3; path: "app.traktor.decks." + (deckId + 1) + ".stems.3.color_id" }
  AppProperty { id: stemColorId_4; path: "app.traktor.decks." + (deckId + 1) + ".stems.4.color_id" }

  //--------------------------------------------------------------------------------------------------------------------
  // STEM WAVEFORMS
  //--------------------------------------------------------------------------------------------------------------------
  Repeater {
    model: 4

    SingleWaveform { 
      y: topMargin + (index * (waveformHeight + (2 * screenScale))) // 2 píxeles de espacio entre cada onda
      width: view.width
      height: waveformHeight
      clip: false // true

      deckId: view.deckId
      streamId: index + 1
      sampleWidth: view.sampleWidth
      waveformPosition: view.waveformPosition
      waveformColors: colors.getWaveformColors(colorIds[index])
    }
  }
}
