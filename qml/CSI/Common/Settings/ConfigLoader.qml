import CSI 1.0
import QtQuick

// Config LOADER
/*
Accessing local files
By default, you cannot use the XMLHttpRequest object to read files from your local file system. If you wish to use this feature to access local files, you can set the following environment variables to 1.

QML_XHR_ALLOW_FILE_READ
QML_XHR_ALLOW_FILE_WRITE
Warning: Use this feature only if you know that the application runs trusted QML and JavaScript code.
*/

Item {
  id: configLoader

  AppProperty { id: traktorPath; path: "app.traktor.settings.paths.root" }
  

  readonly property string _XMLHTTP_GET       : "GET"
  readonly property string _XMLHTTP_PUT       : "PUT"
  readonly property bool   _XMLHTTP_SYNCHRO   : false
  readonly property bool   _XMLHTTP_ASYNCHRO  : true
  readonly property int    _XMLHTTP_DONE      : 4

  signal fileWritten( url fileUrl )

  signal configLoaded()
  signal configSaved()

  signal themeLoaded( string themeName )

  signal notifyLog( string message, string level )

  Component.onCompleted: { 
    // Leemos de forma Sincrona
    //loadConfig()

    // Leemos de forma asincrona
    loadConfigAsync()
  }

  function loadConfig() {
    var configpath = getSettingsFilePath()
    notifyLog("Config path: " + configpath, "WARN")
    var result = openFile(configpath)
    notifyLog("result: " + result, "WARN")

    try {
      var prefsTemp = JSON.parse(result)
      updatePrefs(prefsTemp)
      configLoaded()
    } catch (e) {
      saveConfig(prefs)
      notifyLog("Error on load config: " + e.message, "ERROR")
    }
  }

  function prepareConfigData(prefs) {
    return {
        // System
        objectName: prefs.objectName,
        osMode: prefs.osMode,

        // Global Controller
        s12Mode: prefs.s12Mode,

        // Global Mixer
        fineMasterTempoAdjust: prefs.fineMasterTempoAdjust,
        fineDeckTempoAdjust: prefs.fineDeckTempoAdjust,

        // Theme System
        currentTheme: prefs.currentTheme,

        // Global
        keyNotation: prefs.keyNotation,
        phraseLength: prefs.phraseLength,

        // Browser
        displayMatchGuides: prefs.displayMatchGuides,
        displayMoreItems: prefs.displayMoreItems,

        // Display
        displayAlbumCover: prefs.displayAlbumCover,
        displayHotCueBar: prefs.displayHotCueBar,
        displayDeckIndicators: prefs.displayDeckIndicators,
        displayPhaseMeter: prefs.displayPhaseMeter,
        phaseMeterHeight: prefs.phaseMeterHeight,
        displayStripe: prefs.displayStripe,

        // Waveform
        enhancedWaveform: prefs.enhancedWaveform,
        spectrumWaveformColors: prefs.spectrumWaveformColors,
        mixerFXSlotsAlias: prefs.mixerFXSlotsAlias,
        mixerFXSlot0: prefs.mixerFXSlot0,
        mixerFXSlot1: prefs.mixerFXSlot1,
        mixerFXSlot2: prefs.mixerFXSlot2,
        mixerFXSlot3: prefs.mixerFXSlot3,
        mixerFXSlot4: prefs.mixerFXSlot4,

        // Deck Header Text
        topLeftText: prefs.topLeftText,
        topCenterText: prefs.topCenterText,
        topRightText: prefs.topRightText,
        middleLeftText: prefs.middleLeftText,
        middleCenterText: prefs.middleCenterText,
        middleRightText: prefs.middleRightText,
        bottomLeftText: prefs.bottomLeftText,
        bottomCenterText: prefs.bottomCenterText,
        bottomRightText: prefs.bottomRightText,

        // Beatgrid
        fullHeightBeatgridLines: prefs.fullHeightBeatgridLines,
        fullHeightRedBeatgridLines: prefs.fullHeightRedBeatgridLines,
        heightBeatgridLines: prefs.heightBeatgridLines,
        heightRedBeatgridLines: prefs.heightRedBeatgridLines,

        // Fonts
        normalFontName: prefs.normalFontName,
        mediumFontName: prefs.mediumFontName,
        cueFontName: prefs.cueFontName,

        fontDeckHeaderNumber: prefs.fontDeckHeaderNumber,
        fontDeckHeaderString: prefs.fontDeckHeaderString,

        // Font Sizes
        factorSmallFontSize: prefs.factorSmallFontSize,
        factorMiddleFontSize: prefs.factorMiddleFontSize,
        factorLargeFontSize: prefs.factorLargeFontSize,
        factorExtraLargeFontSize: prefs.factorExtraLargeFontSize,

        // Debug
        debug: prefs.debug,
        logLevel: prefs.logLevel,

        // Loop & Playmarker
        showLoopDottedLines: prefs.showLoopDottedLines,
        showPlaymarkerGlow: prefs.showPlaymarkerGlow,

        // Time
        showMillisecondsInTime: prefs.showMillisecondsInTime,
        showTimeProgressColors: prefs.showTimeProgressColors,
        showTimeWarnings: prefs.showTimeWarnings,
        timeWarningThreshold: prefs.timeWarningThreshold,
        showElapsedTimeInsteadOfBeats: prefs.showElapsedTimeInsteadOfBeats,

        // Footer Fonts
        footerNumberSize: prefs.footerNumberSize,
        footerLabelSize: prefs.footerLabelSize,

        // Footer Colors
        bpmColor: prefs.bpmColor,
        tempoColor: prefs.tempoColor,

        // Browser
        displayBrowserItemCount: prefs.displayBrowserItemCount,

        // Experimental Options
        mixerFXSelector: prefs.mixerFXSelector,
        prioritizeFXSelection: prefs.prioritizeFXSelection,
        enableDataSaving: prefs.enableDataSaving,

        // Mirror Options
        mirrorMode: prefs.mirrorMode,
        mirrorInverted: prefs.mirrorInverted,
        screenScale: prefs.screenScale
    };
  }

  function saveConfig(prefs) {
    var configPath = getSettingsFilePath();
    var prefsToSave = prepareConfigData(prefs);
    
    // Guardar configuración Sync
    //saveFile(configPath, JSON.stringify(prefsToSave, null, 2));

    // Guardar configuración Aync
    saveConfigAsync(prefsToSave);

    // Emitir señal después de guardar
    configSaved();
    
    // Forzar actualización inmediata
    applyTheme();
  }

  function updatePrefs(prefsTemp) {
    // Controller
    prefs.s12Mode = prefsTemp.s12Mode

    // Mixer
    prefs.fineMasterTempoAdjust = prefsTemp.fineMasterTempoAdjust
    prefs.fineDeckTempoAdjust = prefsTemp.fineDeckTempoAdjust

    // Theme System
    prefs.currentTheme = prefsTemp.currentTheme

    // Global
    prefs.keyNotation = prefsTemp.keyNotation
    prefs.phraseLength = prefsTemp.phraseLength

    // Browser
    prefs.displayMatchGuides = prefsTemp.displayMatchGuides
    prefs.displayMoreItems = prefsTemp.displayMoreItems

    // Display
    prefs.displayAlbumCover = prefsTemp.displayAlbumCover
    prefs.displayHotCueBar = prefsTemp.displayHotCueBar
    prefs.displayDeckIndicators = prefsTemp.displayDeckIndicators
    prefs.displayPhaseMeter = prefsTemp.displayPhaseMeter
    prefs.phaseMeterHeight = prefsTemp.phaseMeterHeight || 20
    prefs.displayStripe = prefsTemp.displayStripe

    // Waveform
    prefs.enhancedWaveform = prefsTemp.enhancedWaveform
    prefs.spectrumWaveformColors = prefsTemp.spectrumWaveformColors
    prefs.mixerFXSlotsAlias = prefsTemp.mixerFXSlotsAlias
    prefs.mixerFXSlot0 = prefsTemp.mixerFXSlot0
    prefs.mixerFXSlot1 = prefsTemp.mixerFXSlot1
    prefs.mixerFXSlot2 = prefsTemp.mixerFXSlot2
    prefs.mixerFXSlot3 = prefsTemp.mixerFXSlot3
    prefs.mixerFXSlot4 = prefsTemp.mixerFXSlot4

    // Deck Header Text
    prefs.topLeftText = prefsTemp.topLeftText
    prefs.topCenterText = prefsTemp.topCenterText
    prefs.topRightText = prefsTemp.topRightText
    prefs.middleLeftText = prefsTemp.middleLeftText
    prefs.middleCenterText = prefsTemp.middleCenterText
    prefs.middleRightText = prefsTemp.middleRightText
    prefs.bottomLeftText = prefsTemp.bottomLeftText
    prefs.bottomCenterText = prefsTemp.bottomCenterText
    prefs.bottomRightText = prefsTemp.bottomRightText

    // Beatgrid
    prefs.fullHeightBeatgridLines = prefsTemp.fullHeightBeatgridLines
    prefs.fullHeightRedBeatgridLines = prefsTemp.fullHeightRedBeatgridLines
    prefs.heightBeatgridLines = prefsTemp.heightBeatgridLines
    prefs.heightRedBeatgridLines = prefsTemp.heightRedBeatgridLines

    // Fonts
    prefs.normalFontName = prefsTemp.normalFontName
    prefs.mediumFontName = prefsTemp.mediumFontName
    prefs.cueFontName = prefsTemp.cueFontName

    prefs.fontDeckHeaderNumber = prefsTemp.fontDeckHeaderNumber
    prefs.fontDeckHeaderString = prefsTemp.fontDeckHeaderString

    // Font Sizes
    prefs.factorSmallFontSize = prefsTemp.factorSmallFontSize
    prefs.factorMiddleFontSize = prefsTemp.factorMiddleFontSize
    prefs.factorLargeFontSize = prefsTemp.factorLargeFontSize
    prefs.factorExtraLargeFontSize = prefsTemp.factorExtraLargeFontSize

    // Debug
    prefs.debug = prefsTemp.debug
    prefs.logLevel = prefsTemp.logLevel || "WARN"

    // Loop & Playmarker
    prefs.showLoopDottedLines = prefsTemp.showLoopDottedLines
    prefs.showPlaymarkerGlow = prefsTemp.showPlaymarkerGlow

    // Time
    prefs.showMillisecondsInTime = prefsTemp.showMillisecondsInTime
    prefs.showTimeProgressColors = prefsTemp.showTimeProgressColors
    prefs.showTimeWarnings = prefsTemp.showTimeWarnings
    prefs.timeWarningThreshold = prefsTemp.timeWarningThreshold
    prefs.showElapsedTimeInsteadOfBeats = prefsTemp.showElapsedTimeInsteadOfBeats

    // Footer Fonts
    prefs.footerNumberSize = prefsTemp.footerNumberSize
    prefs.footerLabelSize = prefsTemp.footerLabelSize

    // Browser
    prefs.displayBrowserItemCount = prefsTemp.displayBrowserItemCount

    // Experimental Options
    prefs.mixerFXSelector = prefsTemp.mixerFXSelector
    prefs.prioritizeFXSelection = prefsTemp.prioritizeFXSelection
    prefs.enableDataSaving = prefsTemp.enableDataSaving

    // Mirror Options
    prefs.mirrorMode = prefsTemp.mirrorMode || 1
    prefs.mirrorInverted = prefsTemp.mirrorInverted
    prefs.screenScale = prefsTemp.screenScale || 1.0
  }

  function getSettingsFilePath() {
    var configpath = "";
    configpath = traktorPath.value;
    
    if (prefs.osMode === 1) {	
      configpath = "file:///" + configpath.replace(/\\/g,"/") + "/Settings/Settings.json";
    } else {
      //configpath = "file:///Volumes" + configpath.replace(/:/g, "/") + "/Settings/Settings.json";
      configpath = "" + configpath.replace(/:/g, "/") + "/Settings/Settings.json";
    }
    
    return configpath;
  }


  //-------------- OPEN FILE SINCRONA

  /*
  function openFile(fileUrl) {
    notifyLog("openFile: " + fileUrl, "INFO");
    
    try {
        const request = new XMLHttpRequest();
        request.open(_XMLHTTP_GET, fileUrl, false); // false = síncrono
        request.send();
        
        if (request.status === 200) {
            notifyLog("Archivo leído correctamente", "INFO");
            return request.responseText;
        } else {
            throw new Error('Error al leer el archivo OpenFile: ' + request.status);
        }
    } catch (error) {
        notifyLog("Error al leer el archivo: OpenFile" + error, "ERROR");
        throw error;
    }
  }

  function openFileOld(fileUrl) {
    const request = new XMLHttpRequest();
    request.open(_XMLHTTP_GET, fileUrl, false); // false = síncrono
    request.send(null);
    return request.responseText;
  }
*/
  //-------------- OPEN FILE ASINCRONA

  function openFileAsync(fileUrl) {
      notifyLog("openFileAsync: " + fileUrl, "INFO");
      
      return {
          then: function(onSuccess, onError) {
              var request = new XMLHttpRequest();
              request.open(_XMLHTTP_GET, fileUrl, true); // true = asíncrono
              
              request.onreadystatechange = function() {
                  if (request.readyState === XMLHttpRequest.DONE) {
                      if (request.status === 200) {
                          notifyLog("Archivo leído correctamente", "INFO");
                          onSuccess(request.responseText);
                      } else {
                          var error = new Error('Error al leer el archivo openFileAsync: ' + request.status);
                          notifyLog("Error al leer el archivo: openFileAsync" + error + " - " + request.status, "ERROR");
                          if (onError) {
                              onError(error);
                          }
                      }
                  }
              };

              request.onerror = function() {
                  var error = new Error('Error en la petición XMLHttpRequest');
                  notifyLog("Error al leer el archivo: openFileAsync" + error, "ERROR");
                  if (onError) {
                      onError(error);
                  }
              };

              request.ontimeout = function() {
                  var error = new Error('Timeout en la petición');
                  notifyLog("Error al leer el archivo: openFileAsync" + error, "ERROR");
                  if (onError) {
                      onError(error);
                  }
              };

              request.timeout = 10000; // 10 segundos de timeout
              request.send();
          }
      };
  }

  // Función para cargar la configuración con callbacks
  function loadConfigWithCallback(callback) {
      var configpath = getSettingsFilePath();
      notifyLog("Config path: " + configpath, "WARN");
      
      openFileAsync(configpath).then(
          function(result) {
              try {
                  var prefsTemp = JSON.parse(result);
                  updatePrefs(prefsTemp);
                  configLoaded();
                  if (callback) {
                      callback(null, result);
                  }
              } catch (e) {
                  notifyLog("Error parsing config: " + e.message, "ERROR");
                  if (callback) {
                      callback(e);
                  }
              }
          },
          function(error) {
              notifyLog("Error on load config: " + error.message, "ERROR");
              saveConfig(prefs);
              if (callback) {
                  callback(error);
              }
          }
      );
  }

  // Ejemplo de uso:
  function loadConfigAsync() {
      loadConfigWithCallback(function(error, result) {
          if (error) {
              notifyLog("Error loading config: " + error.message, "ERROR");
              return;
          }
          notifyLog("Config loaded successfully", "INFO");
      });
  }

  //-------------- SAVE FILE SINCRONA

  function saveFile(fileUrl, fileContent) {
      var request = new XMLHttpRequest()
      request.open(_XMLHTTP_PUT, fileUrl, true)
      request.onreadystatechange = function() {
          if( request.readyState === 4 ) {
              fileWritten(fileUrl)
          }
      }
      request.send(fileContent)
  }

  //-------------- SAVE FILE ASINCRONA
  function saveFileAsync(fileUrl, fileContent) {
      notifyLog("saveFileAsync: " + fileUrl, "INFO");
      
      return {
          then: function(onSuccess, onError) {
              var request = new XMLHttpRequest();
              request.open(_XMLHTTP_PUT, fileUrl, true);
              
              request.onreadystatechange = function() {
                  if (request.readyState === XMLHttpRequest.DONE) {
                      if (request.status === 200 || request.status === 201) {
                          notifyLog("Archivo guardado correctamente: " + fileUrl, "INFO");
                          fileWritten(fileUrl);
                          onSuccess(fileUrl);
                      } else {
                          var error = new Error('Error al guardar el archivo: ' + request.status);
                          notifyLog("Error al guardar el archivo: " + error, "ERROR");
                          if (onError) {
                              onError(error);
                          }
                      }
                  }
              };

              request.onerror = function() {
                  var error = new Error('Error en la petición XMLHttpRequest al guardar');
                  notifyLog("Error al guardar el archivo: " + error, "ERROR");
                  if (onError) {
                      onError(error);
                  }
              };

              request.ontimeout = function() {
                  var error = new Error('Timeout en la petición al guardar');
                  notifyLog("Error al guardar el archivo: " + error, "ERROR");
                  if (onError) {
                      onError(error);
                  }
              };

              request.timeout = 10000; // 10 segundos de timeout
              
              try {
                  request.send(fileContent);
              } catch (e) {
                  if (onError) {
                      onError(e);
                  }
              }
          }
      };
  }

  // Función wrapper con callback para mantener compatibilidad
  function saveFileWithCallback(fileUrl, fileContent, callback) {
      notifyLog("saveFileWithCallback: " + fileUrl, "INFO");
      
      saveFileAsync(fileUrl, fileContent).then(
          function(result) {
              if (callback) {
                  callback(null, result);
              }
          },
          function(error) {
              if (callback) {
                  callback(error);
              }
          }
      );
  }

  // Ejemplo de uso:
  function saveConfigAsync(config) {
      var configpath = getSettingsFilePath();
      var content = JSON.stringify(config, null, 2);
      
      saveFileWithCallback(configpath, content, function(error, result) {
          if (error) {
              notifyLog("Error saving config: " + error.message, "ERROR");
              return;
          }
          notifyLog("Config saved successfully", "INFO");
      });
  }

  //-------------- 

  // Añadir una función para aplicar el tema
  function applyTheme() {
      notifyLog("Entering applyTheme()", "INFO")

      const currentThemeIndex = prefs.currentTheme || 0

      notifyLog("currentThemeIndex: " + currentThemeIndex, "INFO")
      
      // Verificar si prefs.colorThemes existe y tiene elementos
      if (!prefs.colorThemes || !prefs.colorThemes.length) {
          notifyLog("Error: prefs.colorThemes not defined or empty", "ERROR")
          return
      }
      
      const themeName = prefs.colorThemes[currentThemeIndex].name.toLowerCase()
      notifyLog("Applying theme: " + themeName + " (index: " + currentThemeIndex + ")", "INFO")

      // Aplicar el tema desde ThemeDefinitions
      notifyLog("Loading theme " + themeName, "INFO")
      themeLoaded(themeName)
      notifyLog("Theme " + themeName + " loaded", "INFO")
  }

  // Llamar a applyTheme cuando se carga la configuración
  onConfigLoaded: {
      notifyLog("Config loaded. Applying theme", "INFO")
      applyTheme()
      notifyLog("Theme applied", "INFO")
      updateOptionsModel()
      notifyLog("Options model updated", "INFO")
  }
}
