import CSI 1.0
import QtQuick
import Qt5Compat.GraphicalEffects

import '../../../../Defines'
import '../Waveform' as WF

import '../../../../Screens/Defines'


//----------------------------------------------------------------------------------------------------------------------
// TRACK DECK - Componente principal para visualización de deck de pista
//
// ELEMENTOS PRINCIPALES Y COLORES:
//
// 1. Contenedor Principal (trackDeck)
//    - Color de fondo: colors.colorBgEmpty
//    - Estado de tamaño: "small", "medium", "large"
//
// 2. Contenedor de Forma de Onda (WaveformContainer)
//    - Márgenes: 
//      * Superior: 30px
//      * Inferior: 5px
//    - Altura: Variable según deckSizeState
//      * small: 0px
//      * medium: parent.height - 55px
//      * large: parent.height - 70px
//
// 3. Stripe (Línea de progreso)
//    - Altura: 30px
//    - Color de fondo: colors.colorBgEmpty
//    - Márgenes laterales: 9px
//    - Indicadores laterales:
//      * Izquierdo: Letra del deck (A,B,C,D)
//      * Derecho: Indicador de Key Lock
//        - Activo: colors.colorDeckBright
//        - Inactivo: colors.colorGrey40
//
// 4. Barra de Hotcues
//    - Altura: 19px (0px si está oculta)
//    - Espaciado: 2px entre hotcues
//    - Colores de Hotcues:
//      * Activo: hotcueColors[type] (varios colores según tipo)
//      * Inactivo: colors.colorBgEmpty
//    - Texto:
//      * Color activo: colors.colorGrey24
//      * Color inactivo: colors.colorGrey128
//      * Fuente: prefs.mediumFontName, tamaño: fonts.miniFontSizePlusPlus
//
// 5. Deck Vacío
//    - Imagen: EmptyDeck.png
//    - Color overlay: deckColor
//    - Márgenes:
//      * Superior: 5px
//      * Inferior: 18px
//
// ESTADOS Y TRANSICIONES:
// - Transiciones suaves en cambios de altura (duración: durations.deckTransition)
// - Visibilidad condicionada al estado de carga de la pista
// - Adaptación automática según el tamaño del deck
//
//----------------------------------------------------------------------------------------------------------------------

Item {
  id: trackDeck

  property int    deckId:          0
  property string deckSizeState:   "large"
  property color  deckColor:       colors.colorBgEmpty // transparent blue not possible for logo due to low bit depth of displays. was: // (deckId < 2) ? colors.colorDeckBlueBright12Full : colors.colorBgEmpty
  property bool   trackIsLoaded:   (primaryKey.value > 0)
  
  readonly property variant deckLetters: ["A", "B", "C", "D"]

  readonly property int waveformHeight: (deckSizeState == "small") ? 0 : ( parent ? ( (deckSizeState == "medium") ? (parent.height-55) : (parent.height-70) ) : 0 )

  readonly property int largeDeckBottomMargin: (waveformContainer.isStemStyleDeck) ? 1 : 1  
  readonly property int smallDeckBottomMargin: (deckId > 1) ? 1 : 1

  property bool showLoopSize: false
  property int  zoomLevel:    1
  property bool isInEditMode: false
  property int    stemStyle:    StemStyle.track
  property string propertiesPath: ""

  readonly property int minSampleWidth: 0x800
  readonly property int sampleWidth: minSampleWidth << zoomLevel

  readonly property variant hotcueColors: [colors.hotcue.hotcue, colors.colorRed, colors.hotcue.fade, colors.hotcue.load, colors.hotcue.grid, colors.hotcue.loop ]

  //--------------------------------------------------------------------------------------------------------------------

  AppProperty   { id: deckType;          path: "app.traktor.decks." + (deckId + 1) + ".type"                    }
  AppProperty   { id: primaryKey;        path: "app.traktor.decks." + (deckId + 1) + ".track.content.entry_key" }

  AppProperty   { id: trackLength;       path: "app.traktor.decks." + (deckId + 1) + ".track.content.track_length" }
  AppProperty   { id: keyLockEnabled;    path: "app.traktor.decks." + (deckId+1) + ".track.key.lock_enabled" }


  //--------------------------------------------------------------------------------------------------------------------
  // Waveform
  //--------------------------------------------------------------------------------------------------------------------

  WF.WaveformContainer {
    id: waveformContainer

    deckId:             trackDeck.deckId
    deckSizeState:      trackDeck.deckSizeState
    sampleWidth:        trackDeck.sampleWidth
    propertiesPath:     trackDeck.propertiesPath

    anchors.top:        parent.top
    anchors.left:       parent.left
    anchors.right:      parent.right
    anchors.bottom:     parent.bottom
    //anchors.bottom:     stripe.top

    showLoopSize:       trackDeck.showLoopSize
    isInEditMode:       trackDeck.isInEditMode
    stemStyle:          trackDeck.stemStyle

    anchors.topMargin: {
      if (prefs.displayDeckIndicators || prefs.displayPhaseMeter)
        return 30
      return 5
    }

    anchors.bottomMargin: {
      var incMargin = 0
      if (prefs.displayStripe)
        incMargin = incMargin + stripe.height
      if (prefs.displayHotCueBar)
        incMargin = incMargin + hotcues.height
      return incMargin + 5
    }

    // the height of the waveform is defined as the remaining space of deckHeight - stripe.height - spacerWaveStripe.height
    height:  waveformHeight              
    visible: (trackIsLoaded && deckSizeState != "small") ? 1 : 0

    Behavior on height { PropertyAnimation { duration: durations.deckTransition } }
  }
  

  //--------------------------------------------------------------------------------------------------------------------
  // Stripe
  //--------------------------------------------------------------------------------------------------------------------

  Rectangle {
    id:             stripeGapFillerLeft
    anchors.left:   parent.left
    anchors.right:  stripe.left
    anchors.bottom: stripe.bottom
    height:         stripe.height
    color:          colors.colorBgEmpty
    visible:        trackDeck.trackIsLoaded && prefs.displayStripe && deckSizeState != "small"
  }

  Rectangle {
    id:             stripeGapFillerRight
    anchors.left:   stripe.right
    anchors.right:  parent.right
    anchors.bottom: stripe.bottom
    height:         stripe.height
    color:          colors.colorBgEmpty
    visible:        trackDeck.trackIsLoaded && prefs.displayStripe && deckSizeState != "small"
  }

  //--------------------------------------------------------------------------------------------------------------------
  // Deck Indicator
  //--------------------------------------------------------------------------------------------------------------------
  Rectangle {
    id:             trackDeckIndicator
    anchors.left:   parent.left
    anchors.bottom: stripe.bottom
    height:         stripe.height
    width:          20
    color:          colors.colorBgEmpty
    radius:         1
    antialiasing:   false
    opacity:        trackDeck.trackIsLoaded && prefs.displayStripe ? 1 : 0

    Image {
      id: deck_letter_large
      anchors.fill: parent
      fillMode: Image.Stretch
      source: "../Images/Deck_" + deckLetters[deckId] + colors.inverted + ".png"
    }
  }

  //--------------------------------------------------------------------------------------------------------------------
  // Key Lock Indicator
  //--------------------------------------------------------------------------------------------------------------------  
  Rectangle {
    id: keyLockIndicatorBox

    anchors.right:     parent.right
    anchors.bottom:    stripe.bottom
    height:            stripe.height
    width:             20
    color:             keyLockEnabled.value ? colors.colorGrey40 : colors.colorDeckBright
    radius:            1
    antialiasing:      false
    opacity:           trackDeck.trackIsLoaded && prefs.displayStripe ? 1 : 0

    Image {
      id: key_lock
      width: 6
      height: 18
      anchors.horizontalCenter: parent.horizontalCenter
      anchors.verticalCenter: parent.verticalCenter
      antialiasing:    false
      source:          "../Images/QuarterNote.svg"
    }

    ColorOverlay {
      id:           key_lock_overlay
      color:        keyLockEnabled.value ? colors.colorGrey200: colors.colorGrey24
      anchors.fill: key_lock
      source:       key_lock
    }
  }

  //--------------------------------------------------------------------------------------------------------------------
  // Stripe
  //--------------------------------------------------------------------------------------------------------------------
  WF.Stripe {
    id: stripe

    anchors.left:           trackDeckIndicator.right
    anchors.right:          keyLockIndicatorBox.left
    anchors.bottom:         hotcues.top
    anchors.bottomMargin:   (deckSizeState == "large") ? largeDeckBottomMargin : smallDeckBottomMargin
    anchors.leftMargin:     9
    anchors.rightMargin:    9
    height:                 30
    opacity:                trackDeck.trackIsLoaded && prefs.displayStripe ? 1 : 0

    deckId:                 trackDeck.deckId
    windowSampleWidth:      trackDeck.sampleWidth

    audioStreamKey: deckTypeValid(deckType.value) ? ["PrimaryKey", primaryKey.value] : ["PrimaryKey", 0]

    function deckTypeValid(deckType)      { return (deckType == DeckType.Track || deckType == DeckType.Stem);  }

    Behavior on anchors.bottomMargin { PropertyAnimation {  duration: durations.deckTransition } }

    enabled: trackDeck.trackIsLoaded && prefs.displayStripe
  }

  //--------------------------------------------------------------------------------------------------------------------
  // Hotcues
  //--------------------------------------------------------------------------------------------------------------------
  Row {
    id: hotcues
    height: prefs.displayHotCueBar && deckSizeState != "small" ? 19 : 0
    visible: prefs.displayHotCueBar && deckSizeState != "small" && trackIsLoaded ? true : false
    spacing: 2
    anchors.bottom: parent.bottom
    anchors.bottomMargin: deckSizeState == "medium" ? 1 : 0
    anchors.left: parent.left
    anchors.right: parent.right

    Repeater {
      model: 8
      Rectangle {
        AppProperty { id: exists;  path: "app.traktor.decks." + (deckId+1) + ".track.cue.hotcues." + (index + 1) + ".exists" }
        AppProperty { id: name;    path: "app.traktor.decks." + (deckId+1) + ".track.cue.hotcues." + (index + 1) + ".name" }
        AppProperty { id: type;    path: "app.traktor.decks." + (deckId+1) + ".track.cue.hotcues." + (index + 1) + ".type" }

        width: (parent.width - 14) / 8
        height: parent.height
        color: exists.value > 0 ? hotcueColors[type.value] : colors.colorBgEmpty

        Text {
          width: parent.width - 6
          elide: Text.ElideRight
          text: (index + 1) + " " + (exists.value > 0 && name.value != "n.n." && name.value != "AutoGrid" ? name.value : "")
          color: exists.value > 0 ? colors.colorGrey24 : colors.colorGrey128

          font.pixelSize: fonts.miniFontSizePlusPlus // set in state
          font.family: prefs.mediumFontName        

          anchors.top: parent.top
          anchors.bottom: parent.bottom
          anchors.horizontalCenter: parent.horizontalCenter
          // anchors.leftMargin: 5
          // anchors.rightMargin: 5
          verticalAlignment: Text.AlignVCenter
        }
      }
    }

    Behavior on height { PropertyAnimation {  duration: durations.deckTransition } }
  }

  //--------------------------------------------------------------------------------------------------------------------
  // Empty Deck
  //--------------------------------------------------------------------------------------------------------------------  
  EmptyDeck {
    id: emptyTrackDeckImage
    anchors.fill: parent
    visible: (!trackIsLoaded && deckSizeState != "small")
  }
}
