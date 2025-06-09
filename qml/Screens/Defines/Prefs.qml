import QtQuick
import "."  // Importar desde el directorio actual

// Objeto principal para almacenar todas las preferencias de la aplicación
Rectangle {
  id: instancePrefs

  anchors.bottom: parent.bottom
  anchors.left: parent.left
  anchors.right: parent.right
  height: 0
  opacity: instancePrefs.debug ? 1 : 0
  color: "red"
  z: 200
  visible: instancePrefs.debug // Mostrar solo si debug está activado
  clip: true

  // Instanciar Colors
  property Colors colors: Colors { }

  Component.onCompleted: {
    instancePrefs.log("INFO", "Prefs.qml loaded " + Math.floor(Math.random() * 1000000))

    // Force load config
    var confLoader = Qt.createComponent("../../CSI/Common/Settings/ConfigLoader.qml",).createObject(this);
    if(confLoader){
      confLoader.loadConfigAsync();
    }
  }

  // --------------------------------------------------------------------------------------------------------------------
  // DEBUG TEXT
  // --------------------------------------------------------------------------------------------------------------------
  Text {
      id: debugText
      anchors.fill: parent
      text: instancePrefs.debugResult
      font.pixelSize: fonts.miniFontSize
      font.family: instancePrefs.normalFontName
      color: colors.colorFontWhite
  }

  //--------------------------------------------------------------------------------------------------------------------
  // SYSTEM PREFERENCES
  //--------------------------------------------------------------------------------------------------------------------
  readonly property int  osMode:                  1

  //--------------------------------------------------------------------------------------------------------------------
  // CONTROLLER PREFERENCES
  //--------------------------------------------------------------------------------------------------------------------
  // Mixer FX preferences
  property bool mixerFXSelector:                  false         // Enable Mixer FX selector
  onMixerFXSelectorChanged: {
    instancePrefs.log("INFO", "mixerFXSelector changed to " + mixerFXSelector)
  }
  property bool prioritizeFXSelection:            false         // Prioritize FX selection
  onPrioritizeFXSelectionChanged: {
    instancePrefs.log("INFO", "prioritizeFXSelection changed to " + prioritizeFXSelection)
  }

  // Controller mode
  property bool s12Mode:                          false         // Set to true if you are using S8 + 2x D2
  onS12ModeChanged: {
    instancePrefs.log("INFO", "s12Mode changed to " + s12Mode)
  }
  
  // Tempo adjustments
  property bool fineMasterTempoAdjust:            true          // Fine master tempo adjustment
  onFineMasterTempoAdjustChanged: {
    instancePrefs.log("INFO", "fineMasterTempoAdjust changed to " + fineMasterTempoAdjust)
  }
  property bool fineDeckTempoAdjust:              true          // Fine deck tempo adjustment
  onFineDeckTempoAdjustChanged: {
    instancePrefs.log("INFO", "fineDeckTempoAdjust changed to " + fineDeckTempoAdjust)
  }

  //--------------------------------------------------------------------------------------------------------------------
  // GLOBAL PREFERENCES
  //--------------------------------------------------------------------------------------------------------------------
  property string keyNotation: "camelot" // Valores posibles: "camelot", "open", "musical", "musical_all"
  onKeyNotationChanged: {
    instancePrefs.log("INFO", "keyNotation changed to " + keyNotation)
  }
  property int  phraseLength:                     4
  onPhraseLengthChanged: {
    instancePrefs.log("INFO", "phraseLength changed to " + phraseLength)
  }
  //--------------------------------------------------------------------------------------------------------------------
  // BROWSER PREFERENCES
  //--------------------------------------------------------------------------------------------------------------------
  property bool displayMatchGuides:               true          // Display match guides
  onDisplayMatchGuidesChanged: {
    instancePrefs.log("INFO", "displayMatchGuides changed to " + displayMatchGuides)
  }
  property bool displayMoreItems:                 true          // Display more items
  onDisplayMoreItemsChanged: {
    instancePrefs.log("INFO", "displayMoreItems changed to " + displayMoreItems)
  }
  property bool displayBrowserItemCount:        true          // Display browser item count
  onDisplayBrowserItemCountChanged: {
    instancePrefs.log("INFO", "displayBrowserItemCount changed to " + displayBrowserItemCount)
  }

  //--------------------------------------------------------------------------------------------------------------------
  // DECK DISPLAY PREFERENCES
  //--------------------------------------------------------------------------------------------------------------------
  // Visual elements
  property bool displayAlbumCover:                true          // Display album cover
  onDisplayAlbumCoverChanged: {
    instancePrefs.log("INFO", "displayAlbumCover changed to " + displayAlbumCover)
  }
  property bool displayHotCueBar:                 true          // Display hot cue bar
  onDisplayHotCueBarChanged: {
    instancePrefs.log("INFO", "displayHotCueBar changed to " + displayHotCueBar)
  }
  property bool displayDeckIndicators:            true          // Display deck indicators
  onDisplayDeckIndicatorsChanged: {
    instancePrefs.log("INFO", "displayDeckIndicators changed to " + displayDeckIndicators)
  }
  property bool displayPhaseMeter:                true          // Display phase meter
  onDisplayPhaseMeterChanged: {
    instancePrefs.log("INFO", "displayPhaseMeter changed to " + displayPhaseMeter)
  }
  property int phaseMeterHeight: 20  // Altura por defecto del phase meter
  onPhaseMeterHeightChanged: {
    instancePrefs.log("INFO", "phaseMeterHeight changed to " + phaseMeterHeight)
  }
  property bool displayStripe:                    true          // Display stripe
  onDisplayStripeChanged: {
    instancePrefs.log("INFO", "displayStripe changed to " + displayStripe)
  }


  //--------------------------------------------------------------------------------------------------------------------
  // DISPLAY WAVEFORM PREFERENCES
  //--------------------------------------------------------------------------------------------------------------------
  property bool enhancedWaveform: true          // Enable enhanced waveform rendering
  onEnhancedWaveformChanged: {
    instancePrefs.log("INFO", "enhancedWaveform changed to " + enhancedWaveform)
  }

  // Waveform theme selection (1-11)
  // 1 - KOKERNUTZ, 
  // 2 - NEXUS
  // 3 - PRIME
  // 4 - Denon SC5000 / SC6000
  // 5 - Pioneer CDJ 2000
  // 6 - Pioneer CDJ 3000
  // 7 - NUMARK
  // 8 - X RAY
  // 9 - Infrared
  // 10 - Ultraviolet
  // 11 - Spectrum-like colors
  property int spectrumWaveformColors:            1             // Change for Spectrum Waveform Colors Themes
  onSpectrumWaveformColorsChanged: {
    instancePrefs.log("INFO", "spectrumWaveformColors changed to " + spectrumWaveformColors)
  }


  // Mixer FX names configuration
  property variant mixerFXSlotsAlias: ["FLTR", "RVRB", "DLDL", "NOISE", "TIMG", "FLNG", "BRPL", "DTDL", "CRSH"] // do not change FLTR

  // Enumerado de tipos de efectos de filtro
  readonly property var filterEffectTypes: [
    { id: 0, name: "FILTER",         alias: "FLTR"},
    { id: 1, name: "REVERB",         alias: "RVRB"},
    { id: 2, name: "DUAL DELAY",     alias: "DLDL"},
    { id: 3, name: "NOISE",          alias: "NOISE"},
    { id: 4, name: "TIME GATER",     alias: "TIMG"},
    { id: 5, name: "FLANGER",        alias: "FLNG"},
    { id: 6, name: "BARBER POLE",    alias: "BRPL"},
    { id: 7, name: "DOTTED DELAY",   alias: "DTDL"},
    { id: 8, name: "CRUSH",          alias: "CRSH"},
  ]

  function getFilterAlias(id) {
    if (id === 0) return getFilterEffectAlias(mixerFXSlot0)
    if (id === 1) return getFilterEffectAlias(mixerFXSlot1)
    if (id === 2) return getFilterEffectAlias(mixerFXSlot2)
    if (id === 3) return getFilterEffectAlias(mixerFXSlot3)
    if (id > 3) return getFilterEffectAlias(mixerFXSlot4)

    return getFilterEffectAlias(mixerFXSlot0)
  }

  // Funciones helper para el enumerado de efectos
  function getFilterEffectName(id) {
    const effect = filterEffectTypes.find(effect => effect.id === id)
    return effect ? effect.name : filterEffectTypes[0].name
  }

  function getFilterEffectAlias(id) {
    if (id >= 0 && id < mixerFXSlotsAlias.length) {
      return mixerFXSlotsAlias[id]
    }
    return mixerFXSlotsAlias[0]
  }

  function getFilterEffectId(name) {
    const effect = filterEffectTypes.find(effect => effect.name === name)
    return effect ? effect.id : filterEffectTypes[0].id
  }

  // Mixer FX Configuration
  property int mixerFXSlot0: 0  // FILTER por defecto
  property int mixerFXSlot1: 1  // REVERB por defecto
  property int mixerFXSlot2: 2  // DUAL DELAY por defecto
  property int mixerFXSlot3: 3  // NOISE por defecto
  property int mixerFXSlot4: 4  // TIME GATER por defecto

  //--------------------------------------------------------------------------------------------------------------------
  // DECK HEADER TEXT CONFIGURATION
  //--------------------------------------------------------------------------------------------------------------------
  // Text display positions (-1 to disable)
  property int topLeftText:      0
  property int topCenterText:    14
  property int topRightText:     12

  property int middleLeftText:   1
  property int middleCenterText: 31
  property int middleRightText:  24

  property int bottomLeftText:   19
  property int bottomCenterText: 15
  property int bottomRightText:  28

  //--------------------------------------------------------------------------------------------------------------------
  // BEATGRID PREFERENCES
  //--------------------------------------------------------------------------------------------------------------------
  property bool fullHeightBeatgridLines:          false
  property bool fullHeightRedBeatgridLines:       false
  property int heightBeatgridLines:               6
  property int heightRedBeatgridLines:            10
  //--------------------------------------------------------------------------------------------------------------------
  // TIME DISPLAY PREFERENCES
  //--------------------------------------------------------------------------------------------------------------------
  property bool showMillisecondsInTime: false // Show milliseconds in time display
  property bool showTimeProgressColors: true  // Show colored time progress
  property bool showTimeWarnings: true        // Enable visual time warnings
  property int timeWarningThreshold: 30       // Seconds before track end to show warning
  property bool showElapsedTimeInsteadOfBeats: false        // Show elapsed time instead of beats

  //--------------------------------------------------------------------------------------------------------------------
  // LOOP & PLAYMARKER PREFERENCES
  //--------------------------------------------------------------------------------------------------------------------
  property bool showLoopDottedLines: true     // Show dotted lines for loops
  property bool showPlaymarkerGlow: false     // Show glow effect around playmarker

  // options:
  //
  // 0:  "title",          1: "artist",       2:  "release", 
  // 3:  "mix",            4: "label",        5:  "catNo", 
  // 6:  "genre",          7: "trackLength",  8:  "bitrate", 
  // 9:  "bpmTrack",      10: "gain",        11: "elapsedTime", 
  // 12: "remainingTime", 13: "beats",       14: "beatsToCue", 
  // 15: "bpm",           16: "tempo",       17: "key", 
  // 18: "keyText",       19: "comment",     20: "comment2",
  // 21: "remixer",       22: "pitchRange",  23: "bpmStable", 
  // 24: "tempoStable",   25: "sync",        26: "off", 
  // 27: "off",           28: "bpmTrack"     29: "remixBeats"
  // 30: "remixQuantize", 31: "keyDisplay"


  //--------------------------------------------------------------------------------------------------------------------
  // FONT PREFERENCES
  //--------------------------------------------------------------------------------------------------------------------
  /* Available font options:
      A) DEFAULT:
        - "Pragmatica"
        - "Pragmatica MediumTT"
      
      B) GAMER:
        - "Consolas"
        - "TRAKTORFREON"
      
      C) ROBOTO:
        - "Roboto"
      
      Additional supported fonts:
      - "Consolas"
      - "UpheavalX1"
      - "ProggyCleanTT" (requires installation)
      - "ProggyVector" (requires installation)
  */

  // Enumerado de fuentes disponibles
  readonly property var availableFonts: [
      "Pragmatica",
      "Pragmatica MediumTT",
      "Consolas",
      "TRAKTORFREON",
      "Arial",
      "Roboto",
      "UpheavalX1",
      "ProggyCleanTT",
      "ProggyVector"
  ]

  // Función helper para obtener índice de fuente
  function getFontIndex(fontName) {
      return availableFonts.indexOf(fontName)
  }

  // Función helper para obtener nombre de fuente por índice
  function getFontName(index) {
      return availableFonts[index] || availableFonts[0]
  }

  // Default fonts
  property string normalFontName: "Pragmatica"
  property string mediumFontName: "Pragmatica MediumTT"
  property string cueFontName:    "ProggyVector"

  property int factorSmallFontSize: 0
  property int factorMiddleFontSize: 0
  property int factorLargeFontSize: 0
  property int factorExtraLargeFontSize: 0

  // Deck display fonts
  property string fontDeckHeaderNumber: "Pragmatica"
  property string fontDeckHeaderString: "Pragmatica MediumTT"

  //--------------------------------------------------------------------------------------------------------------------
  // DEBUG AND LOGGING SYSTEM
  //--------------------------------------------------------------------------------------------------------------------
  property bool debug: false                  // Enable debug mode
  property string debugResult: ""             // Store debug messages
  property int maxDebugLines: 14
  property string logLevel: "INFO"            // Nivel mínimo de log
  onLogLevelChanged: {
      log("ERROR", "logLevel changed to " + logLevel) 
  }

  // Enumeración de niveles de log
  readonly property var logLevels: {
      "ERROR": 0,
      "WARN": 1,
      "INFO": 2
  }

  // Función para obtener el índice numérico de un nivel de log
  function getLogLevelIndex(level) {
      // Si level es undefined o null, retornar el valor por defecto (INFO = 2)
      if (!level) return 2;
      
      // Convertir a mayúsculas y verificar en el enum
      const upperLevel = level.toUpperCase()
      if (logLevels.hasOwnProperty(upperLevel)) {
          return logLevels[upperLevel]
      }
      return 2 // INFO por defecto si no se encuentra
  }

  // Función para obtener el nombre del nivel de log desde un índice
  function getLogLevelFromIndex(index) {
      // Buscar la clave (nombre del nivel) que corresponde al índice
      for (const [key, value] of Object.entries(logLevels)) {
          if (value === index) return key
      }
      return "INFO" // Valor por defecto si no se encuentra
  }

  property int expandedDebugLines: 14        // Número expandido de líneas (el doble)

  // Timer para controlar la expansión temporal
  Timer {
      id: expansionTimer
      interval: 4000  // 4 segundos
      running: false
      repeat: false
      onTriggered: {
          instancePrefs.height = 0
      }
  }

  // Modificar la función log para incluir la expansión temporal
  function log(level, message) {
      // Verificar si el nivel de log está permitido
      if (!logLevels.hasOwnProperty(level) || !logLevels.hasOwnProperty(logLevel)) return
      if (logLevels[level] > logLevels[logLevel]) return

      // Expandir temporalmente el área de logs
      instancePrefs.height = 26*8
      expansionTimer.restart()

      // Obtener timestamp actual
      var now = new Date()
      var timestamp = now.getHours().toString().padStart(2, '0') + ':' +
                  now.getMinutes().toString().padStart(2, '0') + ':' +
                  now.getSeconds().toString().padStart(2, '0') + '.' +
                  now.getMilliseconds().toString().padStart(3, '0')
      
      // Dividir el registro existente en líneas
      var lines = debugResult.split('\n').filter(line => line.trim() !== '')
      
      // Añadir nueva línea al principio del array
      lines.unshift(`[${timestamp}] ${level}: ${message}`)
      
      // Mantener solo las últimas maxDebugLines líneas
      if (lines.length > maxDebugLines) {
          lines = lines.slice(0, maxDebugLines)
      }
      
      // Unir las líneas de nuevo
      debugResult = lines.join('\n')
  }

  //--------------------------------------------------------------------------------------------------------------------
  // EXPERIMENTAL OPTIONS
  //--------------------------------------------------------------------------------------------------------------------
  property bool enableDataSaving: false          // Enable data saving to files
  onEnableDataSavingChanged: {
    instancePrefs.log("INFO", "enableDataSaving changed to " + enableDataSaving)
  }

  //--------------------------------------------------------------------------------------------------------------------
  // WAVEFORM THEMES ENUMERATION
  //--------------------------------------------------------------------------------------------------------------------
  readonly property var waveformThemes: [
      { id: 1, name: "KOKERNUTZ" },
      { id: 2, name: "NEXUS" },
      { id: 3, name: "PRIME" },
      { id: 4, name: "DENON SC5000/6000" },
      { id: 5, name: "PIONEER CDJ-2000" },
      { id: 6, name: "PIONEER CDJ-3000" },
      { id: 7, name: "NUMARK" },
      { id: 8, name: "X-RAY" },
      { id: 9, name: "INFRARED" },
      { id: 10, name: "ULTRAVIOLET" },
      { id: 11, name: "SPECTRUM" },
      { id: 12, name: "PIONNER CDJ-3000 PRO" },
      { id: 13, name: "CLUB" },
      { id: 14, name: "ENERGY FLOW" },
      { id: 15, name: "DEEP HOUSE" },
      { id: 16, name: "TECHNO DARK" }
  ]

  // Helper functions para el enumerado
  function getWaveformThemeName(id) {
      const theme = waveformThemes.find(theme => theme.id === id)
      return theme ? theme.name : waveformThemes[0].name
  }

  function getWaveformThemeId(name) {
      const theme = waveformThemes.find(theme => theme.name === name)
      return theme ? theme.id : waveformThemes[0].id
  }

  //--------------------------------------------------------------------------------------------------------------------
  // THEME
  //--------------------------------------------------------------------------------------------------------------------
  // Función para obtener colores del tema actual
  function getThemeTextColor(deckId) {
    return getCurrentTheme().colors.textColors[deckId]
  }

  function getThemeDarkerTextColor(deckId) {
    return getCurrentTheme().colors.darkerTextColors[deckId]
  }

  function getThemeCoverBgColor(deckId) {
    return getCurrentTheme().colors.coverBgEmptyColors[deckId]
  }

  //--------------------------------------------------------------------------------------------------------------------
  // FOOTER FONT SIZES
  //--------------------------------------------------------------------------------------------------------------------
  property int footerNumberSize: 13
  property int footerLabelSize: 9

  //--------------------------------------------------------------------------------------------------------------------
  // THEME PREFERENCES
  //--------------------------------------------------------------------------------------------------------------------
  readonly property var colorThemes: [
    {
      id: 0,
      name: "DEFAULT",
      key: "default",
    },
    {
      id: 1,
      name: "LIGHT",
      key: "light",     
    },
    {
      id: 2,
      name: "PASTEL",
      key: "pastel",     
    },
    // Aquí se pueden añadir más temas...
  ]

  // Tema actual
  property int currentTheme: 0

  // Funciones helper para el sistema de temas
  function getCurrentTheme() {
    return colorThemes[currentTheme]
  }

  // Helper function to get a color from the current theme
  function getThemeColor(colorPath) {
    const theme = getCurrentTheme()
    const paths = colorPath.split('.')
    let result = theme.colors
    
    for (const path of paths) {
      result = result[path]
      if (result === undefined) return colorThemes[0].colors[paths[0]]
    }
    
    return result
  }

  // Helper function to get a theme name from the current theme 
  function getThemeName(id) {
    const theme = colorThemes.find(theme => theme.id === id)
    return theme ? theme.name : colorThemes[0].name
  }

  // Helper function to get a theme id from the current theme name
  function getThemeId(name) {
    const theme = colorThemes.find(theme => theme.name === name)
    return theme ? theme.id : colorThemes[0].id
  }

  //--------------------------------------------------------------------------------------------------------------------
  // MIRROR PREFERENCES
  //--------------------------------------------------------------------------------------------------------------------
 
  // 0: none
  // 1: 2 decks
  // 2: 4 decks
  property int    mirrorMode: 1
  onMirrorModeChanged: {
    instancePrefs.log("INFO", "Mirror Mode changed to " + mirrorMode)
  }

  property bool   mirrorInverted: true  // Invierte la visualización del espejo
  onMirrorInvertedChanged: {
    instancePrefs.log("INFO", "Mirror Inverted changed to " + mirrorInverted)
  }

  property real   screenScale: 1.9      // Factor de escala de la pantalla
  onScreenScaleChanged: {
    instancePrefs.log("INFO", "Screen Scale changed to " + screenScale)
  }
}
