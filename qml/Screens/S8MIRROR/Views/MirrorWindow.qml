import CSI 1.0
import QtQuick
import QtQuick.Window 2.15
import Qt5Compat.GraphicalEffects
import Traktor.Gui 1.0 as Traktor

import '../Templates/Deck' as Deck
import '../Templates/Browser' as Browser
import '../Templates/MySettings' as MySettings

import './Overlays/' as Overlays
import './Overlays/FullscreenOverlays/' as FullscreenOverlays
import './Overlays/CenterOverlays/' as CenterOverlays
import './Overlays/SideOverlays/' as SideOverlays

import './Widgets' as Widgets
import './Panels' as Panels

// Plugins
import './Plugins' as Plugins

import '../../Defines' as Defines

Window {
    id: mirrorWindow

    required property bool isLeftScreen
    required property bool mirrorInverted

    required property string settingsPath
    required property string propertiesPath

    required property int focusDeckId

    required property string screenState
    required property var overlayState

    required property var colors
    required property var deckView

    property bool topControlsEnableVisible: true
    required property var topControls
    property bool bottomControlsEnableVisible: true
    required property var bottomControls

    required property var buttonArea1
    required property var buttonArea2
    required property var softTakeoverKnobs
    required property var softTakeoverFaders
    required property var overlayManager

    required property var browserView
    required property var screenView

    required property var upperDeckState
    onUpperDeckStateChanged: {
        enableButtonArea2()
        hideBrowserView()
    }
    required property var lowerDeckState
    onLowerDeckStateChanged: {
        enableButtonArea2()
        hideBrowserView()
    }

    // Añadir propiedad de escala
    property real screenScale: prefs.screenScale

    // Hacer que el fondo de la ventana sea negro
    color: colors.colorBlack

    // Actualizar dimensiones
    width:  480 * screenScale
    height: 272 * screenScale

    title: "Dj Mirror - " + (isLeftScreen ? "Left" : "Right")

    property bool showWindowDecorations: true
    
    // Usar flags para controlar decoraciones de ventana
    flags: showWindowDecorations ? Qt.Window : (Qt.Window | Qt.FramelessWindowHint)

    visible: true

    // Añadir propiedad para mantener el foco independiente
    property int mirrorFocusDeckId: {
        if (mirrorInverted) {
            // Modo invertido: mostrar deck opuesto
            if (isLeftScreen) {
                return focusDeckId === 0 ? 2 : 0  // A->C, C->A
            } else {
                return focusDeckId === 1 ? 3 : 1  // B->D, D->B
            }
        } else {
            // Modo normal: mostrar mismo deck
            if (isLeftScreen) {
                return focusDeckId === 0 ? 0 : 2  // A->A, C->C
            } else {
                return focusDeckId === 1 ? 1 : 3  // B->B, D->D
            }
        }
    }

    // Añadir propiedad para calcular la altura del deckView
    property int mirrorDeckViewHeight: {
        if (mirrorBottomControls.sizeState === "hide" && mirrorTopControls.showHideState === "hide") {
            return mirrorWindow.height - (8 * screenScale) // Altura completa si no hay controles
        } else if (mirrorBottomControls.sizeState === "small") {
            return mirrorWindow.height - (27 * screenScale) - (8 * screenScale)
        } else if (mirrorBottomControls.sizeState === "large") {
            return mirrorWindow.height - (27 * screenScale) - (8 * screenScale)
        } else {
            return mirrorWindow.height - (8 * screenScale) // Por defecto, altura completa
        }
    }

    // Estados para la ventana: normal, maximizado, anclado
    property string windowState: "normal" // "normal", "maximized" o "anchored"
    
    // Almacenar dimensiones originales para restaurar
    property real originalX: x
    property real originalY: y
    property real originalWidth: width
    property real originalHeight: height

    // Contenido espejo con márgenes
    Item {
        id: mirrorContent

        anchors.fill: parent
        visible: currentState !== "SettingsView"

        // Añadir márgenes de 4px * escala en todos los lados
        //anchors.leftMargin: (isLeftScreen ? (4 * screenScale) : (16 * screenScale))
        //anchors.rightMargin: (isLeftScreen ? (16 * screenScale) : (4 * screenScale))

        anchors.leftMargin: 4 * screenScale
        anchors.rightMargin: 4 * screenScale
        anchors.topMargin: 4 * screenScale
        anchors.bottomMargin: 4 * screenScale

        // Fondo negro para el contenido
        Rectangle {
            id: mirrorRoot
            anchors.fill: parent
            color: colors.colorBlack
            clip: false // true
           
            // Vista del deck espejo
            Deck.DeckView {
                id: mirrorDeckView
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.right: parent.right
                // Ajustar altura según el estado de los controles
                height: mirrorWindow.mirrorDeckViewHeight
      
                settingsPath: mirrorWindow.settingsPath
                propertiesPath: mirrorWindow.propertiesPath

                // Invertir los deckIds según el modo
                deckIds: {
                    if (mirrorInverted) {
                        // Modo invertido
                        return isLeftScreen ? [2,0] : [3,1]
                    } else {
                        // Modo normal
                        return isLeftScreen ? [0,2] : [1,3]
                    }
                }
                focusDeckId: mirrorWindow.mirrorFocusDeckId
                
                // Invertir estados según el modo
                upperDeckState: mirrorInverted ? deckView.lowerDeckState : deckView.upperDeckState
                lowerDeckState: mirrorInverted ? deckView.upperDeckState : deckView.lowerDeckState
                isUpperDeck: mirrorInverted ? !deckView.isUpperDeck : deckView.isUpperDeck

                remixUpperDeckRowShift: deckView.remixUpperDeckRowShift
                remixLowerDeckRowShift: deckView.remixLowerDeckRowShift

                clip: false // true

                // Añadir Behavior para suavizar los cambios de altura
                Behavior on height {
                    NumberAnimation { 
                        duration: 100
                        easing.type: Easing.OutCubic
                    }
                }
            }
        }


        //--------------------------------------------------------------------------------------------------------------------
        //  OPTIONAL OVERLAYS
        //--------------------------------------------------------------------------------------------------------------------

        // Replicar los overlays
        Overlays.TopControls {
            id: mirrorTopControls

            anchors.left:   parent.left
            anchors.right:  parent.right

            deckId: topControls.deckId
            fxUnit: topControls.fxUnit

            showHideState: topControls.showHideState
            sizeState: topControls.sizeState

            visible: topControlsEnableVisible
        }

        // Timer para ocultar los botones
        Timer {
            id: hideTouchPanelButtonAreaTimer
            interval: 1800
            repeat: false
            onTriggered: {
                hideButtonArea2();
            }
        }

        // Añadir área sensible en el centro derecha para ocultar el panel tactil derecho ButtonArea
        Item {
            id: touchPanelButtonArea2External
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: parent.right
            width: mirrorButtonArea2.width + (10 * screenScale)
            height: mirrorButtonArea2.height + (10 * screenScale)
            z: 97
            enabled: mirrorBrowserView.viewState !== "BrowserView" && mirrorButtonArea2.showHideState === "show"
            //color: "red"

            MouseArea {
                anchors.fill: parent
                enabled: parent.enabled
                onPressed: {
                    hideButtonArea2();
                }
            }
        }

        // Añadir área sensible en el centro derecha para mostrar el panel tactil derecho ButtonArea
        Item {
            id: touchPanelButtonArea2
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: parent.right
            width: mirrorButtonArea2.width
            height: mirrorButtonArea2.height - (30 * screenScale)
            z: 98
            enabled: mirrorBrowserView.viewState !== "BrowserView" && mirrorButtonArea2.showHideState === "hide"
            //color: "blue"

            MouseArea {
                anchors.fill: parent
                enabled: parent.enabled
                onPressed: {
                    showButtonArea2();
                }
            }
        }

        AppProperty { 
            id: sequencerOn; 
            path: "app.traktor.decks." + (focusDeckId + 1) + ".remix.sequencer.on"; 
            onValueChanged: {
                if (sequencerOn.value) {
                    disableButtonArea2();
                    hideButtonArea2();
                } else {
                    enableButtonArea2();
                }
            } 
        }

        // right overlay
        SideOverlays.ButtonArea {
            id: mirrorButtonArea2
            state: "hide"
            showHideState: buttonArea2.showHideState
            topButtonText: buttonArea2.topButtonText
            bottomButtonText: buttonArea2.bottomButtonText
            textAngle: 90
            anchors.right: parent.right
            anchors.rightMargin: -6  // Oculta el brillo y borde derecho
            contentState: buttonArea2.contentState
            scrollPosition: buttonArea2.scrollPosition
            z: 99

            // Propiedades básicas
            deckId: overlayManager.deckId
            settingsPath: mirrorWindow.settingsPath
            propertiesPath: mirrorWindow.propertiesPath

            onZoomInRequested: {
                hideTouchPanelButtonAreaTimer.restart()
            }

            onZoomOutRequested: {
                hideTouchPanelButtonAreaTimer.restart()
            }
            
            property int maxPosition: 7  // 8 posiciones (0-7) > 8*2
            property int currentPosition: 0  // 8 posiciones (0-7) > 8*2

            onScrollUp: {
                if (mirrorDeckView.focusDeckState === "Remix Deck" && !sequencerOn.value) {
                    var newShift = 1 + (newPosition * 2)
                    
                    if (mirrorDeckView.isUpperDeck) {
                        mirrorDeckView.remixUpperDeckRowShift = newShift
                    } else {
                        mirrorDeckView.remixLowerDeckRowShift = newShift
                    }
                }
                hideTouchPanelButtonAreaTimer.restart()
            }

            onScrollDown: {
                if (mirrorDeckView.focusDeckState === "Remix Deck" && !sequencerOn.value) {
                    var newShift = 1 + (newPosition * 2)
                    
                    if (mirrorDeckView.isUpperDeck) {
                        mirrorDeckView.remixUpperDeckRowShift = newShift
                    } else {
                        mirrorDeckView.remixLowerDeckRowShift = newShift
                    }
                }
                hideTouchPanelButtonAreaTimer.restart()
            }
        }

        // Configuración del OverlayManager
        Overlays.OverlayManager {
            id: mirrorOverlayManager
            
            // Propiedades básicas
            deckId: overlayManager.deckId
            remixDeckId: overlayManager.remixDeckId
            // Usar una ruta de propiedades que funcione para el mirror
            propertiesPath: "app.traktor.decks." + (mirrorFocusDeckId + 1)
            mirrorFocusDeckId: mirrorWindow.mirrorFocusDeckId
            screenScale: mirrorWindow.screenScale
            isLeftScreen: mirrorWindow.isLeftScreen
            
            // Asegurar que no haya overlays visibles al inicio
            tempoAdjustVisible: false
            keyLockVisible: false
            quantizeSizeAdjustVisible: false
            swingAdjustVisible: false
            fxSelectVisible: false
            
            z: 100
        }

        Overlays.BottomControls {
            id: mirrorBottomControls
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom

            deckId: bottomControls.deckId
            focusDeckId: bottomControls.focusDeckId

            contentState: bottomControls.contentState
            sizeState: bottomControls.sizeState

            propertiesPath: bottomControls.propertiesPath
            
            midiId: bottomControls.midiId

            fxUnit: bottomControls.fxUnit
            isInEditMode: bottomControls.isInEditMode
            isRemixDeck: bottomControls.isRemixDeck
            isStemDeck: bottomControls.isStemDeck
            visible: bottomControlsEnableVisible
        }

        // Añadir el browserView
        Browser.BrowserView {
            id: mirrorBrowserView
            anchors.fill: parent

            propertiesPath: mirrorWindow.propertiesPath
            
            enabled: browserView.visible
            isActive: browserView.isActive
            viewState: browserView.viewState
            visible: browserView.visible

            focusDeckId: mirrorWindow.mirrorFocusDeckId
            
            // Sincronizar la propiedad sortingKnobValue con la ventana principal
            sortingKnobValue: browserView.sortingKnobValue
            
            // Conectar la señal trackLoaded del BrowserView
            onTrackLoaded: {
                enableButtonArea2();
                showDeckView();
            }
        }

        // Añadir área sensible en el centro superior para ocultar el panel de control táctil
        Item {
            id: touchPanelButtonExternal
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            anchors.right: parent.right
            anchors.left: parent.left
            anchors.leftMargin: (40 * screenScale)
            anchors.rightMargin: (40 * screenScale)
            height: touchControlPanel.height + (6 * screenScale)
            z: 97
            enabled: mirrorBrowserView.viewState !== "BrowserView"

            MouseArea {
                anchors.fill: parent
                
                // Al presionar, mostramos el panel
                onPressed: {
                    if (mirrorBrowserView.viewState !== "BrowserView") {
                        touchPanelButton.isPanelVisible = false
                    }
                }
            }
        }

        // Añadir área sensible en el centro superior para mostrar el panel de control táctil
        Item {
            id: touchPanelButton
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            width: touchControlPanel.width
            height: touchControlPanel.height + (4 * screenScale)
            z: 98
            enabled: mirrorBrowserView.viewState !== "BrowserView"
            
            // Variable para controlar si el panel está visible
            property bool isPanelVisible: false
            
            MouseArea {
                anchors.fill: parent
                
                // Al presionar, mostramos el panel
                onPressed: {
                    if (mirrorBrowserView.viewState !== "BrowserView") {
                        touchPanelButton.isPanelVisible = true
                    }
                }
            }
        }

        Panels.TouchControlPanelRound {
            id: touchControlPanel

            // Elevar el Z para que esté por encima de otros elementos
            z: 99

            // Posicionamiento y tamaño
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            anchors.topMargin: 4 * screenScale
            width: 340 * screenScale
            height: 60 * screenScale

            // Estilo
            color: colors.colorBlack
            opacity: touchPanelButton.isPanelVisible ? 0.85 : 0
            visible: opacity > 0
            radius: 10 * screenScale
            
            // Sincronizar el estado de la ventana
            windowState: mirrorWindow.windowState

            // Animación para aparecer/desaparecer suavemente
            Behavior on opacity {
                NumberAnimation { 
                    duration: 200
                    easing.type: Easing.OutQuad
                }
            }
            
            // Conexiones para las señales
            onViewSelected: {
                touchPanelButton.isPanelVisible = false
                // Cambiar entre vista completa y mini
                toggleView()
            }
            
            onDeckSelected: {
                touchPanelButton.isPanelVisible = false
                // Cambiar entre decks
                toggleDeck()
            }
            
            onLoadSelected: {
                // Mostrar el navegador para cargar una pista
                touchPanelButton.isPanelVisible = false
                showBrowserView()
            }
            
            onSettingsSelected: {
                // Mostrar la vista de configuración
                touchPanelButton.isPanelVisible = false
                showSettingsView()
            }
            
            onWindowMaximizeSelected: {
                // Alternar entre estados de ventana
                touchPanelButton.isPanelVisible = false
                toggleWindowState()
            }

            onFxSelected: {
                // Mostrar/ocultar el selector de efectos
                touchPanelButton.isPanelVisible = false
                // Forzar la visibilidad a true para mostrar el panel
                mirrorOverlayManager.toggleFxSelect(true);
            }

            onPlaySelected: {
                // Ocultar el panel táctil
                touchPanelButton.isPanelVisible = false
                // Alternar la reproducción
                play.value = !play.value
            }
        }

        // Añadir propiedad para controlar la reproducción
        AppProperty { 
            id: play
            path: "app.traktor.decks." + (mirrorFocusDeckId + 1) + ".play"
        }
    }


    //--------------------------------------------------------------------------------------------------------------------
    //  SHORTCUTS
    //--------------------------------------------------------------------------------------------------------------------

    // Manejar tecla C para esta ventana también (C > Config)
    Shortcut {
        sequence: "C"
        onActivated: {
            // Mostrar la vista de configuración
            touchPanelButton.isPanelVisible = false
            showSettingsView()
        }
    }

    // Manejar tecla M para esta ventana también (A > Anclado)
    Shortcut {
        sequence: "A"
        onActivated: {
            mirrorWindow.showWindowDecorations = !mirrorWindow.showWindowDecorations
        }
    }

    // Atajo de teclado para cambiar entre vista completa y mini (V > View)
    Shortcut {
        sequence: "V"
        onActivated: {
            touchPanelButton.isPanelVisible = false
            toggleView()
        }
    }

    // Atajo de teclado para cambiar entre decks (D > Deck)
    Shortcut {
        sequence: "D"
        onActivated: {
            touchPanelButton.isPanelVisible = false
            // Cambiar entre decks
            toggleDeck()
        }
    }

    // Añadir el Shortcut para el browser (L > Load)
    Shortcut {
        sequence: "L"  // Browser toggle
        onActivated: {
            // Mostrar el navegador para cargar una pista
            touchPanelButton.isPanelVisible = false
            showBrowserView()
        }
    }

    // Añadir nuevo Shortcut para mostrar/ocultar la lista de efectos (F)
    Shortcut {
        sequence: "F"
        onActivated: {
            mirrorOverlayManager.toggleFxSelect(true);
        }
    }

    // Añadir nuevo Shortcut para mostrar/ocultar el sequencer
    Shortcut {
        sequence: "S"
        onActivated: {
            touchPanelButton.isPanelVisible = false
            sequencerOn.value = !sequencerOn.value;
        }
    }


    //--------------------------------------------------------------------------------------------------------------------
    //  FUNCTIONS
    //--------------------------------------------------------------------------------------------------------------------

    // Función para deshabilidar ButtonArea2
    function enableButtonArea2() {
        touchPanelButtonArea2.enabled = true
    }

    // Función para deshabilidar ButtonArea2
    function disableButtonArea2() {
        touchPanelButtonArea2.enabled = false
    }

    // Función para ocultar ButtonArea2
    function hideButtonArea2() {
        mirrorButtonArea2.contentState = buttonArea2.contentState
        mirrorButtonArea2.showHideState = "hide"
        mirrorButtonArea2.enabled = false
    }

    // Función para mostrar ButtonArea2
    function showButtonArea2() {
        mirrorButtonArea2.contentState = buttonArea2.contentState
        mirrorButtonArea2.showHideState = "show"
        mirrorButtonArea2.enabled = true
    }

    // Función para cambiar entre vistas
    function toggleView() {
        // Cambiar entre vista completa y mini
        deckSingleControl.value = !deckSingleControl.value;
    }

    // Función para cambiar entre decks
    function toggleDeck() {
        // Asegurar vista dividida primero
        if (deckSingleControl.value) {
            deckSingleControl.value = false;
        }
        // Luego cambiar el foco entre decks
        deckFocusControl.value = !deckFocusControl.value;

        // Cambiar entre vista completa y mini
        deckSingleControl.value = !deckSingleControl.value;
        
        // Actualizar el deck ID en los overlays
        mirrorOverlayManager.updateDeckId(mirrorFocusDeckId)
    }

    // Función para mostrar los overlays
    function showOverlays() {
        // Mostrar todos los overlays
        mirrorTopControls.showHideState = "show"
        mirrorBottomControls.sizeState = "small"
        bottomControls.sizeState = "small"  // Sincronizar con ventana principal
    }

    // Función para ocultar los overlays
    function hideOverlays() {
        // Ocultar todos los overlays
        mirrorTopControls.showHideState = "hide"
        mirrorBottomControls.sizeState = "hide"
        bottomControls.sizeState = "hide"  // Sincronizar con ventana principal
        
        // Ocultar también los overlays centrales
        mirrorOverlayManager.hideAllOverlays()
    }

    function toggleFxView() {
        // Mostrar/ocultar el selector de efectos
        touchPanelButton.isPanelVisible = false
        // Forzar la visibilidad a true para mostrar el panel
        mirrorOverlayManager.toggleFxSelect(true);
    }
    
    // Función que puede ser llamada desde BrowserView para cerrar el navegador
    function showDeckView() {
        // Desactivar Browser
        mirrorBrowserView.isActive = false
        mirrorBrowserView.viewState = "DeckView"
        mirrorBrowserView.visible = false
        mirrorBrowserView.enabled = false

        enableButtonArea2();

        mirrorDeckView.visible = true

        screenState = "DeckView";
        screenView.value = ScreenView.deck;
    }

    // Función que puede ser llamada desde BrowserView para mostrar el navegador
    function showBrowserView() {
        mirrorBrowserView.isActive = true
        mirrorBrowserView.viewState = "BrowserView"
        mirrorBrowserView.visible = true
        mirrorBrowserView.enabled = true
        
        disableButtonArea2();
        hideButtonArea2();
     
        mirrorDeckView.visible = false

        screenState = "BrowserView";
        screenView.value = ScreenView.browser;
    }

    // Función que puede ser llamada desde BrowserView para ocultar el navegador
    function hideBrowserView() {
        mirrorBrowserView.isActive = false
        //mirrorBrowserView.viewState = "DeckView"
        mirrorBrowserView.visible = false
        mirrorBrowserView.enabled = false

        //screenState = "DeckView";
        //screenView.value = ScreenView.deck;
    }

    // Función para mostrar la vista de configuración
    function showSettingsView() {
        // Verificar si ya hay otra pantalla mostrando los ajustes
        if (!settingsViewer.isAnyScreenShowingSettings) {          
            // Activar los ajustes en esta ventana
            mirrorWindow.showSettings = true
            mirrorWindow.isSettingsActive = true
            settingsViewer.isAnyScreenShowingSettings = true
            
            // Asegurar que el panel de control táctil esté oculto
            touchPanelButton.isPanelVisible = false
            
            return true
        } else {
            return false
        }
    }
      
    // Función para cerrar la vista de configuración y mostrar el deck
    function closeSettingsView() {
        // Cerrar los ajustes
        mirrorWindow.showSettings = false
        mirrorWindow.isSettingsActive = false
        settingsViewer.isAnyScreenShowingSettings = false
        
        // Si estábamos en el navegador, volver a la vista de deck
        if (screenState === "BrowserView") {
            showDeckView()
        }
        
        return true
    }

    // Función para alternar entre estados de la ventana
    function toggleWindowState() {
        // Alternar solo entre normal y maximizado
        if (windowState === "normal") {
            // Guardar dimensiones originales
            originalX = x
            originalY = y
            originalWidth = width
            originalHeight = height
            
            // Maximizar la ventana
            flags = Qt.Window | Qt.FramelessWindowHint // Quitar el marco
            showMaximized()
            windowState = "maximized"
        } 
        else {
            // Restaurar a estado normal con marco
            showNormal()
            flags = Qt.Window // Restaurar marco normal
            x = originalX
            y = originalY
            width = originalWidth
            height = originalHeight
            windowState = "normal"
        }
    }


    //--------------------------------------------------------------------------------------------------------------------
    //  OPTIONAL SETTINGS VIEW
    //--------------------------------------------------------------------------------------------------------------------

    // Estado actual de la pantalla
    property string currentState: showSettings ? "SettingsView" : screenState

    // Propiedades para Settings
    property bool showSettings: false
    property bool isSettingsActive: false  // Nueva propiedad para controlar qué pantalla tiene los ajustes activos

    // Settings viewer
    MySettings.MySettingsView {
        id: settingsViewer
        anchors.fill: parent

        opacity: visible ? 1 : 0
        Behavior on opacity { NumberAnimation { duration: 100 } }

        z: visible ? 10 : 0

        // Propiedad estática para controlar que solo una pantalla muestre los ajustes
        property bool isAnyScreenShowingSettings: false

        isEditing: mirrorWindow.showSettings
        visible: mirrorWindow.showSettings

        settingsPath: mirrorWindow.settingsPath
        propertiesPath: mirrorWindow.propertiesPath
        
        // Conectar la señal de salida de ajustes
        onExitSettings: {
            // Llamar directamente a closeSettingsView para evitar ambigüedades
            closeSettingsView()
        }
    }

    // Shortcut para Configuración
    Shortcut {
        sequence: "C"
        onActivated: {
            toggleSettingsView()
        }
    }

    // Función para alternar la vista de configuración
    function toggleSettingsView() {
        if (mirrorWindow.isSettingsActive) {
            return closeSettingsView()
        } else {
            // Refrescar preferencias
            settingsViewer.refreshPreferences()
            
            return showSettingsView()
        }
    }

    //--------------------------------------------------------------------------------------------------------------------
    //  DEBUG VIEWER
    //--------------------------------------------------------------------------------------------------------------------
    
    // Añadir el componente DebugViewer para mostrar los logs
    Widgets.DebugViewer {
        id: debugViewer
        z: 100 // Asegurar que aparezca por encima de otros elementos
        
        screenScale: mirrorWindow.screenScale
        
        // Configuración personalizada
        maxHeight: 300 * screenScale
        minHeight: 40 * screenScale
        autoHide: true
        autoHideDelay: 10000
        pinned: false
        showMinimized: false // No mostrar ni siquiera la barra minimizada por defecto
        
        // Establecer colores consistentes con el resto de la UI
        backgroundColor: "#001933" // Azul oscuro para mejor contraste
        borderColor: "#0088CC" // Borde azul más brillante
        textColor: "#FFFFFF" // Texto blanco para máxima legibilidad
        headerColor: "#004477" // Azul medio para el encabezado
        
        // Iniciar completamente oculto
        expanded: false
    }

    // Acceso directo para mostrar/ocultar logs (D)
    Shortcut {
        sequence: "Shift+D"
        onActivated: {          
            // Usar la nueva función para controlar la visibilidad completa
            debugViewer.toggleVisibility();
        }
    }
    
    // Acceso directo para mostrar/ocultar logs completamente (K)
    Shortcut {
        sequence: "Shift+K"
        onActivated: {
            if (debugViewer.visible) {
                debugViewer.hide();
            } else {
                debugViewer.show();
            }
        }
    }

    //--------------------------------------------------------------------------------------------------------------------

    // Añadir función para inicializar el estado al cargar
    Component.onCompleted: {
        // Establecer el estado inicial de la pantalla
        screenState = "DeckView";

        // Ocultar todos los overlays al iniciar
        mirrorOverlayManager.hideAllOverlays();
    }
} 
