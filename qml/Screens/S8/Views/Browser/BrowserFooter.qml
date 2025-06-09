import CSI 1.0
import QtQuick
import Traktor.Gui 1.0 as Traktor

import './../Widgets' as Widgets 
import '../../../../Defines'


//------------------------------------------------------------------------------------------------------------------
//  BROWSER FOOTER - Barra inferior del browser con información y controles
//
//  Características principales:
//  - Muestra el criterio de ordenamiento actual
//  - Visualiza el estado del reproductor de vista previa (Preview)
//  - Permite cambiar el tipo de ordenamiento
//  - Adapta su visualización según el contenido mostrado
//
//  Propiedades principales:
//  - propertiesPath: Ruta base para las propiedades de mapeo
//  - sortingKnobValue: Valor del knob de ordenamiento
//  - isContentList: Indica si se muestra una lista de contenido
//  - sortIds: IDs de los diferentes tipos de ordenamiento disponibles
//  - sortNames: Nombres de los criterios de ordenamiento
//  - selectedFooterId: ID del elemento de footer seleccionado
//
//  Elementos visuales:
//  - browserFooterBg (Rectangle):
//    * Fondo del footer
//    * Color según tema
//
//  - sortingRow (Row):
//    * Muestra información de ordenamiento
//    * Incluye flecha indicadora de dirección
//    * Separadores entre secciones
//
//  - previewSection (Item):
//    * Muestra estado del reproductor de vista previa
//    * Incluye tiempo transcurrido
//    * Icono de reproducción
//
//  Estados:
//  - show: Muestra el footer (height: 21)
//  - hide: Oculta el footer (height: 0)
//
//  Funciones principales:
//  - getSortingIdWithDelta(): Obtiene siguiente/anterior criterio de ordenamiento
//  - getPosForSortId(): Obtiene posición en array para un ID de ordenamiento
//  - getSortingNameForSortId(): Obtiene nombre del criterio de ordenamiento
//  - clamp(): Limita valores dentro de un rango
//
//  Comportamiento:
//  - Actualiza overlay al cambiar ordenamiento
//  - Gestiona temporizador para ocultar overlay
//  - Adapta visualización según tipo de contenido
//------------------------------------------------------------------------------------------------------------------

// Fondo del footer
Rectangle {
  id: footer

  property string propertiesPath: ""
  property real  sortingKnobValue: 0.0
  property bool  isContentList:    qmlBrowser.isContentList
  
  // Los números dados son determinados por el EContentListColumns en Traktor
  readonly property variant sortIds:          [0 ,           2     ,     3     ,  7   ,      9   ,  5   ,  28  ,     22     ,    27     ]
  readonly property variant sortNames:        ["Sort By #", "Title", "Artist", "Release", "Genre", "BPM", "Key", "Rating", "Import Date"]
  readonly property int     selectedFooterId: (selectedFooterItem.value === undefined) ? 0 : ( ( selectedFooterItem.value % 2 === 1 ) ? 1 : 4 ) // selectedFooterItem.value toma valores de 1 a 4.
  
  property          real    preSortingKnobValue: 0.0

  //--------------------------------------------------------------------------------------------------------------------  

  AppProperty { id: previewIsLoaded;     path : "app.traktor.browser.preview_player.is_loaded" }
  AppProperty { id: previewTrackLenght;  path : "app.traktor.browser.preview_content.track_length" }
  AppProperty { id: previewTrackElapsed; path : "app.traktor.browser.preview_player.elapsed_time" }

  MappingProperty { id: overlayState;      path: propertiesPath + ".overlay" }
  MappingProperty { id: isContentListProp; path: propertiesPath + ".browser.is_content_list" }
  MappingProperty { id: selectedFooterItem;      path: propertiesPath + ".selected_footer_item" }

  //--------------------------------------------------------------------------------------------------------------------  
  // Comportamiento al cambiar el ordenamiento (mostrar/ocultar widget de ordenamiento, seleccionar siguiente ordenamiento permitido)
  //--------------------------------------------------------------------------------------------------------------------  

  // Cambio en la lista de contenido
  onIsContentListChanged: { 
    // Necesario para deshabilitar mapeos (orden ascendente/descendente)
    isContentListProp.value = isContentList; 
  }

  // Cambio en el valor del knob de ordenamiento
  onSortingKnobValueChanged: { 
    if (!footer.isContentList)
    return;

    overlayState.value = Overlay.sorting;
    sortingOverlayTimer.restart();

    var val = clamp(footer.sortingKnobValue - footer.preSortingKnobValue, -1, 1);
    val     = parseInt(val);
    if (val != 0) {
      qmlBrowser.sortingId   = getSortingIdWithDelta( val );
      footer.preSortingKnobValue = footer.sortingKnobValue;   
    }
  }

  // Temporizador para ocultar el overlay
  Timer {
    id: sortingOverlayTimer
    interval: 800  // duration of the scrollbar opacity
    repeat:   false

    onTriggered: overlayState.value = Overlay.none;
  }


  //--------------------------------------------------------------------------------------------------------------------  
  // Vista
  //--------------------------------------------------------------------------------------------------------------------  

  clip: true
  anchors.left:   parent.left
  anchors.right:  parent.right
  anchors.bottom: parent.bottom
  height:         21 // set in state
  color:          "transparent"

  // Color de fondo
  Rectangle {
    id: browserFooterBg
    anchors.left:   parent.left
    anchors.right:  parent.right
    anchors.bottom: parent.bottom
    height:         17
    color:          colors.colorBrowserHeader // footer background color
  }

  // Contenedor de fila para el ordenamiento
  Row {
    id: sortingRow
    anchors.left:   browserFooterBg.left
    anchors.leftMargin: 1
    anchors.top:  browserFooterBg.top

    // Primer elemento de la fila
    Item {
      width:  120
      height: 17

      Text {
        anchors.left: parent.left
        anchors.leftMargin:     3

        font.pixelSize: fonts.miniFontSizePlusPlus
        font.capitalization: Font.AllUppercase
        font.family: prefs.normalFontName

        color: selectedFooterId == 1 ? colors.colorFontWhite : colors.colorFontBrowserHeader
        text:  getSortingNameForSortId(qmlBrowser.sortingId)
        visible: qmlBrowser.isContentList
      }

      // Flecha de dirección de ordenamiento
      Widgets.Triangle { 
        id : sortDirArrow
        width:  8
        height: 4
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.topMargin:  6
        anchors.rightMargin: 6
        antialiasing: false
        visible: (qmlBrowser.isContentList && qmlBrowser.sortingId > 0)
        color: colors.colorGrey80
        rotation: ((qmlBrowser.sortingDirection == 1) ? 0 : 180) 
      }

      Rectangle {
        height: 15
        width: 1
        color: colors.colorGrey40 // footer divider color
        anchors.right: parent.right
      }
    }

    Item {
      width:  120
      height: 17
      Text {
        anchors.left:   parent.left
        anchors.leftMargin: 3

        font.pixelSize: fonts.miniFontSizePlusPlus
        font.capitalization: Font.AllUppercase
        font.family: prefs.normalFontName

        color: colors.colorFontBrowserHeader
        text: ""
      }

      Rectangle {
        height: 15
        width: 1
        color: colors.colorGrey40 // footer divider color
        anchors.right: parent.right
      }
    }

    Item {
      width:  120
      height: 17

      // Item counter
      Text {
        visible: prefs.displayBrowserItemCount && isContentList
        anchors.left: parent.left
        anchors.leftMargin: 5

        font.pixelSize: fonts.miniFontSizePlusPlus
        font.capitalization: Font.AllUppercase
        font.family: prefs.normalFontName

        color: colors.colorFontBrowserHeader

        // Mostrar formato: (posición_actual/total)
        text: "Track (" + (contentList.currentIndex + 1) + "/" + contentList.count + ")"
      }

      Rectangle {
        height: 15
        width: 1
        color: colors.colorGrey40 // footer divider color
        anchors.right: parent.right
      }
    }

    // Reproductor de vista previa en el footer
    Item {
      width:  120
      height: 17

      // Preview text
      Text {
        anchors.left: parent.left
        anchors.leftMargin: 5

        font.pixelSize: fonts.miniFontSizePlusPlus
        font.capitalization: Font.AllUppercase
        font.family: prefs.normalFontName

        color: selectedFooterId == 4 ? colors.colorFontWhite : colors.colorFontBrowserHeader
        text: "Preview"
      }

      Image {
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.topMargin:     2
        anchors.rightMargin:  45
        visible: previewIsLoaded.value
        antialiasing: false
        source: "../Images/PreviewIcon_Small" + colors.inverted + ".png"
        fillMode: Image.Pad
        clip: true
        cache: false
        sourceSize.width: width
        sourceSize.height: height
      }

      Text {
        width: 40
        clip: true
        horizontalAlignment: Text.AlignRight
        visible: previewIsLoaded.value
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.topMargin:     2
        anchors.rightMargin:  7

        font.pixelSize: fonts.miniFontSizePlusPlus
        font.family: prefs.normalFontName
        font.capitalization: Font.AllUppercase

        color: colors.browser.prelisten
        text: utils.convertToTimeString(previewTrackElapsed.value)
      }
    }
  }

  //--------------------------------------------------------------------------------------------------------------------  
  // Borde y sombra negros
  //--------------------------------------------------------------------------------------------------------------------  
  Rectangle {    
    id: browserHeaderBottomGradient
    height:         3
    anchors.left:   parent.left
    anchors.right:  parent.right
    anchors.bottom: browserHeaderBlackBottomLine.top
    gradient: Gradient {
      GradientStop { position: 0.0; color: colors.colorBlack0 }
      GradientStop { position: 1.0; color: colors.colorBlack38 }
    }
  }

  Rectangle {
    id: browserHeaderBlackBottomLine
    height:         2
    color:          colors.colorBlack
    anchors.left:   parent.left
    anchors.right:  parent.right
    anchors.bottom: browserFooterBg.top
  }

  //------------------------------------------------------------------------------------------------------------------
  // Estados
  //--------------------------------------------------------------------------------------------------------------------  
  state: "show"  
  states: [
    State {
      name: "show"
      PropertyChanges{ target: footer; height: 21 }
    },
    State {
      name: "hide"
      PropertyChanges{ target: footer; height: 0 }
    }
  ]


  //--------------------------------------------------------------------------------------------------------------------  
  // Funciones necesarias
  //--------------------------------------------------------------------------------------------------------------------  

  // Obtiene el ID de ordenamiento con delta
  function getSortingIdWithDelta( delta ) {
    var curPos = getPosForSortId( qmlBrowser.sortingId );
    var pos    = curPos + delta;
    var count  = sortIds.length;

    pos = (pos < 0)      ? count-1 : pos;
    pos = (pos >= count) ? 0       : pos;

    return sortIds[pos];
  }

  // Obtiene la posición del ID de ordenamiento
  function getPosForSortId(id) {
    if (id == -1) return 0; // -1 is a special case which should be interpreted as "0"
    for (var i=0; i<sortIds.length; i++) {
      if (sortIds[i] == id) return i;
    }
    return -1;
  }

  // Obtiene el nombre del criterio de ordenamiento
  function getSortingNameForSortId(id) {
    if (id >= 0)
    {
      var pos = getPosForSortId(id);

      if (pos >= 0 && pos < sortNames.length)
        return sortNames[pos];
    }
    return "SORTED";
  }

  // Limita un valor dentro de un rango
  function clamp(val, min, max){
    return Math.max( Math.min(val, max) , min );
  }
}
