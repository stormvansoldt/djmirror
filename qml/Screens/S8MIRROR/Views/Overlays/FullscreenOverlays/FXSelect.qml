import CSI 1.0
import QtQuick

import '../../../../../Defines'

// Componente principal para selección de FX
Rectangle {
  id: fxSelect
  
  property real screenScale: prefs.screenScale
  property string propertiesPath: ""
  property alias navMenuValue: body.navMenuValue
  property alias navMenuSelected: body.navMenuSelected
  property int deckId: 0
  
  // Determinar si es la pantalla izquierda
  property bool isLeftScreen: (deckId === 0 || deckId === 2)
  
  // Control de FX alternativos
  property bool useAlternateFx: false // Por defecto usar FX1/FX2 en vez de FX3/FX4

  // Propiedades derivadas
  property variant deckIds: (isLeftScreen) ? [0, 2] : [1, 3]
  property int fxUnitId: (prefs.s12Mode ? deckId : useAlternateFx ? (isLeftScreen ? 2 : 3) : (isLeftScreen ? 0 : 1))
  property int activeTab: FxOverlay.upper_button_1

  // Señal para notificar el cierre
  signal closeRequested()

  anchors.fill: parent
  color: colors.colorBlack
  visible: false

  //--------------------------------------------------------------------------------------------------------------------
  // Propiedades de la app
  
  AppProperty { id: fxStoreProp; path: "app.traktor.fx." + (fxUnitId + 1) + ".store" }
  AppProperty { id: fxRoutingProp; path: "app.traktor.fx." + (fxUnitId + 1) + ".routing" }
  AppProperty { id: fxViewSelectProp; path: "app.traktor.fx." + (fxUnitId + 1) + ".type"; onValueChanged: { updateActiveTab(); } } 
  AppProperty { id: fx4Mode; path: "app.traktor.fx.4fx_units" }

  MappingProperty { id: fxSelectionState; path: propertiesPath + ".fx_button_selection"; onValueChanged: { updateActiveTab(); } }
  MappingProperty { id: screenOverlay; path: propertiesPath + ".overlay" }

  // Gestión de visibilidad
  onVisibleChanged: {   
    if (visible) {
      updateActiveTab();
      body.visible = true;
      header.visible = true;
    }
  }

  //--------------------------------------------------------------------------------------------------------------------
  // Inicialización
  
  Component.onCompleted: {  
    visible = false;
    body.visible = false;
    header.visible = false;
  }
         
  // Componente de cuerpo con lista de FX
  FXSelectBody {
    id: body
    anchors.fill: parent
    fxUnitId: fxSelect.fxUnitId
    activeTab: fxSelect.activeTab 
    propertiesPath: fxSelect.propertiesPath
    visible: fxSelect.visible

    onCloseRequested: {
      fxSelect.closeRequested()
    }
  }

  // Componente de encabezado
  FXSelectHeader {
    id: header
    width: parent.width
    height: 30 * screenScale
    fxUnitId: fxSelect.fxUnitId
    visible: fxSelect.visible
    
    function refreshLabels() {
      if (typeof updateLabels === "function") {
        updateLabels();
      }
    }
  }
  
  // Botón para alternar entre FX
  Rectangle {
    id: toggleFxButton
    width: 100 * screenScale
    height: 25 * screenScale
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.bottom: parent.bottom
    anchors.bottomMargin: 8 * screenScale
    anchors.horizontalCenterOffset: 0
    color: toggleMouseArea.pressed ? Qt.darker("#004477", 1.2) : colors.colorGrey32
    radius: 4 * screenScale
    z: 100
    
    // Animación de color
    Behavior on color { 
      ColorAnimation { duration: 100 }
    }

    Text {
      anchors.centerIn: parent
      text: useAlternateFx ? 
          (isLeftScreen ? "FX3 → FX1" : "FX4 → FX2") : 
          (isLeftScreen ? "FX1 → FX3" : "FX2 → FX4")
      font.pixelSize: fonts.middleFontSize * screenScale
      font.family: prefs.normalFontName
      color: colors.colorWhite
    }

    MouseArea {
      id: toggleMouseArea
      anchors.fill: parent
      onClicked: {
        useAlternateFx = !useAlternateFx;
        header.refreshLabels();
      }
    }
  }

  
  //--------------------------------------------------------------------------------------------------------------------
  // Botón de cierre
  
  Rectangle {
    id: exitButton
    width: 60 * screenScale
    height: 25 * screenScale
    anchors.bottom: parent.bottom
    anchors.right: parent.right
    anchors.bottomMargin: 8 * screenScale
    anchors.rightMargin: 8 * screenScale

    color: exitMouseArea.pressed ? Qt.darker(colors.colorRed, 1.2) : colors.colorGrey32
    radius: 4 * screenScale
    z: 100
    
    // Animación de color
    Behavior on color { 
      ColorAnimation { duration: 100 }
    }

    Text {
      anchors.centerIn: parent
      text: "EXIT"
      font.pixelSize: fonts.middleFontSize * screenScale
      font.family: prefs.normalFontName
      color: colors.colorWhite
    }

    MouseArea {
      id: exitMouseArea
      anchors.fill: parent
      onClicked: {
        screenOverlay.value = Overlay.none
        fxSelect.visible = false
        closeRequested()
      }
    }
  }


  //--------------------------------------------------------------------------------------------------------------------
  // Actualizar pestaña activa basado en el estado de selección

  function updateActiveTab() {   
    if (fxSelectionState.value !== undefined) {
      activeTab = fxSelectionState.value % FxOverlay.lower_button_1;
      if (fxViewSelectProp.value != FxType.Group) {
        if (activeTab > FxOverlay.upper_button_2) {
          activeTab = FxOverlay.upper_button_2;
        }
      }
    }
    else {
      activeTab = FxOverlay.upper_button_1;
    }
  }
}
