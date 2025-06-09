import QtQuick
import Qt5Compat.GraphicalEffects
import CSI 1.0

import '../../../../../Defines'

// Vista principal simplificada para selección de FX
Item {
  id: fxSelectBody

  property real screenScale: prefs.screenScale
  property string propertiesPath: ""
  property int navMenuValue: 0
  property int preNavMenuValue: 0
  property bool navMenuSelected: false
  property int fxUnitId: 0
  property int activeTab: 1
  
  // Vista actual basada en la pestaña activa y tipo de FX
  property int currentView: (activeTab === FxOverlay.upper_button_1) ? settingsView : 
                           ((activeTab < FxOverlay.lower_button_1) || (fxViewSelectProp.value === FxType.Group)) ? 
                           tableView : emptyView
  
  readonly property bool patternPlayerFxViewSelected: (fxViewSelectProp.value === FxType.PatternPlayer)
  readonly property int delegateHeight: 27 * screenScale
  readonly property int emptyView: 0
  readonly property int tableView: 1
  readonly property int settingsView: 2
  readonly property int macroEffectChar: 0x00B6

  // Señal para notificar el cierre
  signal closeRequested()

  anchors.margins: 5 * screenScale
  anchors.bottomMargin: 10 * screenScale

  //--------------------------------------------------------------------------------------------------------------------
  // Propiedades de la app
  
  AppProperty { 
    id: fxSelectProp 
    path: "app.traktor.fx." + (fxUnitId+1) + ".select." + Math.max(1, activeTab)
    onValueChanged: { updateFxSelection(); }
  }
  
  AppProperty {
    id: kitSelectProp
    path: "app.traktor.fx." + (fxUnitId+1) + ".kitSelect"
    onValueChanged: { updateFxSelection(); }
  }

  MappingProperty { id: screenOverlay; path: propertiesPath + ".overlay" }

  onVisibleChanged: { updateFxSelection(); }

  // Función para obtener el valor del efecto actualmente configurado
  function getCurrentConfiguredFxIndex() {
    if (patternPlayerFxViewSelected) {
      return kitSelectProp.value !== undefined ? kitSelectProp.value : -1;
    } else {
      return fxSelectProp.value !== undefined ? fxSelectProp.value : -1;
    }
  }

  // Función para actualizar la selección
  function updateFxSelection() {
    if ((currentView === tableView) && (fxSelectProp.value !== undefined)) {
      preNavMenuValue = navMenuValue; 
      navMenuValue = patternPlayerFxViewSelected ? kitSelectProp.value : fxSelectProp.value;
      fxList.currentIndex = patternPlayerFxViewSelected ? kitSelectProp.value : fxSelectProp.value;
    }
  }

  //--------------------------------------------------------------------------------------------------------------------
  // Lista de efectos
  
  ListView {
    id: fxList
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.topMargin: 33 * screenScale
    height: parent.height - anchors.topMargin - anchors.topMargin
    clip: true
    
    // Desactivar seguimiento automático
    highlightFollowsCurrentItem: false
    
    // Propiedad para rastrear elemento con longPress activo
    property int longPressIndex: -1
    
    visible: (currentView === tableView)
    model: patternPlayerFxViewSelected ? kitSelectProp.valuesDescription : fxSelectProp.valuesDescription

    // Cuando cambia el índice, resetear longPressIndex
    onCurrentIndexChanged: {
      longPressIndex = -1
    }

    delegate: Item {
      anchors.horizontalCenter: parent.horizontalCenter
      height: delegateHeight
      width: fxList.width
      
      readonly property bool isMacroFx: (modelData.charCodeAt(0) === macroEffectChar)
      // Propiedad para saber si este elemento está actualmente seleccionado
      readonly property bool isSelected: fxList.currentIndex === index
      // Propiedad para saber si este elemento está en estado de longPress
      readonly property bool isLongPressed: fxList.longPressIndex === index
      // Propiedad para saber si este elemento es el efecto actualmente configurado
      readonly property bool isConfigured: getCurrentConfiguredFxIndex() === index

      // Fondo de selección
      Rectangle {
        id: itemBackground
        anchors.fill: parent
        // Prioridad: primero si está en longPress, luego si está seleccionado normalmente
        color: isLongPressed ? Qt.darker(colors.colorOrange, 1.2) : 
               isSelected ? colors.colorOrange : "transparent"
        opacity: 0.7
        
        // Animación suave del color
        Behavior on color { 
          ColorAnimation { duration: 150 }
        }
      }

      // Área táctil
      MouseArea {
        anchors.fill: parent
        
        // Propiedades para controlar el tap largo
        property bool isLongPress: false
        property real startX: 0
        property real startY: 0
        property int touchThreshold: 10 * screenScale
        
        onPressed: {
          fxList.currentIndex = index

          isLongPress = false
          startX = mouse.x
          startY = mouse.y
          
          // Iniciar timer para detectar pulsación larga
          longPressTimer.restart()
        }
        
        onPositionChanged: {
          // Cancelar longPress si el dedo se mueve significativamente
          if (Math.abs(mouse.x - startX) > touchThreshold || 
              Math.abs(mouse.y - startY) > touchThreshold) {
            isLongPress = false
            // Limpiar índice longPress si corresponde a este elemento
            if (fxList.longPressIndex === index) {
              fxList.longPressIndex = -1
            }
          }
          // Detener el timer
          longPressTimer.restart()
          longPressTimer.stop()
        }

        onClicked: {
          // Detener el timer
          longPressTimer.restart()
          longPressTimer.stop()
        }
        
        onReleased: {
          // Detener el timer
          longPressTimer.restart()
          longPressTimer.stop()
          
          // Limpiar índice longPress si corresponde a este elemento
          if (fxList.longPressIndex === index) {
            fxList.longPressIndex = -1
          }
          
          // Solo actualizar la selección si no fue un tap largo (ya que el tap largo ya aplicó la selección)
          if (!isLongPress) {
            fxList.currentIndex = index
          }
        }
        // Timer para detectar pulsación larga
        property Timer longPressTimer: Timer {
          interval: 1200 // 1.2 segundos para mejor respuesta
          onTriggered: {
            // Marcar como pulsación larga
            parent.isLongPress = true
            
            // Actualizar el índice de longPress en la lista
            fxList.longPressIndex = index
            
            // Seleccionar este elemento y aplicar inmediatamente
            fxList.currentIndex = index
            applySelection()

            // Notificamos el cierre
            closeRequested()
            //screenOverlay.value = Overlay.none;

            // Detener el timer
            longPressTimer.restart()
            longPressTimer.stop()
          }
        }
      }

      // Texto del nombre del efecto
      Text {
        id: fxName
        anchors.centerIn: parent
        anchors.horizontalCenterOffset: isMacroFx ? (10 * screenScale) : 0
        font.pixelSize: fonts.largeFontSize * screenScale
        font.capitalization: Font.AllUppercase
        font.family: prefs.normalFontName
        
        // Mostrar el texto configurado en color cyan, los seleccionados en negro, el resto en color normal
        color: {
          if (isConfigured) {
            return colors.colorFontYellow; 
          } else if (isSelected) {
            return colors.colorFontOrange;
          } else if (isLongPressed) {
            return colors.colorFontOrange;
          } else {
            return colors.colorFontGrey;
          }
        }
        
        text: isMacroFx ? modelData.substr(1) : modelData
      }

      // Icono de Macro FX (mantenido al final por claridad del código principal)
      Image {
        id: macroIcon
        source: "./../../Images/Fx_Multi_Icon_Large.png"
        fillMode: Image.PreserveAspectCrop
        width: sourceSize.width * screenScale
        height: sourceSize.height * screenScale
        anchors.right: fxName.left
        anchors.top: parent.top
        anchors.rightMargin: 5 * screenScale
        anchors.topMargin: 5 * screenScale
        visible: false
      }

      // Color overlay para el icono
      ColorOverlay {
        anchors.fill: macroIcon
        source: macroIcon
        color: colors.colorGrey56
        visible: isMacroFx
      }
    }
  }

  //------------------------------------------------------------------------------------------------------------------
  // Vista de configuración de FX
  
  Item {
    id: setting
    anchors.fill: parent
    visible: (currentView === settingsView)

    property int currentBtn: 0
    property int currentIndex: setting.btnToIndexMap[setting.currentBtn]
    property var btnToProperty: [fxViewSelectProp, fxRoutingProp, fxStoreProp, fxViewSelectProp, fxRoutingProp, null, fxViewSelectProp, fxRoutingProp]
    property var btnToValue: [FxType.Group, FxRouting.Send, true, FxType.Single, FxRouting.Insert, null, FxType.PatternPlayer, FxRouting.PostFader]
    readonly property var btnNames: ["Group", "Send", "Snapshot", "Single", "Insert", "-", "Pattern", "Post Fader", "-"]
    readonly property var btnToIndexMap: [0, 3, patternPlayerBtn, 1, 4, 7, snapshotBtn]
    readonly property int snapshotBtn: 2
    readonly property int patternPlayerBtn: 6
    readonly property int buttonCount: btnToIndexMap.length

    Grid {
      columns: 3
      rows: 3
      columnSpacing: 27 * screenScale
      rowSpacing: 5 * screenScale
      anchors.centerIn: parent
      anchors.verticalCenterOffset: 3 * screenScale

      Repeater {
        model: 9

        // Botones de configuración
        Rectangle {
          id: settingButton
          width: 130 * screenScale
          height: 29 * screenScale
          color: buttonMouseArea.pressed && buttonEnabled ? Qt.darker(colors.colorGrey32, 1.2) : colors.colorGrey16
          border.width: 1 * screenScale
          opacity: (setting.btnNames[index] !== "-") ? 1 : 0
          border.color: (index === setting.currentIndex) ? colors.colorOrange : colors.colorGrey32
          
          // Animación para transición suave de color
          Behavior on color { 
            ColorAnimation { duration: 100 }
          }
          
          // Propiedad para determinar si el botón está habilitado
          readonly property bool buttonEnabled: setting.btnNames[index] !== "-" && setting.btnToProperty[index] !== null

          // Área táctil
          MouseArea {
            id: buttonMouseArea
            anchors.fill: parent
            enabled: parent.buttonEnabled
            
            onClicked: {
              if (enabled) {
                setting.currentIndex = index
                if (setting.btnToProperty[index] && setting.btnToValue[index] !== null) {
                  setting.btnToProperty[index].value = setting.btnToValue[index]
                }
              }
            }
          }

          // Texto del botón
          Text {
            anchors.horizontalCenter: (index === setting.snapshotBtn) ? parent.horizontalCenter : undefined 
            anchors.verticalCenter: parent.verticalCenter
            x: 9 * screenScale
            font.pixelSize: fonts.middleFontSize * screenScale
            font.family: prefs.normalFontName
            text: setting.btnNames[index]
            color: (index === setting.currentIndex) ? colors.colorOrange : colors.colorFontFxHeader
          }

          // Botón de radio
          Rectangle {
            visible: (index !== setting.snapshotBtn)
            width: 8 * screenScale
            height: width
            anchors.verticalCenter: parent.verticalCenter
            anchors.verticalCenterOffset: -1 * screenScale
            anchors.right: parent.right
            anchors.rightMargin: 9 * screenScale
            radius: 4 * screenScale
            border.width: 1 * screenScale
            border.color: (isButtonAtIndexSelected(index) || index === setting.currentIndex) ? colors.colorOrange : colors.colorGrey72
            color: isButtonAtIndexSelected(index) ? colors.colorOrange : "transparent"
          }
        }
      }
    }
  }

  //------------------------------------------------------------------------------------------------------------------
  
  // Función para aplicar la selección y cerrar
  function applySelection() {
    if (patternPlayerFxViewSelected) {
      kitSelectProp.value = fxList.currentIndex;
    } else {
      fxSelectProp.value = fxList.currentIndex;
    }
  }

  // Manejador de selección de menú
  onNavMenuSelectedChanged: {
    if (navMenuSelected) {
      if (currentView === settingsView) {
        if (setting.btnToProperty[setting.currentIndex] && setting.btnToValue[setting.currentIndex] !== null) {
          setting.btnToProperty[setting.currentIndex].value = setting.btnToValue[setting.currentIndex];
        }
      }
      else if (currentView === tableView) {
        applySelection();
      }
    }
  }

  // Manejador de cambio en el valor del menú
  onNavMenuValueChanged: { 
    var delta = navMenuValue - preNavMenuValue;
    preNavMenuValue = navMenuValue;

    if (currentView === settingsView) {
      var btn = setting.currentBtn;
      btn = (btn + delta) % setting.buttonCount;
      setting.currentBtn = (btn < 0) ? setting.buttonCount + btn : btn;
    }
    else if (currentView === tableView) {
      var index = fxList.currentIndex + delta;
      fxList.currentIndex = clamp(index, 0, fxList.count-1);
    }
  }

  // Funciones auxiliares
  function clamp(value, min, max) {
    return Math.max(min, Math.min(value, max));
  }

  function isButtonAtIndexSelected(index) {
    if (index === setting.snapshotBtn) {
      return false;
    }
    if (setting.btnToProperty[index] == null || setting.btnToValue[index] == null) {
      return false;
    }
    return setting.btnToProperty[index].value === setting.btnToValue[index]
  }
}
