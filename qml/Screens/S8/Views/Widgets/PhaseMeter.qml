import CSI 1.0
import QtQuick
import Qt5Compat.GraphicalEffects


//----------------------------------------------------------------------------------------------------------------------
// PHASE METER - Indicador visual de la fase de los beats entre el deck actual y el deck maestro
//
// ELEMENTOS PRINCIPALES Y COLORES:
//
// 1. Contenedor Principal (Row)
//    - Centrado horizontal y verticalmente en el padre
//
// 2. Indicadores de Beat (Repeater con 4 Rectangles)
//    - Colores:
//      * Beat activo del deck actual:
//        - Si es deck maestro: colors.colorPhaseMeterMasterActive
//        - Si no es deck maestro: colors.colorPhaseMeterDeckActive
//      * Beats inactivos: colors.colorPhaseMeterInactive
//    - Borde:
//      * Color:
//        - Beat activo del deck maestro: colors.colorPhaseMeterMasterActive
//        - Beats inactivos: colors.colorPhaseMeterBorder
//
// NOTAS:
// - El componente muestra visualmente la sincronización de beats entre el deck actual y el deck maestro.
// - Los colores cambian dinámicamente para indicar el beat activo y el estado de maestro.
// - Se utilizan AppProperties para obtener información en tiempo real sobre los decks y sus estados.
//
//----------------------------------------------------------------------------------------------------------------------

Item {
  id : phaseMeter

  property int              deckId:          0

  readonly property int     isMaster:        (propSyncMasterDeck.value == deckId) ? 1 : 0

  property var   propDeckLastCue:            null
  property var   propMasterLastCue:          null

  AppProperty { id: propDeckElapsedTime;     path: "app.traktor.decks." + (deckId + 1) + ".track.player.elapsed_time" }
  AppProperty { id: propDeckNextCuePoint;    path: "app.traktor.decks." + (deckId + 1) + ".track.player.next_cue_point"; onValueChanged: { updateDeckLastCue() } }
  AppProperty { id: propDeckMixerBpm;        path: "app.traktor.decks." + (deckId + 1) + ".tempo.base_bpm" }

  AppProperty { id: propSyncMasterDeck;      path: "app.traktor.masterclock.source_id"; onValueChanged: { updateMasterLastCue() } }

  AppProperty { id: propMasterElapsedTime;   path: "app.traktor.decks." + (propSyncMasterDeck.value + 1) + ".track.player.elapsed_time" }
  AppProperty { id: propMasterNextCuePoint;  path: "app.traktor.decks." + (propSyncMasterDeck.value + 1) + ".track.player.next_cue_point"; onValueChanged: { updateMasterLastCue() } }
  AppProperty { id: propMasterMixerBpm;      path: "app.traktor.decks." + (propSyncMasterDeck.value + 1) + ".tempo.base_bpm" }

  Row {
    spacing: 2
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.verticalCenter: parent.verticalCenter

    Repeater {
      id: master_beats
      model: 4

      Rectangle {
        width:  (phaseMeter.width - 6) / 4
        height: phaseMeter.height
        //radius: 2

        color: index == getBeat() 
               ? (propSyncMasterDeck.value == deckId 
                  ? colors.colorPhaseMeterMasterActive 
                  : colors.colorPhaseMeterDeckActive) 
               : colors.colorPhaseMeterInactive
    
        border.width: 2
        border.color: index == getMasterBeat() 
                     ? colors.colorPhaseMeterMasterActive 
                     : colors.colorPhaseMeterBorder
      }
    }
  }
  
  //--------------------------------------------------------------------------------------------------------------------
  //  FUNCTIONS
  //--------------------------------------------------------------------------------------------------------------------
  function compare(a,b) {
    if (a.value < b.value) return -1;
    if (a.value > b.value) return 1;
    return 0;
  }

  function updateDeckLastCue() {
    if (propDeckNextCuePoint.value > -1) {
      propDeckLastCue = propDeckNextCuePoint.value;
    } 
  }

  function updateMasterLastCue() {  
    if (propMasterNextCuePoint.value > -1) {
      propMasterLastCue = propMasterNextCuePoint.value;
    }  
  }

  function getBeat() {
    if (propDeckElapsedTime.value * 1000 > propDeckLastCue)
      return toInt(((propDeckElapsedTime.value * 1000 - propDeckLastCue) * propDeckMixerBpm.value) / 60000.0) % 4;
    else
      return 3 + (toInt(((propDeckElapsedTime.value * 1000 - propDeckNextCuePoint.value) * propDeckMixerBpm.value) / 60000.0) % 4);
  }

  function getMasterBeat() {
    // if there is no master deck, return -1
    if (propSyncMasterDeck.value == -1) return -1;

    if (propMasterElapsedTime.value * 1000 > propMasterLastCue)
      return toInt(((propMasterElapsedTime.value * 1000 - propMasterLastCue) * propMasterMixerBpm.value) / 60000.0) % 4;
    else
      return 3 + (toInt(((propMasterElapsedTime.value * 1000 - propMasterNextCuePoint.value) * propMasterMixerBpm.value) / 60000.0) % 4);
  }
}
