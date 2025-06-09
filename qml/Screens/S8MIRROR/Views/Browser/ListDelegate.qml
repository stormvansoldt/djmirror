import CSI 1.0
import QtQuick
import Qt5Compat.GraphicalEffects

import '../Widgets' as Widgets

//------------------------------------------------------------------------------------------------------------------
//  LIST DELEGATE - Define la apariencia y comportamiento de cada elemento en el browser
//
//  Características principales:
//  - Muestra información de pistas y carpetas en el browser
//  - Gestiona la visualización de covers, ratings, BPM y key
//  - Implementa indicadores visuales para:
//    * Pistas cargadas en decks (A/B/C/D)
//    * Estado de reproducción previa
//    * Coincidencia de tempo y key con el master
//    * Calificación (rating) de la pista
//
//  Propiedades del modelo:
//  - dataType: Tipo de elemento (Track/Folder)
//  - nodeIconId: ID del icono para carpetas
//  - nodeName: Nombre del elemento
//  - coverUrl: URL de la carátula
//  - artistName: Nombre del artista
//  - trackName: Nombre de la pista
//  - bpm: Tempo de la pista
//  - key: Tonalidad musical
//  - keyIndex: Índice de tonalidad (0-23)
//  - rating: Calificación (0-5)
//  - loadedInDeck: Array con decks donde está cargada
//  - prevPlayed: Indica si fue reproducida previamente
//  - prelisten: Indica si está en preescucha
//
//  Funciones principales:
//  - getListItemTextColor(): Define el color del texto según el estado
//  - getListItemBpmTextColor(): Color del BPM según coincidencia
//  - getListItemKeyTextColor(): Color de la tonalidad
//  - updateKeyMatch(): Actualiza indicador de coincidencia de tonalidad
//  - updateTempoMatch(): Actualiza indicador de coincidencia de tempo
//  - isLoadedInDeck(): Verifica si la pista está cargada en un deck


//------------------------------------------------------------------------------------------------------------------
// ELEMENTOS PRINCIPALES
//------------------------------------------------------------------------------------------------------------------

// contactDelegate (Item) - Contenedor principal
//  Propiedades:
//  - screenFocus: Define el foco actual de la pantalla
//  - deckColor: Color del deck seleccionado
//  - textColor: Color del texto basado en selección
//  - isCurrentItem: Estado de selección del elemento
//  - browserFontSize: Tamaño de fuente adaptativo

// zebratrack (Rectangle) - Contenedor de información de pista
//  - Implementa el efecto zebra en la lista
//  - Contiene los campos de información de la pista
//  - Gestiona la disposición de elementos informativos

// firstFieldTrack (Rectangle) - Campo del nombre de pista
//  - Muestra el nombre de la pista
//  - Incluye icono de preparación (PrepListIcon)
//  - Visible solo para elementos tipo Track

// firstFieldFolder (Text) - Campo del nombre de carpeta
//  - Muestra el nombre de la carpeta
//  - Visible solo para elementos tipo Folder
//  - Elide para nombres largos

// trackTitleField (Text) - Campo del artista
//  - Muestra el nombre del artista
//  - Adaptable según tipo de elemento
//  - Ancho fijo de 140 pixels

// bpmField (Text) - Campo de BPM
//  - Muestra el tempo de la pista
//  - Color adaptativo según coincidencia con master
//  - Formato fijo sin decimales

// keyField (Text) - Campo de tonalidad
//  - Muestra la tonalidad musical
//  - Soporta formato Camelot
//  - Color según compatibilidad armónica

// ratingField (TrackRating) - Indicador de valoración
//  - Muestra la valoración de 0 a 5
//  - Colores adaptables según selección
//  - Visible solo para pistas

// trackImage (Rectangle) - Contenedor de imagen
//  - Muestra la carátula de la pista
//  - Indicadores de deck (A/B/C/D)
//  - Overlay para estados especiales (prelisten, prevPlayed)

// folderIcon (Image) - Icono de carpeta
//  - Muestra el icono para elementos tipo Folder
//  - ColorOverlay para estados de selección

//------------------------------------------------------------------------------------------------------------------

// Contenedor principal
Item {
  id: contactDelegate

  property int           screenFocus:           0
  property color         deckColor :            qmlBrowser.focusColor
  property color         textColor :            ListView.isCurrentItem ? deckColor : colors.colorFontListBrowser
  property bool          isCurrentItem :        ListView.isCurrentItem
  property string        prepIconColorPostfix:  (screenFocus < 2 && ListView.isCurrentItem) ? "Blue" : ((screenFocus > 1 && ListView.isCurrentItem) ? "White" : "Grey")
  readonly property int  textTopMargin:         1 // centers text vertically
  readonly property bool isLoaded:              (model.dataType == BrowserDataType.Track) ? model.loadedInDeck.length > 0 : false

  // visible: !ListView.isCurrentItem

  property color          keyMatchColor:        textColor
  property color          tempoMatchColor:      textColor
  property int            browserFontSize:      prefs.displayMoreItems ? fonts.middleFontSize : fonts.middleFontSizePlus

  AppProperty { id: masterClockBpm;    path: "app.traktor.masterclock.tempo"; onValueChanged: { updateMatchInfo(); } }
  AppProperty { id: masterKeyDisplay;  path: "app.traktor.decks." + (masterDeckId.value + 1) + ".content.musical_key"; onValueChanged: { updateMatchInfo(); }}
  AppProperty { id: masterDeckId;      path: "app.traktor.masterclock.source_id"; onValueChanged: { updateMatchInfo(); } }

  property real screenScale: prefs.screenScale

  height: prefs.displayMoreItems ? 25 * screenScale : 32 * screenScale

  anchors.left: parent.left
  anchors.right: parent.right

  Component.onCompleted:  { updateMatchInfo(); }

  // Contenedor para información de pista
  Rectangle {
    id: zebratrack
    // when changing colors here please remember to change it in the GridView in Templates/Browser.qml 
    color:  (index%2 == 0) ? colors.colorGrey08 : "transparent" 
    anchors.left: trackImage.right
    anchors.right: parent.right
    anchors.top: parent.top
    anchors.bottom: parent.bottom
    anchors.leftMargin: 3 * screenScale
    anchors.rightMargin: 3 * screenScale
    height: parent.height  

    // track name, toggles with folder name
    Rectangle {
      id: firstFieldTrack
      color:  (index%2 == 0) ? colors.colorGrey08 : "transparent" 
      anchors.left: parent.left
      anchors.top: parent.top
      anchors.bottom: parent.bottom
      anchors.topMargin: contactDelegate.textTopMargin
      // anchors.leftMargin: 37
      width: 190 * screenScale
      visible: (model.dataType == BrowserDataType.Track)

      //! Dummy text to measure maximum text lenght dynamically and adjust icons behind it.
      Text {
        id: textLengthDummy
        visible: false

        font.pixelSize: browserFontSize * screenScale
        font.family: prefs.normalFontName

        text: (model.dataType == BrowserDataType.Track) ? model.trackName  : ( (model.dataType == BrowserDataType.Folder) ? model.nodeName : "")
      }

      Text {
        id: firstFieldText
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        width: (textLengthDummy.width) > 180 ? 180 * screenScale : textLengthDummy.width
        // visible: false
        elide: Text.ElideRight
        text: textLengthDummy.text

        font.pixelSize: browserFontSize * screenScale
        font.family: prefs.normalFontName

        color: getListItemTextColor()
        verticalAlignment: Text.AlignVCenter
      }

      Image {
        id: prepListIcon
        visible: (model.dataType == BrowserDataType.Track) ? model.prepared : false
        source: "./../Images/PrepListIcon" + prepIconColorPostfix + "" + colors.inverted + ".png"
        anchors.left: firstFieldText.right 
        anchors.verticalCenter: parent.verticalCenter
        anchors.leftMargin: 2 * screenScale
        fillMode: Image.PreserveAspectFit
      }
    }   

    // Nombre de la carpeta
    Text {
      id: firstFieldFolder
      anchors.left: parent.left
      anchors.top: parent.top
      anchors.bottom: parent.bottom
      anchors.right: parent.right
      anchors.topMargin: contactDelegate.textTopMargin
      anchors.rightMargin: 5 * screenScale
      color: textColor
      clip: false // true
      text: (model.dataType == BrowserDataType.Folder) ? model.nodeName : ""

      font.pixelSize: browserFontSize * screenScale
      font.family: prefs.normalFontName

      elide: Text.ElideRight
      visible: (model.dataType != BrowserDataType.Track)
      verticalAlignment: Text.AlignVCenter
    }
  
    // Nombre del artista
    Text {
      id: trackTitleField
      anchors.leftMargin: 5 * screenScale
      anchors.left: (model.dataType == BrowserDataType.Track) ? firstFieldTrack.right : firstFieldFolder.right
      anchors.right: bpmField.left
      anchors.top: parent.top
      anchors.bottom: parent.bottom
      anchors.topMargin: contactDelegate.textTopMargin
      width: 140 * screenScale
      color: getListItemTextColor()
      clip: false // true
      text: (model.dataType == BrowserDataType.Track) ? model.artistName : ""

      font.pixelSize: browserFontSize * screenScale
      font.family: prefs.normalFontName

      elide: Text.ElideRight
      verticalAlignment: Text.AlignVCenter
    }  

    // BPM
    Text {
      id: bpmField
      anchors.right: tempoMatch.left    
      anchors.top: parent.top
      anchors.bottom: parent.bottom
      anchors.topMargin: contactDelegate.textTopMargin
      horizontalAlignment: Text.AlignRight
      verticalAlignment: Text.AlignVCenter
      width: 29 * screenScale
      color: getListItemBpmTextColor()
      clip: false // true
      text: (model.dataType == BrowserDataType.Track) ? model.bpm.toFixed(0) : ""
      visible: (model.dataType == BrowserDataType.Track)

      font.pixelSize: browserFontSize * screenScale
      font.family: prefs.normalFontName
    }  

    // Indicador de coincidencia de tempo
    Item {
      id : tempoMatch
      anchors.right:          keyField.left
      anchors.top:            parent.top
      anchors.bottom:         parent.bottom
      width:                  16 * screenScale
      visible: (model.dataType == BrowserDataType.Track) && prefs.displayMatchGuides

      Widgets.Triangle {
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter
        width:              8 * screenScale
        height:             8 * screenScale
        color:              masterDeckId.value >= 0 ? tempoMatchColor : textColor
        rotation:           model.bpm > masterClockBpm.value ? 180 : 0
        visible:            masterDeckId.value >= 0 && Math.round(Math.abs(masterClockBpm.value - model.bpm)) >= 1 && Math.round(Math.abs(masterClockBpm.value - model.bpm)) <= 4
        antialiasing:       false
      }

      Rectangle {
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter
        width:              8 * screenScale
        height:             width
        radius:             width * 0.5
        color:              masterDeckId.value >= 0 ? tempoMatchColor : textColor
        visible:            masterDeckId.value >= 0 && Math.round(Math.abs(masterClockBpm.value - model.bpm)) < 1
      }
    }  

    function colorForKey(keyIndex) {
      return colors.musicalKeyColors[keyIndex]
    }

    // Indicador de coincidencia de tonalidad
    Text {
      id: keyField

      anchors.right: keyMatchField.left
      anchors.top: parent.top
      anchors.bottom: parent.bottom
      anchors.topMargin: contactDelegate.textTopMargin

      horizontalAlignment: Text.AlignRight
      verticalAlignment: Text.AlignVCenter

      color: getListItemKeyTextColor()
      width: 28 * screenScale
      clip: false // true
      visible: (model.dataType == BrowserDataType.Track)
      text: (model.dataType == BrowserDataType.Track) ? utils.getKeyText(model.keyIndex, prefs.keyNotation) : ""

      font.pixelSize: browserFontSize * screenScale
      font.family: prefs.normalFontName
    }

    // Indicador de coincidencia de tonalidad
    Item {
      id : keyMatchField
      anchors.right:          ratingField.left
      anchors.top:            parent.top
      anchors.bottom:         parent.bottom
      visible: (model.dataType == BrowserDataType.Track) && prefs.displayMatchGuides
      width:                  16 * screenScale

      Widgets.Triangle {
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter
        width:              8 * screenScale
        height:             8 * screenScale
        color:              keyMatchColor
        rotation:           utils.getMasterKeyOffset(masterKeyDisplay.value, model.key) > 0 ? 180 : 0
        visible:            masterDeckId.value >= 0 && Math.abs(utils.getMasterKeyOffset(masterKeyDisplay.value, model.key)) > 1
        antialiasing:       false
      }

      Rectangle {
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter
        width:              8 * screenScale
        height:             width
        radius:             width * 0.5
        color:              keyMatchColor
        visible:            masterDeckId.value >= 0 && Math.abs(utils.getMasterKeyOffset(masterKeyDisplay.value, model.key)) <= 1
      }
    }

    // Indicador de valoración de pista
    Widgets.TrackRating {
      id: ratingField
      visible:     (model.dataType == BrowserDataType.Track)
      rating:      (model.dataType == BrowserDataType.Track) ? ((model.rating == "") ? 0 : model.rating ) : 0
      anchors.right: parent.right
      anchors.rightMargin: 2 * screenScale
      anchors.verticalCenter: parent.verticalCenter
      height: 13 * screenScale
      width: 20 * screenScale
      bigLineColor:   contactDelegate.isCurrentItem ? ((contactDelegate.screenFocus < 2) ? colors.colorDeckBright       : colors.colorWhite )    : colors.colorGrey64
      smallLineColor: contactDelegate.isCurrentItem ? ((contactDelegate.screenFocus < 2) ? colors.colorDeckBlueBright50Full : colors.colorGrey32 )   : colors.colorGrey32
    }
    
    ListHighlight {
      anchors.fill: parent
      visible: contactDelegate.isCurrentItem
      anchors.rightMargin: 0 * screenScale 
    }
  }

  // Imagen de la pista
  Rectangle {
    id: trackImage 
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.leftMargin: 3 * screenScale              
    width: parent.height
    height: parent.height
    color: (model.coverUrl != "") ? "transparent" : ((contactDelegate.screenFocus < 2) ? colors.colorDeckBlueBright50Full : colors.colorGrey128 )
    visible: (model.dataType == BrowserDataType.Track)

    // Imagen de la portada
    Image {
      id: cover
      anchors.fill: parent
      source: (model.dataType == BrowserDataType.Track) ? ("image://covers/" + model.coverUrl ) : ""
      fillMode: Image.PreserveAspectFit
      clip: false // true
      cache: false
      sourceSize.width: width
      sourceSize.height: height
      // the image either provides the cover of the track, or if not available the traktor logo on colored background ( opacity == 0.3)
      opacity: (model.coverUrl != "") ? 1.0 : 0.3
    }

    // Aplica un efecto de oscurecimiento a las portadas no seleccionadas
    Rectangle {
      id: darkener
      anchors.fill: parent
      color: {
          if (model.prelisten) {
            return colors.browser.prelisten;
          }
          else {
            if (model.prevPlayed) {
              return colors.colorBlack88;
            } else if (!isCurrentItem) {
              return colors.colorBlack81;
            } else if (isCurrentItem) {
              return "transparent";
            } else {
              return colors.colorBlack60;
            }
          }
        }
      }

      // Borde de la portada
      Rectangle {
        id: cover_border
        anchors.fill: trackImage
        color: "transparent"
        border.width: 1 * screenScale
        border.color: isCurrentItem ? colors.colorWhite16 : colors.colorGrey16 // semi-transparent border on artwork
        visible: (model.coverUrl != "")
      }

      // Icono de vista previa
      Image {
        anchors.centerIn: trackImage
        width: 17 * screenScale
        height: 17 * screenScale
        source: "../Images/PreviewIcon_Big" + colors.inverted + ".png"
        fillMode: Image.PreserveAspectFit
        clip: false // true
        cache: false
        sourceSize.width: width
        sourceSize.height: height
        visible: (model.dataType == BrowserDataType.Track) ? model.prelisten : false
      }

      // Icono de pista previamente reproducida
      Image {
        anchors.centerIn: trackImage
        width: 17 * screenScale
        height: 17 * screenScale
        source: "../Images/PreviouslyPlayed_Icon"+ colors.inverted + ".png"
        fillMode: Image.PreserveAspectFit
        clip: false // true
        cache: false
        sourceSize.width: width
        sourceSize.height: height
        visible: (model.dataType == BrowserDataType.Track) ? (model.prevPlayed && !model.prelisten) : false
      }
    
      // Icono de pista cargada en el Deck A
      Image {
        id: loadedDeckA
        source: "../Images/LoadedDeckA"+ colors.inverted + ".png"
        anchors.top: parent.top
        anchors.left: parent.left
        sourceSize.width: 11 * screenScale
        sourceSize.height: 11 * screenScale
        visible: (model.dataType == BrowserDataType.Track && parent.isLoadedInDeck("A"))
        fillMode: Image.PreserveAspectFit
      }

      // Icono de pista cargada en el Deck B
      Image {
        id: loadedDeckB
        source: "../Images/LoadedDeckB"+ colors.inverted + ".png"
        anchors.top: parent.top
        anchors.right: parent.right
        sourceSize.width: 11 * screenScale
        sourceSize.height: 11 * screenScale
        visible: (model.dataType == BrowserDataType.Track && parent.isLoadedInDeck("B"))
        fillMode: Image.PreserveAspectFit
      }

      // Icono de pista cargada en el Deck C
      Image {
        id: loadedDeckC
        source: "../Images/LoadedDeckC"+ colors.inverted + ".png"
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        sourceSize.width: 11 * screenScale
        sourceSize.height: 11 * screenScale
        visible: (model.dataType == BrowserDataType.Track && parent.isLoadedInDeck("C"))
        fillMode: Image.PreserveAspectFit
      }

      // Icono de pista cargada en el Deck D
      Image {
        id: loadedDeckD
        source: "../Images/LoadedDeckD"+ colors.inverted + ".png"
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        sourceSize.width: 11 * screenScale
        sourceSize.height: 11 * screenScale
        visible: (model.dataType == BrowserDataType.Track && parent.isLoadedInDeck("D"))
        fillMode: Image.PreserveAspectFit
      }

      // Función para verificar si la pista está cargada en un Deck específico
      function isLoadedInDeck(deckLetter) {
        return model.loadedInDeck.indexOf(deckLetter) != -1;
      }
    }

    // Icono de carpeta
    Image {
      id:       folderIcon
      source:   (model.dataType == BrowserDataType.Folder) ? ("image://icons/" + model.nodeIconId ) : ""
      width:    parent.height
      height:   parent.height
      fillMode: Image.PreserveAspectFit
      anchors.top: parent.top
      anchors.left: parent.left
      anchors.leftMargin: 3 * screenScale
      clip: false // true
      cache:    false
      visible:  false
    }

    // Aplica un color de superposición al icono de carpeta
    ColorOverlay {
      id: folderIconColorOverlay
      color: isCurrentItem == false ? colors.colorFontListBrowser : contactDelegate.deckColor // unselected vs. selected
      anchors.fill: folderIcon
      source: folderIcon
    }

  // Oculta el borde de la portada
  function hideCoverBorder() {
    if (model.dataType == BrowserDataType.Folder) {
      return false
    }
    return true
  }

  // Obtiene el color del texto de la tonalidad
  function getListItemKeyTextColor() {
    if (model.dataType != BrowserDataType.Track) {
      return textColor;
    }

    if ((model.key == "none") || (model.key == "None")) {
        return textColor;
    } else {
        return zebratrack.colorForKey(model.keyIndex) ;
    }

    return textColor;
  }

  // Obtiene el color del texto del BPM según compatibilidad de mezcla
  function getListItemBpmTextColor() {
    if (model.dataType != BrowserDataType.Track) {
      return textColor;
    }

    const masterBpm = masterClockBpm.value;
    const trackBpm = model.bpm;
    
    // Si no hay BPM válido
    if (!masterBpm || !trackBpm) return textColor;

    // Calcular diferencia absoluta y porcentual
    const bpmDiff = Math.abs(masterBpm - trackBpm);
    const bpmPercentDiff = (bpmDiff / masterBpm) * 100;

    // Rangos de compatibilidad mejorados
    if (bpmDiff <= 1 || bpmPercentDiff <= 0.8) {
        return colors.color07MusicalKey;  // Verde - Mezcla perfecta
    } 
    else if (bpmDiff <= 3 || bpmPercentDiff <= 2.5) {
        return colors.color04MusicalKey;  // Amarillo - Mezcla fácil
    }
    else if (bpmDiff <= 6 || bpmPercentDiff <= 5) {
        return colors.color02MusicalKey;  // Naranja - Mezcla posible
    }
    // Casos especiales para doubles/halves (útil para drum&bass/dubstep)
    else if (Math.abs(trackBpm/2 - masterBpm) <= 1 || 
             Math.abs(trackBpm*2 - masterBpm) <= 2) {
        return colors.color04MusicalKey;  // Amarillo - Compatible double/half tempo
    }
    
    return colors.color01MusicalKey;  // Rojo - Mezcla difícil
  }

  // Obtiene el color del texto de la lista
  function getListItemTextColor() {
    if (model.dataType != BrowserDataType.Track) {
        return textColor;
    } 

    if (model.isPlaying) {
        return colors.colorFontGreen;  // Verde brillante - Pista activa
    }

    if (model.prevPlayed && !model.prelisten) {
        return colors.colorGreen50Full;
    }

    // Pista cargada en algún deck
    if (model.loadedInDeck.length > 0) {
        // Si está cargada en múltiples decks
        if (model.loadedInDeck.length > 1) {
            return colors.colorFontOrange;  // Naranja - Advertencia de duplicado
        }
        return colors.colorGreen50Full;  // Verde medio - Cargada pero no activa
    }

    return textColor;
  }

  // Actualiza el color de coincidencia de tonalidad según compatibilidad armónica
  function updateKeyMatch() {
    if (masterDeckId.value < 0) return;
    
    const masterKey = masterKeyDisplay.value;
    const trackKey = model.key;
    
    // Si alguna key es inválida o "none"
    if (!masterKey || !trackKey || masterKey === "none" || trackKey === "none") {
        keyMatchColor = textColor;
        return;
    }

    // Obtener información de las keys
    const offset = utils.getMasterKeyOffset(masterKey, trackKey);
    const isMasterMinor = masterKey.includes('m');
    const isTrackMinor = trackKey.includes('m');
    const modeChange = isMasterMinor !== isTrackMinor;

    // Compatibilidad armónica perfecta
    if (offset === 0) {
        keyMatchColor = colors.color07MusicalKey;  // Verde brillante - Misma key
        return;
    }

    // Transiciones armónicas comunes
    switch (Math.abs(offset)) {
        case 1:  // Semitono arriba/abajo
            keyMatchColor = modeChange ? 
                colors.color02MusicalKey :   // Naranja - Cambio de modo más semitono
                colors.color04MusicalKey;    // Amarillo - Solo semitono
            break;
            
        case 7:  // Quinta perfecta
            keyMatchColor = colors.color07MusicalKey;  // Verde - Transición armónica perfecta
            break;
            
        case 5:  // Cuarta perfecta
        case 8:  // Sexta menor
            keyMatchColor = colors.color04MusicalKey;  // Amarillo - Transición armónica buena
            break;
            
        case 3:  // Tercera menor
        case 4:  // Tercera mayor
            keyMatchColor = modeChange ?
                colors.color02MusicalKey :   // Naranja - Cambio de modo más tercera
                colors.color04MusicalKey;    // Amarillo - Solo tercera
            break;
            
        case 2:  // Tono entero
        case 6:  // Tritono
            keyMatchColor = colors.color02MusicalKey;  // Naranja - Transición creativa
            break;
            
        default:
            keyMatchColor = colors.color01MusicalKey;  // Rojo - Mezcla difícil
    }

    // Ajuste por energía (si está disponible)
    if (model.energy && masterEnergy.value) {
        const energyDiff = Math.abs(model.energy - masterEnergy.value);
        if (energyDiff > 3) {
            keyMatchColor = darkenColor(keyMatchColor, 0.7); // Oscurecer color si hay mucha diferencia de energía
        }
    }
  }

  // Función helper para oscurecer colores
  function darkenColor(color, factor) {
    // Implementación de oscurecimiento de color
    return color; // Placeholder - implementar lógica real de oscurecimiento
  }

  // Actualiza el color de coincidencia de tempo según compatibilidad rítmica
  function updateTempoMatch() {
    if (masterDeckId.value < 0) return;

    const masterBpm = masterClockBpm.value;
    const trackBpm = model.bpm;
    
    // Si no hay BPM válido
    if (!masterBpm || !trackBpm) {
        tempoMatchColor = textColor;
        return;
    }

    // Calcular diferencias de BPM
    const bpmDiff = Math.abs(masterBpm - trackBpm);
    const bpmPercentDiff = (bpmDiff / masterBpm) * 100;
    
    // Comprobar compatibilidad double/half tempo
    const isDoubleCompatible = Math.abs(trackBpm/2 - masterBpm) <= 1;
    const isHalfCompatible = Math.abs(trackBpm*2 - masterBpm) <= 2;
    const isThirdCompatible = Math.abs((trackBpm/3) - masterBpm) <= 1;
    const isTripleCompatible = Math.abs((trackBpm*3) - masterBpm) <= 3;

    // Determinar género basado en BPM (aproximado)
    const genre = getApproximateGenre(trackBpm);
    
    // Ajustar tolerancias según género
    const tolerances = getGenreTolerances(genre);

    // Asignar color según compatibilidad
    if (bpmDiff <= tolerances.perfect || bpmPercentDiff <= 0.8) {
        tempoMatchColor = colors.color07MusicalKey;  // Verde - Mezcla perfecta
    }
    else if (isDoubleCompatible || isHalfCompatible) {
        tempoMatchColor = colors.color07MusicalKey;  // Verde - Compatible double/half
    }
    else if (isThirdCompatible || isTripleCompatible) {
        tempoMatchColor = colors.color04MusicalKey;  // Amarillo - Compatible third/triple
    }
    else if (bpmDiff <= tolerances.good || bpmPercentDiff <= tolerances.goodPercent) {
        tempoMatchColor = colors.color04MusicalKey;  // Amarillo - Mezcla buena
    }
    else if (bpmDiff <= tolerances.moderate || bpmPercentDiff <= tolerances.moderatePercent) {
        tempoMatchColor = colors.color02MusicalKey;  // Naranja - Mezcla moderada
    }
    else {
        tempoMatchColor = colors.color01MusicalKey;  // Rojo - Mezcla difícil
    }
  }

  // Helper: Obtener género aproximado basado en BPM
  function getApproximateGenre(bpm) {
    if (bpm < 90) return "downtempo";
    if (bpm < 115) return "hiphop";
    if (bpm < 125) return "house";
    if (bpm < 135) return "techno";
    if (bpm < 145) return "hardtechno";
    if (bpm < 165) return "drumAndBass";
    return "hardcore";
  }

  // Helper: Obtener tolerancias según género
  function getGenreTolerances(genre) {
    const tolerances = {
        downtempo: { perfect: 1, good: 2, moderate: 4, goodPercent: 2, moderatePercent: 5 },
        hiphop: { perfect: 1, good: 3, moderate: 5, goodPercent: 2.5, moderatePercent: 6 },
        house: { perfect: 1, good: 3, moderate: 6, goodPercent: 2.5, moderatePercent: 5 },
        techno: { perfect: 1, good: 4, moderate: 8, goodPercent: 3, moderatePercent: 6 },
        hardtechno: { perfect: 2, good: 5, moderate: 10, goodPercent: 3.5, moderatePercent: 7 },
        drumAndBass: { perfect: 2, good: 6, moderate: 12, goodPercent: 3.5, moderatePercent: 7 },
        hardcore: { perfect: 2, good: 8, moderate: 15, goodPercent: 4, moderatePercent: 8 }
    };
    
    return tolerances[genre] || tolerances.house; // House como default
  }

  // Actualiza la información de coincidencia
  function updateMatchInfo() {
    updateKeyMatch();
    updateTempoMatch();
  }


//------------------------------------------------------------------------------------------------------------------
// Control de eventos de mouse para el ListView
//------------------------------------------------------------------------------------------------------------------

  MouseArea {
    anchors.fill: parent
    hoverEnabled: true
    
    // Permitir que el ListView reciba eventos de wheel para scroll
    propagateComposedEvents: true
    
    // Timer para detectar presión sostenida
    Timer {
      id: pressTimer
      interval: 500 // medio segundo para la presión sostenida
      repeat: false
      onTriggered: {
        // Primero seleccionar este item antes de cualquier acción
        browser.changeCurrentIndex(index);
        
        if (model.dataType == BrowserDataType.Folder) {
          // Si es carpeta, usar enterNode
          qmlBrowser.enterNode = true;
        } else {
          // Si es track, cargarlo
          var movedDown = browser.enterNode(qmlBrowser.focusDeckId, index);
          // Si no se movió hacia abajo, significa que se cargó una pista
          if (!movedDown) {
            // Emitir la señal trackLoaded
            if (typeof qmlBrowser.trackLoaded === "function") {
              qmlBrowser.trackLoaded(qmlBrowser.focusDeckId);
            }
            // Cerrar el navegador después de un breve retraso
            closeAfterLoad.start();
          }
        }
      }
    }
    
    onWheel: function(wheel) {
      // Propagar el evento de wheel al ListView padre
      wheel.accepted = false;
    }
    
    onClicked: {
      // Seleccionar este item con un click simple
      browser.changeCurrentIndex(index);
    }
    
    onPressed: {
      // Primero seleccionar este item antes de cualquier acción
      browser.changeCurrentIndex(index);

      // Iniciar el timer cuando se presiona
      pressTimer.start();
      
      // Mostrar el indicador de carga progresivamente
      loadIndicatorAnimation.start();
    }
    
    onReleased: {
      // Si se suelta antes de que se complete el timer, no cargar
      if (pressTimer.running) {
        pressTimer.stop();
        // Ocultar el indicador inmediatamente
        loadIndicatorAnimation.stop();
        loadIndicator.opacity = 0;
      }
    }
    
    onCanceled: {
      // Asegurarse de que el timer se detiene si se cancela el gesto
      pressTimer.stop();
      // Ocultar el indicador inmediatamente
      loadIndicatorAnimation.stop();
      loadIndicator.opacity = 0;
    }
  }

  // Indicador visual de carga
  Rectangle {
    id: loadIndicator
    anchors.fill: parent
    color: qmlBrowser.focusColor
    opacity: 0
    z: -1

    // Borde para el indicador
    Rectangle {
      anchors.fill: parent
      color: "transparent"
      border.width: 2 * screenScale
      border.color: colors.colorWhite
    }

    // Animación de fundido para el indicador
    Behavior on opacity {
      NumberAnimation { duration: 100 }
    }
  }

  // Animación para mostrar el progreso de carga
  PropertyAnimation {
    id: loadIndicatorAnimation
    target: loadIndicator
    property: "opacity"
    from: 0
    to: 0.3
    duration: 500 // Mismo tiempo que el pressTimer
  }

  // Timer para cerrar el navegador después de la carga
  Timer {
    id: closeAfterLoad
    interval: 300 // Breve retraso para mostrar retroalimentación visual
    repeat: false
    onTriggered: {
      // Emitir la señal trackLoaded
      if (typeof qmlBrowser.trackLoaded === "function") {
        qmlBrowser.trackLoaded(qmlBrowser.focusDeckId);
      }
    }
  }
}

