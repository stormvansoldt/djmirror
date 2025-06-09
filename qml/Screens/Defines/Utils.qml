import QtQuick

QtObject {

  // Convertir segundos a cadena de tiempo
  function convertToTimeString(inSeconds, showMilliseconds = false) {
    // Validación de entrada
    if (inSeconds === undefined || inSeconds === null || isNaN(inSeconds)) {
      return "--:--";
    }

    var neg = (inSeconds < 0);
    var absoluteTime = Math.abs(inSeconds);
    
    // Separar milisegundos si es necesario
    var ms = showMilliseconds ? Math.floor((absoluteTime % 1) * 1000) : 0;
    var roundedSec = Math.floor(absoluteTime);
    
    var sec = roundedSec % 60;
    var min = Math.floor(roundedSec / 60);
    
    // Formatear strings
    var secStr = sec.toString().padStart(2, '0');
    var minStr = min.toString().padStart(2, '0');
    var msStr = showMilliseconds ? "." + ms.toString().padStart(3, '0') : "";
    
    return (neg ? "-" : "") + minStr + ":" + secStr + msStr;
  }

  // ELIMINAR: Calcular la proporción de tiempo
  function computeTimeRatio(elapsed, total) {
    if (!total) return 0;
    return Math.min(Math.max(elapsed / total, 0), 1);
  }
  
  // ELIMINAR: Obtener el color según la proporción de tiempo
  function getTimeColor(ratio) {
    if (!prefs.showTimeProgressColors) {
        return colors.colorGrey232; // Color por defecto si los colores dinámicos están desactivados
    }

    // Calcular umbrales basados en preferencias
    const criticalThreshold = 0.95; // Último 5% siempre en rojo
    const warningThreshold = 0.75; // 75-95% en naranja

    if (ratio > criticalThreshold) {
        return "red";
    }
    if (ratio > warningThreshold) {
        return "orange";
    }
    return colors.colorGrey232;
  }

  // Calcular la cadena de tiempo restante
  function computeRemainingTimeString(length, elapsed) {
    return ((elapsed > length) ? convertToTimeString(0) : convertToTimeString( Math.floor(elapsed) - Math.floor(length)));
  }

  // Calcular el offset de la tonalidad
  function getKeyOffset(offset) {
    return (((offset - 1) + 12) % 12) + 1;
  }

  // Calcular el offset de la tonalidad maestra
  function getMasterKeyOffset(masterKey, trackKey) {
    var masterKeyMatches = masterKey.match(/(\d+)(d|m)/);
    var trackKeyMatches = trackKey.match(/(\d+)(d|m)/);

    if (!masterKeyMatches || !trackKeyMatches) return;

    if (masterKeyMatches[1] == trackKeyMatches[1]) return 0;

    if (masterKeyMatches[2] == trackKeyMatches[2]) {
      if (getKeyOffset(trackKeyMatches[1] - 1) == masterKeyMatches[1]) return  1;
      if (getKeyOffset(trackKeyMatches[1] - 2) == masterKeyMatches[1]) return  2;
      if (getKeyOffset(masterKeyMatches[1] - 1) == trackKeyMatches[1]) return -1;
      if (getKeyOffset(masterKeyMatches[1] - 2) == trackKeyMatches[1]) return -2;
    }
  }

  // Convertir a notación Camelot (por compatibilidad con S4MK3 )
  function convertToCamelot(keyToConvert) {
    if (!keyToConvert || keyToConvert === "") return "-";
    
    // Limpiar el valor de entrada eliminando el "~" si existe
    keyToConvert = keyToConvert.replace(/^~ /, '');

    // Validar formato de clave
    if (!keyToConvert.match(/^\d+[dm]$/)) {
        return "-";
    }

    switch(keyToConvert) {
      case "1d"  : return "8B";
      case "2d"  : return "9B";
      case "3d"  : return "10B";
      case "4d"  : return "11B";
      case "5d"  : return "12B";
      case "6d"  : return "1B";
      case "7d"  : return "2B";
      case "8d"  : return "3B";
      case "9d"  : return "4B";
      case "10d" : return "5B";
      case "11d" : return "6B";
      case "12d" : return "7B";

      case "1m"  : return "8A";
      case "2m"  : return "9A";
      case "3m"  : return "10A";
      case "4m"  : return "11A";
      case "5m"  : return "12A";
      case "6m"  : return "1A";
      case "7m"  : return "2A";
      case "8m"  : return "3A";
      case "9m"  : return "4A";
      case "10m" : return "5A";
      case "11m" : return "6A";
      case "12m" : return "7A";
    }
    return "ERR";
  }

  // Índice de las keys
  readonly property variant keyIndex: {
      "1d": 0, "8d": 1, "3d": 2, "10d": 3, "5d": 4, "12d": 5,
      "7d": 6, "2d": 7, "9d": 8, "4d": 9, "11d": 10, "6d": 11,
      "10m": 12, "5m": 13, "12m": 14, "7m": 15, "2m": 16, "9m": 17,
      "4m": 18, "11m": 19, "6m": 20, "1m": 21, "8m": 22, "3m": 23
  }

  // Convertir a notación
  function convertToKeyNotation(keyToConvert, notation) {

    if (!keyToConvert || keyToConvert === "") return "-";
    
   // Limpiar el valor de entrada eliminando el "~" si existe
   keyToConvert = keyToConvert.replace(/^~ /, '');

    // Validar formato de clave
    if (!keyToConvert.match(/^\d+[dm]$/)) {
        return "-";
    }

    // Obtener el índice de la key
    const keyIdx = keyIndex[keyToConvert];
    if (keyIdx === undefined) return "ERR";

    // Convertir según la notación solicitada
    switch(notation) {
        case "camelot":
            return getCamelotKeyNotation(keyIdx);
        case "open":
            return getOpenKeyNotation(keyIdx);
        case "musical":
            return getMusicalNotation(keyIdx, false);
        case "musical_all":
            return getMusicalNotation(keyIdx, true);
        default:
            return "-";
    }
    return "ERR";
  }

  // Convertir a índice de tonalidad
  function returnKeyIndex(keyToConvert) {
    // Validación inicial
    if (!keyToConvert || typeof keyToConvert !== 'string') {
        return null;
    }

   // Limpiar el valor de entrada eliminando el "~" si existe
   keyToConvert = keyToConvert.replace(/^~ /, '');

    // Limpiar y normalizar la entrada
    const cleanKey = keyToConvert.trim().toLowerCase();
    if (!cleanKey.match(/^\d+[dm]$/)) {
        return null;
    }

    switch(keyToConvert) {
      case "1d"  : return 0;
      case "8d"  : return 1;
      case "3d"  : return 2;
      case "10d" : return 3;
      case "5d"  : return 4;
      case "12d" : return 5;
      case "7d"  : return 6;
      case "2d"  : return 7;
      case "9d"  : return 8;
      case "4d"  : return 9;
      case "11d" : return 10;
      case "6d"  : return 11;

      case "10m" : return 12;
      case "5m"  : return 13;
      case "12m" : return 14;
      case "7m"  : return 15;
      case "2m"  : return 16;
      case "9m"  : return 17;
      case "4m"  : return 18;
      case "11m" : return 19;
      case "6m"  : return 20;
      case "1m"  : return 21;
      case "8m"  : return 22;
      case "3m"  : return 23;
      default:    return null;
    }
  }

  // Convertir el índice de tonalidad al formato deseado
  function getKeyText(keyIndex, notation) {
    if (keyIndex < 0 || keyIndex >= 24) return "";

    switch(notation) {
        case "camelot":
            return getCamelotKeyNotation(keyIndex);
        case "open":
            return getOpenKeyNotation(keyIndex);
        case "musical":
            return getMusicalNotation(keyIndex, false);
        case "musical_all":
            return getMusicalNotation(keyIndex, true);
        default:
            return keyIndex;
    }
  }

  // Helper para notación Camelot Key
  function getCamelotKeyNotation(keyIndex) {
    const camelotKeyText = [
        // Mayores (1B -> 12B)
        "8B", "3B", "10B", "5B", "12B", "7B", "2B", "9B", "4B", "11B", "6B", "1B",
        // Menores (1A -> 12A)
        "5A", "12A", "7A", "2A", "9A", "4A", "11A", "6A", "1A", "8A", "3A", "10A"
    ];
    return camelotKeyText[keyIndex];
  }

  // Helper para notación Open Key
  function getOpenKeyNotation(keyIndex) {
    const openKeyText = [
        // Mayores (1B -> 12B)
        "1d", "8d", "3d", "10d", "5d", "12d", "7d", "2d", "9d", "4d", "11d", "6d",
        // Menores (1A -> 12A)
        "10m", "5m", "12m", "7m", "2m", "9m", "4m", "11m", "6m", "1m", "8m", "3m"
    ];
    return openKeyText[keyIndex];
  }

  // Helper para notación Musical
  function getMusicalNotation(keyIndex, showMode) {
    // Orden correcto siguiendo el círculo de quintas y sistema Camelot
    const musicalKeys = [
        // Mayores (1B -> 12B)
        "C", "Db", "D", "Eb", "E", "F", "Gb", "G", "Ab", "A", "Bb", "B",
        //"C", "G", "D", "A", "E", "B", "F#", "C#", "G#", "D#", "A#", "F",

        // Menores (1A -> 12A)
         "Cm", "Dbm", "Dm", "Ebm", "Em", "Fm", "Gbm", "Gm", "Abm", "Am", "Bbm", "Bm"
        //"Am", "Em", "Bm", "F#m", "C#m", "G#m", "D#m", "A#m", "Fm", "Cm", "Gm", "Dm"
    ];
    const musicalKeysAll = [
        // Mayores (1B -> 12B)
        "C", "C#", "D", "D#", "E", "F", "F#", "G", "G#", "A", "A#", "B",
        // "C maj", "G maj", "D maj", "A maj", "E maj", "B maj", "F# maj", "C# maj", "G# maj", "D# maj", "A# maj", "F maj",

        // Menores (1A -> 12A)
        "Cm", "C#m", "Dm", "D#m", "Em", "Fm", "F#m", "Gm", "G#m", "Am", "A#m", "Bm"
        // "A min", "E min", "B min", "F# min", "C# min", "G# min", "D# min", "A# min", "F min", "C min", "G min", "D min"
    ];
    return showMode ? musicalKeysAll[keyIndex] : musicalKeys[keyIndex];
  }
}
