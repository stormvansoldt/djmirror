import CSI 1.0
import QtQuick

import '../../../../Defines'
import '../../Views/Deck/' as DeckTypes

// Deck.qml
// 
// Componente principal que representa un deck en Traktor. Maneja la visualización y 
// comportamiento de diferentes tipos de decks (Track, Remix, Stem, Live Input, Direct Thru).
// 
// @property {int} deckId - ID del deck (0=A, 1=B, 2=C, 3=D)
// @property {int} remixDeckRowShift - Desplazamiento de filas para el Remix Deck
// @property {string} deckSize - Tamaño del deck ("small", "medium", "large")
// @property {bool} showLoopSize - Indica si se muestra el tamaño del loop
// @property {int} zoomLevel - Nivel de zoom de la forma de onda
// @property {bool} isInEditMode - Indica si el deck está en modo edición
// @property {string} propertiesPath - Ruta base para las propiedades del deck
// @property {int} stemStyle - Estilo de visualización para Stem Decks

Item {
    id: view

    property real screenScale: prefs.screenScale

    property int    deckId: 0

    property int    remixDeckRowShift: 1
    property string deckSize: "medium"
    property bool   showLoopSize: false
    property int    zoomLevel: 1
    property bool   isInEditMode: false
    property string propertiesPath: ""
    property int    stemStyle: StemStyle.track
    
    // Propiedades calculadas
    property bool   directThru: directThruID.value
    property string deckContentState: deckType.description

    //--------------------------------------------------------------------------------------------------------------------
    // Propiedades de la App
    //--------------------------------------------------------------------------------------------------------------------
    // AppProperty deckType
    // Tipo de deck actual (Track, Remix, Stem, etc.)
    // @path app.traktor.decks.[deckId+1].type
    AppProperty { 
        id: deckType
        path: "app.traktor.decks." + (deckId + 1) + ".type" 
    }
    

    // AppProperty directThruID
    // Indica si el deck está configurado para Direct Thru
    // @path app.traktor.decks.[deckId+1].direct_thru
    AppProperty { 
        id: directThruID
        path: "app.traktor.decks." + (deckId + 1) + ".direct_thru" 
    }

    //--------------------------------------------------------------------------------------------------------------------
    // Componentes del Deck
    //--------------------------------------------------------------------------------------------------------------------
    
    // DeckHeader
    // Encabezado del deck que muestra información de la pista y controles
    DeckTypes.DeckHeader {
        id: deckHeader
        anchors {
            top: view.top
            left: view.left
            right: view.right
        }
        deck_Id: view.deckId
    }

    // Contenedor principal Flipable
    // Contenedor que permite la animación de volteo entre diferentes tipos de deck
    // Usa dos Loaders para cargar los componentes de manera eficiente
    Flipable {
        id: flipable
        anchors {
            top: deckHeader.bottom
            left: parent.left
            right: parent.right
            bottom: parent.bottom
        }

        Behavior on anchors.topMargin { 
            NumberAnimation { duration: durations.deckTransition } 
        }

        // Cara Frontal (Track Deck)
        front: Item {
            id: frontSide
            anchors.fill: parent
            // Loader frontal
            // Carga el componente Track Deck por defecto
            Loader {
                id: loader1
                anchors.fill: parent
                sourceComponent: trackDeckComponent
                active: true
                visible: true
            }
        }

        // Cara Posterior (Remix Deck)
        back: Item {
            id: backSide
            anchors.fill: parent
            
            // Loader posterior
            // Carga el componente Remix Deck por defecto
            Loader {
                id: loader2
                anchors.fill: parent
                sourceComponent: remixDeckComponent
                active: true
                visible: true
            }
        }

        // Transformación de rotación
        transform: Rotation {
            id: rotation
            origin {
                x: 0.5 * flipable.width
                y: 0.5 * flipable.height
            }
            axis { x: 1; y: 0; z: 0 }
            angle: 0
            
            Behavior on angle { 
                NumberAnimation { duration: 1000 } 
            }
        }
    }

    //--------------------------------------------------------------------------------------------------------------------
    // Definición de Componentes
    //--------------------------------------------------------------------------------------------------------------------
    // Deck vacío para Live Input y Direct Thru
    Component { 
        id: emptyDeckComponent
        DeckTypes.EmptyDeck { 
            id: emptyDeck
            deckSizeState: view.deckSize 
        } 
    }

    // Deck principal para reproducción de pistas
    Component { 
        id: trackDeckComponent
        DeckTypes.TrackDeck { 
            id: trackDeck
            deckId: view.deckId
            deckSizeState: view.deckSize
            zoomLevel: view.zoomLevel
            showLoopSize: view.showLoopSize
            isInEditMode: view.isInEditMode
            stemStyle: view.stemStyle
            propertiesPath: view.propertiesPath 
        } 
    }

    // Deck para reproducción de stems
    Component { 
        id: stemDeckComponent
        DeckTypes.TrackDeck { 
            id: stemDeck
            deckId: view.deckId
            deckSizeState: view.deckSize
            zoomLevel: view.zoomLevel
            showLoopSize: view.showLoopSize
            isInEditMode: view.isInEditMode
            stemStyle: view.stemStyle
            propertiesPath: view.propertiesPath 
        } 
    }

    // Deck para reproducción de remixes
    Component {
        id: remixDeckComponent
        DeckTypes.RemixDeck {
            id: remixDeck
            remixDeckPropertyPath: "app.traktor.decks." + (deckId + 1) + ".remix."
            deckId: view.deckId
            sizeState: view.deckSize
            rowShift: remixDeckRowShift
            showLoopSize: view.showLoopSize
            height: 0
            visible: true
        }
    }

    //--------------------------------------------------------------------------------------------------------------------
    // Gestión de Estados
    // Maneja las transiciones entre diferentes tipos de deck
    //--------------------------------------------------------------------------------------------------------------------
    Item {
        id: content
        state: "Track Deck"
        property string prevState: "Track Deck"
        property bool flipped: false

        Component.onCompleted: {
            content.state = Qt.binding(function() {
                return directThruID.value ? "Direct Thru" : deckType.description
            })
        }

        states: [
            State { name: "Track Deck" },
            State { name: "Stem Deck" },
            State { name: "Remix Deck" },
            State { name: "Live Input" },
            State { name: "Direct Thru" }
        ]

        // Transiciones
        // Define las animaciones entre estados de deck
        // Cada transición incluye:
        // 1. Carga del nuevo componente
        // 2. Activación del loader correspondiente
        // 3. Animación de rotación
        // 4. Desactivación del loader anterior
        // 5. Actualización del estado flipped
        transitions: [
          // the sequntial animations are necessary to load the correct deck before flipping sides.
          Transition {
            to: "Track Deck"
            SequentialAnimation {
              PropertyAction  { target: content.flipped ? loader1 : loader2; property: "sourceComponent"; value: trackDeckComponent               }
              PropertyAction  { target: content.flipped ? loader1 : loader2; property: "active";          value: true                             }
              NumberAnimation { target: rotation;                            property: "angle";           to:    content.flipped ? 0 : 180; duration: 100 }
              PropertyAction  { target: content.flipped ? loader2 : loader1; property: "active";          value: false                            }
              PropertyAction  { target: content;                             property: "flipped";         value: !content.flipped                         }
            }
          },
          Transition {
            to: "Remix Deck"
            SequentialAnimation {
              PropertyAction  { target: content.flipped ? loader1 : loader2; property: "sourceComponent"; value: remixDeckComponent            }
              PropertyAction  { target: content.flipped ? loader1 : loader2; property: "active";          value: true                          }
              NumberAnimation { target: rotation;                            property: "angle";           to: content.flipped ? 0 : 180; duration: 100 }
              PropertyAction  { target: content.flipped ? loader2 : loader1; property: "active";          value: false                         }
              PropertyAction  { target: content;                             property: "flipped";         value: !content.flipped                      }
            }
          },
          Transition {
            to: "Stem Deck"
            SequentialAnimation {
              PropertyAction  { target: content.flipped ? loader1 : loader2; property: "sourceComponent"; value: stemDeckComponent            }
              PropertyAction  { target: content.flipped ? loader1 : loader2; property: "active";          value: true                          }
              NumberAnimation { target: rotation;                            property: "angle";           to: content.flipped ? 0 : 180; duration: 100 }
              PropertyAction  { target: content.flipped ? loader2 : loader1; property: "active";          value: false                         }
              PropertyAction  { target: content;                             property: "flipped";         value: !content.flipped              }
            }
          },
          Transition {
            to: "Live Input"
            SequentialAnimation {
              PropertyAction  { target: content.flipped ? loader1 : loader2; property: "sourceComponent"; value: emptyDeckComponent               }
              PropertyAction  { target: content.flipped ? loader1 : loader2; property: "active";          value: true                             }
              NumberAnimation { target: rotation;                            property: "angle";           to:    content.flipped  ? 0 : 180; duration: 100 }
              PropertyAction  { target: content.flipped ? loader2 : loader1; property: "active";          value: false                            }
              PropertyAction  { target: content;                             property: "flipped";         value: !content.flipped                 }
            }
          },
          Transition {
            to: "Direct Thru"
            SequentialAnimation {
              PropertyAction  { target: content.flipped ? loader1 : loader2; property: "sourceComponent"; value: emptyDeckComponent               }
              PropertyAction  { target: content.flipped ? loader1 : loader2; property: "active";          value: true                             }
              NumberAnimation { target: rotation;                            property: "angle";           to:    content.flipped  ? 0 : 180; duration: 100 }
              PropertyAction  { target: content.flipped ? loader2 : loader1; property: "active";          value: false                            }
              PropertyAction  { target: content;                             property: "flipped";         value: !content.flipped                 }
            }
          }
      ]
    }

    //--------------------------------------------------------------------------------------------------------------------
    // Estados del Deck
    //--------------------------------------------------------------------------------------------------------------------
    
    state: deckSize

    // Estados del Deck
    // Define los diferentes tamaños y configuraciones visuales del deck
    // - small: Deck minimizado
    // - medium: Tamaño estándar
    // - large: Deck maximizado
    states: [
        State {
            name: "small"
            PropertyChanges { target: deckHeader; headerState: "small" }
            PropertyChanges { target: flipable; anchors.topMargin: -3 * screenScale }  // Escalar margen
        },
        State {
            name: "medium"
            PropertyChanges { target: deckHeader; headerState: "large" }
            PropertyChanges { target: flipable; anchors.topMargin: 0 }
        },
        State {
            name: "large"
            PropertyChanges { target: deckHeader; headerState: "large" }
            PropertyChanges { target: flipable; anchors.topMargin: 0 }
        }
    ]
}
