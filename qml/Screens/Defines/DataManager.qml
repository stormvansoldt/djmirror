import CSI 1.0
import QtQuick

// Save LOGS
/*
Accessing local files
By default, you cannot use the XMLHttpRequest object to read files from your local file system. If you wish to use this feature to access local files, you can set the following environment variables to 1.

QML_XHR_ALLOW_FILE_READ
QML_XHR_ALLOW_FILE_WRITE
Warning: Use this feature only if you know that the application runs trusted QML and JavaScript code.
*/

Item {

  //------------------------------------------------------------------------------------------------------------------
  // DEBUG MAPPING
  //------------------------------------------------------------------------------------------------------------------

  AppProperty { id: traktorPath; path: "app.traktor.settings.paths.root" }

  property var activeRequests: []  // Para rastrear requests activos

  function cleanupRequest(request) {
      const index = activeRequests.indexOf(request)
      if (index > -1) {
          activeRequests.splice(index, 1)
      }
      request.onreadystatechange = null
      request = null
  }

  function getSettingsFilePath(fileName) {
    var configpath = "";
    configpath = traktorPath.value;

    if (prefs.osMode === 1) {
      configpath = "file:///" + configpath.replace(/\\/g,"/") + "/" + fileName;
    } else {
      configpath = "file:///Volumes/" + configpath.replace(/:/g, "/") + "/" + fileName;
    }
  
    return configpath;
  }

  function saveFile(fileUrl, fileContent) {
    // Limitar el número de requests activos
    if (activeRequests.length >= 5) {
        return
    }

    try {
        var request = new XMLHttpRequest()
        activeRequests.push(request)
        
        request.open("PUT", fileUrl, true)
        request.onreadystatechange = function() {
            if (request.readyState === 4) {
                if (request.status === 200) {
                    fileWritten(fileUrl)
                }
                cleanupRequest(request)
            }
        }
        
        request.onerror = function() {
            cleanupRequest(request)
        }
        
        request.ontimeout = function() {
            cleanupRequest(request)
        }

        request.timeout = 5000  // 5 segundos de timeout
        request.send(fileContent)
    } catch (e) {
        cleanupRequest(request)
    }
  }

  function save(fileName, data) {
      var configPath = getSettingsFilePath(fileName);
      saveFile(configPath, JSON.stringify(data, null, 2));
  }

  //--------------------------------------------------------------------------------------------------------------------
  // SAVE LOG PREFERENCES
  //--------------------------------------------------------------------------------------------------------------------

  function saveLogPreferences(fileName) {
      var config = getConfig();
      var configPath = getSettingsFilePath(fileName);
      saveFile(configPath, JSON.stringify(config, null, 2));
  }

  function getConfig() {
      var configuracion = {
        "traktorPath;": traktorPath.value,
        "s12Mode": prefs.s12Mode,
        "fineDeckTempoAdjust": prefs.fineDeckTempoAdjust,
        "fineMasterTempoAdjust": prefs.fineMasterTempoAdjust,
        "mixerFXSelector": prefs.mixerFXSelector,
        "prioritizeFXSelection": prefs.prioritizeFXSelection,
        "useMIDIControls": prefs.useMIDIControls,
      };
      
      return configuracion;
  }

  //--------------------------------------------------------------------------------------------------------------------
  // LOG FUNCTIONS
  //--------------------------------------------------------------------------------------------------------------------

  function saveLog(fileName, description) {
      if (!fileName || !description) return;
      
        // Añadir timestamp al objeto de log
        var timestamp = '2025-03-03 12:00:00';
        var logWithTimestamp = {};
        
        // Obtener la ruta completa y guardar
        var logPath = getSettingsFilePath(fileName);
        saveFile(logPath, description);
  }
}
