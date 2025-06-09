import CSI 1.0
import QtQuick
import Qt5Compat.GraphicalEffects

import './CenterOverlays/' as CenterOverlays
import './FullscreenOverlays/' as FullscreenOverlays
import '../../../../Defines'

/**
 * @brief Gestor de ventanas superpuestas (overlays) para la interfaz
 * 
 * Este componente maneja la visualización de diferentes ventanas modales
 * y overlays en la interfaz, controlando su visibilidad según el estado actual.
 * 
 * @property {int} deckId - ID del deck actual
 * @property {int} remixDeckId - ID del remix deck
 * @property {string} propertiesPath - Ruta base para las propiedades de mapping
 * @property {string} overlayState - Estado actual del overlay (desde Overlay.states)
 * @property {int} bottomControlHeight - Altura de los controles inferiores
 * @property {int} marginHeadline - Margen superior para títulos (21px)
 * @property {real} screenScale - Escala de la pantalla para adaptación
 * 
 * Overlays Centrales:
 * - TempoAdjust: Ajuste de BPM
 * - Keylock: Control de tonalidad
 * - QuantizeSizeAdjust: Ajuste de cuantización
 * - SwingAdjust: Control de swing
 * - SliceSize: Tamaño de slice
 * - BrowserSorting: Ordenación del navegador
 * - RemixCaptureSource: Fuente de captura para remix
 * - BrowserWarnings: Advertencias del navegador
 * 
 * Overlays a Pantalla Completa:
 * - FXSelect: Selección de efectos
 * 
 * Estados:
 * - none: Sin overlay visible
 * - bpm: Ajuste de tempo
 * - key: Control de tonalidad
 * - fx: Selección de efectos
 * - quantize: Ajuste de cuantización
 * - swing: Control de swing
 * - slice: Tamaño de slice
 * - sorting: Ordenación del navegador
 * - capture: Captura para remix
 * - browserWarnings: Advertencias
 * 
 * Ejemplo de uso:
 * ```qml
 * OverlayManager {
 *     deckId: 1
 *     propertiesPath: "app.traktor.decks.1"
 *     overlayState: Overlay.states[buttonStateProp.value]
 * }
 * ```
 */

Item {
  id: overlay
  
  property int    deckId:          0 
  property int    remixDeckId:     0
  property string propertiesPath:  ""
  property alias  navMenuValue:    fxSelect.navMenuValue
  property alias  navMenuSelected: fxSelect.navMenuSelected

  property int bottomControlHeight: 0
  property int marginHeadline: 21

  property string overlayState: Overlay.states[buttonStateProp.value]
  
  // Nuevas propiedades para compatibilidad con MirrorWindow
  property real screenScale: 1.0
  property int mirrorFocusDeckId: deckId
  property bool isLeftScreen: false
  
  // Propiedades de estado de visibilidad para cada overlay
  property bool tempoAdjustVisible: false
  property bool keyLockVisible: false
  property bool quantizeSizeAdjustVisible: false
  property bool swingAdjustVisible: false
  property bool fxSelectVisible: false
  
  // Señales para notificar cambios
  signal tempoAdjustVisibilityChanged(bool visible)
  signal keylockVisibilityChanged(bool visible)
  signal quantizeVisibilityChanged(bool visible)
  signal swingVisibilityChanged(bool visible)
  signal fxSelectVisibilityChanged(bool visible)
  
  // Inicialización
  Component.onCompleted: {
    // Ocultar todos los overlays explícitamente al iniciar
    tempo.visible = false
    keylock.visible = false
    quantize.visible = false
    swing.visible = false
    fxSelect.visible = false
    sliceSize.visible = false
    browserSorting.visible = false
    captureSource.visible = false
    browserWarnings.visible = false
  }

  anchors.fill: parent
 
  MappingProperty { id: buttonStateProp;  path: propertiesPath + ".overlay"     }
  MappingProperty { id: screenView;       path: propertiesPath + ".screen_view" }

  
  //------------------------------------------------------------------------------------------------------------------
  //  OVERLAY CONTENT
  //------------------------------------------------------------------------------------------------------------------
  
  // centered overlay windows
  CenterOverlays.TempoAdjust {
    id: tempo
    deckId: overlay.mirrorFocusDeckId
    visible: tempoAdjustVisible
    
    anchors.centerIn: parent
    
    onVisibleChanged: {
      tempoAdjustVisible = visible
      tempoAdjustVisibilityChanged(visible)
    }
  }

  CenterOverlays.Keylock {
    id: keylock
    deckId: overlay.mirrorFocusDeckId
    visible: keyLockVisible
    
    anchors.centerIn: parent
    
    onVisibleChanged: {
      keyLockVisible = visible
      keylockVisibilityChanged(visible)
    }
  }

  CenterOverlays.QuantizeSizeAdjust {
    id: quantize
    deckId: overlay.mirrorFocusDeckId
    visible: quantizeSizeAdjustVisible
    
    anchors.centerIn: parent
    
    onVisibleChanged: {
      quantizeSizeAdjustVisible = visible
      quantizeVisibilityChanged(visible)
    }
  }

  CenterOverlays.SwingAdjust {
    id: swing
    deckId: overlay.mirrorFocusDeckId
    visible: swingAdjustVisible
    
    anchors.centerIn: parent
    
    onVisibleChanged: {
      swingAdjustVisible = visible
      swingVisibilityChanged(visible)
    }
  }

  CenterOverlays.SliceSize {
    id: sliceSize
    deckId: overlay.deckId
  }

  CenterOverlays.BrowserSorting {
    id: browserSorting
    deckId: overlay.deckId
  }

  CenterOverlays.RemixCaptureSource {
    id: captureSource
    deckId: overlay.remixDeckId  
  }

  CenterOverlays.BrowserWarnings {
    id: browserWarnings
    deckId: overlay.deckId
  }
  
  // fullscreen overlays
  FullscreenOverlays.FXSelect {
    id: fxSelect
    propertiesPath: overlay.propertiesPath
    deckId: overlay.deckId
    visible: fxSelectVisible
    screenScale: overlay.screenScale
    isLeftScreen: overlay.isLeftScreen
    
    onVisibleChanged: {
      fxSelectVisible = visible
      fxSelectVisibilityChanged(visible)
    }
    
    // Conectar señal de cierre
    onCloseRequested: {
      toggleFxSelect(false)
    }
    
    // Asegurar que el componente cubre toda la pantalla
    anchors.fill: parent
    z: 120
  }

  
  //------------------------------------------------------------------------------------------------------------------
  //  STATES
  //------------------------------------------------------------------------------------------------------------------
  
  onOverlayStateChanged: { 
    // Use this function to disable all subViews. This is to keep the 
    // states simple and compact.
    overlay.visible     = false;
    tempo.visible       = false;
    keylock.visible     = false;
    quantize.visible    = false;
    swing.visible       = false;
    fxSelect.visible    = false;
    sliceSize.visible   = false;
    browserSorting.visible = false;
    captureSource.visible   = false;
    browserWarnings.visible = false;
  }
  
  state: overlayState

  states: [
    State {
      name: Overlay.states[Overlay.none]
      PropertyChanges { target: overlay;     visible: false; }
    },
    State {
      name: Overlay.states[Overlay.bpm]
      PropertyChanges { target: overlay;     visible: true; }
      PropertyChanges { target: tempo;       visible: true; }  
    },
    State {
      name: Overlay.states[Overlay.key]
      PropertyChanges { target: overlay;     visible: true; }
      PropertyChanges { target: keylock;     visible: true; } 
    },
    State {
      name: Overlay.states[Overlay.fx]
      PropertyChanges { target: overlay;     visible: true; }
      PropertyChanges { target: fxSelect;    visible: true; }
    },
    State {
      name: Overlay.states[Overlay.quantize]
      PropertyChanges { target: overlay;     visible: true; }
      PropertyChanges { target: quantize;    visible: true; }
    },
    State {
      name: Overlay.states[Overlay.swing]
      PropertyChanges { target: overlay;     visible: true; }
      PropertyChanges { target: swing;       visible: true; }
    },
    State {
      name: Overlay.states[Overlay.slice]
      PropertyChanges { target: overlay;     visible: true; }
      PropertyChanges { target: sliceSize;   visible: true; }
    },
    State {
      name: Overlay.states[Overlay.sorting]
      PropertyChanges { target: overlay;        visible: true; }
      PropertyChanges { target: browserSorting; visible: true; }
    },
    State {
      name: Overlay.states[Overlay.capture]
      PropertyChanges { target: overlay;        visible: true; }
      PropertyChanges { target: captureSource;  visible: true; }
    },
    State {
      name: Overlay.states[Overlay.browserWarnings]
      PropertyChanges { target: overlay;         visible: true; }
      PropertyChanges { target: browserWarnings; visible: true; }
    }
  ]
  
  //------------------------------------------------------------------------------------------------------------------
  //  MÉTODOS PARA CONTROL DE OVERLAYS
  //------------------------------------------------------------------------------------------------------------------
  
  // Toggle para TempoAdjust
  function toggleTempoAdjust(forceState) {
    if (forceState !== undefined) {
      tempo.visible = forceState
    } else {
      tempo.visible = !tempo.visible
    }
    return tempo.visible
  }
  
  // Toggle para Keylock
  function toggleKeylock(forceState) {
    if (forceState !== undefined) {
      keylock.visible = forceState
    } else {
      keylock.visible = !keylock.visible
    }
    return keylock.visible
  }
  
  // Toggle para QuantizeSizeAdjust
  function toggleQuantizeSizeAdjust(forceState) {
    if (forceState !== undefined) {
      quantize.visible = forceState
    } else {
      quantize.visible = !quantize.visible
    }
    return quantize.visible
  }
  
  // Toggle para SwingAdjust
  function toggleSwingAdjust(forceState) {
    if (forceState !== undefined) {
      swing.visible = forceState
    } else {
      swing.visible = !swing.visible
    }
    return swing.visible
  }
  
  // Toggle para FXSelect
  function toggleFxSelect(forceState) {
   
    // Verificar que el propertiesPath sea válido
    if (!propertiesPath) {
      return false;
    }
    
    if (forceState !== undefined) {
      fxSelect.visible = forceState
    } else {
      fxSelect.visible = !fxSelect.visible
    }
    return fxSelect.visible
  }
  
  // Toggle para SliceSize
  function toggleSliceSize(forceState) {
    if (forceState !== undefined) {
      sliceSize.visible = forceState
    } else {
      sliceSize.visible = !sliceSize.visible
    }
    return sliceSize.visible
  }
  
  // Toggle para BrowserSorting
  function toggleBrowserSorting(forceState) {
    if (forceState !== undefined) {
      browserSorting.visible = forceState
    } else {
      browserSorting.visible = !browserSorting.visible
    }
    return browserSorting.visible
  }
  
  // Toggle para CaptureSource
  function toggleCaptureSource(forceState) {
    if (forceState !== undefined) {
      captureSource.visible = forceState
    } else {
      captureSource.visible = !captureSource.visible
    }
    return captureSource.visible
  }
  
  // Toggle para BrowserWarnings
  function toggleBrowserWarnings(forceState) {
    if (forceState !== undefined) {
      browserWarnings.visible = forceState
    } else {
      browserWarnings.visible = !browserWarnings.visible
    }
    return browserWarnings.visible
  }
  
  // Cerrar todos los overlays
  function hideAllOverlays() {
    toggleTempoAdjust(false)
    toggleKeylock(false)
    toggleQuantizeSizeAdjust(false)
    toggleSwingAdjust(false)
    toggleFxSelect(false)
    toggleSliceSize(false)
    toggleBrowserSorting(false)
    toggleCaptureSource(false)
    toggleBrowserWarnings(false)
  }
  
  // Actualizar el deck ID para todos los overlays
  function updateDeckId(newDeckId) {
    mirrorFocusDeckId = newDeckId
  }
}

