import QtQuick

//------------------------------------------------------------------------------------------------------------------
//  THEME DEFINITIONS - Sistema de temas y definición de colores para la aplicación
//
//  Características principales:
//  1. Sistema de Temas
//     - Soporta múltiples temas ("default", "light")
//     - Cada tema define su propia paleta de colores
//     - Sistema de fallback al tema "default"
//
//  2. Categorías de Color:
//     A. Waveform Colors (waveformColorsMap)
//        - 16 esquemas predefinidos de color
//        - Cada esquema define low1/2, mid1/2, high1/2
//        - Incluye emulaciones de equipos populares (Pioneer, Denon, etc.)
//
//     B. Colores Base (en cada tema)
//        - Colores fundamentales (black, white, red, green, etc.)
//        - Escalas de opacidad para negro (94% a 0%)
//        - Escalas de opacidad para blanco (85% a 6%)
//        - Escala de grises (232 a 8)
//
//     C. Colores Funcionales
//        - Phase Meter: Visualización de fase entre decks
//        - Browser: Navegación y prelisten
//        - Hotcues: Diferentes tipos de cues y colores
//        - Freeze/Slicer: Modos de manipulación
//        - Musical Keys: 16 colores para tonalidades
//
//     D. Paletas Específicas
//        - FX: Colores para efectos (naranja, rojo, verde, azul, amarillo)
//        - Deck: Colores específicos para decks
//        - Loop: Colores activos y dimmed
//
//  3. Estructura de Temas:
//     - default: Tema base oscuro
//       * Fondo negro (#000000)
//       * Texto claro (#FFFFFF)
//       * Acentos brillantes
//
//     - light: Tema claro
//       * Fondo blanco (#FFFFFF)
//       * Texto oscuro (#000000)
//       * Acentos oscurecidos
//       * Inversión de opacidades
//
//  4. Formato de Color:
//     - Arrays RGBA: [R, G, B, A] donde cada valor es 0-255
//     - Comentarios con equivalente hexadecimal
//     - Soporte para objetos de color complejos (waveform)
//
//  5. Objetos Anidados:
//     - browser: Colores de navegación
//     - hotcue: Tipos de cues
//     - freeze: Modo freeze
//     - slicer: Modo slicer
//
//  Notas:
//  - Los colores incluyen comentarios con sus valores hexadecimales
//  - Algunos valores son específicos para emular hardware real
//  - Sistema extensible para futuros temas
//------------------------------------------------------------------------------------------------------------------

QtObject {

    readonly property variant waveformColorsMap: [
        // Default
        { 
            low1:  rgba (24,   48,  80, 180),  low2:  rgba (24,   56,  96, 190),
            mid1:  rgba (80,  160, 160, 100),  mid2:  rgba (48,  112, 112, 150),
            high1: rgba (184, 240, 232, 120),  high2: rgba (208, 255, 248, 180)
        },
        // Red - #c80000
        { 
            low1:  rgba (200,   0,   0, 150),  low2:  rgba (200,  30,  30, 155),
            mid1:  rgba (180, 100, 100, 120),  mid2:  rgba (180, 110, 110, 140),
            high1: rgba (220, 180, 180, 140),  high2: rgba (220, 200, 200, 160)
        },
        // Dark Orange - #ff3200
        { 
            low1:  rgba (255,  50,   0, 150),  low2:  rgba (255,  70,  20, 170),
            mid1:  rgba (180,  70,  50, 120),  mid2:  rgba (180,  90,  70, 140),
            high1: rgba (255, 200, 160, 140),  high2: rgba (255, 220, 180, 160)
        },
        // Light Orange - #ff6e00
        { 
            low1:  rgba (255, 110,   0, 150),  low2:  rgba (245, 120,  10, 160),
            mid1:  rgba (255, 150,  80, 120),  mid2:  rgba (255, 160,  90, 140),
            high1: rgba (255, 220, 200, 140),  high2: rgba (255, 230, 210, 160)
        },
        // Warm Yellow - #ffa000
        { 
            low1:  rgba (255, 160,   0, 160),  low2:  rgba (255, 170,  20, 170),
            mid1:  rgba (255, 180,  70, 120),  mid2:  rgba (255, 190,  90, 130),
            high1: rgba (255, 210, 135, 140),  high2: rgba (255, 220, 145, 160)
        },
        // Yellow - #ffc800
        { 
            low1:  rgba (255, 200,   0, 160),  low2:  rgba (255, 210,  20, 170),
            mid1:  rgba (241, 230, 110, 120),  mid2:  rgba (241, 240, 120, 130),
            high1: rgba (255, 255, 200, 120),  high2: rgba (255, 255, 210, 180)
        },
        // Lime - #64aa00
        { 
            low1:  rgba (100, 170,   0, 150),  low2:  rgba (100, 170,   0, 170),
            mid1:  rgba (190, 250,  95, 120),  mid2:  rgba (190, 255, 100, 150),
            high1: rgba (230, 255, 185, 120),  high2: rgba (230, 255, 195, 180)
        },
        // Green - #0a9119
        { 
            low1:  rgba ( 10, 145,  25, 150),  low2:  rgba ( 20, 145,  35, 170),
            mid1:  rgba ( 80, 245,  80, 110),  mid2:  rgba ( 95, 245,  95, 130),
            high1: rgba (185, 255, 185, 140),  high2: rgba (210, 255, 210, 180)
        },
        // Mint - #00be5a
        { 
            low1:  rgba (  0, 155, 110, 150),  low2:  rgba ( 10, 165, 130, 170),
            mid1:  rgba ( 20, 235, 165, 120),  mid2:  rgba ( 20, 245, 170, 150),
            high1: rgba (200, 255, 235, 140),  high2: rgba (210, 255, 245, 170)
        },
        // Cyan - #009b6e
        { 
            low1:  rgba ( 10, 200, 200, 150),  low2:  rgba ( 10, 210, 210, 170),
            mid1:  rgba (  0, 245, 245, 120),  mid2:  rgba (  0, 250, 250, 150),
            high1: rgba (170, 255, 255, 140),  high2: rgba (180, 255, 255, 170)
        },
        // Turquoise - #0aa0aa
        { 
            low1:  rgba ( 10, 130, 170, 150),  low2:  rgba ( 10, 130, 180, 170),
            mid1:  rgba ( 50, 220, 255, 120),  mid2:  rgba ( 60, 220, 255, 140),
            high1: rgba (185, 240, 255, 140),  high2: rgba (190, 245, 255, 180)
        },
        // Blue - #1e55aa
        { 
            low1:  rgba ( 30,  85, 170, 150),  low2:  rgba ( 50, 100, 180, 170),
            mid1:  rgba (115, 170, 255, 120),  mid2:  rgba (130, 180, 255, 140),
            high1: rgba (200, 230, 255, 140),  high2: rgba (215, 240, 255, 170)
        },
        //Plum - #6446a0
        { 
            low1:  rgba (100,  70, 160, 150),  low2:  rgba (120,  80, 170, 170),
            mid1:  rgba (180, 150, 230, 120),  mid2:  rgba (190, 160, 240, 150),
            high1: rgba (220, 210, 255, 140),  high2: rgba (230, 220, 255, 160)
        },
        // Violet - #a028c8
        { 
            low1:  rgba (160,  40, 200, 140),  low2:  rgba (170,  50, 190, 170),
            mid1:  rgba (200, 135, 255, 120),  mid2:  rgba (210, 155, 255, 150),
            high1: rgba (235, 210, 255, 140),  high2: rgba (245, 220, 255, 170)
        },
        // Purple - #c81ea0
        { 
            low1:  rgba (200,  30, 160, 150),  low2:  rgba (210,  40, 170, 170),
            mid1:  rgba (220, 130, 240, 120),  mid2:  rgba (230, 140, 245, 140),
            high1: rgba (250, 200, 255, 140),  high2: rgba (255, 200, 255, 170)
        },
        // Magenta - #e60a5a
        { 
            low1:  rgba (230,  10,  90, 150),  low2:  rgba (240,  10, 100, 170),
            mid1:  rgba (255, 100, 200, 120),  mid2:  rgba (255, 120, 220, 150),
            high1: rgba (255, 200, 255, 140),  high2: rgba (255, 220, 255, 160)
        },
        // Fuchsia - #ff0032
        { 
            low1:  rgba (255,   0,  50, 150),  low2:  rgba (255,  30,  60, 170),
            mid1:  rgba (255, 110, 110, 130),  mid2:  rgba (255, 125, 125, 160),
            high1: rgba (255, 210, 220, 140),  high2: rgba (255, 220, 230, 160)
        },

        // Spectrum 1 - KOKERNUTZ
        // High contrast spectrum with vibrant RGB progression
        { 
            // Low frequencies: Intense red with medium transparency for powerful bass visualization
            low1:  rgba (255,  50,   0, 150),  low2:  rgba (255,  70,  20, 170),
            // Mid frequencies: Bright green with subtle opacity for clear midrange display
            mid1:  rgba ( 80, 245,  80, 110),  mid2:  rgba ( 95, 245,  95, 130),
            // High frequencies: Deep blue with full opacity for crisp treble representation
            high1: rgba ( 30,  85, 170, 255),  high2: rgba ( 50, 100, 180, 255)
        },
        // Spectrum 2 - NEXUS
        // Classic Pioneer-style spectrum with professional color scheme
        { 
            // Low frequencies: Red to orange transition for dynamic bass response
            low1:  rgba (200,   0,   0, 100),  low2:  rgba (200, 100,   0, 250),
            // Mid frequencies: Medium blue with progressive transparency
            mid1:  rgba (60,  120, 240, 100),  mid2:  rgba (80,  160, 240, 250),
            // High frequencies: Light blue with crystalline clarity
            high1: rgba (100, 200, 240, 100),  high2: rgba (120, 240, 240, 250)
        },
        // Spectrum 3 - PRIME
        // Denon DJ signature spectrum with modern aesthetics
        { 
            // Low frequencies: Electric blue with dramatic opacity shift
            low1:  rgba ( 41, 113, 246, 100),  low2:  rgba ( 41, 113, 246, 250),
            // Mid frequencies: Vibrant green with matching transparency range
            mid1:  rgba ( 98, 234,  82, 100),  mid2:  rgba ( 98, 234,  82, 250),
            // High frequencies: Pure white with intensity variation
            high1: rgba (255, 255, 255, 100),  high2: rgba (255, 255, 255, 250)
        },
        // Spectrum 4 - Denon SC5000/SC6000
        // Refined version of PRIME spectrum for flagship models
        { 
            // Low frequencies: Precise electric blue with enhanced clarity
            low1:  rgba ( 42, 112, 245, 100),  low2:  rgba ( 42, 114, 247, 250),
            // Mid frequencies: Optimized green for improved midrange definition
            mid1:  rgba ( 99, 235,  83, 100),  mid2:  rgba ( 99, 235,  83, 250),
            // High frequencies: Clean white with graduated transparency
            high1: rgba (255, 255, 255, 100),  high2: rgba (255, 255, 255, 250)
        },
        // Spectrum 5 - Pioneer CDJ 2000
        // Industry standard spectrum with traditional Pioneer colors
        { 
            // Low frequencies: Bold red to orange for impactful bass display
            low1:  rgba (204,   0,   0, 100),  low2:  rgba (204, 104,   0, 250),
            // Mid frequencies: Rich blue with subtle intensity variation
            mid1:  rgba (64,  124, 244, 100),  mid2:  rgba ( 84, 164, 244, 250),
            // High frequencies: Bright blue for detailed high-end response
            high1: rgba (104, 204, 244, 100),  high2: rgba (124, 244, 244, 250)
        },
        // Spectrum 6 - Pioneer CDJ 3000
        // Next-generation spectrum with enhanced visual depth
        { 
            // Low frequencies: Deep blue transitioning to electric blue
            low1:  rgba (26,   50, 142, 200),  low2:  rgba (  2, 186, 234, 180),
            // Mid frequencies: Vibrant orange with dynamic opacity
            mid1: rgba  (255, 112,   2, 255),  mid2:  rgba (245, 122,  12, 160),
            // High frequencies: Neutral white to grey gradient
            high1: rgba (234, 234, 234, 255),  high2: rgba (154, 154, 154, 255)
        },
        // Spectrum 7 - NUMARK
        // Distinctive tri-color spectrum with unique character
        { 
            // Low frequencies: Navy to electric blue transition
            low1:  rgba ( 30,  50, 120, 160),  low2:  rgba ( 28, 182, 226, 170),
            // Mid frequencies: Energetic green with subtle opacity
            mid1:  rgba ( 80, 228,  80, 110),  mid2:  rgba (120, 246, 120, 130),
            // High frequencies: Warm orange/amber for high frequency detail
            high1: rgba (255, 150,   3, 255),  high2: rgba (245, 176,  18, 255)
        },
        // Spectrum 8 - X RAY
        // Monochromatic spectrum for minimalist visualization
        { 
            // Low frequencies: Dark grey with moderate transparency
            low1:  rgba ( 72,  72,  72, 160),  low2:  rgba (144, 144, 144, 170),
            // Mid frequencies: Medium grey with subtle variation
            mid1:  rgba (120, 120, 120, 110),  mid2:  rgba (160, 160, 160, 190),
            // High frequencies: Bright white to light grey transition
            high1: rgba (255, 255, 255, 255),  high2: rgba (222, 222, 222, 255)
        },
        // Spectrum 9 - Infrared
        // Warm color spectrum inspired by thermal imaging
        { 
            // Low frequencies: Deep amber with consistent opacity
            low1:  rgba (122,  65,  20, 160),  low2:  rgba (140,  70,  27, 170),
            // Mid frequencies: Bright yellow with varying transparency
            mid1:  rgba (255, 210, 100, 110),  mid2:  rgba (255, 244, 134, 190),
            // High frequencies: Intense yellow with maximum brightness
            high1: rgba (255, 240,   0, 255),  high2: rgba (255, 245,  60, 255)
        },
        // Spectrum 10 - Ultraviolet
        // Cool-toned spectrum with ethereal quality
        { 
            // Low frequencies: Deep blue with high opacity
            low1:  rgba (24,   48,  80, 180),  low2:  rgba (24,   56,  96, 190),
            // Mid frequencies: Teal with varying transparency
            mid1:  rgba (80,  160, 160, 100),  mid2:  rgba (48,  112, 112, 150),
            // High frequencies: Cyan to white transition
            high1: rgba (184, 240, 232, 120),  high2: rgba (208, 255, 248, 180)
        },
        // Spectrum 11 - Like Colors
        // Alternative high-contrast RGB spectrum
        { 
            // Low frequencies: Bright red with graduated opacity
            low1:  rgba (255,  50,   0, 150),  low2:  rgba (255,  70,  20, 170),
            // Mid frequencies: Vibrant green with subtle transparency
            mid1:  rgba ( 80, 245,  80, 110),  mid2:  rgba ( 95, 245,  95, 130),
            // High frequencies: Rich blue with full opacity
            high1: rgba ( 30,  85, 170, 255),  high2: rgba ( 50, 100, 180, 255)
        },
        // Spectrum 12 - CDJ-3000 Pro Style
        // Professional spectrum inspired by high-end DJ equipment
        { 
            // Low frequencies: Deep blue to electric transition for powerful bass
            low1:  rgba(26, 50, 142, 200),    // Deep blue for bass fundamentals
            low2:  rgba(2, 186, 234, 180),    // Electric blue for sub-bass detail
            // Mid frequencies: Vibrant orange spectrum for clear midrange
            mid1:  rgba(255, 112, 2, 255),    // Vibrant orange for mid presence
            mid2:  rgba(245, 122, 12, 160),   // Soft orange for upper mids
            // High frequencies: White to grey gradient for crisp highs
            high1: rgba(234, 234, 234, 255),  // Bright white for high detail
            high2: rgba(154, 154, 154, 255)   // Grey for ultra-high harmonics
        },
        // Spectrum 13 - Club Style
        // High-impact spectrum designed for club environments
        {
            // Low frequencies: Intense reds for maximum bass impact
            low1:  rgba(255, 0, 0, 200),      // Intense red for powerful bass
            low2:  rgba(255, 30, 0, 180),     // Red-orange for sub-bass depth
            // Mid frequencies: Green spectrum for midrange clarity
            mid1:  rgba(0, 255, 0, 180),      // Bright green for clear mids
            mid2:  rgba(0, 200, 0, 160),      // Dark green for mid body
            // High frequencies: Sky to deep blue for treble detail
            high1: rgba(0, 128, 255, 200),    // Sky blue for crisp highs
            high2: rgba(0, 64, 255, 180)      // Deep blue for ultra highs
        },
        // Spectrum 14 - Energy Flow
        // Dynamic spectrum for high-energy electronic music
        {
            // Low frequencies: Neon pink spectrum for energetic bass
            low1:  rgba(255, 0, 128, 200),    // Neon pink for bass punch
            low2:  rgba(255, 0, 64, 180),     // Dark pink for sub depth
            // Mid frequencies: Yellow to orange transition for warm mids
            mid1:  rgba(255, 255, 0, 180),    // Yellow for mid presence
            mid2:  rgba(255, 128, 0, 160),    // Orange for upper harmonics
            // High frequencies: Cyan to electric blue for crystal highs
            high1: rgba(0, 255, 255, 200),    // Cyan for bright highs
            high2: rgba(0, 128, 255, 180)     // Electric blue for air
        },
        // Spectrum 15 - Deep House
        // Smooth spectrum optimized for deep house music
        {
            // Low frequencies: Purple spectrum for deep bass presence
            low1:  rgba(128, 0, 255, 200),    // Purple for deep bass
            low2:  rgba(64, 0, 128, 180),     // Dark purple for sub layers
            // Mid frequencies: Mint green spectrum for smooth mids
            mid1:  rgba(0, 255, 128, 180),    // Mint green for clear mids
            mid2:  rgba(0, 128, 64, 160),     // Dark green for mid texture
            // High frequencies: Soft yellow spectrum for gentle highs
            high1: rgba(255, 255, 128, 200),  // Soft yellow for smooth highs
            high2: rgba(128, 128, 64, 180)    // Dark yellow for air
        },
        // Spectrum 16 - Techno Dark
        // Minimalist dark spectrum for techno aesthetics
        {
            // Low frequencies: Dark red spectrum for subtle bass
            low1:  rgba(255, 0, 0, 150),      // Dark red for bass impact
            low2:  rgba(128, 0, 0, 130),      // Very dark red for sub depth
            // Mid frequencies: Grey spectrum for neutral mids
            mid1:  rgba(64, 64, 64, 150),     // Grey for mid presence
            mid2:  rgba(32, 32, 32, 130),     // Dark grey for mid texture
            // High frequencies: Silver to grey for subtle highs
            high1: rgba(192, 192, 192, 150),  // Silver for high detail
            high2: rgba(128, 128, 128, 130)   // Medium grey for air
        }     
    ]


    readonly property var themes: {
        // Tema por defecto
        "default": {
            // Invertir colores de los recursos?
            invertedResources: false,
            
            // Colores por defecto
            defaultBackground: [0, 0, 0, 255],              // #000000   
            loopActiveColor: [0, 255, 70, 255],             // #00FF70
            loopActiveDimmedColor: [0, 255, 70, 190],       // #00FF70
            grayBackground: [255, 51, 51, 51],              // #ff333333

            // Colores FX - usar valores exactos del original
            colorMixerFXOrange: [250, 132, 42, 255],        // #FA842A
            colorMixerFXRed: [254, 0, 0, 255],              // #FE0000
            colorMixerFXGreen: [78, 225, 12, 255],          // #4EE50C
            colorMixerFXBlue: [92, 201, 238, 255],          // #5CB5E4
            colorMixerFXYellow: [254, 217, 36, 255],        // #FED924

            // Basic colors
            colorWhite: [235, 235, 235, 255],               // #EBEBEB
            colorRed: [255, 0, 0, 255],                     // #FF0000
            colorBlack: [0, 0, 0, 255],                     // #000000
            colorOrange: [198, 94, 0, 255],                 // #C65E00
            colorGreen: [0, 255, 0, 255],                   // #00FF00

            // Colores base y opacidades - mantener valores exactos
            colorBlack94: [0, 0, 0, 240],                   // #000000    
            colorBlack88: [0, 0, 0, 224],                   // #000000
            colorBlack85: [0, 0, 0, 217],                   // #000000
            colorBlack81: [0, 0, 0, 207],                   // #000000
            colorBlack78: [0, 0, 0, 199],                   // #000000
            colorBlack75: [0, 0, 0, 191],                   // #000000
            colorBlack69: [0, 0, 0, 176],                   // #000000
            colorBlack66: [0, 0, 0, 168],                   // #000000
            colorBlack63: [0, 0, 0, 161],                   // #000000
            colorBlack60: [0, 0, 0, 153],                   // #000000
            colorBlack56: [0, 0, 0, 143],                   // #000000
            colorBlack53: [0, 0, 0, 135],                   // #000000
            colorBlack50: [0, 0, 0, 128],                   // #000000
            colorBlack47: [0, 0, 0, 120],                   // #000000
            colorBlack44: [0, 0, 0, 112],                   // #000000
            colorBlack41: [0, 0, 0, 105],                   // #000000
            colorBlack38: [0, 0, 0, 97],                    // #000000
            colorBlack35: [0, 0, 0, 89],                    // #000000
            colorBlack31: [0, 0, 0, 79],                    // #000000
            colorBlack28: [0, 0, 0, 71],                    // #000000
            colorBlack25: [0, 0, 0, 64],                    // #000000
            colorBlack22: [0, 0, 0, 56],                    // #000000
            colorBlack19: [0, 0, 0, 51],                    // #000000  
            colorBlack16: [0, 0, 0, 41],                    // #000000
            colorBlack12: [0, 0, 0, 31],                    // #000000
            colorBlack09: [0, 0, 0, 23],                    // #000000
            colorBlack0:  [0, 0, 0, 0],                     // #000000

            // Colores base - Blanco con opacidades (ajustados para tema oscuro)
            colorWhite85: [235, 235, 235, 217],             // #EBEBEB
            colorWhite75: [235, 235, 235, 191],             // #EBEBEB
            colorWhite50: [235, 235, 235, 128],             // #EBEBEB
            colorWhite41: [235, 235, 235, 105],             // #EBEBEB
            colorWhite35: [235, 235, 235, 89],              // #EBEBEB
            colorWhite28: [235, 235, 235, 71],              // #EBEBEB
            colorWhite25: [235, 235, 235, 64],              // #EBEBEB
            colorWhite22: [235, 235, 235, 56],              // #EBEBEB 
            colorWhite19: [235, 235, 235, 51],              // #EBEBEB
            colorWhite16: [235, 235, 235, 41],              // #EBEBEB
            colorWhite12: [235, 235, 235, 31],              // #EBEBEB
            colorWhite09: [235, 235, 235, 23],              // #EBEBEB
            colorWhite06: [235, 235, 235, 15],              // #EBEBEB

            // Escala de grises (ajustada para tema oscuro)
            colorGrey232: [212, 212, 212, 255],             // #D4D4D4
            colorGrey216: [196, 196, 196, 255],             // #C4C4C4
            colorGrey208: [188, 188, 188, 255],             // #BCBCBC
            colorGrey200: [180, 180, 180, 255],             // #B4B4B4
            colorGrey192: [172, 172, 172, 255],             // #ACACAC
            colorGrey152: [148, 148, 148, 255],             // #989898
            colorGrey128: [124, 124, 124, 255],             // #7C7C7C
            colorGrey120: [116, 116, 116, 255],             // #707070  
            colorGrey112: [108, 108, 108, 255],             // #6C6C6C
            colorGrey104: [100, 100, 100, 255],             // #646464
            colorGrey96: [92, 92, 92, 255],                 // #5C5C5C
            colorGrey88: [84, 84, 84, 255],                 // #545454
            colorGrey80: [76, 76, 76, 255],                 // #4C4C4C
            colorGrey72: [68, 68, 68, 255],                 // #444444
            colorGrey64: [60, 60, 60, 255],                 // #3C3C3C
            colorGrey56: [52, 52, 52, 255],                 // #343434
            colorGrey48: [44, 44, 44, 255],                 // #2C2C2C
            colorGrey40: [36, 36, 36, 255],                 // #242424
            colorGrey32: [28, 28, 28, 255],                 // #1C1C1C
            colorGrey24: [20, 20, 20, 255],                 // #141414
            colorGrey16: [12, 12, 12, 255],                 // #0C0C0C
            colorGrey08: [08, 08, 08, 255],                 // #080808

            // Red variations
            colorRed70: [185, 6, 6, 255],                   // #B90606

            // Green variations
            colorGreen50: [0, 255, 0, 128],                 // #00FF00     50% opacity
            colorGreen12: [0, 255, 0, 31],                  // #00FF00     12% opacity - used for loop bg
            colorGreen08: [0, 255, 0, 20],                  // #00FF00
            colorGreen50Full: [0, 51, 0, 255],              // #003300    

            // Colores específicos
            colorOrangeDimmed: [86, 38, 0, 255],            // #562600

            // Loops
            colorLoopActive: [0, 255, 0, 40],               // #00FF00
            colorLoopBorder: [0, 255, 0, 255],              // #00FF00
            colorLoopGradient: [0, 255, 0, 20],             // #00FF00
            colorLoopMarker: [0, 255, 0, 255],              // #00FF00
            colorLoopOverlay: [96, 192, 128, 16],           // #60C080

            // Decks
            colorDeckBright: [0, 136, 184, 255],                  // #0088B8
            colorDeckDark: [0, 64, 88, 255],                      // #004058
            colorDeckBlueBright20: [0, 174, 239, 51],             // #00AEEF
            colorDeckBlueBright50Full: [0, 87, 120, 255],         // #005778
            colorDeckBlueBright12Full: [0, 8, 10, 255],           // #00080A

            // Browser
            colorBrowserBlueBright: [0, 187, 255, 255],            // #00BBEB
            colorBrowserBlueBright56Full: [0, 114, 143, 255],      // #00728F

            // Playmarker colors
            colorRedPlaymarker: [255, 0, 0, 255],                  // #FF0000
            colorRedPlaymarker75: [255, 56, 26, 191],              // #FF381A
            colorRedPlaymarker06: [255, 56, 26, 31],               // #FF381A
            colorBluePlaymarker: [96, 184, 192, 255],              // #60D0C0

            // Active/Inactive states
            colorGreenActive: [82, 255, 148, 255],                 // #52FF94
            colorGreenInactive: [8, 56, 24, 255],                  // #083818
            colorGreyInactive: [139, 145, 139, 255],               // #8B918B
            colorGreenGreyMix: [139, 240, 139, 82],                // #8BD08B

            // Colores de fuente
            defaultTextColor: [255, 255, 255, 255],                // #FFFFFF
            defaultInvertedTextColor: [0, 0, 0, 255],              // #000000
            colorFontWhite: [255, 255, 255, 255],                  // #FFFFFF
            colorFontBlack: [0, 0, 0, 255],                        // #000000
            colorFontRed: [255, 0, 0, 255],                        // #FF0000
            colorFontOrange: [198, 94, 0, 255],                    // #C65E00
            colorFontGreen: [0, 255, 0, 255],                      // #00FF00
            colorFontBlue: [92, 201, 238, 255],                    // #5CB5E4
            colorFontYellow: [254, 217, 36, 255],                  // #FED924
            colorFontGrey: [44, 44, 44, 255],                      // #2C2C2C
            colorFontListBrowser: [82, 82, 82, 255],               // #525252
            colorFontListFx: [66, 66, 66, 255],                    // #424242 
            colorFontBrowserHeader: [78, 78, 78, 255],             // #4E4E4E
            colorFontFxHeader: [70, 70, 70, 255],                  // #464646


            // Fondos de cabeceras y pies
            colorBgEmpty: [0, 0, 0, 255],                          // #000000
            colorBrowserHeader: [20, 20, 20, 255],                 // #141414 
            colorFxHeaderBg: [12, 12, 12, 255],                    // #0C0C0C
            colorFxHeaderLightBg: [20, 20, 20, 255],               // #141414 

            // Fondos de progreso
            colorProgressBg: [28, 28, 28, 255],                    // #1C1C1C
            colorProgressBgLight: [44, 44, 44, 255],               // #2C2C2C
            colorDivider: [36, 36, 36, 255],                       // #242424

            // Fondos de indicadores
            colorIndicatorBg: [20, 20, 20, 255],                   // #141414
            colorIndicatorBg2: [31, 31, 31, 255],                  // #1F1F1F

            // Indicadores de nivel
            colorIndicatorLevelGrey: [51, 51, 51, 255],            // #333333
            colorIndicatorLevelOrange: [247, 143, 30, 255],        // #F78F1E

            // Cabecera de overlay
            colorCenterOverlayHeadline: [84, 84, 84, 255],         // #545454

            // Fondo del BottomControls
            footerBackgroundBlue: [1, 31, 38, 255],                // #011F26

            // fx Select overlay colors
            fxSelectHeaderTextRGB: [96, 96, 96, 255],              // #606060
            fxSelectHeaderNormalRGB: [32, 32, 32, 255],            // #202020
            fxSelectHeaderNormalBorderRGB: [32, 32, 32, 255],      // #202020
            fxSelectHeaderHighlightRGB: [64, 64, 48, 255],         // #404030
            fxSelectHeaderHighlightBorderRGB: [128, 128, 48, 255], // #808030

            // fx Slider colors
            colorFxSlider: [247, 143, 30, 255],                   // #F78F1E
            colorFxSliderBackground: [32, 32, 32, 255],           // #202020

            // Colores para Phase Meter
            colorPhaseMeterMasterActive: [180, 84, 0, 255],    // #B45400 (naranja oscuro para beat activo del master)
            colorPhaseMeterDeckActive: [0, 140, 0, 255],       // #008C00 (verde oscuro para beat activo del deck)
            colorPhaseMeterInactive: [20, 20, 20, 255],        // #141414 (casi negro para beats inactivos)
            colorPhaseMeterBorder: [100, 100, 100, 255],       // #646464 (gris medio para bordes)

            // Nueva estructura de colores para Decks
            deckColors: {
                // Estados
                states: {
                    active: [255, 71, 0, 255],         // #FF4700 (Naranja Traktor)
                    inactive: [72, 72, 72, 255],       // #484848 (Gris)
                    warning: [255, 128, 0, 255],       // #FF8000 (Naranja advertencia)
                    error: [255, 0, 0, 255]            // #FF0000 (Rojo error)
                },

                // Indicadores
                indicators: {
                    // Sync
                    sync: {
                        active: [0, 255, 0, 255],           // #00FF00
                        inactive: [36, 36, 36, 255],        // #242424
                        text: {
                            active: [24, 24, 24, 255],      // #181818 (running)
                            enabled: [255, 128, 0, 255],    // #FF8000 (not running)
                            disabled: [128, 128, 128, 255]  // #808080 (inactive)
                        }
                    },
                    
                    // Master
                    master: {
                        active: [0, 136, 184, 255],         // #0088B8
                        inactive: [36, 36, 36, 255],        // #242424
                        text: {
                            active: [24, 24, 24, 255],      // #181818 (running)
                            enabled: [255, 128, 0, 255],    // #FF8000 (not running)
                            disabled: [128, 128, 128, 255]  // #808080 (inactive)
                        }
                    },

                    // Loop
                    loop: {
                        active: [0, 255, 0, 128],           // #00FF00     Verde 50%
                        inactive:[36, 36, 36, 255],         // #242424
                        text: {
                            active: [40, 40, 40, 255],      // #282828
                            inactive: [0, 255, 0, 128]      // #00FF00     Verde 50%
                        }
                    },

                    // MixerFX (mantiene compatibilidad con mixerFXColors)
                    mixerfx: {
                        background: {
                            active: "fromMixerFXColors",   // Usa el color del efecto
                            inactive: [40, 40, 40, 255]    // #282828
                        },
                        text: {
                            active: [40, 40, 40, 255],     // #282828
                            inactive: "fromMixerFXColors"  // Usa el color del efecto
                        }
                    },

                    // Colores del cover del deck
                    deckCover: {
                        // Bordes
                        borders: {
                            inner: [255, 255, 255, 41],    // #FFFFFF con 16% (anterior colorWhite16)
                            outer: [0, 0, 0, 255]          // #000000 (negro sólido)
                        },
                        // Sombra
                        shadow: [0, 0, 0, 255],            // #000000
                        // Elementos vacíos
                        empty: {
                            dot: [8, 8, 8, 255]            // #080808 (anterior colorGrey08)
                        }
                    },

                    // Colores para mensajes de advertencia del deck
                    deckWarning: {
                        background: [0, 0, 0, 255],          // #000000 (anterior colorBlack)
                        text: {
                            error: [255, 0, 0, 255],         // #FF0000 (anterior colorRed)
                            warning: {
                                normal: [255, 128, 0, 255],  // #FF8000 (anterior colorOrange)
                                dimmed: [255, 128, 0, 128]   // #FF8000 con 50% (anterior colorOrangeDimmed)
                            }
                        }
                    },

                    // Empty Deck
                    emptyDeck: {
                        background: [31, 31, 31, 255],          // #1F1F1F
                        overlay: [255, 0, 0, 255],              // #FF0000
                        image: {
                            path: "../Images/EmptyDeck.png"
                        }
                    }                
                }
            },

            // Colores específicos para los decks (A, B, C, D)
            deckItemColors: {
                text: [
                    [0, 136, 184, 255],                // #0088B8
                    [0, 136, 184, 255],                // #0088B8
                    [212, 212, 212, 255],              // #D4D4D4
                    [212, 212, 212, 255],              // #D4D4D4
                ],
                darker: [
                    [0, 64, 88, 255],                  // #004058
                    [0, 64, 88, 255],                  // #004058
                    [68, 68, 68, 255],                 // #444444
                    [68, 68, 68, 255],                 // #444444
                ],
                background: [
                    [0, 64, 88, 255],                  // #004058
                    [0, 64, 88, 255],                  // #004058
                    [44, 44, 44, 255],                 // #2C2C2C
                    [44, 44, 44, 255],                 // #2C2C2C
                ],
                circle: [
                    [0, 37, 54, 255],                  // #002536
                    [0, 37, 54, 255],                  // #002536
                    [24, 24, 24, 255],                 // #181818
                    [24, 24, 24, 255]                  // #181818
                ],
                icon: [
                    "Blue",                            // #0088B8 Deck A
                    "Blue",                            // #0088B8 Deck B
                    "Grey",                            // #D4D4D4 Deck C
                    "Grey"                             // #D4D4D4 Deck D
                ]
            },

            // 16 Colors Palette (Bright)
            color01Bright: [255, 0, 0, 255],           // #FF0000 
            color02Bright: [255, 16, 16, 255],         // #FF1010  
            color03Bright: [255, 120, 0, 255],         // #FF7800
            color04Bright: [255, 184, 0, 255],         // #FFB800
            color05Bright: [255, 255, 0, 255],         // #FFFF00
            color06Bright: [144, 255, 0, 255],         // #90FF00
            color07Bright: [40, 255, 40, 255],         // #28D928
            color08Bright: [0, 208, 128, 255],         // #00D080
            color09Bright: [0, 184, 232, 255],         // #00B8E8
            color10Bright: [0, 120, 255, 255],         // #0078FF   
            color11Bright: [0, 72, 255, 255],          // #0048FF
            color12Bright: [128, 0, 255, 255],         // #8000FF
            color13Bright: [160, 0, 200, 255],         // #A000C8   
            color14Bright: [240, 0, 200, 255],         // #F000C8
            color15Bright: [255, 0, 120, 255],         // #FF0078
            color16Bright: [248, 8, 64, 255],          // #F80840

            // 16 Colors Palette (Mid)
            color01Mid: [112, 8, 8, 255],              // #700808
            color02Mid: [112, 24, 8, 255],             // #701808
            color03Mid: [112, 56, 0, 255],             // #703800
            color04Mid: [112, 80, 0, 255],             // #705000
            color05Mid: [96, 96, 0, 255],              // #606000
            color06Mid: [56, 96, 0, 255],              // #386000
            color07Mid: [8, 96, 8, 255],               // #086008
            color08Mid: [0, 90, 60, 255],              // #005A3C
            color09Mid: [0, 77, 77, 255],              // #004D4D
            color10Mid: [0, 84, 108, 255],             // #00546C
            color11Mid: [32, 56, 112, 255],            // #203870
            color12Mid: [72, 32, 120, 255],            // #482078
            color13Mid: [80, 24, 96, 255],             // #501860
            color14Mid: [111, 12, 149, 255],           // #6F0C95
            color15Mid: [122, 0, 122, 255],            // #7A007A
            color16Mid: [130, 1, 43, 255],             // #82012B

            // 16 Colors Palette (Dark)
            color01Dark: [16, 0, 0, 255],              // #100000  
            color02Dark: [16, 8, 0, 255],              // #100800  
            color03Dark: [16, 8, 0, 255],              // #100800
            color04Dark: [16, 16, 0, 255],             // #101000
            color05Dark: [16, 16, 0, 255],             // #101000
            color06Dark: [8, 16, 0, 255],              // #081000
            color07Dark: [8, 16, 8, 255],              // #081008
            color08Dark: [0, 16, 8, 255],              // #001008    
            color09Dark: [0, 8, 16, 255],              // #000810    
            color10Dark: [0, 8, 16, 255],              // #000810
            color11Dark: [0, 0, 16, 255],              // #000010
            color12Dark: [8, 0, 16, 255],              // #080010
            color13Dark: [8, 0, 16, 255],              // #080010
            color14Dark: [16, 0, 16, 255],             // #100010
            color15Dark: [16, 0, 8, 255],              // #100008   
            color16Dark: [16, 0, 8, 255],              // #100008   

            //  Musical Key coloring for the browser
            color01MusicalKey: [255, 0, 0, 255],       // #FF0000
            color02MusicalKey: [255, 64, 0, 255],      // #FF4000
            color03MusicalKey: [255, 120, 0, 255],     // #FF7800
            color04MusicalKey: [255, 200, 0, 255],     // #FFC800
            color05MusicalKey: [255, 255, 0, 255],     // #FFFF00
            color06MusicalKey: [210, 255, 0, 255],     // #D2FF00
            color07MusicalKey: [0, 255, 0, 255],       // #00FF00
            color08MusicalKey: [0, 255, 128, 255],     // #00FF80
            color09MusicalKey: [0, 136, 184, 255],     // #0088B8
            color10MusicalKey: [0, 100, 255, 255],     // #0064FF
            color11MusicalKey: [0, 40, 255, 255],      // #0028FF
            color12MusicalKey: [128, 0, 255, 255],     // #8000FF
            color13MusicalKey: [160, 0, 200, 255],     // #A000C8
            color14MusicalKey: [240, 0, 200, 255],     // #F000C8
            color15MusicalKey: [255, 0, 120, 255],     // #FF0078
            color16MusicalKey: [248, 8, 64, 255],      // #F80840

            // Objetos anidados
            // Browser
            browser: {
                prelisten: [223, 178, 30, 255],        // #DFB21E 
                prevPlayed: [32, 32, 32, 255]          // #202020
            },

            // Hotcue
            hotcue: {
                grid: [235, 235, 235, 255],            // #EBEBEB  
                hotcue: [0, 136, 184, 255],            // #0088B8
                fade: [255, 120, 0, 255],              // #FF7800
                load: [255, 255, 0, 255],              // #FFFF00
                loop: [40, 255, 40, 255],              // #28D928
                temp: "grey"                           // #808080
            },

            // Hotcue colors
            hotcueColors: {
                1: [255, 0, 0, 255],                   // #FF0000 color01Bright
                2: [255, 120, 0, 255],                 // #FF7800 color03Bright
                3: [255, 255, 0, 255],                 // #FFFF00 color05Bright
                4: [40, 255, 40, 255],                 // #28D928 color07Bright
                5: [0, 184, 232, 255],                 // #00B8E8 color09Bright
                6: [0, 72, 255, 255],                  // #0048FF color11Bright
                7: [160, 0, 200, 255],                 // #A000C8 color13Bright
                8: [255, 0, 120, 255]                  // #FF0078 color15Bright
            },
  
            // Freeze 
            freeze: {
                box_inactive: [133, 170, 211, 20],     // #85AAE7
                box_active: [135, 211, 219, 230],      // #87D3DB 
                marker: [235, 235, 235, 65],           // #EBEBEB
                slice_overlay: [235, 235, 235, 230]    // #EBEBEB
            },

            // Slicer
            slicer: {
                box_active: [15, 180, 10, 255],        // #0F900A 
                box_inrange: [15, 180, 10, 90],        // #0F900A
                box_inactive: [15, 180, 10, 25],       // #0F900A
                marker_default: [15, 180, 10, 77],     // #0F900A
                marker_beat: [15, 180, 10, 150],       // #0F900A
                marker_edge: [15, 180, 10, 255]        // #0F900A
            },
        },

        // Tema para pantalla clara
        "light": {
            // Invertir colores de los recursos?
            invertedResources: true,

            // Colores por defecto
            defaultBackground: [255, 255, 255, 255],                // #FFFFFF   
            loopActiveColor: [0, 72, 180, 255],                     // #0048B4
            loopActiveDimmedColor: [0, 72, 180, 190],               // #0048B4
            grayBackground: [255, 51, 51, 51],                      // #ff333333

            // Colores FX - versión oscurecida
            colorMixerFXOrange: [180, 95, 30, 255],                 // #B45F1E
            colorMixerFXRed: [180, 0, 0, 255],                      // #B40000
            colorMixerFXGreen: [56, 160, 8, 255],                   // #38A008
            colorMixerFXBlue: [66, 144, 170, 255],                  // #4290AA
            colorMixerFXYellow: [180, 154, 25, 255],                // #B49A19

            // Basic colors - Invertidos
            colorWhite: [20, 20, 20, 255],                          // #141414    Invertido 
            colorRed: [255, 0, 0, 255],                             // #FF0000    Mantener        
            colorBlack: [255, 255, 255, 255],                       // #FFFFFF    Invertido
            colorOrange: [198, 94, 0, 255],                         // #C65E00    Mantener     
            colorGreen: [0, 100, 0, 255],                           // #006400

            // Colores para Phase Meter - versión invertida
            colorPhaseMeterMasterActive: [180, 0, 0, 255],          // #B40000 (rojo oscuro para beat activo del master)
            colorPhaseMeterDeckActive: [0, 100, 0, 255],            // #006400 (verde oscuro para beat activo del deck)
            colorPhaseMeterInactive: [20, 20, 20, 255],             // #141414 (casi negro para beats inactivos)
            colorPhaseMeterBorder: [100, 100, 100, 255],            // #646464 (gris medio para bordes)

            // Colores base: Negro con opacidades - Invertidos
            colorBlack94: [235, 235, 235, 240],                     // #EBEBEB F0
            colorBlack88: [235, 235, 235, 224],                     // #EBEBEB E0
            colorBlack85: [235, 235, 235, 217],                     // #EBEBEB D9
            colorBlack81: [235, 235, 235, 207],                     // #EBEBEB CF
            colorBlack78: [235, 235, 235, 199],                     // #EBEBEB C7
            colorBlack75: [235, 235, 235, 191],                     // #EBEBEB BF
            colorBlack69: [235, 235, 235, 176],                     // #EBEBEB B0
            colorBlack66: [235, 235, 235, 168],                     // #EBEBEB A8
            colorBlack63: [235, 235, 235, 161],                     // #EBEBEB A1
            colorBlack60: [235, 235, 235, 153],                     // #EBEBEB 99
            colorBlack56: [235, 235, 235, 143],                     // #EBEBEB 8F
            colorBlack53: [235, 235, 235, 135],                     // #EBEBEB 87
            colorBlack50: [235, 235, 235, 128],                     // #EBEBEB 80
            colorBlack47: [235, 235, 235, 120],                     // #EBEBEB 78
            colorBlack44: [235, 235, 235, 112],                     // #EBEBEB 70
            colorBlack41: [235, 235, 235, 105],                     // #EBEBEB 69
            colorBlack38: [235, 235, 235, 97],                      // #EBEBEB 61
            colorBlack35: [235, 235, 235, 89],                      // #EBEBEB 59
            colorBlack31: [235, 235, 235, 79],                      // #EBEBEB 4F
            colorBlack28: [235, 235, 235, 71],                      // #EBEBEB 47
            colorBlack25: [235, 235, 235, 64],                      // #EBEBEB 40
            colorBlack22: [235, 235, 235, 56],                      // #EBEBEB 38
            colorBlack19: [235, 235, 235, 51],                      // #EBEBEB 33
            colorBlack16: [235, 235, 235, 41],                      // #EBEBEB 29
            colorBlack12: [235, 235, 235, 31],                      // #EBEBEB 1F
            colorBlack09: [235, 235, 235, 23],                      // #EBEBEB 17
            colorBlack0: [235, 235, 235, 0],                        // #EBEBEB 00

            // Colores base: Blanco con opacidades - Invertidos
            colorWhite41: [20, 20, 20, 105],                        // #141414 69
            colorWhite35: [20, 20, 20, 89],                         // #141414 59
            colorWhite28: [20, 20, 20, 71],                         // #141414 47
            colorWhite25: [20, 20, 20, 64],                         // #141414 40
            colorWhite22: [20, 20, 20, 56],                         // #141414 38
            colorWhite19: [20, 20, 20, 51],                         // #141414 33
            colorWhite16: [20, 20, 20, 41],                         // #141414 29
            colorWhite12: [20, 20, 20, 31],                         // #141414 1F
            colorWhite09: [20, 20, 20, 23],                         // #141414 17
            colorWhite06: [20, 20, 20, 15],                         // #141414 0F

            // Colores base: Escala de grises con opacidades - Invertidos
            colorGrey232: [43, 43, 43, 255],                        // #2B2B2B
            colorGrey216: [59, 59, 59, 255],                        // #3B3B3B
            colorGrey208: [67, 67, 67, 255],                        // #434343
            colorGrey200: [75, 75, 75, 255],                        // #4B4B4B
            colorGrey192: [83, 83, 83, 255],                        // #535353
            colorGrey152: [107, 107, 107, 255],                     // #6B6B6B
            colorGrey128: [131, 131, 131, 255],                     // #838383
            colorGrey120: [139, 139, 139, 255],                     // #8B8B8B
            colorGrey112: [147, 147, 147, 255],                     // #939393
            colorGrey104: [155, 155, 155, 255],                     // #9B9B9B
            colorGrey96:  [163, 163, 163, 255],                     // #A3A3A3
            colorGrey88:  [171, 171, 171, 255],                     // #ABABAB
            colorGrey80:  [179, 179, 179, 255],                     // #B3B3B3
            colorGrey72:  [187, 187, 187, 255],                     // #BBBBBB
            colorGrey64:  [195, 195, 195, 255],                     // #C3C3C3
            colorGrey56:  [203, 203, 203, 255],                     // #CBCBCB
            colorGrey48:  [211, 211, 211, 255],                     // #D3D3D3
            colorGrey40:  [219, 219, 219, 255],                     // #DBDBDB
            colorGrey32:  [227, 227, 227, 255],                     // #E3E3E3
            colorGrey24:  [235, 235, 235, 255],                     // #EBEBEB
            colorGrey16:  [243, 243, 243, 255],                     // #F3F3F3
            colorGrey08:  [247, 247, 247, 255],                     // #F7F7F7

            // Red variations - mantener
            colorRed70: [185, 6, 6, 255],                           // #B90606

            // Green variations - mantener opacidad, invertir base
            colorGreen50: [25, 51, 0, 255],                         // #193300
            colorGreen12: [51, 102, 0, 255],                        // #336600
            colorGreen08: [0, 102, 0, 255],                         // #006600
            colorGreen50Full: [0, 51, 0, 255],                      // #003300    

            // Colores específicos
            colorOrangeDimmed: [169, 217, 255, 255],                // #A9D9FF Invertido

            // Loops - versión azul oscuro manteniendo opacidades relativas
            colorLoopActive: [0, 72, 180, 60],                      // #0048B4
            colorLoopBorder: [0, 72, 180, 255],                     // #0048B4
            colorLoopGradient: [0, 72, 180, 40],                    // #0048B4
            colorLoopMarker: [0, 72, 180, 255],                     // #0048B4
            colorLoopOverlay: [112, 44, 89, 32],                    // #702C59

            // Decks - ajustar brillos
            colorDeckBlueBright20: [0, 174, 239, 71],               // #00BEEF
            colorDeckBlueBright50Full: [0, 168, 204, 255],          // #00A8CC
            colorDeckBlueBright12Full: [247, 247, 245, 255],        // #F7F7F5

            // Browser - ajustar brillos
            colorBrowserBlueBright56Full: [0, 141, 112, 255],       // #008D70

            // Playmarker colors - mantener rojos, ajustar azules
            colorRedPlaymarker: [255, 0, 0, 255],                   // #FF0000
            colorRedPlaymarker75: [255, 56, 26, 191],               // #FF381A
            colorRedPlaymarker06: [255, 56, 26, 31],                // #FF381A
            colorBluePlaymarker: [159, 71, 63, 255],                // #9F473F

            // Active/Inactive states - invertir relación
            colorGreenActive: [8, 56, 24, 255],                     // #083818
            colorGreenInactive: [58, 180, 104, 255],                // #3AB468
            colorGreyInactive: [180, 180, 180, 255],                // #B4B4B4
            colorGreenGreyMix: [116, 15, 116, 173],                 // #740F74

            // Fondos de progreso - invertidos
            colorProgressBg: [220, 220, 220, 255],                  // #DCDCDC
            colorProgressBgLight: [230, 230, 230, 255],             // #E6E6E6
            colorDivider: [200, 200, 200, 255],                     // #C8C8C8

            // Indicadores de nivel - invertidos
            colorIndicatorLevelGrey: [204, 204, 204, 255],          // #CCCCCC
            colorIndicatorLevelOrange: [8, 112, 225, 255],          // #0870E1

            // Cabecera de overlay - invertido
            colorCenterOverlayHeadline: [30, 30, 30, 255],          // #1E1E1E

            // Fondo del BottomControls - invertido
            footerBackgroundBlue: [254, 224, 217, 255],             // #FED0D9

            // fx Select overlay colors - invertidos
            fxSelectHeaderTextRGB: [159, 159, 159, 255],            // #9F9F9F 
            fxSelectHeaderNormalRGB: [223, 223, 223, 255],          // #E3E3E3
            fxSelectHeaderNormalBorderRGB: [223, 223, 223, 255],    // #E3E3E3
            fxSelectHeaderHighlightRGB: [191, 191, 207, 255],       // #BFBFD7
            fxSelectHeaderHighlightBorderRGB: [127, 127, 207, 255], // #7F7FD7

            // fx Slider colors
            colorFxSlider: [0, 168, 204, 255],                      // #00A8CC
            colorFxSliderBackground: [127, 127, 207, 255],          // #7F7FD7
            
            //  Musical Key coloring for the browser - versión oscurecida
            color01MusicalKey: [180, 0, 0, 255],                    // #B40000
            color02MusicalKey: [180, 45, 0, 255],                   // #B42D00
            color03MusicalKey: [180, 84, 0, 255],                   // #B45400
            color04MusicalKey: [140, 110, 0, 255],                  // #8C6E00
            color05MusicalKey: [140, 140, 0, 255],                  // #8C8C00
            color06MusicalKey: [110, 140, 0, 255],                  // #6E8C00
            color07MusicalKey: [0, 140, 0, 255],                    // #008C00
            color08MusicalKey: [0, 140, 70, 255],                   // #008C46
            color09MusicalKey: [0, 95, 129, 255],                   // #005F81
            color10MusicalKey: [0, 70, 180, 255],                   // #0046B4
            color11MusicalKey: [0, 28, 180, 255],                   // #001CB4
            color12MusicalKey: [90, 0, 180, 255],                   // #5A00B4
            color13MusicalKey: [112, 0, 140, 255],                  // #70008C
            color14MusicalKey: [168, 0, 140, 255],                  // #A8008C
            color15MusicalKey: [180, 0, 84, 255],                   // #B40054
            color16MusicalKey: [174, 6, 45, 255],                   // #AE062D

            // Colores específicos - mantener algunos, invertir otros
            colorDeckBright: [90, 90, 90, 255],                     // #5A5A5A
            colorDeckDark: [100, 100, 100, 255],                    // #646464
            colorBrowserBlueBright: [80, 80, 80, 255],              // #505050

            // Fondos de cabeceras y pies - invertidos
            colorBgEmpty: [255, 255, 255, 255],                     // #FFFFFF
            colorBrowserHeader: [235, 235, 235, 255],               // #EBEBEB
            colorFxHeaderBg: [245, 245, 245, 255],                  // #F5F5F5
            colorFxHeaderLightBg: [240, 240, 240, 255],             // #F0F0F0

            // Colores de fuente - invertidos
            defaultTextColor: [0, 0, 0, 255],                       // #000000
            defaultInvertedTextColor: [255, 255, 255, 255],         // #FFFFFF
            colorFontWhite: [0, 0, 0, 255],                         // #000000
            colorFontBlack: [255, 255, 255, 255],                   // #FFFFFF
            colorFontRed: [255, 0, 0, 255],                         // #FF0000
            colorFontOrange: [198, 94, 0, 255],                     // #C65E00
            colorFontGreen: [0, 255, 0, 255],                       // #00FF00
            colorFontBlue: [92, 201, 238, 255],                     // #5CB5E4
            colorFontYellow: [254, 217, 36, 255],                   // #FED924
            colorFontGrey: [44, 44, 44, 255],                       // #2C2C2C
            colorFontListBrowser: [40, 40, 40, 255],                // #282828
            colorFontListFx: [100, 100, 100, 255],                  // #646464
            colorFontBrowserHeader: [80, 80, 80, 255],              // #505050
            colorFontFxHeader: [85, 85, 85, 255],                   // #555555

            // Mantener paletas de colores originales
            // 16 Colors Palette (Bright)
            color01Bright: [255, 0, 0, 255],                        // #FF0000
            // ... (mantener todos los colores bright) ...

            // 16 Colors Palette (Mid)
            color01Mid: [112, 8, 8, 255],                           // #700808
            // ... (mantener todos los colores mid) ...

            // 16 Colors Palette (Dark)
            color01Dark: [16, 0, 0, 255],                           // #100000
            // ... (mantener todos los colores dark) ...

            // Musical Key colors - mantener originales
            color01MusicalKey: [255, 0, 0, 255],                    // #FF0000
            // ... (mantener todos los colores musical key) ...

            // Objetos anidados - ajustar según necesidad
            browser: {
                prelisten: [223, 178, 30, 255],                     // #DFB21E
                prevPlayed: [100, 100, 100, 255]                    // #646464
            },

            hotcue: {
                grid: [20, 20, 20, 255],                            // #141414
                hotcue: [0, 136, 184, 255],                         // #0088B8
                fade: [255, 120, 0, 255],                           // #FF7800
                load: [255, 255, 0, 255],                           // #FFFF00
                loop: [40, 255, 40, 255],                           // #28D928
                temp: "darkgrey"                                    // #A9A9A9
            },

            // Freeze - invertido y oscurecido
            freeze: {
                box_inactive: [78, 41, 44, 20],                     // #4E292C 14
                box_active: [84, 44, 36, 230],                      // #542C24 E6
                marker: [20, 20, 20, 65],                           // #141414 41
                slice_overlay: [20, 20, 20, 230]                    // #141414 E6
            },

            slicer: { /* ... mismo que default ... */ }
        },

        "pastel": {
            // Invertir colores de los recursos
            invertedResources: false,

            // Colores de fuente
            defaultTextColor: [90, 80, 120, 255],                      // #5A5078 (morado oscuro)
            defaultInvertedTextColor: [250, 245, 255, 255],            // #FAF5FF
            colorFontWhite: [250, 245, 255, 255],                      // #FAF5FF (blanco liláceo)
            colorFontBlack: [90, 80, 120, 255],                        // #5A5078 (morado oscuro)
            colorFontListBrowser: [120, 110, 150, 255],                // #786E96 (lila medio)
            colorFontListFx: [130, 120, 160, 255],                     // #8278A0 (lila medio-oscuro)
            colorFontBrowserHeader: [110, 100, 140, 255],              // #6E648C (lila oscuro)
            colorFontFxHeader: [115, 105, 145, 255],                   // #736991 (lila medio-oscuro)

            // Decks en pastel
            colorDeckBright: [173, 216, 230, 255],   // #ADD8E6
            colorDeckDark: [190, 214, 228, 255],     // #BED6E4
            colorDeckBlueBright20: [173, 216, 230, 51], // #ADD8E6
            colorDeckBlueBright50Full: [190, 214, 228, 255], // #BED6E4
            colorDeckBlueBright12Full: [220, 228, 230, 255], // #DCE4E6

            // Musical Keys completos - versión pastel
            color01MusicalKey: [230, 180, 200, 255],         // #E6B4C8 (rosa pastel)
            color02MusicalKey: [230, 190, 180, 255],         // #E6BEB4 (melocotón claro)
            color03MusicalKey: [230, 200, 170, 255],         // #E6C8AA (melocotón)
            color04MusicalKey: [230, 210, 170, 255],         // #E6D2AA (amarillo melocotón)
            color05MusicalKey: [230, 220, 170, 255],         // #E6DCAA (amarillo pastel)
            color06MusicalKey: [200, 230, 170, 255],         // #C8E6AA (verde amarillento)
            color07MusicalKey: [180, 230, 180, 255],         // #B4E6B4 (verde pastel)
            color08MusicalKey: [170, 230, 200, 255],         // #AAE6C8 (verde menta)
            color09MusicalKey: [170, 220, 230, 255],         // #AAE6C8 (azul claro)
            color10MusicalKey: [170, 200, 230, 255],         // #AAC8E6 (azul pastel)
            color11MusicalKey: [180, 180, 230, 255],         // #B4B4E6 (lila claro)
            color12MusicalKey: [200, 170, 230, 255],         // #C8AAE6 (lila)
            color13MusicalKey: [210, 170, 220, 255],         // #D2AADC (lila rosado)
            color14MusicalKey: [220, 170, 220, 255],         // #DCAADC (rosa lila)
            color15MusicalKey: [230, 170, 210, 255],         // #E6AAD2 (rosa medio)
            color16MusicalKey: [230, 175, 190, 255],         // #E6AFBE (rosa claro)


            // Hotcue colors (versión pastel)
            hotcueColors: {
                hotcue1: [230, 180, 200, 255],             // #E6B4C8 (rosa pastel)
                hotcue2: [170, 230, 210, 255],             // #AAE6D2 (menta)
                hotcue3: [230, 200, 170, 255],             // #E6C8AA (melocotón)
                hotcue4: [170, 200, 230, 255],             // #AAC8E6 (azul pastel)
                hotcue5: [230, 220, 170, 255],             // #E6DCAA (amarillo pastel)
                hotcue6: [200, 170, 230, 255],             // #C8AAE6 (púrpura pastel)
                hotcue7: [170, 230, 190, 255],             // #AAE6BE (verde menta claro)
                hotcue8: [220, 170, 230, 255],             // #DCAAE6 (lavanda)
            }

            /*
            // Colores por defecto - Versión Pastel
            defaultBackground: [245, 245, 255, 255],       // #F5F5FF Fondo blanco azulado suave
            loopActiveColor: [183, 255, 201, 255],         // #B7FFC9 Verde menta pastel
            loopActiveDimmedColor: [183, 255, 201, 190],   // #B7FFC9 Verde menta pastel con transparencia
            grayBackground: [230, 230, 240, 255],          // #E6E6F0 Gris perla suave

            // Colores FX - Versión Pastel
            colorMixerFXOrange: [255, 198, 173, 255],      // #FFC6AD Melocotón pastel
            colorMixerFXRed: [255, 182, 193, 255],         // #FFB6C1 Rosa pastel
            colorMixerFXGreen: [176, 255, 188, 255],       // #B0FFBC Menta pastel
            colorMixerFXBlue: [173, 216, 230, 255],        // #ADD8E6 Azul cielo pastel
            colorMixerFXYellow: [255, 253, 208, 255],      // #FFFDD0 Amarillo mantequilla

            // Colores básicos - Versión Pastel
            colorWhite: [248, 248, 255, 255],              // #F8F8FF Blanco fantasma
            colorRed: [255, 182, 193, 255],                // #FFB6C1 Rosa pastel
            colorBlack: [220, 220, 230, 255],              // #DCDCE6 Gris muy claro
            colorOrange: [255, 218, 185, 255],             // #FFDAB9 Melocotón claro
            colorGreen: [176, 255, 188, 255],              // #B0FFBC Menta pastel

            // Variaciones de rojo en pastel
            colorRed70: [255, 182, 182, 255],       // #FFB6B6

            // Variaciones de verde en pastel
            colorGreen50: [176, 255, 176, 128],     // #B0FFB0 50% opacidad
            colorGreen12: [176, 255, 176, 31],      // #B0FFB0 12% opacidad
            colorGreen08: [176, 255, 176, 20],      // #B0FFB0 8% opacidad
            colorGreen50Full: [176, 226, 176, 255], // #B0E2B0

            // Colores específicos en pastel
            colorOrangeDimmed: [255, 218, 185, 255], // #FFDAB9

            // Loops en pastel
            colorLoopActive: [176, 255, 176, 40],    // #B0FFB0
            colorLoopBorder: [176, 255, 176, 255],   // #B0FFB0
            colorLoopGradient: [176, 255, 176, 20],  // #B0FFB0
            colorLoopMarker: [176, 255, 176, 255],   // #B0FFB0
            colorLoopOverlay: [196, 255, 208, 16],   // #C4FFD0

            // Estados activo/inactivo en pastel
            colorGreenActive: [176, 255, 176, 255],           // #B0FFB0
            colorGreenInactive: [190, 226, 190, 255],         // #BEE2BE
            colorGreyInactive: [200, 200, 210, 255],          // #C8C8D2
            colorGreenGreyMix: [190, 255, 190, 82],           // #BEEFBE

            // Efectos
            colorMixerFXOrange: [230, 200, 170, 255],  // #E6C8AA (melocotón)
            colorMixerFXRed: [230, 180, 200, 255],     // #E6B4C8 (rosa)
            colorMixerFXGreen: [170, 230, 210, 255],   // #AAE6D2 (menta)
            colorMixerFXBlue: [170, 200, 230, 255],    // #AAC8E6 (azul pastel)
            colorMixerFXYellow: [230, 220, 170, 255],  // #E6DCAA (amarillo pastel)

            // Playmarker colors en pastel
            colorRedPlaymarker: [255, 182, 193, 255],         // #FFB6C1
            colorRedPlaymarker75: [255, 192, 203, 191],       // #FFC0CB
            colorRedPlaymarker06: [255, 192, 203, 31],        // #FFC0CB
            colorBluePlaymarker: [173, 216, 230, 255],        // #ADD8E6

            // Hotcues
            hotcue: {
                grid: [200, 200, 220, 255],            // #C8C8DC
                hotcue: [170, 200, 230, 255],          // #AAC8E6
                fade: [230, 200, 170, 255],            // #E6C8AA
                load: [230, 220, 170, 255],            // #E6DCAA
                loop: [170, 230, 210, 255],            // #AAE6D2
                temp: [200, 200, 220, 255]             // #C8C8DC
            },

            // Browser
            browser: {
                prelisten: [230, 200, 170, 255],       // #E6C8AA
                prevPlayed: [200, 200, 220, 255]       // #C8C8DC
            },

            // Browser en pastel
            colorBrowserBlueBright: [173, 216, 230, 255],     // #ADD8E6
            colorBrowserBlueBright56Full: [190, 214, 228, 255], // #BED6E4

            // Fondos y headers
            colorBgEmpty: [250, 245, 255, 255],        // #FAF5FF
            colorBrowserHeader: [240, 235, 250, 255],  // #F0EBFA
            colorFxHeaderBg: [245, 240, 255, 255],     // #F5F0FF
            
            // Colores base adicionales
            colorWhite: [250, 245, 255, 255],             // #FAF5FF (blanco liláceo)
            colorRed: [230, 180, 200, 255],               // #E6B4C8 (rosa pastel)
            colorBlack: [90, 80, 120, 255],               // #5A5078 (morado oscuro)
            colorOrange: [230, 200, 170, 255],            // #E6C8AA (melocotón)
            colorGreen: [170, 230, 210, 255],             // #AAE6D2 (menta)

            // Indicadores y otros elementos UI
            colorIndicatorBg: [245, 240, 255, 255],            // #F5F0FF (fondo muy claro)
            colorIndicatorBg2: [240, 235, 250, 255],           // #F0EBFA
            colorIndicatorLevelGrey: [200, 200, 220, 255],     // #C8C8DC (gris pastel)
            colorIndicatorLevelOrange: [230, 200, 170, 255],   // #E6C8AA (melocotón)
            colorCenterOverlayHeadline: [180, 170, 230, 255],  // #B4AAE6 (lila)
            footerBackgroundBlue: [230, 240, 250, 255],        // #E6F0FA (azul muy claro)

            // Elementos faltantes del tema default
            grayBackground: [240, 235, 250, 255],          // #F0EBFA (gris pastel)
            
            // fx Select overlay colors en pastel
            fxSelectHeaderTextRGB: [210, 210, 220, 255],      // #D2D2DC
            fxSelectHeaderNormalRGB: [225, 225, 235, 255],    // #E1E1EB
            fxSelectHeaderNormalBorderRGB: [225, 225, 235, 255], // #E1E1EB
            fxSelectHeaderHighlightRGB: [230, 230, 220, 255], // #E6E6DC
            fxSelectHeaderHighlightBorderRGB: [235, 235, 220, 255], // #EBEBDC

            // fx Slider colors en pastel
            colorFxSlider: [255, 218, 185, 255],              // #FFDAB9
            colorFxSliderBackground: [225, 225, 235, 255],    // #E1E1EB

            // Escalas de opacidad - base morado oscuro
            colorBlack94: [90, 80, 120, 240],             // #5A5078 F0
            colorBlack88: [90, 80, 120, 224],             // #5A5078 E0
            colorBlack85: [90, 80, 120, 217],             // #5A5078 D9
            colorBlack81: [90, 80, 120, 207],             // #5A5078 CF
            colorBlack78: [90, 80, 120, 199],             // #5A5078 C7
            colorBlack75: [90, 80, 120, 191],             // #5A5078 BF
            colorBlack69: [90, 80, 120, 176],             // #5A5078 B0
            colorBlack66: [90, 80, 120, 168],             // #5A5078 A8
            colorBlack63: [90, 80, 120, 161],             // #5A5078 A1
            colorBlack60: [90, 80, 120, 153],             // #5A5078 99
            colorBlack56: [90, 80, 120, 143],             // #5A5078 8F
            colorBlack53: [90, 80, 120, 135],             // #5A5078 87
            colorBlack50: [90, 80, 120, 128],             // #5A5078 80
            colorBlack47: [90, 80, 120, 120],             // #5A5078 78
            colorBlack44: [90, 80, 120, 112],             // #5A5078 70
            colorBlack41: [90, 80, 120, 105],             // #5A5078 69
            colorBlack38: [90, 80, 120, 97],              // #5A5078 61
            colorBlack35: [90, 80, 120, 89],              // #5A5078 59
            colorBlack31: [90, 80, 120, 79],              // #5A5078 4F
            colorBlack28: [90, 80, 120, 71],              // #5A5078 47
            colorBlack25: [90, 80, 120, 64],              // #5A5078 40
            colorBlack22: [90, 80, 120, 56],              // #5A5078 38
            colorBlack19: [90, 80, 120, 48],              // #5A5078 30
            colorBlack16: [90, 80, 120, 41],              // #5A5078 29
            colorBlack12: [90, 80, 120, 31],              // #5A5078 1F
            colorBlack09: [90, 80, 120, 23],              // #5A5078 17
            colorBlack0: [90, 80, 120, 0],                // #5A5078 00

            // 16 Colors Palette (Bright) - versión pastel
            color01Bright: [230, 180, 200, 255],             // #E6B4C8 (rosa pastel)
            color02Bright: [230, 190, 180, 255],             // #E6BEB4
            color03Bright: [230, 200, 170, 255],             // #E6C8AA
            color04Bright: [230, 210, 170, 255],             // #E6D2AA
            color05Bright: [230, 220, 170, 255],             // #E6DCAA
            color06Bright: [200, 230, 170, 255],             // #C8E6AA
            color07Bright: [180, 230, 180, 255],             // #B4E6B4
            color08Bright: [170, 230, 200, 255],             // #AAE6C8
            color09Bright: [170, 220, 230, 255],             // #AADCE6
            color10Bright: [170, 200, 230, 255],             // #AAC8E6
            color11Bright: [180, 180, 230, 255],             // #B4B4E6
            color12Bright: [200, 170, 230, 255],             // #C8AAE6
            color13Bright: [210, 170, 220, 255],             // #D2AADC
            color14Bright: [220, 170, 220, 255],             // #DCAADC
            color15Bright: [230, 170, 210, 255],             // #E6AAD2
            color16Bright: [230, 175, 190, 255],             // #E6AFBE

            // Escala de grises pastel
            colorGrey232: [240, 235, 250, 255],           // #F0EBFA
            colorGrey216: [230, 225, 245, 255],           // #E6E1F5
            colorGrey208: [220, 215, 240, 255],           // #DCD7F0
            colorGrey200: [210, 205, 235, 255],           // #D2CDE8
            colorGrey192: [200, 195, 230, 255],           // #C8C3E6
            colorGrey184: [190, 185, 225, 255],           // #BEB9E1
            colorGrey176: [180, 175, 220, 255],           // #B4AFDC
            colorGrey168: [170, 165, 215, 255],           // #AAA5D7
            colorGrey160: [160, 155, 210, 255],           // #A09BD2
            colorGrey152: [150, 145, 205, 255],           // #9691CD
            colorGrey144: [140, 135, 200, 255],           // #8C87C8
            colorGrey136: [130, 125, 195, 255],           // #827DC3
            colorGrey128: [120, 115, 190, 255],           // #7873BE
            colorGrey120: [110, 105, 185, 255],           // #6E69B9
            colorGrey112: [100, 95, 180, 255],            // #645FB4
            colorGrey104: [90, 85, 175, 255],             // #5A55AF
            colorGrey96: [180, 175, 220, 255],              // #B4AFDC (más pastel)
            colorGrey88: [170, 165, 215, 255],              // #AAA5D7
            colorGrey80: [160, 155, 210, 255],              // #A09BD2
            colorGrey72: [150, 145, 205, 255],              // #9691CD
            colorGrey64: [140, 135, 200, 255],              // #8C87C8
            colorGrey56: [130, 125, 195, 255],              // #827DC3
            colorGrey48: [120, 115, 190, 255],              // #7873BE
            colorGrey40: [110, 105, 185, 255],              // #6E69B9
            colorGrey32: [100, 95, 180, 255],               // #645FB4
            colorGrey24: [90, 85, 175, 255],                // #5A55AF
            colorGrey16: [80, 75, 170, 255],                // #504BAA
            colorGrey8: [70, 65, 165, 255],                 // #4641A5

            // Paleta Mid faltante (versión pastel)
            color01Mid: [220, 170, 190, 255],              // #DCAABE
            color02Mid: [220, 180, 170, 255],              // #DCB4AA
            color03Mid: [220, 190, 160, 255],              // #DCBEA0
            color04Mid: [220, 200, 160, 255],              // #DCC8A0
            color05Mid: [220, 220, 160, 255],              // #DCDCA0
            color06Mid: [190, 220, 160, 255],              // #BEDCA0
            color07Mid: [170, 220, 170, 255],              // #AADCAA
            color08Mid: [160, 210, 190, 255],              // #A0D2BE
            color09Mid: [160, 200, 200, 255],              // #A0C8C8
            color10Mid: [160, 190, 220, 255],              // #A0BEDC
            color11Mid: [180, 190, 220, 255],              // #B4BEDC
            color12Mid: [200, 180, 220, 255],              // #C8B4DC
            color13Mid: [210, 180, 210, 255],              // #D2B4D2
            color14Mid: [220, 170, 220, 255],              // #DCAADC
            color15Mid: [220, 160, 220, 255],              // #DCA0DC
            color16Mid: [220, 170, 200, 255],              // #DCAAC8

            // Paleta Dark faltante (versión pastel suave)
            color01Dark: [200, 160, 180, 255],             // #C8A0B4
            color02Dark: [200, 170, 175, 255],               // #C8AAAF
            color03Dark: [200, 180, 160, 255],               // #C8B4A0
            color04Dark: [200, 190, 160, 255],               // #C8BEA0
            color05Dark: [200, 200, 160, 255],               // #C8C8A0
            color06Dark: [180, 200, 160, 255],               // #B4C8A0
            color07Dark: [160, 200, 170, 255],               // #A0C8AA
            color08Dark: [160, 190, 180, 255],               // #A0BEB4
            color09Dark: [160, 180, 200, 255],               // #A0B4C8
            color10Dark: [160, 170, 200, 255],               // #A0AAC8
            color11Dark: [170, 170, 200, 255],               // #AAAAC8
            color12Dark: [180, 170, 200, 255],               // #B4AAC8
            color13Dark: [190, 170, 190, 255],               // #BEAABE
            color14Dark: [200, 160, 200, 255],               // #C8A0C8
            color15Dark: [200, 150, 200, 255],               // #C896C8
            color16Dark: [200, 160, 180, 255],               // #C8A0B4

            // Freeze
            freeze: {
                box_inactive: [180, 170, 230, 20],        // #B4AAE6 14
                box_active: [170, 230, 210, 230],         // #AAE6D2 E6
                marker: [200, 200, 220, 65],              // #C8C8DC 41
                slice_overlay: [200, 200, 220, 230]       // #C8C8DC E6
            },

            // Slicer
            slicer: {
                box_active: [170, 230, 210, 255],         // #AAE6D2 FF
                box_inrange: [170, 230, 210, 90],         // #AAE6D2 5A
                box_inactive: [170, 230, 210, 25],        // #AAE6D2 19
                marker_default: [170, 230, 210, 77],      // #AAE6D2 4D
                marker_beat: [170, 230, 210, 150],        // #AAE6D2 96
                marker_edge: [170, 230, 210, 255]         // #AAE6D2 FF
            },

            // Colores de fuente en pastel
            defaultTextColor: [245, 245, 255, 255],           // #F5F5FF
            defaultInvertedTextColor: [220, 220, 230, 255],   // #DCDCE6
            colorFontWhite: [245, 245, 255, 255],             // #F5F5FF
            colorFontBlack: [220, 220, 230, 255],             // #DCDCE6
            colorFontRed: [255, 182, 193, 255],               // #FFB6C1
            colorFontOrange: [255, 218, 185, 255],            // #FFDAB9
            colorFontGreen: [176, 255, 176, 255],             // #B0FFB0
            colorFontBlue: [173, 216, 230, 255],              // #ADD8E6
            colorFontYellow: [255, 255, 224, 255],            // #FFFFE0
            colorFontGrey: [200, 200, 210, 255],              // #C8C8D2
            colorFontListBrowser: [210, 210, 220, 255],       // #D2D2DC
            colorFontListFx: [200, 200, 210, 255],            // #C8C8D2
            colorFontBrowserHeader: [205, 205, 215, 255],     // #CDCDD7
            colorFontFxHeader: [202, 202, 212, 255],          // #CACAD4


            // Fondos de cabeceras y pies en pastel
            colorBgEmpty: [230, 230, 240, 255],                // #E6E6F0
            colorBrowserHeader: [225, 225, 235, 255],          // #E1E1EB
            colorFxHeaderBg: [220, 220, 230, 255],            // #DCDCE6
            colorFxHeaderLightBg: [225, 225, 235, 255],       // #E1E1EB

            // Fondos de progreso en pastel
            colorProgressBg: [220, 220, 230, 255],            // #DCDCE6
            colorProgressBgLight: [225, 225, 235, 255],       // #E1E1EB
            colorDivider: [215, 215, 225, 255],               // #D7D7E1

            // Fondos de indicadores en pastel
            colorIndicatorBg: [225, 225, 235, 255],           // #E1E1EB
            colorIndicatorBg2: [228, 228, 238, 255],          // #E4E4EE

            // Indicadores de nivel en pastel
            colorIndicatorLevelGrey: [200, 200, 210, 255],    // #C8C8D2
            colorIndicatorLevelOrange: [255, 218, 185, 255],  // #FFDAB9

            // Cabecera de overlay en pastel
            colorCenterOverlayHeadline: [210, 210, 220, 255], // #D2D2DC

            // Fondo del BottomControls en pastel
            footerBackgroundBlue: [173, 216, 230, 255],       // #ADD8E6




            // Colores para Phase Meter en pastel
            colorPhaseMeterMasterActive: [255, 218, 185, 255],   // #FFDAB9
            colorPhaseMeterDeckActive: [176, 255, 176, 255],     // #B0FFB0
            colorPhaseMeterInactive: [225, 225, 235, 255],       // #E1E1EB
            colorPhaseMeterBorder: [210, 210, 220, 255],         // #D2D2DC

            // Nueva estructura de colores para Decks en pastel
            deckColors: {
                states: {
                    active: [255, 218, 185, 255],      // #FFDAB9
                    inactive: [210, 210, 220, 255],    // #D2D2DC
                    warning: [255, 218, 185, 255],     // #FFDAB9
                    error: [255, 182, 193, 255]        // #FFB6C1
                },

                indicators: {
                    sync: {
                        active: [176, 255, 176, 255],       // #B0FFB0
                        inactive: [215, 215, 225, 255],     // #D7D7E1
                        text: {
                            active: [225, 225, 235, 255],   // #E1E1EB
                            enabled: [255, 218, 185, 255],  // #FFDAB9
                            disabled: [210, 210, 220, 255]  // #D2D2DC
                        }
                    },
                    
                    master: {
                        active: [173, 216, 230, 255],       // #ADD8E6
                        inactive: [215, 215, 225, 255],     // #D7D7E1
                        text: {
                            active: [225, 225, 235, 255],   // #E1E1EB
                            enabled: [255, 218, 185, 255],  // #FFDAB9
                            disabled: [210, 210, 220, 255]  // #D2D2DC
                        }
                    },

                    loop: {
                        active: [176, 255, 176, 128],       // #B0FFB0
                        inactive: [215, 215, 225, 255],     // #D7D7E1
                        text: {
                            active: [225, 225, 235, 255],   // #E1E1EB
                            inactive: [176, 255, 176, 128]   // #B0FFB0
                        }
                    },

                    mixerfx: {
                        background: {
                            active: "fromMixerFXColors",    // Mantiene referencia
                            inactive: [225, 225, 235, 255]  // #E1E1EB
                        },
                        text: {
                            active: [225, 225, 235, 255],   // #E1E1EB
                            inactive: "fromMixerFXColors"    // Mantiene referencia
                        }
                    },

                    deckCover: {
                        borders: {
                            inner: [245, 245, 255, 41],     // #F5F5FF
                            outer: [220, 220, 230, 255]     // #DCDCE6
                        },
                        shadow: [220, 220, 230, 255],       // #DCDCE6
                        empty: {
                            dot: [225, 225, 235, 255]       // #E1E1EB
                        }
                    },

                    deckWarning: {
                        background: [220, 220, 230, 255],   // #DCDCE6
                        text: {
                            error: [255, 182, 193, 255],    // #FFB6C1
                            warning: {
                                normal: [255, 218, 185, 255],    // #FFDAB9
                                dimmed: [255, 218, 185, 128]     // #FFDAB9
                            }
                        }
                    },

                    emptyDeck: {
                        background: [228, 228, 238, 255],   // #E4E4EE
                        overlay: [255, 182, 193, 255],      // #FFB6C1
                        image: {
                            path: "../Images/EmptyDeck.png"  // Mantiene ruta original
                        }
                    }                
                }
            },

            // Colores específicos para los decks en pastel
            deckItemColors: {
                text: [
                    [173, 216, 230, 255],    // #ADD8E6
                    [173, 216, 230, 255],    // #ADD8E6
                    [232, 232, 242, 255],    // #E8E8F2
                    [232, 232, 242, 255]     // #E8E8F2
                ],
                darker: [
                    [190, 214, 228, 255],    // #BED6E4
                    [190, 214, 228, 255],    // #BED6E4
                    [210, 210, 220, 255],    // #D2D2DC
                    [210, 210, 220, 255]     // #D2D2DC
                ],
                background: [
                    [190, 214, 228, 255],    // #BED6E4
                    [190, 214, 228, 255],    // #BED6E4
                    [225, 225, 235, 255],    // #E1E1EB
                    [225, 225, 235, 255]     // #E1E1EB
                ],
                circle: [
                    [200, 220, 230, 255],    // #C8DCE6
                    [200, 220, 230, 255],    // #C8DCE6
                    [225, 225, 235, 255],    // #E1E1EB
                    [225, 225, 235, 255]     // #E1E1EB
                ],
                icon: [
                    "PastelBlue",            // Deck A
                    "PastelBlue",            // Deck B
                    "PastelGrey",            // Deck C
                    "PastelGrey"             // Deck D
                ]
            },

            // 16 Colors Palette (Bright) - Versión Pastel
            color01Bright: [255, 182, 193, 255],    // #FFB6C1 Pink
            color02Bright: [255, 192, 203, 255],    // #FFC0CB Light pink
            color03Bright: [255, 218, 185, 255],    // #FFDAB9 Peach
            color04Bright: [255, 228, 181, 255],    // #FFE4B5 Moccasin
            color05Bright: [255, 255, 224, 255],    // #FFFFE0 Light yellow
            color06Bright: [220, 255, 220, 255],    // #DFFFDC Mint cream
            color07Bright: [176, 255, 176, 255],    // #B0FFB0 Light green
            color08Bright: [176, 255, 224, 255],    // #B0FFE0 Aquamarine
            color09Bright: [173, 216, 230, 255],    // #ADD8E6 Light blue
            color10Bright: [176, 196, 255, 255],    // #B0C4FF Light steel blue
            color11Bright: [176, 180, 255, 255],    // #B0B4FF Periwinkle
            color12Bright: [230, 190, 255, 255],    // #E6BEFF Light purple
            color13Bright: [238, 190, 239, 255],    // #EEBEEF Light magenta
            color14Bright: [255, 182, 239, 255],    // #FFB6EF Pink lavender
            color15Bright: [255, 182, 193, 255],    // #FFB6C1 Pink
            color16Bright: [255, 182, 185, 255],    // #FFB6B9 Light coral

            // 16 Colors Palette (Mid) - Versión Pastel
            color01Mid: [230, 190, 190, 255],       // #E6BEBE
            color02Mid: [230, 200, 190, 255],       // #E6C8BE
            color03Mid: [230, 210, 190, 255],       // #E6D2BE
            color04Mid: [230, 220, 190, 255],       // #E6DCBE
            color05Mid: [220, 220, 190, 255],       // #DCDCBE
            color06Mid: [210, 220, 190, 255],       // #D2DCBE
            color07Mid: [190, 220, 190, 255],       // #BEDCBE
            color08Mid: [190, 220, 210, 255],       // #BEDCD2
            color09Mid: [190, 215, 215, 255],       // #BED7D7
            color10Mid: [190, 210, 220, 255],       // #BED2DC
            color11Mid: [200, 210, 230, 255],       // #C8D2E6
            color12Mid: [210, 200, 230, 255],       // #D2C8E6
            color13Mid: [215, 200, 220, 255],       // #D7C8DC
            color14Mid: [225, 195, 230, 255],       // #E1C3E6
            color15Mid: [230, 190, 230, 255],       // #E6BEE6
            color16Mid: [230, 190, 205, 255],       // #E6BECD

            // 16 Colors Palette (Dark) - Versión Pastel Suave
            color01Dark: [200, 190, 190, 255],      // #C8BEBE
            color02Dark: [200, 195, 190, 255],      // #C8C3BE
            color03Dark: [200, 195, 190, 255],      // #C8C3BE
            color04Dark: [200, 200, 190, 255],      // #C8C8BE
            color05Dark: [200, 200, 190, 255],      // #C8C8BE
            color06Dark: [195, 200, 190, 255],      // #C3C8BE
            color07Dark: [195, 200, 195, 255],      // #C3C8C3
            color08Dark: [190, 200, 195, 255],      // #BEC8C3
            color09Dark: [190, 195, 200, 255],      // #BEC3C8
            color10Dark: [190, 195, 200, 255],      // #BEC3C8
            color11Dark: [190, 190, 200, 255],      // #BEBEC8
            color12Dark: [195, 190, 200, 255],      // #C3BEC8
            color13Dark: [195, 190, 200, 255],      // #C3BEC8
            color14Dark: [200, 190, 200, 255],      // #C8BEC8
            color15Dark: [200, 190, 195, 255],      // #C8BEC3
            color16Dark: [200, 190, 195, 255],      // #C8BEC3

            // Musical Key coloring - Versión Pastel
            color01MusicalKey: [255, 182, 193, 255], // #FFB6C1 Pink
            color02MusicalKey: [255, 210, 190, 255], // #FFD2BE Peach
            color03MusicalKey: [255, 218, 185, 255], // #FFDAB9 Light peach
            color04MusicalKey: [255, 228, 181, 255], // #FFE4B5 Moccasin
            color05MusicalKey: [255, 255, 224, 255], // #FFFFE0 Light yellow
            color06MusicalKey: [230, 255, 190, 255], // #E6FFBE Light lime
            color07MusicalKey: [190, 255, 190, 255], // #BEFFBE Mint
            color08MusicalKey: [190, 255, 220, 255], // #BEFFDC Light aqua
            color09MusicalKey: [190, 225, 230, 255], // #BEE1E6 Light blue
            color10MusicalKey: [190, 220, 255, 255], // #BEDCFF Baby blue
            color11MusicalKey: [190, 205, 255, 255], // #BECDFF Light periwinkle
            color12MusicalKey: [220, 190, 255, 255], // #DCBEFF Light purple
            color13MusicalKey: [230, 190, 230, 255], // #E6BEE6 Light magenta
            color14MusicalKey: [255, 190, 230, 255], // #FFBEE6 Light pink
            color15MusicalKey: [255, 190, 220, 255], // #FFBEDC Baby pink
            color16MusicalKey: [255, 195, 210, 255], // #FFC3D2 Soft pink

            // Objetos anidados pastelizados
            browser: {
                prelisten: [255, 230, 180, 255],    // #FFE6B4 Light golden
                prevPlayed: [200, 200, 210, 255]    // #C8C8D2 Light grey
            },

            hotcue: {
                grid: [245, 245, 250, 255],         // #F5F5FA Whitish
                hotcue: [173, 216, 230, 255],       // #ADD8E6 Light blue
                fade: [255, 218, 185, 255],         // #FFDAB9 Peach
                load: [255, 255, 224, 255],         // #FFFFE0 Light yellow
                loop: [176, 255, 176, 255],         // #B0FFB0 Light green
                temp: [220, 220, 225, 255]          // #DCDCE1 Light grey
            },

            hotcueColors: {
                1: [255, 182, 193, 255],            // #FFB6C1 Pink
                2: [255, 218, 185, 255],            // #FFDAB9 Peach
                3: [255, 255, 224, 255],            // #FFFFE0 Light yellow
                4: [176, 255, 176, 255],            // #B0FFB0 Light green
                5: [173, 216, 230, 255],            // #ADD8E6 Light blue
                6: [176, 180, 255, 255],            // #B0B4FF Periwinkle
                7: [230, 190, 230, 255],            // #E6BEE6 Light magenta
                8: [255, 182, 193, 255]             // #FFB6C1 Pink
            },

            freeze: {
                box_inactive: [200, 220, 240, 20],  // #C8DCF0
                box_active: [200, 240, 245, 230],   // #C8F0F5
                marker: [245, 245, 250, 65],        // #F5F5FA
                slice_overlay: [245, 245, 250, 230] // #F5F5FA
            },

            slicer: {
                box_active: [190, 230, 190, 255],   // #BEE6BE
                box_inrange: [190, 230, 190, 90],   // #BEE6BE
                box_inactive: [190, 230, 190, 25],  // #BEE6BE
                marker_default: [190, 230, 190, 77],// #BEE6BE
                marker_beat: [190, 230, 190, 150],  // #BEE6BE
                marker_edge: [190, 230, 190, 255]   // #BEE6BE
            }
*/
        }
    }
} 
