import CSI 1.0
import QtQuick
import Qt5Compat.GraphicalEffects

import '../Widgets' as Widgets

import '../../../../Screens/Defines'

//--------------------------------------------------------------------------------------------------------------------
//  DECK HEADER - Cabecera del deck con información y controles
//
//  Características principales:
//  - Muestra información detallada de la pista actual
//  - Gestiona estados de sincronización y master
//  - Visualiza loops activos y sus tamaños
//  - Muestra advertencias y errores
//  - Adapta su visualización según el tipo de deck
//
//  Propiedades principales:
//  - deck_Id: ID del deck (0-3)
//  - headerState: Estado de visualización ("large"/"small")
//  - deckType: Tipo de deck (Track/Remix/Live/Thru)
//  - isLoaded: Indica si hay una pista cargada
//  - isInSync: Estado de sincronización
//  - isMaster: Indica si es el deck master
//
//  Secciones principales:
//  1. Textos del Header (DeckHeaderText):
//    - Top Row: Información principal (título, artista)
//    - Middle Row: Información secundaria (BPM, key)
//    - Bottom Row: Información adicional
//
//  2. Indicadores de Estado:
//    - SYNC: Estado de sincronización
//    - MASTER: Indicador de deck master
//    - LOOP: Tamaño y estado del loop
//    - MixerFX: Efectos activos
//
//  3. Phase Meter:
//    - Visualiza la fase entre decks
//    - Solo visible en modo track
//
//  4. Cover Art:
//    - Muestra carátula de la pista
//    - Estados especiales para decks vacíos
//
//  5. Sistema de Advertencias:
//    - Muestra mensajes de error/warning
//    - Parpadeo configurable
//    - Diferentes colores según severidad
//
//  Estados:
//  - large: Muestra toda la información
//  - small: Muestra información reducida
//
//  Funciones principales:
//  - updateHeader(): Actualiza estado general
//  - updateKeyColor(): Gestiona colores de tonalidad
//  - updatePhaseSyncBlinker(): Control de parpadeo sync
//  - updateLoopSize(): Actualiza visualización de loops
//  - colorForKey(): Determina color según tonalidad
//  - updateExplicitDeckHeaderNames(): Gestiona textos especiales
//
//  Comportamiento:
//  - Adapta visualización según tipo de deck
//  - Gestiona transiciones animadas
//  - Responde a cambios de estado del deck
//  - Muestra advertencias de forma dinámica
//--------------------------------------------------------------------------------------------------------------------

Item {
  id: deck_header

  property real screenScale: prefs.screenScale

  // QML-only deck types
  readonly property int thruDeckType:  4

  // Placeholder variables for properties that have to be set in the elements for completeness - but are actually set
  // in the states
  readonly property int    _intSetInState:    0

  // Here all the properties defining the content of the DeckHeader are listed. They are set in DeckView.
  property int    deck_Id:           0
  property int    deckId:           deck_Id

  property string headerState:      "large" // this property is used to set the state of the header (large/small)
  
  readonly property variant deckLetters:        ["A",                         "B",                          "C",                  "D"                 ]

  // TEXT COLORS
  readonly property variant textColors:         colors.deckItemColors.text
  // DARKER TEXT COLORS
  readonly property variant darkerTextColors:   colors.deckItemColors.darker
  // COVER BG EMPTY COLORS
  readonly property variant coverBgEmptyColors: colors.deckItemColors.background
  // CIRCLE EMPTY COLORS
  readonly property variant circleEmptyColors:  colors.deckItemColors.circle
  // DECK ICON COLORS
  readonly property variant deckIconColor:      colors.deckItemColors.icon

  // LOOP TEXT
  readonly property variant loopText:           ["/32", "/16", "1/8", "1/4", "1/2", "1", "2", "4", "8", "16", "32"]


  // these variables can not be changed from outside
  readonly property int speed: 40  // Transition speed
  readonly property int smallHeaderHeight: 26 * screenScale
  readonly property int largeHeaderHeight: 64 * screenScale

  // Escalar márgenes y dimensiones
  readonly property int rightFieldMargin: 2 * screenScale
  readonly property int fieldHeight: 20 * screenScale
  readonly property int rightFieldWidth: 68 * screenScale
  readonly property int centerFieldWidth: 60 * screenScale
  readonly property int fieldWidth: 78 * screenScale
  readonly property int topRowHeight: 24 * screenScale
  readonly property int bottomRowsHeight: 19 * screenScale

  readonly property bool   isLoaded:    top_left_text.isLoaded
  readonly property int    deckType:    deckTypeProperty.value
  readonly property int    isInSync:    top_left_text.isInSync
  readonly property int    isMaster:    top_left_text.isMaster
  readonly property double syncPhase:   (headerPropertySyncPhase.value*2.0).toFixed(2)
  readonly property int    loopSizePos: headerPropertyLoopSize.value

  function hasTrackStyleHeader(deckType)      { return (deckType == DeckType.Track  || deckType == DeckType.Stem);  }

  // PROPERTY SELECTION
  // IMPORTANT: See 'stateMapping' in DeckHeaderText.qml for the correct Mapping from
  //            the state-enum in c++ to the corresponding state
  // NOTE: For now, we set fix states in the DeckHeader! But we wanna be able to
  //       change the states.
  property int topLeftState:      prefs.topLeftText                       // headerSettingTopLeft.value
  property int topCenterState:    hasTrackStyleHeader(deckType) ? prefs.topCenterText : 30 // headerSettingTopMid.value
  property int topRightState:     prefs.topRightText                                // headerSettingTopRight.value

  property int middleLeftState:   prefs.middleLeftText                                 // headerSettingMidLeft.value
  property int middleCenterState: hasTrackStyleHeader(deckType) ? prefs.middleCenterText : 29 // headerSettingMidMid.value
  property int middleRightState:  prefs.middleRightText                                // headerSettingMidRight.value

  property int bottomLeftState:   prefs.bottomLeftText
  property int bottomCenterState: prefs.bottomCenterText
  property int bottomRightState:  prefs.bottomRightText

  height: largeHeaderHeight
  clip: false
  Behavior on height { NumberAnimation { duration: speed } }

  readonly property int warningTypeNone:    0
  readonly property int warningTypeWarning: 1
  readonly property int warningTypeError:   2

  property bool isError:   (deckHeaderWarningType.value == warningTypeError)
  

  //--------------------------------------------------------------------------------------------------------------------
  // Helper function
  function toInt(val) { return parseInt(val); }

  //--------------------------------------------------------------------------------------------------------------------
  // DECK PROPERTIES
  //--------------------------------------------------------------------------------------------------------------------
  AppProperty { id: deckKeyDisplay; path: "app.traktor.decks." + (deckId+1) + ".track.key.resulting.precise"; onValueChanged: { updateKeyColor() } }
  AppProperty { id: propMusicalKey; path: "app.traktor.decks." + (deckId+1) + ".content.musical_key" }
  AppProperty { id: propSyncMasterDeck; path: "app.traktor.masterclock.source_id" }

  AppProperty { id: propIsInSync;       path: "app.traktor.decks." + (deckId+1) + ".sync.enabled"; }  

  AppProperty { id: keyDisplay; path: "app.traktor.decks." + (deckId+1) + ".track.key.resulting.precise" }

  AppProperty { id: propElapsedTime; path: "app.traktor.decks." + (deckId+1) + ".track.player.elapsed_time"; }
  AppProperty { id: propNextCuePoint; path: "app.traktor.decks." + (deckId+1) + ".track.player.next_cue_point"; }
  AppProperty { id: propMixerBpm; path: "app.traktor.decks." + (deckId+1) + ".tempo.base_bpm" }
  AppProperty { id: propMixerStableBpm; path: "app.traktor.decks." + (deckId+1) + ".tempo.true_bpm" }

  AppProperty { id: deckTypeProperty; path: "app.traktor.decks." + (deck_Id+1) + ".type" }

  AppProperty { id: directThru; path: "app.traktor.decks." + (deck_Id+1) + ".direct_thru"; onValueChanged: { updateHeader() } }
  AppProperty { id: headerPropertyCover; path: "app.traktor.decks." + (deck_Id+1) + ".content.cover_md5" }
  AppProperty { id: headerPropertySyncPhase; path: "app.traktor.decks." + (deck_Id+1) + ".tempo.phase"; }
  AppProperty { id: headerPropertyLoopActive; path: "app.traktor.decks." + (deck_Id+1) + ".loop.active"; }
  AppProperty { id: headerPropertyLoopSize; path: "app.traktor.decks." + (deck_Id+1) + ".loop.size"; }
  AppProperty { id: keyLockEnabled; path: "app.traktor.decks." + (deck_Id+1) + ".track.key.lock_enabled" }

  AppProperty { id: deckHeaderWarningActive; path: "app.traktor.informer.deckheader_message." + (deck_Id+1) + ".active"; }
  AppProperty { id: deckHeaderWarningType; path: "app.traktor.informer.deckheader_message." + (deck_Id+1) + ".type"; }
  AppProperty { id: deckHeaderWarningMessage; path: "app.traktor.informer.deckheader_message." + (deck_Id+1) + ".long"; }
  AppProperty { id: deckHeaderWarningShortMessage; path: "app.traktor.informer.deckheader_message." + (deck_Id+1) + ".short"; }

  AppProperty { id: mixerFX; path: "app.traktor.mixer.channels." + (deck_Id+1) + ".fx.select" }
  AppProperty { id: mixerFXOn; path: "app.traktor.mixer.channels." + (deck_Id+1) + ".fx.on" }

  AppProperty { id: deckRunning; path: "app.traktor.decks." + (deck_Id+1) + ".running" }

  // STATE OF THE DECK HEADER LABELS
  AppProperty { id: headerSettingTopLeft; path: "app.traktor.settings.deckheader.top.left"; }
  AppProperty { id: headerSettingTopMid; path: "app.traktor.settings.deckheader.top.mid"; }
  AppProperty { id: headerSettingTopRight; path: "app.traktor.settings.deckheader.top.right"; }
  AppProperty { id: headerSettingMidLeft; path: "app.traktor.settings.deckheader.mid.left"; }
  AppProperty { id: headerSettingMidMid; path: "app.traktor.settings.deckheader.mid.mid"; }
  AppProperty { id: headerSettingMidRight; path: "app.traktor.settings.deckheader.mid.right"; }

  // STEP SEQUENCER
  AppProperty { id: sequencerOn; path: "app.traktor.decks." + (deckId + 1) + ".remix.sequencer.on" }
  readonly property bool showStepSequencer: (deckType == DeckType.Remix) && sequencerOn.value && (screen.flavor != ScreenFlavor.S5)
  onShowStepSequencerChanged: { updateLoopSize(); }

  //--------------------------------------------------------------------------------------------------------------------
  // UPDATE VIEW
  //--------------------------------------------------------------------------------------------------------------------
  Component.onCompleted: { updateHeader(); }
  onHeaderStateChanged: { updateHeader(); }
  onIsLoadedChanged: { updateHeader(); }
  onDeckTypeChanged: { updateHeader(); }
  onSyncPhaseChanged: { updateHeader(); }
  onIsMasterChanged: { updateHeader(); }

  function updateHeader() {
      updateExplicitDeckHeaderNames();
      updateCoverArt();
      updateLoopSize();
      updatePhaseSyncBlinker();
      
      // TODO: Implementar la funcionalidad de guardar datos del deck y la imagen de la carátula
      top_left_text.saveDeckData();
      top_left_text.saveDeckCoverImage(coverImage.source);
  }

  // Añadir validación de clave en la actualización
  function updateKeyColor() {
      if (!isLoaded || !keyDisplay.value) return;

      // Validar que la clave sea válida antes de actualizar
      const keyIndex = utils.returnKeyIndex(keyDisplay.value);
      if (keyIndex !== null) {
          // Actualizar colores solo si la clave es válida
          top_left_text.update();
          middle_left_text.update();
      }
  }

  //--------------------------------------------------------------------------------------------------------------------
  // PHASE SYNC BLINK
  //--------------------------------------------------------------------------------------------------------------------
  function updatePhaseSyncBlinker() {
      phase_sync_blink.enabled = ( headerState != "small"
                                  && isLoaded
                                  && !directThru.value
                                  && !isMaster
                                  && deckType != DeckType.Live
                                  && middle_right_text.text == "SYNC"
                                  && syncPhase != 0.0 ) ? 1 : 0;
  }

  Timer {
      id: phase_sync_blink
      property bool enabled: false
      interval: 200; running: true; repeat: true
      onTriggered: middle_right_text.visible = enabled ? !middle_right_text.visible : true
      onEnabledChanged: { middle_right_text.visible = true }
  }

  //--------------------------------------------------------------------------------------------------------------------
  // DECK HEADER TEXT
  //--------------------------------------------------------------------------------------------------------------------
  Rectangle {
      id: top_line;
      width: deck_header.width
      height: deck_Id >= 2 ? 1 : 0
      color: colors.colorBgEmpty
      visible: parent.parent.deckSize == "large" ? false : true // don't display when large
  }

  Rectangle {
      id: stem_text
      width: 35 * screenScale
      height: 14 * screenScale
      y: (3 * screenScale)
      x: top_left_text.x + top_left_text.paintedWidth + (5 * screenScale)

      color: colors.colorBgEmpty
      border.width: 1
      border.color: textColors[deck_Id]
      radius: 3
      opacity: 0.6

      visible: (deckType == DeckType.Stem) || showStepSequencer

      Text {
          x: showStepSequencer ? 5 : 3
          y: 1
          text: showStepSequencer ? "STEP" : "STEM"
          color: textColors[deck_Id]

          font.pixelSize: fonts.miniFontSize * screenScale
          font.family: prefs.normalFontName
      }

      Behavior on opacity { NumberAnimation { duration: speed } }
  }

  // --------------------------------------------------------------------------------------------------------------------
  // FIRST ROW
  // --------------------------------------------------------------------------------------------------------------------
  // top_left_text: TOP LEFT
  DeckHeaderText {
      id: top_left_text
      deckId: deck_Id
      explicitName: ""
      height: topRowHeight
      textState: topLeftState
      color: textState == 17 || textState == 18 || textState == 31 ?
                 (utils.returnKeyIndex(keyDisplay.value) !== null ?
                      parent.colorForKey(utils.returnKeyIndex(keyDisplay.value)) :
                      textColors[deck_Id])
               : textColors[deck_Id]
      elide: Text.ElideRight
      
      fontSizeMode: Text.HorizontalFit
      minimumPixelSize: fonts.miniFontSizePlusPlus

      font.pixelSize: fonts.largeFontSize * screenScale // set in state
      font.family: prefs.fontDeckHeaderString

      anchors.top: parent.top
      anchors.left: cover_small.right
      anchors.right: top_middle_text.left
      anchors.leftMargin: _intSetInState // set by 'state'
      verticalAlignment: Text.AlignVCenter
      Behavior on anchors.left { NumberAnimation { duration: speed } }
      Behavior on anchors.leftMargin { NumberAnimation { duration: speed } }
  }

  // top_middle_text: TOP CENTER
  DeckHeaderText {
      id: top_middle_text
      deckId: deck_Id
      explicitName: ""
      width: fieldWidth
      height: topRowHeight
      textState: topCenterState
      color: textState == 17 || textState == 18 || textState == 31 ?
                 parent.colorForKey(utils.returnKeyIndex(keyDisplay.value)) : textColors[deck_Id]

      fontSizeMode: Text.HorizontalFit
      minimumPixelSize: fonts.miniFontSizePlusPlus

      font.pixelSize: fonts.largeFontSize * screenScale
      font.family: prefs.fontDeckHeaderString

      anchors.top: parent.top
      anchors.right: top_right_text.left
      horizontalAlignment: Text.AlignRight
      verticalAlignment: Text.AlignVCenter
      // Behavior on height { NumberAnimation { duration: speed } }
      // Behavior on anchors.topMargin { NumberAnimation { duration: speed } }
      visible: isLoaded
  }

  // top_right_text: TOP RIGHT
  DeckHeaderText {
      id: top_right_text
      deckId: deck_Id
      explicitName: ""
      width: fieldWidth
      height: topRowHeight
      textState: topRightState
      color: textState == 17 || textState == 18 || textState == 31 ?
                 parent.colorForKey(utils.returnKeyIndex(keyDisplay.value)) : textColors[deck_Id]

      fontSizeMode: Text.HorizontalFit
      minimumPixelSize: fonts.miniFontSizePlusPlus

      font.pixelSize: fonts.largeFontSize * screenScale
      font.family: prefs.fontDeckHeaderString

      anchors.top: parent.top
      anchors.right: parent.right
      anchors.rightMargin: rightFieldMargin
      horizontalAlignment: Text.AlignRight
      verticalAlignment: Text.AlignVCenter
      visible: isLoaded
  }

  // --------------------------------------------------------------------------------------------------------------------
  // SECOND ROW
  // --------------------------------------------------------------------------------------------------------------------

  // middle_left_text: MIDDLE LEFT
  DeckHeaderText {
      id: middle_left_text
      deckId: deck_Id
      explicitName: ""
      height: bottomRowsHeight
      textState: middleLeftState
      color: textState == 17 || textState == 18 || textState == 31 ?
                 (utils.returnKeyIndex(keyDisplay.value) !== null ?
                      parent.colorForKey(utils.returnKeyIndex(keyDisplay.value)) :
                      darkerTextColors[deck_Id])
               : darkerTextColors[deck_Id]
      elide: Text.ElideRight

      fontSizeMode: Text.HorizontalFit
      minimumPixelSize: fonts.miniFontSize * screenScale

      font.pixelSize: fonts.middleFontSize * screenScale
      font.family: prefs.fontDeckHeaderString

      anchors.top: top_left_text.bottom
      anchors.left: cover_small.right
      anchors.right: top_middle_text.left
      anchors.leftMargin: 5 * screenScale
      anchors.rightMargin: 5 * screenScale
      verticalAlignment: Text.AlignVCenter
  }

  // middle_center_text: MIDDLE CENTER
  DeckHeaderText {
      id: middle_center_text
      deckId: deck_Id
      explicitName: ""
      width: fieldWidth
      height: bottomRowsHeight
      textState: middleCenterState
      visible: isLoaded
      color: textState == 17 || textState == 18 || textState == 31 ?
                 parent.colorForKey(utils.returnKeyIndex(keyDisplay.value)) : darkerTextColors[deck_Id]
      elide: Text.ElideRight
      opacity: _intSetInState // set by 'state'

      fontSizeMode: Text.HorizontalFit
      minimumPixelSize: fonts.miniFontSize * screenScale

      font.pixelSize: fonts.middleFontSize * screenScale
      font.family: prefs.fontDeckHeaderString

      anchors.top: top_middle_text.bottom
      anchors.right: middle_right_text.left
      horizontalAlignment: Text.AlignRight
      verticalAlignment: Text.AlignVCenter
      Behavior on opacity { NumberAnimation { duration: speed } }
  }

  // middle_right_text: MIDDLE RIGHT
  DeckHeaderText {
      id: middle_right_text
      deckId: deck_Id
      explicitName: ""
      width: fieldWidth
      height: bottomRowsHeight
      textState: middleRightState
      visible: isLoaded
      anchors.top: top_right_text.bottom
      anchors.right: parent.right
      anchors.rightMargin: rightFieldMargin
      color: textState == 17 || textState == 18 || textState == 31 ?
                 parent.colorForKey(utils.returnKeyIndex(keyDisplay.value)) : darkerTextColors[deck_Id]
      opacity: _intSetInState // set by 'state'

      fontSizeMode: Text.HorizontalFit
      minimumPixelSize: fonts.miniFontSize * screenScale

      font.pixelSize: fonts.middleFontSize * screenScale
      font.family: prefs.fontDeckHeaderString

      horizontalAlignment: Text.AlignRight
      verticalAlignment: Text.AlignVCenter
      onTextChanged: {updateHeader()}
      Behavior on opacity { NumberAnimation { duration: speed } }
  }

  // --------------------------------------------------------------------------------------------------------------------
  // THIRD ROW
  // --------------------------------------------------------------------------------------------------------------------

  // extra_middle_left_text: BOTTOM LEFT
  DeckHeaderText {
      id: extra_middle_left_text
      deckId: deck_Id
      explicitName: ""
      height: bottomRowsHeight
      textState: bottomLeftState
      color: textState == 17 || textState == 18 || textState == 31 ?
                 parent.colorForKey(utils.returnKeyIndex(keyDisplay.value)) : darkerTextColors[deck_Id]
      elide: Text.ElideRight
      opacity: _intSetInState // set by 'state'

      fontSizeMode: Text.HorizontalFit
      minimumPixelSize: fonts.miniFontSize * screenScale

      font.pixelSize: fonts.middleFontSize * screenScale
      font.family: prefs.fontDeckHeaderString

      anchors.top: middle_left_text.bottom
      anchors.left: cover_small.right
      anchors.right: original_tempo.left
      anchors.leftMargin: 5 * screenScale
      anchors.rightMargin: 5 * screenScale
      verticalAlignment: Text.AlignVCenter
      Behavior on opacity { NumberAnimation { duration: speed } }
  }

  // BOTTOM CENTER
  DeckHeaderText {
      id: bottom_center
      deckId: deck_Id
      explicitName: ""
      height: bottomRowsHeight
      textState: bottomCenterState
      visible: isLoaded
      width: fieldWidth
      anchors.bottom: parent.bottom
      anchors.right: bottom_right.left
      color: textState == 17 || textState == 18 || textState == 31 ?
                 parent.colorForKey(utils.returnKeyIndex(keyDisplay.value)) : darkerTextColors[deck_Id]
      opacity: _intSetInState // set by 'state'
    
      fontSizeMode: Text.HorizontalFit
      minimumPixelSize: fonts.miniFontSize * screenScale

      font.pixelSize: fonts.middleFontSize * screenScale
      font.family: prefs.fontDeckHeaderString

      horizontalAlignment: Text.AlignRight
      verticalAlignment: Text.AlignVCenter
      Behavior on opacity { NumberAnimation { duration: speed } }
      onTextChanged: {updateHeader()}
  }

  // BOTTOM RIGHT
  DeckHeaderText {
      id: bottom_right
      deckId: deck_Id
      explicitName: ""
      textState: bottomRightState
      visible: isLoaded
      width: fieldWidth
      height: bottomRowsHeight
      anchors.bottom: parent.bottom
      anchors.right: parent.right
      anchors.rightMargin: rightFieldMargin
      color: textState == 17 || textState == 18 || textState == 31 ?
                 parent.colorForKey(utils.returnKeyIndex(keyDisplay.value)) : darkerTextColors[deck_Id]
      opacity: _intSetInState // set by 'state'

      fontSizeMode: Text.HorizontalFit
      minimumPixelSize: fonts.miniFontSize * screenScale
      
      font.pixelSize: fonts.middleFontSize * screenScale
      font.family: prefs.fontDeckHeaderString

      horizontalAlignment: Text.AlignRight
      verticalAlignment: Text.AlignVCenter
      Behavior on opacity { NumberAnimation { duration: speed } }
  }

  // LOOP SIZE INDICATOR (CIRCLE)
  Widgets.SpinningWheel {
      id: loop_size
      visible: isLoaded && ( deckType == DeckType.Remix || !prefs.displayDeckIndicators )
      anchors.top: middle_center_text.bottom
      anchors.topMargin: 1 * screenScale
      anchors.right: bottom_center.left
      anchors.rightMargin: 0 * screenScale

      width: 22 * screenScale
      height: 22 * screenScale

      spinning: false
      opacity: loop_size.opacity
      textColor: headerPropertyLoopActive.value ? colors.colorGreen50 : textColors[deck_Id]
      Behavior on opacity { NumberAnimation { duration: speed } }
      Behavior on anchors.rightMargin { NumberAnimation { duration: speed } }

      Text {
          id: numberText
          text: loopText[loopSizePos]
          color: headerPropertyLoopActive.value ? colors.colorGreen : textColors[deck_Id]
          
          font.pixelSize: fonts.scale((loopSizePos < 5) ? fonts.miniFontSize : fonts.miniFontSizePlusPlus) * screenScale
          font.family: prefs.fontDeckHeaderString

          anchors.fill: loop_size
          anchors.topMargin: 2 * screenScale
          horizontalAlignment: Text.AlignHCenter
          verticalAlignment: Text.AlignVCenter
      }
  }

  // TEMPO MASTER (METRONOME) ICON
  Image {
      id: metronome_icon
      anchors.top: top_middle_text.bottom
      anchors.right: middle_center_text.left
      anchors.rightMargin: 4 * screenScale
      anchors.topMargin: 3 * screenScale
      visible: isLoaded && isMaster && ( deckType == DeckType.Remix || !prefs.displayDeckIndicators )
      source: "./../Images/DeckIconMetronome" + deckIconColor[deckId] + colors.inverted + ".png"
      sourceSize.width: 14 * screenScale
      sourceSize.height: 14 * screenScale
      width: 14 * screenScale
      height: 14 * screenScale
      fillMode: Image.PreserveAspectFit
      opacity: loop_size.opacity
      Behavior on opacity { NumberAnimation { duration: speed } }
      Behavior on anchors.rightMargin { NumberAnimation { duration: speed } }
  }

  MappingProperty { id: showBrowserOnTouch; path: "mapping.settings.show_browser_on_touch"; onValueChanged: { updateExplicitDeckHeaderNames() } }

  // deck header footer
  Item {
      id: deck_header_footer
      height: fieldHeight
      width: parent.width
      anchors.top: deck_header.bottom
      anchors.topMargin: prefs.displayDeckIndicators || prefs.displayPhaseMeter ? 5 * screenScale : 0

      // SYNC INDICATOR
      Rectangle {
          id: sync_indicator
          width: 62 * screenScale
          visible: prefs.displayDeckIndicators
          height: parent.height
          anchors.top: parent.top
          color: deckRunning.value && isInSync ?
                     colors.deckColors.indicators.sync.active :
                     colors.deckColors.indicators.sync.inactive

          // Propiedades para el control de sync
          property bool isLongPress: false
          property bool isPressed: false
          property bool wasInSync: false // Para recordar el estado anterior

          Timer {
              id: longPressSyncTimer
              interval: 500 // 500ms para considerar pulsación larga
              onTriggered: {
                  if (sync_indicator.isPressed) {
                      sync_indicator.isLongPress = true
                      // Alternar sync de forma permanente según estado actual
                      if (sync_indicator.wasInSync)
                        propIsInSync.value = false
                      else
                        propIsInSync.value = true
                      prefs.log("INFO", "SYNC permanent toggle: " + (propIsInSync.value ? "ON" : "OFF"))
                  }
              }
          }

          Text {
              anchors.fill: parent
              text: "SYNC"
              color: isInSync ?
                         (deckRunning.value ?
                              colors.deckColors.indicators.sync.text.active :
                              colors.deckColors.indicators.sync.text.enabled) :
                         colors.deckColors.indicators.sync.text.disabled

              font.pixelSize: fonts.miniFontSizePlusPlus * screenScale
              font.family: prefs.fontDeckHeaderString

              horizontalAlignment: Text.AlignHCenter
              verticalAlignment: Text.AlignVCenter

              MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                preventStealing: true
                propagateComposedEvents: true

                onPressed: {
                    sync_indicator.isPressed = true
                    sync_indicator.wasInSync = propIsInSync.value // Guardar estado actual
                    longPressSyncTimer.start()
                    
                    // Activar sync temporal inmediatamente
                    if (!sync_indicator.wasInSync) {
                        propIsInSync.value = true
                    }
                }
                
                onReleased: {
                    sync_indicator.isPressed = false
                    longPressSyncTimer.stop()
                    
                    if (!sync_indicator.isLongPress) {
                        // Si fue pulsación corta, restaurar estado anterior
                        propIsInSync.value = sync_indicator.wasInSync
                    }
                    sync_indicator.isLongPress = false
                }
              }
          }
          opacity: deckType == DeckType.Live ? 0 : 1

          property real bpmDifference: {
              if (!isLoaded || isMaster) return 0
              var currentBpm = propMixerBpm.value
              var masterBpm = propMixerStableBpm.value
              return masterBpm > 0 ? ((currentBpm - masterBpm) / masterBpm) * 100 : 0
          }

          // Añadir comportamiento suave
          Behavior on opacity { NumberAnimation { duration: speed } }
          Behavior on color { ColorAnimation { duration: speed } }
      }

      // MASTER INDICATOR
      Rectangle {
          id: master_indicator
          width: 62 * screenScale
          visible: prefs.displayDeckIndicators
          height: parent.height
          anchors.top: parent.top
          anchors.left: sync_indicator.right
          anchors.leftMargin: 2 * screenScale
          color: deckRunning.value && isMaster ?
                     colors.deckColors.indicators.master.active :
                     colors.deckColors.indicators.master.inactive

          Text {
              anchors.fill: parent
              text: "MASTER"
              color: isMaster ?
                         (deckRunning.value ?
                              colors.deckColors.indicators.master.text.active :
                              colors.deckColors.indicators.master.text.enabled) :
                         colors.deckColors.indicators.master.text.disabled

              font.pixelSize: fonts.miniFontSizePlusPlus * screenScale
              font.family: prefs.fontDeckHeaderString

              horizontalAlignment: Text.AlignHCenter
              verticalAlignment: Text.AlignVCenter
          }
          opacity: deckType == DeckType.Live ? 0 : 1
      }

      // MIXER FX INDICATOR
      Rectangle {
          id: mixerfx_indicator
          width: 62 * screenScale
          visible: prefs.displayDeckIndicators
          height: parent.height
          anchors.top: parent.top
          anchors.right: loop_indicator.left
          anchors.rightMargin: 2 * screenScale
          color: mixerFXOn.value ? colors.mixerFXColors[mixerFX.value] : colors.deckColors.indicators.mixerfx.background.inactive

          // Propiedades para el control de efectos
          property bool isLongPress: false
          property bool isPressed: false
          
          Timer {
              id: longPressMixerFxTimer
              interval: 500 // 500ms para considerar pulsación larga
              onTriggered: {
                  if (mixerfx_indicator.isPressed) {
                      mixerfx_indicator.isLongPress = true
                      // Cambiar al siguiente efecto
                      mixerFX.value = (mixerFX.value + 1) % 5 // 0-4
                  }
              }
          }

          Text {
              anchors.fill: parent
              text: prefs.getFilterAlias(mixerFX.value)
              color: mixerFXOn.value ? colors.deckColors.indicators.mixerfx.text.inactive : colors.mixerFXColors[mixerFX.value]
              
              font.pixelSize: fonts.miniFontSizePlusPlus * screenScale
              font.family: prefs.fontDeckHeaderString
              
              horizontalAlignment: Text.AlignHCenter
              verticalAlignment: Text.AlignVCenter

              MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                preventStealing: true
                propagateComposedEvents: true
                
                onPressed: {
                    mixerfx_indicator.isPressed = true
                    longPressMixerFxTimer.start()
                }
                
                onReleased: {
                    mixerfx_indicator.isPressed = false
                    longPressMixerFxTimer.stop()
                    if (!mixerfx_indicator.isLongPress) {
                        // Comportamiento normal: activar/desactivar el efecto
                        mixerFXOn.value = !mixerFXOn.value
                    }
                    mixerfx_indicator.isLongPress = false
                }
              }
          }

          opacity: directThru.value ? 0 : 1
      }

      // LOOP INDICATOR
      Rectangle {
          id: loop_indicator
          width: 62 * screenScale
          visible: prefs.displayDeckIndicators
          height: parent.height
          anchors.top: parent.top
          anchors.right: parent.right
          color: headerPropertyLoopActive.value ?
                     colors.deckColors.indicators.loop.active :
                     colors.deckColors.indicators.loop.inactive

          Text {
              anchors.fill: parent
              text: "LOOP " + loopText[loopSizePos]
              color: headerPropertyLoopActive.value ?
                         colors.deckColors.indicators.loop.text.active :
                         colors.deckColors.indicators.loop.text.inactive
              
              font.pixelSize: fonts.miniFontSizePlusPlus * screenScale
              font.family: prefs.fontDeckHeaderString
              
              horizontalAlignment: Text.AlignHCenter
              verticalAlignment: Text.AlignVCenter
          }
          opacity: deckType == DeckType.Live ? 0 : 1
      }

      // PHASE METER
      Widgets.PhaseMeter {
          id: phase_meter
          deckId: deck_Id
          visible: prefs.displayPhaseMeter
          width: parent.width - ((master_indicator.width + 2 * screenScale) * 4)
          height: prefs.phaseMeterHeight * screenScale
          anchors.verticalCenter: parent.verticalCenter
          anchors.horizontalCenter: parent.horizontalCenter
          opacity: deckType == DeckType.Live ? 0 : (isLoaded && headerState != "small" && hasTrackStyleHeader(deckType)) ? 1 : 0
      }

      visible: (isLoaded && deckType != DeckType.Remix && ( prefs.displayDeckIndicators || prefs.displayPhaseMeter )) || deckType == DeckType.Live
      Behavior on opacity { NumberAnimation { duration: speed } }
  }

  function updateExplicitDeckHeaderNames() {
      if (directThru.value) {
          top_left_text.explicitName      = "Direct Thru";
          middle_left_text.explicitName   = "The Mixer Channel is currently In Thru mode";
          // Limpiar otros textos
          top_middle_text.explicitName    = " ";
          top_right_text.explicitName     = " ";
          middle_center_text.explicitName = " ";
          middle_right_text.explicitName  = " ";
          
          // Ocultar
          state = "small";
      }
      else if (deckType == DeckType.Live) {
          top_left_text.explicitName      = "Live Input";
          middle_left_text.explicitName   = "Traktor Audio Passthru";
          // Limpiar otros textos
          top_middle_text.explicitName    = " ";
          top_right_text.explicitName     = " ";
          middle_center_text.explicitName = " ";
          middle_right_text.explicitName  = " ";
          
          // Ocultar
          state = "small";
      }
      else if ((deckType == DeckType.Track)  && !isLoaded) {
          top_left_text.explicitName      = "No Track Loaded";
          middle_left_text.explicitName   = showBrowserOnTouch.value ? "Touch Browse Knob" : "Push Browse Knob";
          // Limpiar otros textos
          top_middle_text.explicitName    = " ";
          top_right_text.explicitName     = " ";
          middle_center_text.explicitName = " ";
          middle_right_text.explicitName  = " ";
          
          // Ocultar
          state = "small";
      }
      else if (deckType == DeckType.Stem && !isLoaded) {
          top_left_text.explicitName      = "No Stem Loaded";
          middle_left_text.explicitName   = showBrowserOnTouch.value ? "Touch Browse Knob" : "Push Browse Knob";
          // Limpiar otros textos
          top_middle_text.explicitName    = " ";
          top_right_text.explicitName     = " ";
          middle_center_text.explicitName = " ";
          middle_right_text.explicitName  = " ";
          
          // Ocultar
          state = "small";
      }
      else if (deckType == DeckType.Remix && !isLoaded) {
          top_left_text.explicitName      = " ";
          // Limpiar otros textos
          middle_left_text.explicitName   = " ";
          top_middle_text.explicitName    = " ";
          top_right_text.explicitName     = " ";
          middle_center_text.explicitName = " ";
          middle_right_text.explicitName  = " ";
          
          // Ocultar
          state = "small";
      }
      else {
          // Restaurar estado normal
          top_left_text.explicitName      = "";
          middle_left_text.explicitName   = "";
          top_middle_text.explicitName    = "";
          top_right_text.explicitName     = "";
          middle_center_text.explicitName = "";
          middle_right_text.explicitName  = "";
          
          // Restaurar estado según headerState
          state = headerState;
      }
  }

  //--------------------------------------------------------------------------------------------------------------------
  //  COVER ART
  //--------------------------------------------------------------------------------------------------------------------

  // Inner Border
  function updateCoverArt() {
      if (headerState == "small" || deckType == DeckType.Live || directThru.value) {
          cover_small.opacity = 0;
          cover_small.width = 0;
          cover_small.height = cover_small.width;
          cover_innerBorder.opacity = 0;
          cover_small.anchors.leftMargin = 2 * screenScale; // Mantener el margen incluso cuando está oculto
          blackBorder.opacity = 0;
      } else {
          cover_small.opacity = 1;
          cover_small.width = prefs.displayAlbumCover ? largeHeaderHeight - 4 : 0;
          cover_small.height = prefs.displayAlbumCover ? largeHeaderHeight - 4 : 0;
          cover_innerBorder.opacity = (!isLoaded || (headerPropertyCover.value == "")) ? 0 : 1;
          cover_small.anchors.leftMargin = 2 * screenScale; // Mantener el margen de 2 pixels
          blackBorder.opacity = 1;
      }
  }

  // BLACK BORDER
  Rectangle {
      id: blackBorder
      color: colors.deckCover.borders.outer
      anchors.fill: cover_small
      anchors.margins: -1 * screenScale
  }

  // DROP SHADOW
  DropShadow {
      id: blackBorderDropShadow
      visible: blackBorder.visible
      opacity: blackBorder.opacity
      anchors.fill: blackBorder
      cached: false
      fast: false
      horizontalOffset: 0
      verticalOffset: 0
      radius: 3.0 * screenScale
      samples: 32
      spread: 0.5 * screenScale
      color: colors.deckCover.shadow
      transparentBorder: true
      source: blackBorder
  }

  // COVER ART
  Rectangle {
      id: cover_small
      anchors.top: top_line.bottom
      anchors.left: parent.left
      anchors.topMargin: 1 * screenScale
      anchors.leftMargin: 2 * screenScale
      width: prefs.displayAlbumCover ? largeHeaderHeight - 4 : 0
      height: width

      // if no cover can be found: blue / grey background (set in parent). Otherwise transparent
      opacity: (headerPropertyCover.value == "") ? 1.0 : 0.0
      //visible: headerState == "large" && (opacity == 1.0)
      color: coverBgEmptyColors[deck_Id]
      Behavior on opacity { NumberAnimation { duration: speed } }
      Behavior on width { NumberAnimation { duration: speed } }
      Behavior on height { NumberAnimation { duration: speed } }

      Rectangle {
          id: circleEmptyCover
          height: 18 * screenScale
          width: height
          radius: height * 0.5
          anchors.centerIn: parent
          visible:!isLoaded && prefs.displayAlbumCover
          color: circleEmptyColors[deck_Id]
      }

      Rectangle {
          id: dotEmptyCover
          height: 2 * screenScale
          width: height
          anchors.centerIn: parent
          visible: !isLoaded && prefs.displayAlbumCover
          color: colors.deckCover.empty.dot
      }

      Image {
          id: coverImage
          source: "image://covers/" + ((isLoaded) ? headerPropertyCover.value : "" )
          anchors.fill: parent
          sourceSize.width: width
          sourceSize.height: height
          visible: isLoaded
          opacity: (headerPropertyCover.value == "") ? 0.3 : 1.0
          fillMode: Image.PreserveAspectCrop
          Behavior on height { NumberAnimation { duration: speed } }
      }
  }

  // WHITE BORDER
  Rectangle {
      id: cover_innerBorder
      color: "transparent"
      border.width: 1 * screenScale
      border.color: colors.deckCover.borders.inner
      height: cover_small.height
      width: height
      anchors.top: cover_small.top
      anchors.left: cover_small.left
  }


  //--------------------------------------------------------------------------------------------------------------------
  //  Loop Size
  //--------------------------------------------------------------------------------------------------------------------
  function updateLoopSize() {
    if (  headerState == "large" && isLoaded && (hasTrackStyleHeader(deckType) || (deckType == DeckType.Remix )) && !directThru.value ) {
      loop_size.opacity = 1.0;
      loop_size.opacity = showStepSequencer ? 0.0 : 1.0;
      stem_text.opacity = 0.6
    } else {
      loop_size.opacity = 0.0;
      stem_text.opacity = 0.0;
    }
  }

  //--------------------------------------------------------------------------------------------------------------------
  //  Key & Lock indicator
  //--------------------------------------------------------------------------------------------------------------------
  function colorForKey(keyIndex) {
      if (keyIndex === null || keyIndex === undefined) {
          return textColors[deck_Id]; // Color por defecto si no hay clave válida
      }
      return colors.musicalKeyColors[keyIndex];
  }

  //--------------------------------------------------------------------------------------------------------------------
  //  WARNING MESSAGES
  //--------------------------------------------------------------------------------------------------------------------

  Rectangle {
      id: warning_box
      anchors.bottom: parent.bottom
      anchors.topMargin: 20 * screenScale
      anchors.right: deck_letter_large.left
      anchors.left: cover_small.right
      anchors.leftMargin: 5 * screenScale
      height: parent.height -1 * screenScale
      color: colors.deckWarning.background
      visible: deckHeaderWarningActive.value

      Behavior on anchors.leftMargin { NumberAnimation { duration: speed } }
      Behavior on anchors.topMargin { NumberAnimation { duration: speed } }

      // TOP WARNING TEXT
      Text {
          id: top_warning_text
          color: isError ? colors.deckWarning.text.error : colors.deckWarning.text.warning.normal
          
          font.pixelSize: fonts.largeFontSize * screenScale
          font.family: prefs.fontDeckHeaderString

          text: deckHeaderWarningShortMessage.value
          anchors.top: parent.top
          anchors.left: parent.left
          anchors.topMargin: -1 * screenScale
          Behavior on anchors.leftMargin { NumberAnimation { duration: speed } }
          Behavior on anchors.topMargin { NumberAnimation { duration: speed } }
      }

      // BOTTOM WARNING TEXT
      Text {
          id: bottom_warning_text
          color: isError ? colors.deckWarning.text.error : colors.deckWarning.text.warning.dimmed
          elide: Text.ElideRight

          font.pixelSize: fonts.middleFontSize * screenScale
          font.family: prefs.fontDeckHeaderString

          text: deckHeaderWarningMessage.value
          anchors.top: parent.top
          anchors.left: parent.left
          anchors.topMargin: 18 * screenScale
          Behavior on anchors.leftMargin { NumberAnimation { duration: speed } }
          Behavior on anchors.topMargin { NumberAnimation { duration: speed } }
      }
  }

  Timer {
      id: warningTimer
      interval: 1200
      repeat: true
      running: deckHeaderWarningActive.value
      onTriggered: {
          if (warning_box.opacity == 1) {
              warning_box.opacity = 0;
          } else {
              warning_box.opacity = 1;
          }
      }
  }



  //--------------------------------------------------------------------------------------------------------------------
  //  STATES FOR THE DIFFERENT HEADER SIZES
  //--------------------------------------------------------------------------------------------------------------------

  state: headerState

  states: [
    State {
      name: "small";
      PropertyChanges { target: deck_header;            height: smallHeaderHeight }

      PropertyChanges { target: top_left_text;          anchors.leftMargin: 5 * screenScale }
      PropertyChanges { target: top_warning_text;       font.pixelSize: fonts.middleFontSize * screenScale; anchors.topMargin: -1 * screenScale }

      PropertyChanges { target: bottom_warning_text;    opacity: 0; }

      PropertyChanges { target: middle_center_text;     opacity: 0; }
      //PropertyChanges { target: middle_left_text;       opacity: 0; }
      PropertyChanges { target: middle_right_text;      opacity: 0; }

      PropertyChanges { target: extra_middle_left_text; opacity: 0; }
      PropertyChanges { target: bottom_center;          opacity: 0; }

      PropertyChanges { target: deck_header_footer;     opacity: 0; }

      PropertyChanges { target: beat_indicators;        opacity: 0; }
      PropertyChanges { target: key_lock;               opacity: 0; }
      PropertyChanges { target: key_lock_overlay;       opacity: 0; }
      PropertyChanges { target: key_text;               opacity: 0; }
      PropertyChanges { target: bottom_right;           opacity: 0; }
      PropertyChanges { target: middle_center_text;     opacity: 0; }
    },
    State {
      name: "large"; //when: temporaryMouseArea.released
      PropertyChanges { target: deck_header;            height: largeHeaderHeight }

      PropertyChanges { target: top_left_text;          anchors.leftMargin: (deckType.description === "Live Input" || directThru.value) ? -1 * screenScale : 5 * screenScale}
      PropertyChanges { target: top_warning_text;       font.pixelSize: fonts.largeFontSize * screenScale; anchors.topMargin: -2 * screenScale }

      PropertyChanges { target: middle_center_text;     opacity: 0; }
      PropertyChanges { target: middle_left_text;       opacity: 1; anchors.leftMargin: (deckType.description === "Live Input" || directThru.value) ? -1 * screenScale : 5 * screenScale}
      PropertyChanges { target: middle_right_text;      opacity: 1; }

      PropertyChanges { target: extra_middle_left_text; opacity: 1; }
      PropertyChanges { target: bottom_center;          opacity: 1; }

      PropertyChanges { target: deck_header_footer;     opacity: 1; }

      PropertyChanges { target: beat_indicators;        opacity: 1; }
      PropertyChanges { target: key_lock;               opacity: 1; }
      PropertyChanges { target: key_lock_overlay;       opacity: 1; }
      PropertyChanges { target: key_text;               opacity: 1; }
      PropertyChanges { target: bottom_right;           opacity: 1; }
      PropertyChanges { target: middle_center_text;     opacity: 1; }
    }
  ]
}
