import QtQuick
import "."  // Importar desde el directorio actual

//------------------------------------------------------------------------------------------------------------------
//  COLORS - Gestor central de colores para la aplicación
//
//  Características principales:
//  - Gestiona todos los colores de la aplicación
//  - Soporta múltiples temas (default, dark, light)
//  - Proporciona funciones de conversión y manipulación de colores
//  - Organiza colores por categorías funcionales
//
//  Sistema de Temas:
//  - currentTheme: Tema actual ("default", "dark", "light")
//  - getThemeColor(): Función para obtener colores del tema actual
//  - Fallback al tema "default" si un color no existe en el tema actual
//
//  Categorías principales de colores:
//  1. Colores Base:
//     - Colores fundamentales (black, white, orange, red, green)
//     - Opacidades de negro (94% a 6%)
//     - Opacidades de blanco (75% a 6%)
//     - Escala de grises (232 a 8)
//
//  2. Colores Funcionales:
//     - Phase Meter: Colores para visualización de fase
//     - Browser: Colores para navegación y prelisten
//     - Hotcues: Colores para diferentes tipos de cues
//     - Freeze/Slicer: Colores para modos de manipulación
//     - Musical Keys: Paleta para visualización de tonalidades
//
//  3. Paletas de Color:
//     - 16 colores en tres niveles de brillo (Bright, Mid, Dark)
//     - Función palette() para selección basada en brillo
//     - Soporte para estados especiales (Off, Empty)
//
//  4. Colores de UI:
//     - Deck: Colores específicos para decks
//     - FX: Colores para efectos y controles
//     - Waveform: Colores para forma de onda
//     - Loop: Colores para visualización de loops
//
//  Funciones Auxiliares:
//  - neutralizer(): Normaliza valores RGB
//  - rgba(): Convierte valores RGB+A a color Qt
//
//  Notas:
//  - Todos los colores son accesibles como propiedades
//  - Los colores pueden ser arrays [r,g,b,a] u objetos Qt.rgba
//  - Soporte para colores anidados (browser.prelisten, hotcue.grid, etc.)
//------------------------------------------------------------------------------------------------------------------

QtObject {
  property ThemeDefinitions themesManager: ThemeDefinitions { }

  // Propiedad para controlar el tema actual
  property string currentTheme: "default"  // Puede ser "default", "dark" o "light"
  
  // Sistema de caché para colores
  property var _colorCache: ({})

  // Función para obtener el color del tema actual
  function getThemeColor(colorName) {
      // Verificar caché primero
      if (_colorCache[colorName]) {
          return _colorCache[colorName]
      }

      let parts = colorName.split('.')
      let color
      
      if (parts.length > 1) {
          // Es un color anidado, navegar por el objeto
          let obj = themesManager.themes[currentTheme]?.[parts[0]] || themesManager.themes["default"][parts[0]]
          
          // Manejar casos especiales
          if (parts[0] === "hotcueColors") {
              let index = parseInt(parts[1])
              color = obj?.[index] || themesManager.themes["default"].hotcueColors[index]
          } else if (parts[0] === "waveformColorsMap") {
              let index = parseInt(parts[1])
              color = obj?.[index] || themesManager.themes["default"].waveformColorsMap[index]
          } else if (parts[0] === "deckItemColors") {
              let property = parts[1].replace(/\[(.*?)\]/, '')
              let index = parts[1].match(/\[(.*?)\]/)?.[1] || 0
              
              if (obj?.[property] && Array.isArray(obj[property])) {
                  color = obj[property][index] || themesManager.themes["default"][parts[0]]?.[property]?.[index]
              }
          } else if (parts[0] === "deckColors") {
              // Manejar estructura anidada de deckColors
              if (parts.length >= 3) {
                  let currentObj = obj
                  
                  // Navegar por la estructura anidada
                  for (let i = 1; i < parts.length; i++) {
                      currentObj = currentObj?.[parts[i]]
                      
                      // Si no se encuentra, intentar con el tema default
                      if (!currentObj) {
                          currentObj = themesManager.themes["default"]
                          // Volver a navegar desde el principio en el tema default
                          for (let j = 0; j <= i; j++) {
                              currentObj = currentObj?.[parts[j]]
                          }
                          break
                      }
                  }
                  
                  color = currentObj

                  // Manejo especial para MixerFX
                  if (parts[1] === "indicators" && parts[2] === "mixerfx") {
                      if (color === "fromMixerFXColors") {
                          // Usar el color del efecto actual
                          return mixerFXColors[currentEffect] // Asegúrate de tener acceso a estas variables
                      }
                  }
              } else {
                  color = obj?.[parts[1]] || themesManager.themes["default"][parts[0]]?.[parts[1]]
              }
          } else {
              color = obj?.[parts[1]] || themesManager.themes["default"][parts[0]]?.[parts[1]]
          }
      } else {
          color = themesManager.themes[currentTheme]?.[colorName] || themesManager.themes["default"][colorName]
      }

      // Si no se encontró el color en ningún tema, retornar undefined
      if (!color) return undefined

      // Si es un array de valores [r,g,b,a], convertirlo a rgba
      if (Array.isArray(color)) {
          return Qt.rgba(color[0]/255, color[1]/255, color[2]/255, color[3]/255)
      }

      // Guardar en caché antes de retornar
      _colorCache[colorName] = color
      return color
  }

  // Limpiar caché cuando cambie el tema
  onCurrentThemeChanged: {
      _colorCache = {}
  }

  //--------------------------------------------------------------------------------------------------------------------
  // Funciones auxiliares
  //--------------------------------------------------------------------------------------------------------------------
  function rgba(r,g,b,a) { 
    return Qt.rgba(  neutralizer(r)/255. ,  neutralizer(g)/255. ,  neutralizer(b)/255. , neutralizer(a)/255. ) }

  //--------------------------------------------------------------------------------------------------------------------
  // Colores predefinidos
  //--------------------------------------------------------------------------------------------------------------------
  readonly property variant textColors: [
    colorDeckBright,  
    colorDeckBright,   
    colorGrey232,  
    colorGrey232 
  ]
  readonly property variant mixerFXColors: [
    colorMixerFXOrange, 
    colorMixerFXRed, 
    colorMixerFXGreen, 
    colorMixerFXBlue, 
    colorMixerFXYellow
  ]

  //--------------------------------------------------------------------------------------------------------------------
  // Invertir recursos
  //--------------------------------------------------------------------------------------------------------------------
  property string inverted: getThemeColor("invertedResources") ? "_Invert" : ""

  //--------------------------------------------------------------------------------------------------------------------
  // Colores por defecto
  //--------------------------------------------------------------------------------------------------------------------
  property color defaultBackground: getThemeColor("defaultBackground")
  property color loopActiveColor: getThemeColor("loopActiveColor")
  property color loopActiveDimmedColor: getThemeColor("loopActiveDimmedColor")
  property color grayBackground: getThemeColor("grayBackground")

  //--------------------------------------------------------------------------------------------------------------------
  // Colores de los FX
  //--------------------------------------------------------------------------------------------------------------------
  property color colorMixerFXOrange: getThemeColor("colorMixerFXOrange")
  property color colorMixerFXRed: getThemeColor("colorMixerFXRed")
  property color colorMixerFXGreen: getThemeColor("colorMixerFXGreen")
  property color colorMixerFXBlue: getThemeColor("colorMixerFXBlue")
  property color colorMixerFXYellow: getThemeColor("colorMixerFXYellow")

  // this categorizes any rgb value to multiples of 8 for each channel to avoid unbalanced colors on the display (r5-g6-b5 bit)
  // function neutralizer(value) { if(value%8 > 4) { return  value - value%8 + 8} else { return  value - value%8 }}
  function neutralizer(value) { return value}

  //--------------------------------------------------------------------------------------------------------------------
  // Colores base
  //--------------------------------------------------------------------------------------------------------------------
  property color colorBlack: getThemeColor("colorBlack") // rgba(0, 0, 0, 255)
  property color colorWhite: getThemeColor("colorWhite") // rgba(255, 255, 255, 255)
  property color colorOrange: getThemeColor("colorOrange") // rgba(255, 165, 0, 255)
  property color colorRed: getThemeColor("colorRed") // rgba(255, 0, 0, 255)
  property color colorGreen: getThemeColor("colorGreen") // rgba(0, 255, 0, 255)

  //--------------------------------------------------------------------------------------------------------------------
  // Opacidades de negro
  //--------------------------------------------------------------------------------------------------------------------
  property color colorBlack94: getThemeColor("colorBlack94") // from 93 - 95%
  property color colorBlack88: getThemeColor("colorBlack88") // from 87 - 89%
  property color colorBlack85: getThemeColor("colorBlack85") // from 84 - 86%
  property color colorBlack81: getThemeColor("colorBlack81") // from 80 - 83%
  property color colorBlack78: getThemeColor("colorBlack78") // from 77 - 79%
  property color colorBlack75: getThemeColor("colorBlack75") // from 74 - 76%
  property color colorBlack69: getThemeColor("colorBlack69") // from 68 - 70%
  property color colorBlack66: getThemeColor("colorBlack66") // from 65 - 67%
  property color colorBlack63: getThemeColor("colorBlack63") // from 62 - 64%
  property color colorBlack60: getThemeColor("colorBlack60") // from 59 - 61%
  property color colorBlack56: getThemeColor("colorBlack56") // from 55 - 57%
  property color colorBlack53: getThemeColor("colorBlack53") // from 49 - 51%
  property color colorBlack50: getThemeColor("colorBlack50") // from 49 - 51%
  property color colorBlack47: getThemeColor("colorBlack47") // from 46 - 48%
  property color colorBlack44: getThemeColor("colorBlack44") // from 43 - 45%
  property color colorBlack41: getThemeColor("colorBlack41") // from 40 - 42%
  property color colorBlack38: getThemeColor("colorBlack38") // from 37 - 39%
  property color colorBlack35: getThemeColor("colorBlack35") // from 33 - 36%
  property color colorBlack31: getThemeColor("colorBlack31") // from 30 - 32%  
  property color colorBlack28: getThemeColor("colorBlack28") // from 27 - 29%
  property color colorBlack25: getThemeColor("colorBlack25") // from 24 - 26%
  property color colorBlack22: getThemeColor("colorBlack22") // from 21 - 23%
  property color colorBlack19: getThemeColor("colorBlack19") // from 18 - 20%
  property color colorBlack16: getThemeColor("colorBlack16") // from 15 - 17%
  property color colorBlack12: getThemeColor("colorBlack12") // from 11 - 13%
  property color colorBlack09: getThemeColor("colorBlack09") // from 8 - 10%
  property color colorBlack06: getThemeColor("colorBlack06") // from 5 - 7%

  //--------------------------------------------------------------------------------------------------------------------
  // Opacidades de blanco
  //--------------------------------------------------------------------------------------------------------------------
  property color colorWhite75: getThemeColor("colorWhite75") // rgba (255, 255, 255, 191) 
  property color colorWhite85: getThemeColor("colorWhite85") // rgba (255, 255, 255, 217)
  property color colorWhite50: getThemeColor("colorWhite50") // rgba (255, 255, 255, 128) // from 49 - 51%
  property color colorWhite41: getThemeColor("colorWhite41") // rgba (255, 255, 255, 105) // from 40 - 42%
  property color colorWhite35: getThemeColor("colorWhite35") // rgba (255, 255, 255, 89) // from 33 - 36%
  property color colorWhite28: getThemeColor("colorWhite28") // rgba (255, 255, 255, 71) // from 27 - 29%
  property color colorWhite25: getThemeColor("colorWhite25") // rgba (255, 255, 255, 64) // from 24 - 26%
  property color colorWhite22: getThemeColor("colorWhite22") // rgba (255, 255, 255, 56) // from 21 - 23%
  property color colorWhite19: getThemeColor("colorWhite19") // rgba (255, 255, 255, 51) // from 18 - 20%
  property color colorWhite16: getThemeColor("colorWhite16") // rgba (255, 255, 255, 41) // from 15 - 17%
  property color colorWhite12: getThemeColor("colorWhite12") // rgba (255, 255, 255, 31) // from 11 - 13%
  property color colorWhite09: getThemeColor("colorWhite09") // rgba (255, 255, 255, 23) // from 8 - 10%
  property color colorWhite06: getThemeColor("colorWhite06") // rgba (255, 255, 255, 15) // from 5 - 7%

  //--------------------------------------------------------------------------------------------------------------------
  // Opacidades de grises
  //--------------------------------------------------------------------------------------------------------------------
  property color colorGrey232: getThemeColor("colorGrey232") // rgba (232, 232, 232, 255)
  property color colorGrey216: getThemeColor("colorGrey216") // rgba (216, 216, 216, 255)
  property color colorGrey208: getThemeColor("colorGrey208") // rgba (208, 208, 208, 255)
  property color colorGrey200: getThemeColor("colorGrey200") // rgba (200, 200, 200, 255)
  property color colorGrey192: getThemeColor("colorGrey192") // rgba (192, 192, 192, 255)
  property color colorGrey152: getThemeColor("colorGrey152") // rgba (152, 152, 152, 255)
  property color colorGrey128: getThemeColor("colorGrey128") // rgba (128, 128, 128, 255)
  property color colorGrey120: getThemeColor("colorGrey120") // rgba (120, 120, 120, 255)
  property color colorGrey112: getThemeColor("colorGrey112") // rgba (112, 112, 112, 255)
  property color colorGrey104: getThemeColor("colorGrey104") // rgba (104, 104, 104, 255)
  property color colorGrey96: getThemeColor("colorGrey96") // rgba (96, 96, 96, 255)
  property color colorGrey88: getThemeColor("colorGrey88") // rgba (88, 88, 88, 255) 
  property color colorGrey80: getThemeColor("colorGrey80") // rgba (80, 80, 80, 255) 
  property color colorGrey72: getThemeColor("colorGrey72") // rgba (72, 72, 72, 255) 
  property color colorGrey64: getThemeColor("colorGrey64") // rgba (64, 64, 64, 255) 
  property color colorGrey56: getThemeColor("colorGrey56") // rgba (56, 56, 56, 255) 
  property color colorGrey48: getThemeColor("colorGrey48") // rgba (48, 48, 48, 255) 
  property color colorGrey40: getThemeColor("colorGrey40") // rgba (40, 40, 40, 255)
  property color colorGrey32: getThemeColor("colorGrey32") // rgba (32, 32, 32, 255)
  property color colorGrey24: getThemeColor("colorGrey24") // rgba (24, 24, 24, 255)
  property color colorGrey16: getThemeColor("colorGrey16") // rgba (16, 16, 16, 255)
  property color colorGrey08: getThemeColor("colorGrey08") // rgba (08, 08, 08, 255)

  //--------------------------------------------------------------------------------------------------------------------
  // Opacidades de rojo
  //--------------------------------------------------------------------------------------------------------------------
   property color colorRed70: getThemeColor("colorRed70") // rgba(185, 6, 6, 255)

  //--------------------------------------------------------------------------------------------------------------------
  // Opacidades de verde
  //--------------------------------------------------------------------------------------------------------------------
  property color colorGreen50:  getThemeColor("colorGreen50") // rgba(0, 255, 0, 128)
  property color colorGreen12: getThemeColor("colorGreen12") // rgba(0, 255, 0, 31) // used for loop bg (in WaveformCues.qml)
  property color colorGreen08: getThemeColor("colorGreen08") // rgba(0, 255, 0, 20)
  property color colorGreen50Full: getThemeColor("colorGreen50Full") // rgba(0, 51, 0, 255)

  //--------------------------------------------------------------------------------------------------------------------
  // Otros colores
  //--------------------------------------------------------------------------------------------------------------------
  property color colorGreenActive: getThemeColor("colorGreenActive") // rgba( 82, 255, 148, 255)
  property color colorGreenInactive: getThemeColor("colorGreenInactive") // rgba(  8,  56,  24, 255)
  property color colorGreyInactive: getThemeColor("colorGreyInactive") // rgba(139, 145, 139, 255)
  property color colorOrangeDimmed: getThemeColor("colorOrangeDimmed") // rgba(86, 38, 0, 255)
  property color colorGreenGreyMix: getThemeColor("colorGreenGreyMix") // rgba(139, 240, 139, 82)

  //--------------------------------------------------------------------------------------------------------------------
  // Mejoras para la visualización de loops
  //--------------------------------------------------------------------------------------------------------------------
  property color colorLoopActive: getThemeColor("colorLoopActive") // rgba(0, 255, 0, 40)     // Color base del loop
  property color colorLoopBorder: getThemeColor("colorLoopBorder") // rgba(0, 255, 0, 255)    // Color del borde
  property color colorLoopGradient: getThemeColor("colorLoopGradient") // rgba(0, 255, 0, 20)   // Color para el gradiente
  property color colorLoopMarker: getThemeColor("colorLoopMarker") // rgba(0, 255, 0, 255)    // Color de los marcadores
  property color colorLoopOverlay: getThemeColor("colorLoopOverlay") // rgba(96, 192, 128, 16) // Color de la superposición del loop

  //--------------------------------------------------------------------------------------------------------------------
  // Playmarker
  //--------------------------------------------------------------------------------------------------------------------
  property color colorRedPlaymarker: getThemeColor("colorRedPlaymarker") // rgba(255, 0, 0, 255)
  property color colorRedPlaymarker75: getThemeColor("colorRedPlaymarker75") // rgba(255, 56, 26, 191)
  property color colorRedPlaymarker06: getThemeColor("colorRedPlaymarker06") // rgba(255, 56, 26, 31)
  property color colorBluePlaymarker: getThemeColor("colorBluePlaymarker") // rgba(96, 184, 192, 255) //rgba(136, 224, 232, 255)

  //--------------------------------------------------------------------------------------------------------------------
  // Colores de fuente
  //--------------------------------------------------------------------------------------------------------------------
  property color defaultTextColor: getThemeColor("defaultTextColor")
  property color defaultInvertedTextColor: getThemeColor("defaultInvertedTextColor")
  property color colorFontWhite: getThemeColor("colorFontWhite")
  property color colorFontBlack: getThemeColor("colorFontBlack")
  property color colorFontRed: getThemeColor("colorFontRed")
  property color colorFontOrange: getThemeColor("colorFontOrange")
  property color colorFontGreen: getThemeColor("colorFontGreen")
  property color colorFontBlue: getThemeColor("colorFontBlue")
  property color colorFontYellow: getThemeColor("colorFontYellow")
  property color colorFontGrey: getThemeColor("colorFontGrey")
  property color colorFontListBrowser: getThemeColor("colorFontListBrowser") // colorGrey72
  property color colorFontListFx: getThemeColor("colorFontListFx") // colorGrey56
  property color colorFontBrowserHeader: getThemeColor("colorFontBrowserHeader") // colorGrey88
  property color colorFontFxHeader: getThemeColor("colorFontFxHeader") // colorGrey80 // also for FX header, FX select buttons

  //--------------------------------------------------------------------------------------------------------------------
  // Cabeceras y pies de página
  //--------------------------------------------------------------------------------------------------------------------
  property color colorBgEmpty: getThemeColor("colorBgEmpty") // also for empty decks & Footer Small (used to be colorGrey08)
  property color colorBrowserHeader: getThemeColor("colorBrowserHeader") // colorGrey24
  property color colorFxHeaderBg: getThemeColor("colorFxHeaderBg") // colorGrey16 // also for large footer; fx overlay tabs         
  property color colorFxHeaderLightBg: getThemeColor("colorFxHeaderLightBg") // colorGrey24

  //--------------------------------------------------------------------------------------------------------------------
  // Colores de fondo de progreso
  //--------------------------------------------------------------------------------------------------------------------
  property color colorProgressBg: getThemeColor("colorProgressBg") // colorGrey32 
  property color colorProgressBgLight: getThemeColor("colorProgressBgLight") // colorGrey48 
  property color colorDivider: getThemeColor("colorDivider") // colorGrey40

  //--------------------------------------------------------------------------------------------------------------------
  // Colores de fondo de indicadores
  //--------------------------------------------------------------------------------------------------------------------
  property color colorIndicatorBg: getThemeColor("colorIndicatorBg") // rgba(20, 20, 20, 255)
  property color colorIndicatorBg2: getThemeColor("colorIndicatorBg2") // rgba(31, 31, 31, 255)

  //--------------------------------------------------------------------------------------------------------------------
  // Colores de indicadores de nivel
  //--------------------------------------------------------------------------------------------------------------------  
  property color colorIndicatorLevelGrey: getThemeColor("colorIndicatorLevelGrey") // rgba(51, 51, 51, 255)
  property color colorIndicatorLevelOrange: getThemeColor("colorIndicatorLevelOrange") // rgba(247, 143, 30, 255)

  //--------------------------------------------------------------------------------------------------------------------
  // Colores de cabecera de overlay
  //--------------------------------------------------------------------------------------------------------------------  
  property color colorCenterOverlayHeadline: getThemeColor("colorCenterOverlayHeadline") // colorGrey88

  //--------------------------------------------------------------------------------------------------------------------
  // Colores de decks
  //--------------------------------------------------------------------------------------------------------------------
  property color colorDeckBright:         getThemeColor("colorDeckBright") // rgba(0, 136, 184, 255) 
  property color colorDeckDark:               getThemeColor("colorDeckDark") // rgba(0, 64, 88, 255) 
  property color colorDeckBlueBright20:       getThemeColor("colorDeckBlueBright20") // rgba(0, 174, 239, 51)
  property color colorDeckBlueBright50Full:   getThemeColor("colorDeckBlueBright50Full") // rgba(0, 87, 120, 255)
  property color colorDeckBlueBright12Full:   getThemeColor("colorDeckBlueBright12Full") // rgba(0, 8, 10, 255) //rgba(0, 23, 31, 255)

  //--------------------------------------------------------------------------------------------------------------------
  // Colores de browser
  //--------------------------------------------------------------------------------------------------------------------
  property color colorBrowserBlueBright:      getThemeColor("colorBrowserBlueBright") // rgba(0, 187, 255, 255)
  property color colorBrowserBlueBright56Full:getThemeColor("colorBrowserBlueBright56Full") // rgba(0, 114, 143, 255)

  //--------------------------------------------------------------------------------------------------------------------
  // Fondo del BottomControls
  //--------------------------------------------------------------------------------------------------------------------  
  property color colorFooterBackgroundBlue: getThemeColor("colorFooterBackgroundBlue") // #011f26

  //--------------------------------------------------------------------------------------------------------------------
  // Colores de fx Select overlay
  //--------------------------------------------------------------------------------------------------------------------  
  property color fxSelectHeaderTextRGB:            getThemeColor("fxSelectHeaderTextRGB") // rgba( 96,  96,  96, 255)
  property color fxSelectHeaderNormalRGB:          getThemeColor("fxSelectHeaderNormalRGB") // rgba( 32,  32,  32, 255)
  property color fxSelectHeaderNormalBorderRGB:    getThemeColor("fxSelectHeaderNormalBorderRGB") // rgba( 32,  32,  32, 255)
  property color fxSelectHeaderHighlightRGB:       getThemeColor("fxSelectHeaderHighlightRGB") // rgba( 64,  64,  48, 255)
  property color fxSelectHeaderHighlightBorderRGB: getThemeColor("fxSelectHeaderHighlightBorderRGB") // rgba(128, 128,  48, 255)

  //--------------------------------------------------------------------------------------------------------------------
  // Colores de fx Slider
  //--------------------------------------------------------------------------------------------------------------------  
  property color colorFxSlider: getThemeColor("colorFxSlider") 
  property color colorFxSliderBackground: getThemeColor("colorFxSliderBackground")

  //--------------------------------------------------------------------------------------------------------------------
  // Colores de Phase Meter
  //--------------------------------------------------------------------------------------------------------------------  
  property color colorPhaseMeterMasterActive: getThemeColor("colorPhaseMeterMasterActive") 
  property color colorPhaseMeterDeckActive: getThemeColor("colorPhaseMeterDeckActive")
  property color colorPhaseMeterInactive: getThemeColor("colorPhaseMeterInactive")
  property color colorPhaseMeterBorder: getThemeColor("colorPhaseMeterBorder")

  //--------------------------------------------------------------------------------------------------------------------
  // Colores de Deck (Nueva organización)
  //--------------------------------------------------------------------------------------------------------------------
  // Colores de Deck generales
  readonly property QtObject deckColors: QtObject {
      // Estados generales
      readonly property QtObject states: QtObject {
          readonly property color active: getThemeColor("deckColors.states.active")
          readonly property color inactive: getThemeColor("deckColors.states.inactive")
          readonly property color warning: getThemeColor("deckColors.states.warning")
          readonly property color error: getThemeColor("deckColors.states.error")
      }

      // Indicadores
      readonly property QtObject indicators: QtObject {
          // Sync
          readonly property QtObject sync: QtObject {
              readonly property color active: getThemeColor("deckColors.indicators.sync.active")
              readonly property color inactive: getThemeColor("deckColors.indicators.sync.inactive")
              readonly property QtObject text: QtObject {
                  readonly property color active: getThemeColor("deckColors.indicators.sync.text.active")
                  readonly property color enabled: getThemeColor("deckColors.indicators.sync.text.enabled")
                  readonly property color disabled: getThemeColor("deckColors.indicators.sync.text.disabled")
              }
          }

          // Master
          readonly property QtObject master: QtObject {
              readonly property color active: getThemeColor("deckColors.indicators.master.active")
              readonly property color inactive: getThemeColor("deckColors.indicators.master.inactive")
              readonly property QtObject text: QtObject {
                  readonly property color active: getThemeColor("deckColors.indicators.master.text.active")
                  readonly property color enabled: getThemeColor("deckColors.indicators.master.text.enabled")
                  readonly property color disabled: getThemeColor("deckColors.indicators.master.text.disabled")
              }
          }

          // Loop
          readonly property QtObject loop: QtObject {
              readonly property color active: getThemeColor("deckColors.indicators.loop.active")
              readonly property color inactive: getThemeColor("deckColors.indicators.loop.inactive")
              readonly property QtObject text: QtObject {
                  readonly property color active: getThemeColor("deckColors.indicators.loop.text.active")
                  readonly property color inactive: getThemeColor("deckColors.indicators.loop.text.inactive")
              }
          }

          // MixerFX
          readonly property QtObject mixerfx: QtObject {
              readonly property QtObject background: QtObject {
                  readonly property color active: getThemeColor("deckColors.indicators.mixerfx.background.active")
                  readonly property color inactive: getThemeColor("deckColors.indicators.mixerfx.background.inactive")
              }
              readonly property QtObject text: QtObject {
                  readonly property color active: getThemeColor("deckColors.indicators.mixerfx.text.active")
                  readonly property color inactive: getThemeColor("deckColors.indicators.mixerfx.text.inactive")
              }
          }

          // Cover del deck
          readonly property QtObject deckCover: QtObject {
              // Bordes
              readonly property QtObject borders: QtObject {
                  readonly property color inner: getThemeColor("deckCover.borders.inner")
                  readonly property color outer: getThemeColor("deckCover.borders.outer")
              }
              // Sombra
              readonly property color shadow: getThemeColor("deckCover.shadow")
              // Elementos vacíos
              readonly property QtObject empty: QtObject {
                  readonly property color dot: getThemeColor("deckCover.empty.dot")
              }
          }

          // Warning
          readonly property QtObject deckWarning: QtObject {
              readonly property color background: getThemeColor("deckWarning.background")
              
              readonly property QtObject text: QtObject {
                  readonly property color error: getThemeColor("deckWarning.text.error")
                  readonly property QtObject warning: QtObject {
                      readonly property color normal: getThemeColor("deckWarning.text.warning.normal")
                      readonly property color dimmed: getThemeColor("deckWarning.text.warning.dimmed")
                  }
              }
          }

          // Empty Deck
          readonly property QtObject emptyDeck: QtObject {
            readonly property color background: getThemeColor("deckColors.emptyDeck.background")
            readonly property color overlay: getThemeColor("deckColors.emptyDeck.overlay")
            readonly property string imagePath: getThemeColor("deckColors.emptyDeck.image.path")
        }
      }
  }

  // Colores específicos por deck (A,B,C,D)
  readonly property QtObject deckItemColors: QtObject {
      readonly property var text: [
          getThemeColor("deckItemColors.text[0]"),
          getThemeColor("deckItemColors.text[1]"),
          getThemeColor("deckItemColors.text[2]"),
          getThemeColor("deckItemColors.text[3]")
      ]

      readonly property var darker: [
          getThemeColor("deckItemColors.darker[0]"),
          getThemeColor("deckItemColors.darker[1]"),
          getThemeColor("deckItemColors.darker[2]"),
          getThemeColor("deckItemColors.darker[3]")
      ]

      readonly property var background: [
          getThemeColor("deckItemColors.background[0]"),
          getThemeColor("deckItemColors.background[1]"),
          getThemeColor("deckItemColors.background[2]"),
          getThemeColor("deckItemColors.background[3]")
      ]

      readonly property var circle: [
          getThemeColor("deckItemColors.circle[0]"),
          getThemeColor("deckItemColors.circle[1]"),
          getThemeColor("deckItemColors.circle[2]"),
          getThemeColor("deckItemColors.circle[3]")
      ]

      readonly property var icon: [
          getThemeColor("deckItemColors.icon[0]"),
          getThemeColor("deckItemColors.icon[1]"),
          getThemeColor("deckItemColors.icon[2]"),
          getThemeColor("deckItemColors.icon[3]")
      ]
  }

  //--------------------------------------------------------------------------------------------------------------------
  // Paleta de colores
  //--------------------------------------------------------------------------------------------------------------------
  // 16 Colors Palette (Bright)
  property color color01Bright: getThemeColor("color01Bright") // rgba (255,  0,  0, 255)
  property color color02Bright: getThemeColor("color02Bright") // rgba (255,  16,  16, 255)
  property color color03Bright: getThemeColor("color03Bright") // rgba (255, 120,   0, 255)
  property color color04Bright: getThemeColor("color04Bright") // rgba (255, 184,   0, 255)
  property color color05Bright: getThemeColor("color05Bright") // rgba (255, 255,   0, 255)
  property color color06Bright: getThemeColor("color06Bright") // rgba (144, 255,   0, 255)
  property color color07Bright: getThemeColor("color07Bright") // rgba ( 40, 255,  40, 255)
  property color color08Bright: getThemeColor("color08Bright") // rgba (  0, 208, 128, 255)
  property color color09Bright: getThemeColor("color09Bright") // rgba (  0, 184, 232, 255)
  property color color10Bright: getThemeColor("color10Bright") // rgba (  0, 120, 255, 255)
  property color color11Bright: getThemeColor("color11Bright") // rgba (  0,  72, 255, 255)
  property color color12Bright: getThemeColor("color12Bright") // rgba (128,   0, 255, 255)
  property color color13Bright: getThemeColor("color13Bright") // rgba (160,   0, 200, 255)
  property color color14Bright: getThemeColor("color14Bright") // rgba (240,   0, 200, 255)
  property color color15Bright: getThemeColor("color15Bright") // rgba (255,   0, 120, 255)
  property color color16Bright: getThemeColor("color16Bright") // rgba (248,   8,  64, 255)

  // 16 Colors Palette (Mid)
  property color color01Mid: getThemeColor("color01Mid") // rgba (112, 8,   8, 255)
  property color color02Mid: getThemeColor("color02Mid") // rgba (112, 24,  8, 255)
  property color color03Mid: getThemeColor("color03Mid") // rgba (112, 56,  0, 255)
  property color color04Mid: getThemeColor("color04Mid") // rgba (112, 80,  0, 255)
  property color color05Mid: getThemeColor("color05Mid") // rgba (96,  96, 0, 255)
  property color color06Mid: getThemeColor("color06Mid") // rgba (56,  96, 0, 255)
  property color color07Mid: getThemeColor("color07Mid") // rgba (8,  96,  8, 255)
  property color color08Mid: getThemeColor("color08Mid") // rgba (0,   90, 60, 255)
  property color color09Mid: getThemeColor("color09Mid") // rgba (0,   77, 77, 255)
  property color color10Mid: getThemeColor("color10Mid") // rgba (0, 84, 108, 255)
  property color color11Mid: getThemeColor("color11Mid") // rgba (32, 56, 112, 255)
  property color color12Mid: getThemeColor("color12Mid") // rgba (72, 32, 120, 255)
  property color color13Mid: getThemeColor("color13Mid") // rgba (80, 24, 96, 255)
  property color color14Mid: getThemeColor("color14Mid") // rgba (111, 12, 149, 255)
  property color color15Mid: getThemeColor("color15Mid") // rgba (122, 0, 122, 255)
  property color color16Mid: getThemeColor("color16Mid") // rgba (130, 1, 43, 255)

  // 16 Colors Palette (Dark)
  property color color01Dark: getThemeColor("color01Dark") // rgba (16,  0,  0,  255)
  property color color02Dark: getThemeColor("color02Dark") // rgba (16,  8,  0,  255)
  property color color03Dark: getThemeColor("color03Dark") // rgba (16,  8,  0,  255)
  property color color04Dark: getThemeColor("color04Dark") // rgba (16,  16, 0,  255)
  property color color05Dark: getThemeColor("color05Dark") // rgba (16,  16, 0,  255)
  property color color06Dark: getThemeColor("color06Dark") // rgba (8,   16, 0,  255)
  property color color07Dark: getThemeColor("color07Dark") // rgba (8,   16, 8,  255)
  property color color08Dark: getThemeColor("color08Dark") // rgba (0,   16, 8,  255)
  property color color09Dark: getThemeColor("color09Dark") // rgba (0,   8,  16, 255)
  property color color10Dark: getThemeColor("color10Dark") // rgba (0,   8,  16, 255)
  property color color11Dark: getThemeColor("color11Dark") // rgba (0,   0,  16, 255)
  property color color12Dark: getThemeColor("color12Dark") // rgba (8,   0,  16, 255)
  property color color13Dark: getThemeColor("color13Dark") // rgba (8,   0,  16, 255)
  property color color14Dark: getThemeColor("color14Dark") // rgba (16,  0,  16, 255)
  property color color15Dark: getThemeColor("color15Dark") // rgba (16,  0,  8,  255)
  property color color16Dark: getThemeColor("color16Dark") // rgba (16,  0,  8,  255)

  //--------------------------------------------------------------------------------------------------------------------
  // Paleta de colores
  //--------------------------------------------------------------------------------------------------------------------
  function palette(brightness, colorId) {
    if ( brightness >= 0.666 && brightness <= 1.0 ) { // bright color
      switch(colorId) {
        case 0: return colorBgEmpty     // default color for this palette!
        case 1: return color01Bright
        case 2: return color02Bright
        case 3: return color03Bright
        case 4: return color04Bright
        case 5: return color05Bright
        case 6: return color06Bright
        case 7: return color07Bright
        case 8: return color08Bright
        case 9: return color09Bright
        case 10: return color10Bright
        case 11: return color11Bright
        case 12: return color12Bright
        case 13: return color13Bright
        case 14: return color14Bright
        case 15: return color15Bright
        case 16: return color16Bright
        case 17: return "grey"
        case 18: return colorGrey232
      }
    } else if ( brightness >= 0.333 && brightness < 0.666 ) { // mid color
      switch(colorId) {
        case 0: return colorBgEmpty    // default color for this palette!
        case 1: return color01Mid
        case 2: return color02Mid
        case 3: return color03Mid
        case 4: return color04Mid
        case 5: return color05Mid
        case 6: return color06Mid
        case 7: return color07Mid
        case 8: return color08Mid
        case 9: return color09Mid
        case 10: return color10Mid
        case 11: return color11Mid
        case 12: return color12Mid
        case 13: return color13Mid
        case 14: return color14Mid
        case 15: return color15Mid
        case 16: return color16Mid
        case 17: return "grey"
        case 18: return colorGrey232
      }
    } else if ( brightness >= 0 && brightness < 0.333 ) { // dimmed color
      switch(colorId) {
        case 0: return colorBgEmpty   // default color for this palette!
        case 1: return color01Dark
        case 2: return color02Dark
        case 3: return color03Dark
        case 4: return color04Dark
        case 5: return color05Dark
        case 6: return color06Dark
        case 7: return color07Dark
        case 8: return color08Dark
        case 9: return color09Dark
        case 10: return color10Dark
        case 11: return color11Dark
        case 12: return color12Dark
        case 13: return color13Dark
        case 14: return color14Dark
        case 15: return color15Dark
        case 16: return color16Dark
        case 17: return "grey"
        case 18: return colorGrey232
      }
    } else if ( brightness < 0) { // color Off
        return colorBgEmpty;
    }
    return colorBgEmpty;  // default color if no palette is set
  } 

  //--------------------------------------------------------------------------------------------------------------------
  //  Browser
  //--------------------------------------------------------------------------------------------------------------------
  property variant browser: QtObject {
    property color prelisten: getThemeColor("browser.prelisten")
    property color prevPlayed: getThemeColor("browser.prevPlayed")
  }

  //--------------------------------------------------------------------------------------------------------------------
  //  Hotcues
  //--------------------------------------------------------------------------------------------------------------------
  property variant hotcue: QtObject {
    property color grid: getThemeColor("hotcue.grid")
    property color hotcue: getThemeColor("hotcue.hotcue")
    property color fade: getThemeColor("hotcue.fade")
    property color load: getThemeColor("hotcue.load")
    property color loop: getThemeColor("hotcue.loop")
    property color temp: getThemeColor("hotcue.temp")
  }

  property variant hotcueColors: getThemeColor("hotcueColors")


  //--------------------------------------------------------------------------------------------------------------------
  //  Freeze & Slicer
  //--------------------------------------------------------------------------------------------------------------------
  property variant freeze: QtObject {
    property color box_inactive: getThemeColor("freeze.box_inactive")
    property color box_active: getThemeColor("freeze.box_active")
    property color marker: getThemeColor("freeze.marker")
    property color slice_overlay: getThemeColor("freeze.slice_overlay")
  }

  property variant slicer: QtObject { 
    property color box_active: getThemeColor("slicer.box_active")
    property color box_inrange: getThemeColor("slicer.box_inrange")
    property color box_inactive: getThemeColor("slicer.box_inactive")
    property color marker_default: getThemeColor("slicer.marker_default")
    property color marker_beat: getThemeColor("slicer.marker_beat")
    property color marker_edge: getThemeColor("slicer.marker_edge")
  }

  //--------------------------------------------------------------------------------------------------------------------
  //  Musical Key coloring for the browser
  //--------------------------------------------------------------------------------------------------------------------
  property color color01MusicalKey: getThemeColor("color01MusicalKey") // not yet in use
  property color color02MusicalKey: getThemeColor("color02MusicalKey") // rgba (255,  64,  0, 255)
  property color color03MusicalKey: getThemeColor("color03MusicalKey") // rgba (255, 120,   0, 255) // not yet in use
  property color color04MusicalKey: getThemeColor("color04MusicalKey") // rgba (255, 200,   0, 255)
  property color color05MusicalKey: getThemeColor("color05MusicalKey") // rgba (255, 255,   0, 255)
  property color color06MusicalKey: getThemeColor("color06MusicalKey") // rgba (210, 255,   0, 255) // not yet in use
  property color color07MusicalKey: getThemeColor("color07MusicalKey") // rgba (  0, 255,   0, 255)
  property color color08MusicalKey: getThemeColor("color08MusicalKey") // rgba (  0, 255, 128, 255)
  property color color09MusicalKey: getThemeColor("color09MusicalKey") // use the same color as for the browser selection
  property color color10MusicalKey: getThemeColor("color10MusicalKey") // rgba (  0, 100, 255, 255)
  property color color11MusicalKey: getThemeColor("color11MusicalKey") // rgba (  0,  40, 255, 255)
  property color color12MusicalKey: getThemeColor("color12MusicalKey") // rgba (128,   0, 255, 255)
  property color color13MusicalKey: getThemeColor("color13MusicalKey") // rgba (160,   0, 200, 255) // not yet in use
  property color color14MusicalKey: getThemeColor("color14MusicalKey") // rgba (240,   0, 200, 255)
  property color color15MusicalKey: getThemeColor("color15MusicalKey") // rgba (255,   0, 120, 255) // not yet in use
  property color color16MusicalKey: getThemeColor("color16MusicalKey") // rgba (248,   8,  64, 255)

  property variant musicalKeyColors: [
    color15Bright,        //0   -11 c
    color06Bright,        //1   -4  c#, db
    color11MusicalKey,    //2   -13 d
    color03Bright,        //3   -6  d#, eb
    color09MusicalKey,    //4   -16 e
    color01Bright,        //5   -9  f
    color07MusicalKey,    //6   -2  f#, gb
    color13Bright,        //7   -12 g
    color04MusicalKey,    //8   -5  g#, ab
    color10MusicalKey,    //9   -15 a
    color02MusicalKey,    //10  -7  a#, bb
    color08MusicalKey,    //11  -1  b
    color03Bright,        //12  -6  cm
    color09MusicalKey,    //13  -16 c#m, dbm 
    color01Bright,        //14  -9  dm
    color07MusicalKey,    //15  -2  d#m, ebm
    color13Bright,        //16  -12 em
    color04MusicalKey,    //17  -5  fm
    color10MusicalKey,    //18  -15 f#m, gbm
    color02MusicalKey,    //19  -7  gm
    color08MusicalKey,    //20  -1  g#m, abm
    color15Bright,        //21  -11 am
    color06Bright,        //22  -4  a#m, bbm
    color11MusicalKey     //23  -13 bm
  ]

  //--------------------------------------------------------------------------------------------------------------------
  // Waveform colors
  //--------------------------------------------------------------------------------------------------------------------
  property variant waveformColorsMap: themesManager.waveformColorsMap

  property int skipwaves: 16

  // Función getDefaultWaveformColors que faltaba
  function getDefaultWaveformColors() {
    return waveformColorsMap[prefs.spectrumWaveformColors ? (skipwaves + prefs.spectrumWaveformColors) : 0];
  } 
  
  function getWaveformColors(colorId) {
    if(colorId <= skipwaves) {
      return waveformColorsMap[colorId];
    }

    return waveformColorsMap[0];
  }

  //--------------------------------------------------------------------------------------------------------------------
  //  Tema
  //--------------------------------------------------------------------------------------------------------------------
  function loadTheme(themeName) {
    if (!themeName) {
        return
    }

    // Cargar colores del tema
    currentTheme = themeName || "default"
  }
}
