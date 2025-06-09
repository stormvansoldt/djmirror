import CSI 1.0
import QtQuick
import Qt5Compat.GraphicalEffects
import Traktor.Gui 1.0 as Traktor

import "../Defines" as Defines
import "./Views" as Views
import "./ViewModels" as ViewModels

//----------------------------------------------------------------------------------------------------------------------
//  DECK SCREEN - Pantalla que gestiona la visualización de los diferentes tipos de decks
//
//  ELEMENTOS PRINCIPALES Y COLORES:
//
//  1. Loader Principal (loader)
//     - Contenedor dinámico que carga los diferentes tipos de deck
//     - Hereda colores del componente cargado
//     - Ocupa todo el espacio del padre (anchors.fill: parent)
//
//  2. Tipos de Deck (gestionados por content.state):
//     a. Empty Deck
//        - Vista básica cuando no hay contenido
//        - Hereda colores de Views/EmptyDeck.qml
//
//     b. Track Deck
//        - Vista para reproducción de pistas
//        - Hereda colores de Views/TrackDeck.qml
//        - Incluye waveform, controles y metadata
//
//     c. Stem Deck
//        - Vista para pistas stem (multicanal)
//        - Hereda colores de Views/StemDeck.qml
//        - Incluye controles por stem y waveforms
//
//     d. Remix Deck
//        - Vista para samples y loops
//        - Hereda colores de Views/RemixDeck.qml
//        - Incluye grid de samples y controles
//
//     e. Live Input / Direct Thru
//        - Vista para entrada en directo
//        - Usa el mismo diseño que Empty Deck
//
//  ESTADOS:
//  - Los estados determinan qué componente se carga en el loader
//  - La transición entre estados es inmediata
//  - El estado inicial se determina por deckType.description o directThruID.value
//
//  NOTAS:
//  - Los colores específicos se definen en cada componente hijo
//  - El diseño es responsive y se adapta al tamaño del padre
//  - Cada tipo de deck tiene su propia paleta de colores y diseño
//
//----------------------------------------------------------------------------------------------------------------------


Item {
    id: deckscreen

    property int deckId: 1

    AppProperty { id: deckType; path: "app.traktor.decks." + deckId + ".type" }
    AppProperty { id: directThruID; path: "app.traktor.decks." + deckId + ".direct_thru" }

    ViewModels.DeckInfo {
        id: deckInfoModel
        deckId: deckscreen.deckId
    }

    Component {
        id: emptyDeckComponent
        Views.EmptyDeck {
            anchors.fill: parent
        }
    }

    Component {
        id: trackDeckComponent
        Views.TrackDeck {
            deckInfo: deckInfoModel
            anchors.fill: parent
        }
    }

    Component {
        id: stemDeckComponent
        Views.StemDeck {
            deckInfo: deckInfoModel
            anchors.fill: parent
        }
    }

    Component {
        id: remixDeckComponent
        Views.RemixDeck {
            deckInfo: deckInfoModel
            anchors.fill: parent
        }
    }

    Loader {
        id: loader
        active: true
        visible: true
        anchors.fill: parent
        sourceComponent: trackDeckComponent
    }

    Item {
        id: content
        state: "Empty Deck"

        Component.onCompleted: {
            content.state = Qt.binding(function () {
                return directThruID.value ? "Direct Thru" : deckType.description;
            });
        }

        states: [
            State {
                name: "Empty Deck"
                PropertyChanges {
                    target: loader
                    sourceComponent: emptyDeckComponent
                }
            },
            State {
                name: "Track Deck"
                PropertyChanges {
                    target: loader
                    sourceComponent: trackDeckComponent
                }
            },
            State {
                name: "Stem Deck"
                PropertyChanges {
                    target: loader
                    sourceComponent: stemDeckComponent
                }
            },
            State {
                name: "Remix Deck"
                PropertyChanges {
                    target: loader
                    sourceComponent: remixDeckComponent
                }
            },
            State {
                name: "Live Input"
                PropertyChanges {
                    target: loader
                    sourceComponent: emptyDeckComponent
                }
            },
            State {
                name: "Direct Thru"
                PropertyChanges {
                    target: loader
                    sourceComponent: emptyDeckComponent
                }
            }
        ]
    }
}
