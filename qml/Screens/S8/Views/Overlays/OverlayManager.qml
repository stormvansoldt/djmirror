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

  anchors.fill: parent
 
  MappingProperty { id: buttonStateProp;  path: propertiesPath + ".overlay"     }
  MappingProperty { id: screenView;       path: propertiesPath + ".screen_view" }

  
  //------------------------------------------------------------------------------------------------------------------
  //  OVERLAY CONTENT
  //------------------------------------------------------------------------------------------------------------------
  
  // centered overlay windows
  CenterOverlays.TempoAdjust {
    id: tempo
    deckId: overlay.deckId
  }

  CenterOverlays.Keylock {
    id: keylock
    deckId: overlay.deckId
  }

  CenterOverlays.QuantizeSizeAdjust {
    id: quantize
    deckId: overlay.deckId
  }

  CenterOverlays.SwingAdjust {
    id: swing
    deckId: overlay.deckId
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
    propertiesPath: screen.propertiesPath
    deckId: overlay.deckId
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

}

