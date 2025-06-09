import QtQuick
import CSI 1.0

// Encabezado simplificado para selección de FX
Item {
  id: header
  property real screenScale: prefs.screenScale
  property int fxUnitId: 0
  property string fxUnitName: "FX UNIT " + (fxUnitId + 1)
  readonly property variant headerNames: getHeaderTexts()
  readonly property int macroEffectChar: 0x00B6
  readonly property bool hasFocus: (fxUnitId == fxSelect.fxUnitId)

  AppProperty { id: fxSelectProp1;    path: "app.traktor.fx." + (fxUnitId + 1) + ".select.1" }
  AppProperty { id: fxSelectProp2;    path: "app.traktor.fx." + (fxUnitId + 1) + ".select.2" }
  AppProperty { id: fxSelectProp3;    path: "app.traktor.fx." + (fxUnitId + 1) + ".select.3" }
  AppProperty { id: fxViewSelectProp; path: "app.traktor.fx." + (fxUnitId + 1) + ".type" }
  AppProperty { id: patternPlayerKitSelection; path: "app.traktor.fx." + (fxUnitId + 1) + ".pattern_player.kit_shortname" }

  // Pestañas simplificadas
  Row {
    spacing: 1 * screenScale
    anchors.fill: parent
    
    Repeater {
      model: 4

      Rectangle {
        id: tabBackground
        width: (index == 0) ? (120 * screenScale) : (119 * screenScale)
        height: 19 * screenScale
        color: (hasFocus && index==fxSelect.activeTab) ? colors.colorOrange : 
              (tabMouseArea.pressed && enabled) ? Qt.darker(colors.colorOrange, 1.3) : colors.colorFxHeaderBg
        
        // Animación para transición suave de color
        Behavior on color { 
          ColorAnimation { duration: 100 }
        }
        
        readonly property bool isMacroFx: (headerNames[index].charCodeAt(0) == macroEffectChar)

        // Área táctil simplificada
        MouseArea {
          id: tabMouseArea
          anchors.fill: parent
          enabled: (index < 2) || (fxViewSelectProp.value == FxType.Group)
          
          onClicked: {
            if (enabled) {
              fxSelect.activeTab = index
            }
          }
        }

        // Icono macro
        Rectangle {
          id: macroIcon
          anchors.verticalCenter: parent.verticalCenter
          anchors.left: parent.left
          anchors.leftMargin: 5 * screenScale
          width: 12 * screenScale
          height: 11 * screenScale
          radius: 1 * screenScale
          visible: isMacroFx && ((index < 2) || (fxViewSelectProp.value == FxType.Group))
          color: (hasFocus && index == fxSelect.activeTab) ? colors.colorBlack85 : colors.colorGrey80

          Text {
            anchors.fill: parent
            anchors.topMargin: -1 * screenScale
            anchors.leftMargin: 1 * screenScale
            text: "M"
            font.pixelSize: fonts.miniFontSize * screenScale
            font.family: prefs.normalFontName
            color: (hasFocus && index == fxSelect.activeTab) ? colors.colorOrange : colors.colorBlack
          }
        }

        // Texto de la pestaña
        Text {
          visible: (index < 2) || (fxViewSelectProp.value == FxType.Group)
          anchors.fill: parent
          anchors.topMargin: 2 * screenScale
          anchors.leftMargin: isMacroFx ? (20 * screenScale) : (5 * screenScale)
          anchors.rightMargin: 3 * screenScale
          font.pixelSize: fonts.miniFontSizePlusPlus * screenScale
          font.family: prefs.normalFontName
          font.capitalization: Font.AllUppercase
          color: (hasFocus && index == fxSelect.activeTab) ? colors.colorBlack : colors.colorFontBrowserHeader
          text: isMacroFx ? headerNames[index].substr(1) : headerNames[index]
          elide: Text.ElideRight
        }
      }
    }
  }

  // Función para obtener los textos del encabezado
  function getHeaderTexts() {
    if (fxViewSelectProp.value == FxType.PatternPlayer) {
      return [fxUnitName, patternPlayerKitSelection.description, "", ""];
    }
    return [fxUnitName, fxSelectProp1.description, fxSelectProp2.description, fxSelectProp3.description];
  }
  
  // Función para actualizar las etiquetas (puede ser llamada desde fuera)
  function updateLabels() {
    // Forzar actualización de los textos
    var temp = getHeaderTexts();
    headerNames = temp;
  }
}
