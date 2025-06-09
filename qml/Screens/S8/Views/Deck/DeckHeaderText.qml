import CSI 1.0
import QtQuick

import '../../../../Screens/Defines'

//--------------------------------------------------------------------------------------------------------------------
//  DECK HEADER TEXT
//
//  Componente de texto para mostrar información en el encabezado de los decks de Traktor.
//
//  Características principales:
//  1. Múltiples Estados de Visualización
//     - Información de pista (título, artista, álbum, etc.)
//     - Información técnica (BPM, key, tiempo, etc.)
//     - Estados especiales (sync, master)
//
//  2. Propiedades Principales
//     - deckId: Identificador del deck (0-3)
//     - textState: Estado actual del texto
//     - maxTextWidth: Ancho máximo permitido
//     - isLoaded: Estado de carga del deck
//     - deckType: Tipo de deck (Track, Remix, Stem, Live)
//
//  3. Estados de Visualización
//     - Metadata: title, artist, release, genre, label, etc.
//     - Técnicos: bpm, key, tempo, gain, etc.
//     - Tiempo: elapsedTime, remainingTime, trackLength
//     - Especiales: sync, remixBeats, remixQuantize
//
//  4. Características Especiales
//     - Parpadeo en zona roja (tiempo restante crítico)
//     - Colores dinámicos según estado
//     - Formateo automático según tipo de dato
//     - Soporte para múltiples fuentes
//
//  5. Sistemas de Color
//     - Colores por tipo de deck
//     - Colores de advertencia/error
//     - Colores para estados especiales (sync, master)
//     - Colores para keys musicales
//
//  6. Funciones Principales
//     - getTrackKeyColor(): Color según key musical
//     - computeBeatsToCueString(): Cálculo de beats al siguiente cue
//     - getSyncStatusString(): Estado de sincronización
//     - convertToDb(): Conversión a decibeles
//
//  Uso:
//  DeckHeaderText {
//    deckId: 0
//    textState: 0 // título
//    maxTextWidth: 200
//  }
//
//--------------------------------------------------------------------------------------------------------------------

Text {
  id: header_text

  property int              maxTextWidth : 200
  property int              textState: 0       // this property sets the state of this label (artist, album, bpm, ...)
  property double           syncLabelOpacity: 0.6

  // by setting this string, we can suppres the properties below and expicit define a name
  property string           explicitName: " "  

  // Deck y tipo de deck
  property int              deckId: 0
  readonly property int     deckType:  propDeckType.value
  readonly property int     isLoaded:  (primaryKey.value > 0) || (deckType == DeckType.Remix)
  readonly property double  cuePos:    (propNextCuePoint.value >= 0) ? propNextCuePoint.value : propTrackLength.value*1000
  readonly property int     isInSync:  propIsInSync.value
  onIsInSyncChanged: {
    saveDeckData()
  }
  readonly property int     isMaster:  (propSyncMasterDeck.value == deckId) ? 1 : 0


  readonly property variant keyIndex:      {"1d": 0, "8d": 1, "3d": 2, "10d": 3, "5d": 4, "12d": 5,
                                            "7d": 6, "2d": 7, "9d": 8, "4d": 9, "11d": 10, "6d": 11,
                                            "10m": 12, "5m": 13, "12m": 14, "7m": 15, "2m": 16, "9m": 17,
                                            "4m": 18, "11m": 19, "6m": 20, "1m": 21, "8m": 22, "3m": 23}
  readonly property variant keyText:       {"1d": "8B", "8d": "3B", "3d": "10B", "10d": "5B", "5d": "12B", "12d": "7B",
                                            "7d": "2B", "2d": "9B", "9d": "4B", "4d": "11B", "11d": "6B", "6d": "1B",
                                            "10m": "5A", "5m": "12A", "12m": "7A", "7m": "2A", "2m": "9A", "9m": "4A",
                                            "4m": "11A", "11m": "6A", "6m": "1A", "1m": "8A", "8m": "3A", "3m": "10A"}

  property bool showMilliseconds: false
  property bool showTimeProgress: true

  // Properties of the TextItem itself. Anchors are set from outside
  x:            0
  y:            0
  width:        (maxTextWidth == 0 || text.paintedWidth > maxTextWidth) ? text.paintedWidth : maxTextWidth
  text:         "" 
  font.family:  prefs.fontDeckHeaderString


  //--------------------------------------------------------------------------------------------------------------------
  //  DECK PROPERTIES
  //--------------------------------------------------------------------------------------------------------------------
  AppProperty { id: propDeckType;       path: "app.traktor.decks." + (deckId+1) + ".type" }
  AppProperty { id: primaryKey;         path: "app.traktor.decks." + (deckId+1) + ".track.content.entry_key" }
  AppProperty { id: keyDisplay;         path: "app.traktor.decks." + (deckId+1) + ".track.key.resulting.precise" }
  
  AppProperty { id: propTitle;          path: "app.traktor.decks." + (deckId+1) + ".content.title" }
  AppProperty { id: propArtist;         path: "app.traktor.decks." + (deckId+1) + ".content.artist" }
  AppProperty { id: propAlbum;          path: "app.traktor.decks." + (deckId+1) + ".content.album" }
  AppProperty { id: propGenre;          path: "app.traktor.decks." + (deckId+1) + ".content.genre" }
  AppProperty { id: propComment;        path: "app.traktor.decks." + (deckId+1) + ".content.comment" }
  AppProperty { id: propComment2;       path: "app.traktor.decks." + (deckId+1) + ".content.comment2" }
  AppProperty { id: propLabel;          path: "app.traktor.decks." + (deckId+1) + ".content.label" }
  AppProperty { id: propMix;            path: "app.traktor.decks." + (deckId+1) + ".content.mix" }
  AppProperty { id: propRemixer;        path: "app.traktor.decks." + (deckId+1) + ".content.remixer" }
  AppProperty { id: propCatNo;          path: "app.traktor.decks." + (deckId+1) + ".content.catalog_number" }
  AppProperty { id: propGridOffset;     path: "app.traktor.decks." + (deckId+1) + ".content.grid_offset" }
  AppProperty { id: propBitrate;        path: "app.traktor.decks." + (deckId+1) + ".content.bitrate"; } 

  AppProperty { id: propTrackLength;    path: "app.traktor.decks." + (deckId+1) + ".track.content.track_length"; }
  AppProperty { id: propElapsedTime;    path: "app.traktor.decks." + (deckId+1) + ".track.player.elapsed_time"; } 
  AppProperty { id: propNextCuePoint;   path: "app.traktor.decks." + (deckId+1) + ".track.player.next_cue_point"; }

  AppProperty { id: propMusicalKey;       path: "app.traktor.decks." + (deckId+1) + ".content.musical_key" }
  AppProperty { id: propLegacyKey;        path: "app.traktor.decks." + (deckId+1) + ".content.legacy_key" }
  AppProperty { id: propPitchRange;       path: "app.traktor.decks." + (deckId+1) + ".tempo.range_value" }
  AppProperty { id: propTempoAbsolute;    path: "app.traktor.decks." + (deckId+1) + ".tempo.absolute" }  
  AppProperty { id: propMixerBpm;         path: "app.traktor.decks." + (deckId+1) + ".tempo.base_bpm" }
  AppProperty { id: propMixerStableBpm;   path: "app.traktor.decks." + (deckId+1) + ".tempo.true_bpm" }
  AppProperty { id: propMixerStableTempo; path: "app.traktor.decks." + (deckId+1) + ".tempo.true_tempo" }
  AppProperty { id: propTempo;            path: "app.traktor.decks." + (deckId+1) + ".tempo.tempo_for_display" } 
  AppProperty { id: propMixerTotalGain;   path: "app.traktor.decks." + (deckId+1) + ".content.total_gain" }
  
  AppProperty { id: propKeyDisplay;     path: "app.traktor.decks." + (deckId+1) + ".track.key.resulting.precise" }
  AppProperty { id: propIsInSync;       path: "app.traktor.decks." + (deckId+1) + ".sync.enabled"; }  
  AppProperty { id: propSyncMasterDeck; path: "app.traktor.masterclock.source_id" }

  //--- Special Remix Deck Properties   
  AppProperty { id: propRemixBeatPos;     path: "app.traktor.decks." + (deckId+1) + ".remix.current_beat_pos"; }
  AppProperty { id: propRemixQuantize;    path: "app.traktor.decks." + (deckId+1) + ".remix.quant_index"; }
  AppProperty { id: propRemixIsQuantize;  path: "app.traktor.decks." + (deckId+1) + ".remix.quant"; }
  //property string propRemixQuantize: "1/4"

  AppProperty { id: deckAKeyDisplay; path: "app.traktor.decks.1.track.key.resulting.precise" }
  AppProperty { id: deckBKeyDisplay; path: "app.traktor.decks.2.track.key.resulting.precise" }
  AppProperty { id: deckCKeyDisplay; path: "app.traktor.decks.3.track.key.resulting.precise" }
  AppProperty { id: deckDKeyDisplay; path: "app.traktor.decks.4.track.key.resulting.precise" }

  // Añadir la propiedad para detectar si está en reproducción
  AppProperty { id: propIsRunning; path: "app.traktor.decks." + (deckId+1) + ".running" }
  
  //--------------------------------------------------------------------------------------------------------------------
  //  MAPPING FROM TRAKTOR ENUM TO QML-STATE!
  //--------------------------------------------------------------------------------------------------------------------
  readonly property variant stateMapping:  ["title", "artist", "release", 
                                            "mix", "label", "catNo", 
                                            "genre", "trackLength", "bitrate", 
                                            "bpmTrack", "gain", "elapsedTime", 
                                            "remainingTime", "beats", "beatsToCue", 
                                            "bpm", "tempo", "key", 
                                            "keyText", "comment", "comment2",
                                            "remixer", "pitchRange", "bpmStable", 
                                            "tempoStable", "sync", "off", 
                                            "off", "bpmTrack", "remixBeats", 
                                            "remixQuantize", "keyDisplay"]

/*
  readonly property variant stateMapping:  [0:  "title",          1: "artist",       2:  "release", 
                                            3:  "mix",            4: "label",        5:  "catNo", 
                                            6:  "genre",          7: "trackLength",  8:  "bitrate", 
                                            9:  "bpmTrack",      10: "gain",        11: "elapsedTime", 
                                            12: "remainingTime", 13: "beats",       14: "beatsToCue", 
                                            15: "bpm",           16: "tempo",       17: "key", 
                                            18: "keyText",       19: "comment",     20: "comment2",
                                            21: "remixer",       22: "pitchRange",  23: "bpmStable", 
                                            24: "tempoStable",   25: "sync",        26: "off", 
                                            27: "off",           28: "bpmTrack"     29: "remixBeats"
                                            30: "remixQuantize", 31: "keyDisplay"]
*/
  //--------------------------------------------------------------------------------------------------------------------
  //  STATES FOR THE LABELS IN THE DECK HEADER
  //--------------------------------------------------------------------------------------------------------------------

  state: (explicitName == "") ? stateMapping[textState] : "explicitName"

  states: [
    State { 
      name: "explicitName";     
      PropertyChanges { target: header_text;  text: explicitName } 
    },
    //------------------------------------------------------------------------------------------------------------------
    State { 
      name: "off";     
      PropertyChanges { target: header_text;  text: "" } 
    },
    State { 
      name: "title"; // Top1 and Bottom1 ONLY
      PropertyChanges { target: header_text; font.family: prefs.fontDeckHeaderString;
                        text:   (!isLoaded)?"":propTitle.value; }
    },
    State { 
      name: "artist";   // Top1 and Bottom1 ONLY
      PropertyChanges { target: header_text; font.family: prefs.fontDeckHeaderString;
                        text:   (!isLoaded)?"":propArtist.value; }
    },
    State { 
      name: "release"; // Top1 and Bottom1 ONLY
      PropertyChanges { target: header_text; font.family: prefs.fontDeckHeaderString;  
                        text:   (!isLoaded)?"":propAlbum.value; }
    },
    State { 
      name: "genre";   // Top1 and Bottom1 ONLY
      PropertyChanges { target: header_text; font.family: prefs.fontDeckHeaderString;  
                        text:   (!isLoaded)?"":propGenre.value; }
    },
    State { 
      name: "comment"; // Top1 and Bottom1 ONLY
      PropertyChanges { target: header_text; font.family: prefs.fontDeckHeaderString;  
                        text:   (!isLoaded)?"":propComment.value; }
    },
    State { 
      name: "comment2";// Top1 and Bottom1 ONLY
      PropertyChanges { target: header_text; font.family: prefs.fontDeckHeaderString;  
                        text:   (!isLoaded)?"":propComment2.value; }
    },
    State { 
      name: "label";// Top1 and Bottom1 ONLY
      PropertyChanges { target: header_text; font.family: prefs.fontDeckHeaderString;  
                        text:   (!isLoaded)?"":propLabel.value; }
    },
    State { 
      name: "mix";     // Top1 and Bottom1 ONLY
      PropertyChanges { target: header_text; font.family: prefs.fontDeckHeaderString;  
                        text:   (!isLoaded)?"":propMix.value; }
    },
    State { 
      name: "remixer"; // Top1 and Bottom1 ONLY
      PropertyChanges { target: header_text; font.family: prefs.fontDeckHeaderString; 
                        text:   (!isLoaded)?"":propRemixer.value; }
    },
    State { 
      name: "catNo"; 
      PropertyChanges { target: header_text; font.family: prefs.fontDeckHeaderString;  
                        text:   (!isLoaded)?"":propCatNo.value }
    },
    //--------------------------------------------------------------------------------------------------------------------
    State { 
      name: "trackLength"; 
      PropertyChanges { target: header_text; font.family: prefs.fontDeckHeaderNumber;  
                        text:   (!isLoaded)?"":utils.convertToTimeString(propTrackLength.value); }
    },
    State { 
      name: "elapsedTime"
      PropertyChanges { 
        target: header_text
        font.family: prefs.fontDeckHeaderNumber
        text: {
          if (!isLoaded) return "--:--";
          if (propElapsedTime.value === undefined || propElapsedTime.value === null) return "--:--";
          return utils.convertToTimeString(propElapsedTime.value, prefs.showMillisecondsInTime);
        }
        isInRedZone: {
          if (!showTimeProgress || !prefs.showTimeProgressColors) return false;
          
          const remaining = propTrackLength.value - propElapsedTime.value;
          return (prefs.showTimeWarnings && remaining <= prefs.timeWarningThreshold) || 
                 (propElapsedTime.value / propTrackLength.value >= 0.95);
        }
        color: {
          if (!showTimeProgress || !prefs.showTimeProgressColors) {
            return textColors[deckId];
          }

          const ratio = propElapsedTime.value / propTrackLength.value;
          
          if (isInRedZone) {
            return colors.deckColors.states.error;
          } else if (ratio >= 0.75) {
            return colors.deckColors.states.warning;
          }
          
          blinkAnimation.stop();
          return textColors[deckId];
        }
      }
    },
    State { 
      name: "remainingTime"
      PropertyChanges { 
        target: header_text
        font.family: prefs.fontDeckHeaderNumber
        text: {
          if (!isLoaded) return "--:--";
          if (propTrackLength.value === undefined || propElapsedTime.value === undefined) return "--:--";
          
          const remaining = propTrackLength.value - propElapsedTime.value;
          if (remaining < 0) return "--:--";
          
          return "-" + utils.convertToTimeString(remaining, prefs.showMillisecondsInTime);
        }
        isInRedZone: {
          if (!showTimeProgress || !prefs.showTimeProgressColors) return false;
          
          const remaining = propTrackLength.value - propElapsedTime.value;
          return (prefs.showTimeWarnings && remaining <= prefs.timeWarningThreshold) || 
                 (propElapsedTime.value / propTrackLength.value >= 0.95);
        }
        color: {
          if (!showTimeProgress || !prefs.showTimeProgressColors) {
            return textColors[deckId];
          }

          const ratio = propElapsedTime.value / propTrackLength.value;
          
          if (isInRedZone) {
            return colors.deckColors.states.error;
          } else if (ratio >= 0.75) {
            return colors.deckColors.states.warning;
          }
          
          return textColors[deckId];
        }
      }
    },
    //--------------------------------------------------------------------------------------------------------------------
    State { 
      name: "key"; 
      PropertyChanges { target: header_text; font.family: prefs.fontDeckHeaderNumber;
                        color:  getTrackKeyColor(propKeyDisplay.value);
                        text:   (!isLoaded)?"":"♪"+getTrackKeyText(propKeyDisplay.value); }
                        
    },
    State { 
      name: "keyText"; 
      PropertyChanges { target: header_text; font.family: prefs.fontDeckHeaderNumber; 
                        text:   (!isLoaded)?"":propLegacyKey.value.toString(); }
    },
    State { 
      name: "pitchRange"; 
      PropertyChanges { target: header_text; font.family: prefs.fontDeckHeaderNumber; 
                        text:   (!isLoaded)?"":toInt_round(propPitchRange.value*100).toString() + "%"; }
    },
    State { 
      name: "bpm"; 
      PropertyChanges { target: header_text; font.family: prefs.fontDeckHeaderNumber; 
                        text:   (!isLoaded)?"":propMixerBpm.value.toFixed(2).toString(); }
    },
    State { 
      name: "bpmStable"; 
      PropertyChanges { target: header_text; font.family: prefs.fontDeckHeaderNumber;
                        text:   (!isLoaded)?"": propMixerStableBpm.value.toFixed(2).toString(); }
    },
    State { 
      name: "bpmTrack";
      PropertyChanges { target: header_text; font.family: prefs.fontDeckHeaderNumber; 
                        text:   (!isLoaded)?"":propMixerStableBpm.value.toFixed(2).toString();  }
    },
    State { 
      name: "tempo"; 
      PropertyChanges { target: header_text; font.family: prefs.fontDeckHeaderNumber; 
                        text:   (!isLoaded)?"":((propTempo.value-1 <= 0)?"":"+") + ((propTempo.value-1)*100).toFixed(1).toString() + "%"; }
    },
    State { 
      name: "tempoStable"; 
      PropertyChanges { target: header_text; font.family: prefs.fontDeckHeaderNumber;
                        text:   getStableTempoString(); }
    },
    State { 
      name: "gain";
      PropertyChanges { target: header_text; font.family: prefs.fontDeckHeaderNumber; 
                        text:   (!isLoaded)?"":convertToDb(propMixerTotalGain.value).toFixed(1).toString() + "dB"; }
    },
    //--------------------------------------------------------------------------------------------------------------------
    State { 
      name: "beats"; 
      PropertyChanges { target: header_text; font.family: prefs.fontDeckHeaderNumber;
                        text:   (!isLoaded)?"":computeBeatCounterStringFromPosition(((propElapsedTime.value*1000-propGridOffset.value)*propMixerBpm.value)/60000.0); }
    },
    State { 
      name: "beatsToCue";
      PropertyChanges { 
        target: header_text
        font.family: prefs.fontDeckHeaderNumber
        color: computeBeatsToCueColor()
        text: prefs.showElapsedTimeInsteadOfBeats ? 
             (!isLoaded ? "--:--" : utils.convertToTimeString(propElapsedTime.value, prefs.showMillisecondsInTime)) :
             computeBeatsToCueString()
      }
    },
    State { 
      name: "bitrate"; 
      PropertyChanges { target: header_text;  font.family: prefs.fontDeckHeaderNumber; 
                        text:   (!isLoaded)?"":toInt(propBitrate.value / 1000).toString(); }
    },
    State { 
      name: "sync";
      PropertyChanges { target: header_text; font.family: prefs.fontDeckHeaderNumber; 
                        text:  getSyncStatusString(); }
    },
    State { 
      name: "remixBeats";
      PropertyChanges { target: header_text; font.family: prefs.fontDeckHeaderNumber; 
                        text:  (!isLoaded) ? "" : computeBeatCounterStringFromPosition(propRemixBeatPos.value); }
    },
    State { 
      name: "remixQuantize";
      PropertyChanges { target: header_text; font.family: prefs.fontDeckHeaderNumber; 
                        text:  (!isLoaded) ? "" : ((propRemixIsQuantize.value)? "Q " + propRemixQuantize.description : "Off"); }
    },
    State { 
      name: "keyDisplay"; 
      PropertyChanges { target: header_text; font.family: prefs.fontDeckHeaderNumber;
                        text: (!isLoaded) ? "": utils.convertToKeyNotation(keyDisplay.value, prefs.keyNotation); }
    }
  ]


  //--------------------------------------------------------------------------------------------------------------------
  //  CONVERSION FUNCTIONS
  //--------------------------------------------------------------------------------------------------------------------
  function toInt(val)       { return parseInt(val); }
  function toInt_round(val) { return parseInt(val+0.5); }
  function log10(num)       { return Math.log(num) / Math.LN10; }

  // Convert the gain to decibels
  function convertToDb(gain) {
    var level0dB = 1.0;
    var norm = gain / level0dB;
    if (norm <= 0.0)
      return -0.0000000001;
    
    return 20.0*log10(norm);
  }

  // Compute the beat counter string from position
  function computeBeatCounterStringFromPosition(beat) {
    var phraseLen = prefs.phraseLength;
    var curBeat  = Math.abs(beat);

    if (beat < 0.0)
      curBeat = curBeat*-1;

    var value1 = Math.floor(((curBeat/4)/phraseLen)+1);
    var value2 = Math.floor(((curBeat/4)%phraseLen)+1);
    var value3 = Math.floor( (curBeat%4)+1);

    if (beat < 0.0)
      return "- " + value1.toString() + "." + value2.toString() + "." + value3.toString();

    return value1.toString() + "." + value2.toString() + "." + value3.toString();
  }

  // Compute the stable tempo string
  function getStableTempoString() {
    var tempo = propMixerStableTempo.value - 1;
    return   ((tempo <= 0) ? "" : "+") + (tempo * 100).toFixed(1).toString() + "%";
  }

  // Compute the sync status string
  function getSyncStatusString() {
    if ( !isLoaded ) 
      return " ";
    else if (isMaster)
      return "MASTER";
    else if (isInSync)
      return "SYNC";

    // Show the decks current pitch value in the area of the Master/Sync indicator 
    // if a deck is neither synced nor set to maste (TP-8070)
    return getStableTempoString();
  }

  // Añadir propiedad para almacenar el último estado de reproducción
  property bool lastPlayState: false

  // Añadir propiedad para el estado de reproducción
  AppProperty { 
    id: propPlayState
    path: "app.traktor.decks." + (deckId + 1) + ".play" 
    onValueChanged: {
      // Si el guardado está desactivado, salir
      if (!prefs.enableDataSaving) return;

      // Si el estado de reproducción ha cambiado, guardar los datos
      var currentPlayState = (value == 1)
      if (currentPlayState !== lastPlayState) {
        lastPlayState = currentPlayState
        saveDeckData()
      }
    }
  }

  // Save the deck header text to a file
  function saveDeckData() {
    // Si el guardado está desactivado, salir
    if (!prefs.enableDataSaving) return;

    var data = {}

    if (!isLoaded) {
      data = { 
        "deckHeaderText.deckId": deckId,
        "isPlaying": false,
        "title": "",
        "artist": "",
        "album": "",
        "genre": "",
        //"comment": propComment.value,
        //"comment2": propComment2.value,
        //"label": propLabel.value,
        //"mix": propMix.value,
        //"remixer": propRemixer.value,
        //"catNo": propCatNo.value,
        "trackLength": 0,
        "bitrate": 0,
        //"pitchRange": propPitchRange.value,
        "bpm": 0,
        "tempo": 0,
        //"tempoStable": propMixerStableTempo.value,
        //"gain": propMixerTotalGain.value,
        "sync": "",
        "master": "",
        //"remixQuantize": (propRemixIsQuantize.value)? "Q " + propRemixQuantize.description : "Off",
        "key": "",
        "keyDisplay": "",
      }
    }
    else {
      data = { 
        "deckHeaderText.deckId": deckId,
        "isPlaying": propPlayState.value,
        "title": propTitle.value,
        "artist": propArtist.value,
        "album": propAlbum.value,
        "genre": propGenre.value,
        //"comment": propComment.value,
        //"comment2": propComment2.value,
        //"label": propLabel.value,
        //"mix": propMix.value,
        //"remixer": propRemixer.value,
        //"catNo": propCatNo.value,
        "trackLength": propTrackLength.value,
        "bitrate": propBitrate.value,
        //"pitchRange": propPitchRange.value,
        "bpm": propMixerBpm.value,
        "tempo": propTempo.value,
        //"tempoStable": propMixerStableTempo.value,
        //"gain": propMixerTotalGain.value,
        "sync": isInSync ? "SYNC" : "",
        "master": isMaster ? "MASTER" : "",
        //"remixQuantize": (propRemixIsQuantize.value)? "Q " + propRemixQuantize.description : "Off",
        "key": propKeyDisplay.value,
        "keyDisplay": utils.convertToKeyNotation(keyDisplay.value, prefs.keyNotation),
      }
    }

    dataManager.save("Deck" + deckId + ".json", data );
  }

  // Save the deck header text to a file
  function saveDeckCoverImage(source) {
    // Si el guardado está desactivado, salir
    if (!prefs.enableDataSaving) return;

    if (!isLoaded) return;

    var data = { 
      "DeckCoverImage": source,
    }

    dataManager.save("Image" + deckId + ".json", data );
  }

  // Compute the color of the beats to cue indicator
  function computeBeatsToCueColor() {
    if (!isLoaded || propNextCuePoint.value < 0) {
        return parent.textColors[deckId];
    }

    try {
        var beats = ((propNextCuePoint.value - propElapsedTime.value * 1000) * propMixerBpm.value) / 60000.0;
        
        if (beats < 0 || beats > 256 || isNaN(beats)) {
            return parent.textColors[deckId];
        }

        var bars = Math.floor(beats / 4);
        if (bars < 4) {
            return colors.deckColors.states.warning;
        }

        return parent.textColors[deckId];
    } catch (e) {
        return parent.textColors[deckId];
    }
  }

  // Compute the string of beats to cue
  function computeBeatsToCueString() {
    // Validación inicial
    if (!isLoaded) {
        return "--:--";
    }

    if (propNextCuePoint.value === undefined || propNextCuePoint.value < 0) {
        return "--:--";
    }

    try {
        // Convertir tiempos a la misma unidad (milisegundos)
        var currentTimeMs = propElapsedTime.value * 1000;
        var nextCueMs = propNextCuePoint.value;
        var bpm = propMixerBpm.value;

        // Calcular beats hasta el siguiente cue
        var timeToNextCue = nextCueMs - currentTimeMs;
        var beats = (timeToNextCue * bpm) / 60000.0;

        // Validar el resultado
        if (isNaN(beats) || beats < 0) {
            return "--:--";
        }

        // Calcular barras y beats
        var bars = Math.floor(beats / 4);
        var beat = Math.floor(beats % 4) + 1;
        // Formatear resultado
        var barsStr = bars.toString().padStart(2, '0');
        var result = barsStr + "." + beat;

        return result;

    } catch (e) {
        return "--:--";
    }
  }

  // Compute the master key
  function getMasterKey() {
    switch (propSyncMasterDeck.value) {
      case 0: return deckAKeyDisplay.value;
      case 1: return deckBKeyDisplay.value;
      case 2: return deckCKeyDisplay.value;
      case 3: return deckDKeyDisplay.value;
    }

    return "";
  }

  // Compute the color of the track key
  function getTrackKeyColor(trackKey) {
    if (isMaster) {
      return parent.textColors[deckId];
    }

    var keyOffset = utils.getMasterKeyOffset(getMasterKey(), trackKey);
    if (keyOffset == 0) {
      return colors.color04MusicalKey; // Yellow
    }
    if (keyOffset == 1 || keyOffset == -1) {
      return colors.color02MusicalKey; // Orange
    }
    if (keyOffset == 2 || keyOffset == 7) {
      return colors.color07MusicalKey; // Green
    }
    if (keyOffset == -2 || keyOffset == -7) {
      return colors.color10MusicalKey; // Blue
    }

    return parent.textColors[deckId];
  }

  // Compute the text of the track key
  function getTrackKeyText(trackKey) {
    return trackKey.replace(
      /(~ )?(\d+(d|m))/,
      function (match, prefix, key) {
        return keyText[key] || key;
      }
    );
  }

  // Propiedades para el parpadeo
  property bool isInRedZone: false
  
  // Modificar la animación para que solo se active si el deck está en reproducción
  SequentialAnimation {
    id: blinkAnimation
    running: header_text.isInRedZone && propIsRunning.value
    loops: Animation.Infinite
    alwaysRunToEnd: true
    
    NumberAnimation {
      target: header_text
      property: "opacity"
      from: 1
      to: 0.1
      duration: 200
    }
    NumberAnimation {
      target: header_text
      property: "opacity"
      from: 0.1
      to: 1
      duration: 200
    }
  }
}
