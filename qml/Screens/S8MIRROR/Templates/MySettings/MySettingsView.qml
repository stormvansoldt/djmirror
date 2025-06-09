import CSI 1.0
import QtQuick
import Qt5Compat.GraphicalEffects
import Traktor.Gui 1.0 as Traktor

import './Widgets' as Widgets

//----------------------------------------------------------------------------------------------------------------------
// Config LOADER
//----------------------------------------------------------------------------------------------------------------------
import QtQml
import '../../../../CSI/Common/Settings'

Rectangle {
    id: settingsView

    property string settingsPath:  ""
    property string propertiesPath:  ""

    property real screenScale: prefs.screenScale

    anchors.fill: parent
    color: colors.colorGrey08 // Fondo oscuro para el menú

    // Propiedades para navegación
    property int currentSection: 0
    property int currentOption: 0
    
    property bool isEditing: false

    // Añadir señal para salir de la vista de ajustes
    signal exitSettings()


    Component.onCompleted: {
        updateOptionsModel()
    }

    function refreshPreferences() {
        prefs = configManager.loadConfigAsync()
        prefs.log("INFO", "Preferencias refrescadas")
    }

    // Config loader
    ConfigLoader {
        id: configManager
        onConfigLoaded: {
            updateOptionsModel()
            prefs.log("INFO", "Config loaded")
        }
        onConfigSaved: {
            updateOptionsModel()
            prefs.log("INFO", "Config saved")
        }
        onNotifyLog: {
            updateOptionsModel()
            prefs.log(level, message)
        }
        onThemeLoaded: {
            colors.loadTheme(themeName)
            updateOptionsModel()
            prefs.log("INFO", "Theme loaded: " + themeName)
        }
    }

    // Secciones de configuración
    readonly property var sections: [
        { name: "HELP", options: [
            { name: "Navigation", prop: "helpNavigation", proptype: "help", 
              value: "← → Change section - Bottom buttons" },
            { name: "Refresh changes", prop: "helpRefreshChanges", proptype: "help",
              value: "Refresh display deck - Intro other settings deck" },
            { name: " ", prop: "helpDiv1", proptype: "help",
              value: " " },
            { name: "Save", prop: "helpSave", proptype: "help",
              value: "Changes are saved automatically" }
        ]},
        { name: "MIRROR OPTIONS", options: [
            { name: "Mirror Inverted", prop: "mirrorInverted" },
            { name: "Screen Scale", prop: "screenScale", proptype: "decimal", min: 0.1, max: 8.0, step: 0.1 },
        ]},
        { name: "DISPLAY DECK TOP", options: [
            { name: "Deck Indicators", prop: "displayDeckIndicators" },
            { name: "Album Cover", prop: "displayAlbumCover" },
            { name: "Phase Meter", prop: "displayPhaseMeter" },
            { name: "Phase Meter Height", prop: "phaseMeterHeight", proptype: "number", min: 6, max: 20, step: 2 },
        ]},
        { name: "DISPLAY DECK CENTER", options: [
            { name: "Loop Lines", prop: "showLoopDottedLines" }
        ]},
        { name: "DISPLAY DECK BOTTOM", options: [
            { name: "Hot Cue Bar", prop: "displayHotCueBar" },
            { name: "Stripe", prop: "displayStripe" }
        ]},        
        { name: "DISPLAY TIME", options: [
            { name: "Show Milliseconds", prop: "showMillisecondsInTime" },
            { name: "Progress Colors", prop: "showTimeProgressColors" },
            { name: "Time Warnings", prop: "showTimeWarnings" },
            { name: "Warning Threshold", prop: "timeWarningThreshold", proptype: "number", min: 10, max: 60, step: 5 },
            { name: "Elapsed Instead Beats", prop: "showElapsedTimeInsteadOfBeats" }
        ]},
        { name: "DISPLAY BROWSER", options: [
            { name: "Match Guides", prop: "displayMatchGuides" },
            { name: "Item Count", prop: "displayBrowserItemCount" },
            { name: "More Items", prop: "displayMoreItems" }
        ]},
        { name: "DISPLAY THEME", options: [
            { name: "Current Theme", prop: "currentTheme", proptype: "enumtheme", min: 0, max: prefs.colorThemes.length - 1 }
        ]},
        { name: "DISPLAY WAVEFORM", options: [
            { name: "Spectrum Theme", prop: "spectrumWaveformColors", proptype: "enumwave", min: 1, max: 16, step: 1 },
            { name: "Beatgrid Height", prop: "heightBeatgridLines", proptype: "number", min: 2, max: 20, step: 2 },
            { name: "Red Grid Height", prop: "heightRedBeatgridLines", proptype: "number", min: 2, max: 20, step: 2 },
            { name: "Full Height Grid", prop: "fullHeightBeatgridLines" },
            { name: "Full Red Grid", prop: "fullHeightRedBeatgridLines" }
        ]},
        { name: "DISPLAY KEY", options: [
            { name: "Key Notation", prop: "keyNotation", proptype: "enumkey", min: 0, max: 3, step: 1 }
        ]},
        { name: "GENERAL OPTIONS", options: [
            { name: "Phrase Length", prop: "phraseLength", proptype: "number", min: 1, max: 8, step: 1 }
        ]},
        { name: "GENERAL FONTS", options: [
            { name: "Normal font type", prop: "normalFontName", proptype: "font", min: 0, max: prefs.availableFonts.length - 1, step: 1 },
            { name: "Medium font type", prop: "mediumFontName", proptype: "font", min: 0, max: prefs.availableFonts.length - 1, step: 1 },
            { name: "Cue font type", prop: "cueFontName", proptype: "font", min: 0, max: prefs.availableFonts.length - 1, step: 1 }
        ]},
        { name: "SIZE FONTS", options: [
            { name: "Factor Small Font Size", prop: "factorSmallFontSize", proptype: "number", min: 0, max: 3, step: 1 },
            { name: "Factor Middle Font Size", prop: "factorMiddleFontSize", proptype: "number", min: 0, max: 3, step: 1 },
            { name: "Factor Large Font Size", prop: "factorLargeFontSize", proptype: "number", min: 0, max: 3, step: 1 },
            { name: "Factor Extra Large Font Size", prop: "factorExtraLargeFontSize", proptype: "number", min: 0, max: 3, step: 1 }
        ]},
        { name: "HEADER FONTS", options: [
            { name: "Font Header Numbers", prop: "fontDeckHeaderNumber", proptype: "font", min: 0, max: prefs.availableFonts.length - 1, step: 1 },
            { name: "Font Header Strings", prop: "fontDeckHeaderString", proptype: "font", min: 0, max: prefs.availableFonts.length - 1, step: 1 },
        ]},
        { name: "MIXER FX SLOTS", options: [
            { name: "Mixer FX Slot 1", prop: "mixerFXSlot1", proptype: "enumfx", min: 0, max: 8, step: 1 },
            { name: "Mixer FX Slot 2", prop: "mixerFXSlot2", proptype: "enumfx", min: 0, max: 8, step: 1 },
            { name: "Mixer FX Slot 3", prop: "mixerFXSlot3", proptype: "enumfx", min: 0, max: 8, step: 1 },
            { name: "Mixer FX Slot 4", prop: "mixerFXSlot4", proptype: "enumfx", min: 0, max: 8, step: 1 },
        ]},
        { name: "MIXER OPTIONS", options: [
            { name: "Fine Master Tempo", prop: "fineMasterTempoAdjust" },
            { name: "Fine Deck Tempo", prop: "fineDeckTempoAdjust" },
            { name: "", prop: "helpDiv", proptype: "help", value: "" },     
            { name: "NOTE: ", prop: "helpRestartRequired", proptype: "help", 
              value: "This options require a restart to apply changes" },            
        ]},
        { name: "EXPERIMENTAL OPTIONS", options: [
            { name: "Mixer FX Selector", prop: "mixerFXSelector" },
            { name: "Prioritize FX", prop: "prioritizeFXSelection" },
            { name: "", prop: "helpDiv", proptype: "help", value: "" },     
            { name: "NOTE: ", prop: "helpRestartRequired", proptype: "help", 
              value: "This options require a restart to apply changes" },            
        ]},
        { name: "DEVELOPER MODE", options: [
            { name: "Debug Mode", prop: "debug" },
            { name: "Log Level", prop: "logLevel", proptype: "enumlog", min: 0, max: 2, step: 1 },
            { name: "", prop: "helpDiv", proptype: "help", value: "" },
            { name: "VERSION: ", prop: "helpVersion", proptype: "help", value: "1.1.0" },               
        ]}
    ]

    // Modelo para la lista de opciones
    ListModel { id: optionsModel }

    // Función para actualizar el modelo
    function updateOptionsModel() {
        optionsModel.clear()
        var options = sections[currentSection].options

        for (var i = 0; i < options.length; i++) {
            var option = options[i]
            
            var value = ""
            switch(option.proptype) {
                case "help":
                    value = option.value
                    break
                    
                case "enumwave":
                    value = prefs.getWaveformThemeName(prefs[option.prop])
                    break

                case "enumcolor":
                    value = prefs.getThemeColor(prefs[option.prop])
                    break

                case "enumtheme":
                    value = prefs.colorThemes[prefs[option.prop]].name
                    break

                case "enumfx":
                    value = prefs.getFilterEffectName(prefs[option.prop])
                    break

                case "enumlog":
                    value = ["ERROR", "WARN", "INFO"][prefs.getLogLevelIndex(prefs[option.prop])]
                    break

                case "numenumtimeformatber":
                    value = ["ELAPSED", "REMAIN", "BOTH"][prefs[option.prop]]
                    break

                case "number":
                    value = "" + prefs[option.prop]
                    break

                case "font":
                    value = "" + prefs[option.prop]
                    break
                    
                case "enumkey":
                    value = ["Camelot", "Open Key", "Musical", "Musical All"][prefs[option.prop] === "camelot" ? 0 : 
                            prefs[option.prop] === "open" ? 1 :
                            prefs[option.prop] === "musical" ? 2 : 3];
                    break;

                case "enummirror":
                    value = ["None", "2 Decks"][prefs[option.prop]]  //, "4 Decks"
                    break;

                case "decimal":
                    value = prefs[option.prop].toFixed(1)
                    break;

                default: // boolean
                    value = prefs[option.prop] ? "ON" : "OFF"
                    break
            }

            optionsModel.append({
                name: option.name,
                prop: option.prop,
                proptype: option.proptype || "boolean",
                propvalue: value,
                min: option.min,
                max: option.max,
                step: option.step,
                highlight: i === currentOption
            })
        }

        // Forzar actualización de la vista
        optionsList.currentIndex = -1
        Qt.callLater(function() {
            optionsList.currentIndex = currentOption
        })
    }

    // Navegación con actualización del modelo
    function navigateUp() { 
        if (currentOption > 0) {
            currentOption--
        }
    }

    function navigateDown() {
        if (currentOption < sections[currentSection].options.length - 1) {
            currentOption++
        }
    }

    function navigateLeft() {
        if (currentSection > 0) {
            currentSection--
            currentOption = 0
        }
    }

    function navigateRight() {
        if (currentSection < sections.length - 1) {
            currentSection++
            currentOption = 0
        }
    }

    // Añadir observadores para las propiedades de navegación
    onCurrentSectionChanged: { updateOptionsModel() }
    onCurrentOptionChanged: { updateOptionsModel() }

    function toggleOption(operation) {
        var option = sections[currentSection].options[currentOption]
        
        // Ignorar si es un elemento de ayuda
        if (option.proptype === "help") return

        // Aplicar operación según el tipo de opción
        switch(option.proptype) {
            case "enumwave":
                var currentValue = prefs[option.prop]
                if (operation === "increment") {
                    currentValue = currentValue + 1
                    if (currentValue > option.max) currentValue = option.min
                } else if (operation === "decrement") {
                    currentValue = currentValue - 1
                    if (currentValue < option.min) currentValue = option.max
                }
                prefs[option.prop] = currentValue
                break;

            case "enumcolor":
                var currentValue = prefs[option.prop]
                if (operation === "increment") {
                    currentValue = currentValue + 1
                    if (currentValue > option.max) currentValue = option.min
                } else if (operation === "decrement") {
                    currentValue = currentValue - 1
                    if (currentValue < option.min) currentValue = option.max
                }
                prefs[option.prop] = currentValue
                break;

            case "enumtheme":
                var currentValue = prefs[option.prop]
                if (operation === "increment") {
                    currentValue = (currentValue + 1) % prefs.colorThemes.length
                } else if (operation === "decrement") {
                    currentValue = currentValue - 1
                    if (currentValue < 0) currentValue = prefs.colorThemes.length - 1
                }
                prefs[option.prop] = currentValue
                configManager.applyTheme()
                break;

            case "enumfx":
                var currentValue = prefs[option.prop]
                if (operation === "increment") {
                    currentValue = currentValue + 1
                    if (currentValue > option.max) currentValue = option.min
                } else if (operation === "decrement") {
                    currentValue = currentValue - 1
                    if (currentValue < option.min) currentValue = option.max
                }
                prefs[option.prop] = currentValue
                break;
                
            case "enumlog":
                var currentIndex = prefs.getLogLevelIndex(prefs[option.prop])
                if (operation === "increment") {
                    currentIndex = (currentIndex + 1) % 3
                } else if (operation === "decrement") {
                    currentIndex = currentIndex - 1
                    if (currentIndex < 0) currentIndex = 2
                }
                prefs[option.prop] = prefs.getLogLevelFromIndex(currentIndex)
                break;

            case "font":
                var currentIndex = prefs.getFontIndex(prefs[option.prop])
                if (operation === "increment") {
                    currentIndex = (currentIndex + 1) % prefs.availableFonts.length
                } else if (operation === "decrement") {
                    currentIndex = currentIndex - 1
                    if (currentIndex < 0) currentIndex = prefs.availableFonts.length - 1
                }
                prefs[option.prop] = prefs.getFontName(currentIndex)
                break;

            case "number":
                var value = prefs[option.prop]
                if (operation === "increment") {
                    value = value + option.step
                    if (value > option.max) value = option.min
                } else if (operation === "decrement") {
                    value = value - option.step
                    if (value < option.min) value = option.max
                }
                prefs[option.prop] = value
                break;

            case "enumtheme":
                var currentValue = prefs[option.prop]
                if (operation === "increment") {
                    currentValue = (currentValue + 1) % prefs.colorThemes.length
                } else if (operation === "decrement") {
                    currentValue = currentValue - 1
                    if (currentValue < 0) currentValue = prefs.colorThemes.length - 1
                }
                prefs[option.prop] = currentValue
                configManager.applyTheme()
                break;

            case "enumkey":
                let notations = ["camelot", "open", "musical", "musical_all"];
                if (operation === "increment") {
                    let currentIndex = notations.indexOf(prefs[option.prop]);
                    currentIndex = (currentIndex + 1) % notations.length;
                    prefs[option.prop] = notations[currentIndex];
                } else if (operation === "decrement") {
                    let currentIndex = notations.indexOf(prefs[option.prop]);
                    currentIndex = currentIndex - 1;
                    if (currentIndex < 0) currentIndex = notations.length - 1;
                    prefs[option.prop] = notations[currentIndex];
                }
                break;

            case "enummirror":
                var currentValue = prefs[option.prop]
                if (operation === "increment") {
                    currentValue = (currentValue + 1) % 3
                } else if (operation === "decrement") {
                    currentValue = currentValue - 1
                    if (currentValue < 0) currentValue = 2
                }
                prefs[option.prop] = currentValue
                break;

            case "decimal":
                var value = prefs[option.prop]
                if (operation === "increment") {
                    value = Math.min(value + option.step, option.max)
                } else if (operation === "decrement") {
                    value = Math.max(value - option.step, option.min)
                }
                prefs[option.prop] = value
                break;

            default: // boolean
                prefs[option.prop] = !prefs[option.prop]
                break;
        }

        updateOptionsModel()
        configManager.saveConfig(prefs)
    }

    // Header
    Widgets.SettingsHeader {
        id: header
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        title: "SETTINGS - " + sections[currentSection].name
    }

    // Lista de opciones actualizada
    Widgets.SettingsList {
        id: optionsList
        anchors.top: header.bottom
        anchors.bottom: footer.top
        anchors.left: parent.left
        anchors.right: parent.right
        model: optionsModel
        currentIndex: currentOption
    }

    // Footer
    Widgets.SettingsFooter {
        id: footer
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        
        // Conectar la señal de solicitud de salida
        onExitSettingsRequested: {
            // Emitir la señal de salida del componente principal
            settingsView.exitSettings()

            // Refrescar preferencias
            settingsView.refreshPreferences()
        }
    }
}
