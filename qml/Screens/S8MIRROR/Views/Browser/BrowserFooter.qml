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

  property real screenScale: prefs.screenScale
  
  // Propiedades para calcular anchos relativos basados en screenScale
  property real baseItemWidth: 120
  property real backButtonWidth: 50
  property real totalWidth: parent.width - (6 * screenScale)
  property real itemWidth: Math.min(baseItemWidth * screenScale, totalWidth / 5)

  property string propertiesPath: ""
  property real  sortingKnobValue: 0.0
  property bool  isContentList:    qmlBrowser.isContentList
  
  // Los números dados son determinados por el EContentListColumns en Traktor
  readonly property variant sortIds:          [0 ,           2     ,     3     ,  7   ,      9   ,  5   ,  28  ,     22     ,    27     ]
  readonly property variant sortNames:        ["Sort By #", "Title", "Artist", "Release", "Genre", "BPM", "Key", "Rating", "Import Date"]
  readonly property int     selectedFooterId: (selectedFooterItem.value === undefined) ? 0 : ( ( selectedFooterItem.value % 2 === 1 ) ? 1 : 4 ) // selectedFooterItem.value toma valores de 1 a 4.
  
  property          real    preSortingKnobValue: 0.0
  
  // Nueva propiedad para almacenar el índice de ordenamiento actual
  property int     currentSortingIndex: 0

  //--------------------------------------------------------------------------------------------------------------------  

  AppProperty { id: previewIsLoaded;          path : "app.traktor.browser.preview_player.is_loaded" }
  AppProperty { id: previewTrackLenght;       path : "app.traktor.browser.preview_content.track_length" }
  AppProperty { id: previewTrackElapsed;      path : "app.traktor.browser.preview_player.elapsed_time" }

  MappingProperty { id: overlayState;         path: propertiesPath + ".overlay" }
  MappingProperty { id: isContentListProp;    path: propertiesPath + ".browser.is_content_list" }
  MappingProperty { id: selectedFooterItem;   path: propertiesPath + ".selected_footer_item" }

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

    var val = clamp(footer.sortingKnobValue - footer.preSortingKnobValue, -1, 1);
    val     = parseInt(val);
    if (val != 0) {
      qmlBrowser.sortingId   = getSortingIdWithDelta( val );
      footer.preSortingKnobValue = footer.sortingKnobValue;   
    }
  }
  
  // Función para cambiar el orden de la lista
  function changeSorting(direction) {
    if (!footer.isContentList)
      return;
        
    // Calcular el nuevo índice de ordenamiento
    if (direction === "next") {
      currentSortingIndex = (currentSortingIndex + 1) % sortIds.length;
      // Aplicar el nuevo ordenamiento
      qmlBrowser.sortingId = sortIds[currentSortingIndex];
      
    } else if (direction === "previous") {
      currentSortingIndex = (currentSortingIndex - 1 + sortIds.length) % sortIds.length;
      // Aplicar el nuevo ordenamiento
      qmlBrowser.sortingId = sortIds[currentSortingIndex];
      
    } else if (direction === "toggle") {
      // NO FUNCIONA: Parece que no se puede cambiar el valor de sortingDirection
      // Cambiar dirección de ordenamiento
      qmlBrowser.sortingDirection = qmlBrowser.sortingDirection == 1 ? 0 : 1;

      // Efecto visual de feedback para la flecha
      directionFeedback.start();
      return;
    }
    
    // Efecto visual de feedback para el texto
    sortingFeedback.start();
  }
  
  // Animación para feedback visual del texto
  SequentialAnimation {
    id: sortingFeedback
    
    PropertyAnimation {
      target: sortingText
      property: "opacity"
      from: 1.0
      to: 0.5
      duration: 100
    }
    
    PropertyAnimation {
      target: sortingText
      property: "opacity"
      from: 0.5
      to: 1.0
      duration: 100
    }
  }
  
  // Animación para feedback visual de la flecha
  SequentialAnimation {
    id: directionFeedback
    
    PropertyAnimation {
      target: sortDirArrow
      property: "opacity"
      from: 1.0
      to: 0.3
      duration: 100
    }
    
    PropertyAnimation {
      target: sortDirArrow
      property: "opacity"
      from: 0.3
      to: 1.0
      duration: 100
    }
  }


  //--------------------------------------------------------------------------------------------------------------------  
  // Vista
  //--------------------------------------------------------------------------------------------------------------------  

  
  anchors.left:   parent.left
  anchors.right:  parent.right
  anchors.bottom: parent.bottom
  height:         21 * screenScale
  color:          "transparent"
  anchors.rightMargin: 3 * screenScale
  anchors.leftMargin: 3 * screenScale

  // Color de fondo
  Rectangle {
    id: browserFooterBg
    anchors.left:   parent.left
    anchors.right:  parent.right
    anchors.bottom: parent.bottom
    height:         17 * screenScale
    color:          colors.colorBrowserHeader // footer background color
  }

  // Contenedor de fila
  Row {
    id: sortingRow
    anchors.left:   browserFooterBg.left
    anchors.leftMargin: 1 * screenScale
    anchors.top:  browserFooterBg.top
    anchors.right: browserFooterBg.right
    anchors.rightMargin: 1 * screenScale
    height: browserFooterBg.height
    spacing: 0

    // Primer elemento de la fila
    Item {
      width: itemWidth
      height: 17 * screenScale

      Text {
        id: sortingText
        anchors.left: parent.left
        anchors.leftMargin: 3 * screenScale
        anchors.verticalCenter: parent.verticalCenter

        font.pixelSize: fonts.miniFontSizePlusPlus * screenScale
        font.capitalization: Font.AllUppercase
        font.family: prefs.normalFontName
        elide: Text.ElideRight
        width: parent.width - (14 * screenScale) // Dejar espacio para la flecha

        color: selectedFooterId == 1 ? colors.colorFontWhite : colors.colorFontBrowserHeader
        text: getSortingNameForSortId(qmlBrowser.sortingId)
        visible: qmlBrowser.isContentList
              
        MouseArea {
          anchors.fill: parent
          onClicked: {
            changeSorting("next"); // Al hacer clic, avanza al siguiente criterio de ordenamiento
          }
        }
      }

      // Flecha de dirección de ordenamiento
      Widgets.Triangle { 
        id: sortDirArrow
        width: 8 * screenScale
        height: 4 * screenScale
        anchors.verticalCenter: parent.verticalCenter
        anchors.right: parent.right
        anchors.rightMargin: 6 * screenScale
        antialiasing: false
        visible: (qmlBrowser.isContentList && qmlBrowser.sortingId > 0)
        color: colors.colorGrey80
        rotation: ((qmlBrowser.sortingDirection == 1) ? 0 : 180) 
        MouseArea {
          anchors.fill: parent
          anchors.margins: -5 * screenScale // Área táctil más grande para facilitar la interacción
          onClicked: {
            changeSorting("toggle"); // Al hacer clic, cambia la dirección de ordenamiento
          }
        }
      }

      Rectangle {
        height: 15 * screenScale
        width: 1 * screenScale
        color: colors.colorGrey40 // footer divider color
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
      }

    }

    // Contenedor de fila para buscar
    Item {
      width: itemWidth
      height: 17 * screenScale
      visible: parent.width > (itemWidth * 2) // Ocultar si no hay espacio suficiente
      
      Text {
        anchors.left: parent.left
        anchors.leftMargin: 3 * screenScale
        anchors.verticalCenter: parent.verticalCenter

        font.pixelSize: fonts.miniFontSizePlusPlus * screenScale
        font.capitalization: Font.AllUppercase
        font.family: prefs.normalFontName
        elide: Text.ElideRight
        width: parent.width - 6 * screenScale

        color: colors.colorFontBrowserHeader
        text: "" // En el futuro, se mostrará un buscador
      }

      Rectangle {
        height: 15 * screenScale
        width: 1 * screenScale
        color: colors.colorGrey40 // footer divider color
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
      }

      MouseArea {
        id: sortingMouseArea
        anchors.fill: parent
        onClicked: {
        }
      } 
    }

    // Contenedor de fila para el contador de items
    Item {
      width: itemWidth
      height: 17 * screenScale
      visible: parent.width > (itemWidth * 3) // Ocultar si no hay espacio suficiente

      // Item counter
      Text {
        visible: prefs.displayBrowserItemCount && isContentList
        anchors.left: parent.left
        anchors.leftMargin: 5 * screenScale
        anchors.verticalCenter: parent.verticalCenter

        font.pixelSize: fonts.miniFontSizePlusPlus * screenScale
        font.capitalization: Font.AllUppercase
        font.family: prefs.normalFontName
        elide: Text.ElideRight
        width: parent.width - 6 * screenScale

        color: colors.colorFontBrowserHeader

        // Mostrar formato: (posición_actual/total)
        text: "Track (" + (contentList.currentIndex + 1) + "/" + contentList.count + ")"
      }

      Rectangle {
        height: 15 * screenScale
        width: 1 * screenScale
        color: colors.colorGrey40 // footer divider color
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
      }

      MouseArea {
        id: countTracksMouseArea
        anchors.fill: parent
        onClicked: {
        }
      }      
    }

    // Reproductor de vista previa en el footer
    Item {
      width: itemWidth
      height: 17 * screenScale
      visible: parent.width > (itemWidth * 4) // Ocultar si no hay espacio suficiente

      // Preview text
      Text {
        id: previewText
        anchors.left: parent.left
        anchors.leftMargin: 5 * screenScale
        anchors.verticalCenter: parent.verticalCenter

        font.pixelSize: fonts.miniFontSizePlusPlus * screenScale
        font.capitalization: Font.AllUppercase
        font.family: prefs.normalFontName
        elide: Text.ElideRight
        width: parent.width - (previewIsLoaded.value ? 50 : 10) * screenScale

        color: selectedFooterId == 4 ? colors.colorFontWhite : colors.colorFontBrowserHeader
        text: "" // "Preview"
      }

      Image {
        id: previewIcon
        anchors.verticalCenter: parent.verticalCenter
        anchors.right: previewTimeText.left
        anchors.rightMargin: 5 * screenScale
        width: 15 * screenScale
        height: 15 * screenScale
        visible: previewIsLoaded.value
        antialiasing: false
        source: "../Images/PreviewIcon_Small" + colors.inverted + ".png"
        fillMode: Image.PreserveAspectFit
        
        cache: false
        sourceSize.width: width
        sourceSize.height: height
      }

      Text {
        id: previewTimeText
        width: 40 * screenScale
        
        horizontalAlignment: Text.AlignRight
        visible: previewIsLoaded.value
        anchors.verticalCenter: parent.verticalCenter
        anchors.right: parent.right
        anchors.rightMargin: 7 * screenScale

        font.pixelSize: fonts.miniFontSizePlusPlus * screenScale
        font.family: prefs.normalFontName
        font.capitalization: Font.AllUppercase

        color: colors.browser.prelisten
        text: utils.convertToTimeString(previewTrackElapsed.value)
      }

      Rectangle {
        height: 15 * screenScale
        width: 1 * screenScale
        color: colors.colorGrey40 // footer divider color
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
      }
      
      MouseArea {
        id: playPreviewMouseArea
        anchors.fill: parent
        onClicked: {
          // Cargar o reproducir vista previa
          qmlBrowser.previewPlayerLoadOrPlay = true;
        }
      }
    }

    // Botón para subir al nivel superior (navegación táctil)
    Item {
      id: backButton
      width: Math.min(backButtonWidth * screenScale, totalWidth - (sortingRow.children.length - 1) * itemWidth)
      height: parent.height
      visible: width > 20 * screenScale // Ocultar si es demasiado pequeño

      Rectangle {
        id: backButtonBackground
        anchors.centerIn: parent
        width: Math.min(36 * screenScale, parent.width - 4 * screenScale)
        height: 14 * screenScale
        radius: 3 * screenScale
        color: backMouseArea.pressed ? colors.colorBlack28 : colors.colorBlack19

        Text {
          anchors.centerIn: parent
          text: "BACK"
          font.pixelSize: fonts.miniFontSizePlusPlus * screenScale
          font.family: prefs.normalFontName
          font.capitalization: Font.AllUppercase
          elide: Text.ElideRight
          width: parent.width - 4 * screenScale
          horizontalAlignment: Text.AlignHCenter
          color: (qmlBrowser.focusDeckId < 2) ? colors.colorDeckBright : colors.colorFontWhite
        }
      }

      MouseArea {
        id: backMouseArea
        anchors.fill: parent
        onClicked: {
          // Salir del nodo actual (subir un nivel)
          qmlBrowser.exitNode = true;
        }
      }
    }
  }

  //--------------------------------------------------------------------------------------------------------------------  
  // Borde y sombra negros
  //--------------------------------------------------------------------------------------------------------------------  
  Rectangle {    
    id: browserHeaderBottomGradient
    height:         3 * screenScale
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
    height:         2 * screenScale
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
      PropertyChanges{ target: footer; height: 21 * screenScale }
    },
    State {
      name: "hide"
      PropertyChanges{ target: footer; height: 0 }
    }
  ]

  // Inicializar el índice de ordenamiento
  Component.onCompleted: {
    currentSortingIndex = getPosForSortId(qmlBrowser.sortingId);
  }

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
