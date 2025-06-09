import QtQuick
import QtQuick.Window 2.15

import CSI 1.0
import Traktor.Gui 1.0 as Traktor

// Plugin avanzado con overlay interactivo
QtObject {
    id: examplePlugin

    // Información del plugin
    property string name: "Deck Info Plugin"
    property string fileName: "ExamplePlugin"
    property string version: "1.0.5"
    property string author: "DJ Tools"
    property string description: "Show advanced information of the current track"
    
    // Estado del plugin
    property bool isEnabled: true
    property bool isInitialized: false
    
    // Referencia a la vista actual
    property var currentView: null
    property var overlayInstance: null
    
    // Datos del deck
    property int deckId: 0
    property string trackTitle: "Sin título"
    property string trackArtist: "Sin artista"
    property real bpm: 0.0
    property real playPosition: 0.0
    
    // Referencia al objeto prefs para logging
    property var prefs: QtObject {
        function log(level, message) {
            prefs.log("INFO", "[PluginManager] " + level + ": " + message);
        }
    }  

    property real screenScale: 1.0

    // Se llama cuando el plugin se carga
    function onLoad() {

    }
    
    // Se llama cuando el plugin se inicializa en una vista
    function initializeInView(view) {
        if (!view) {
            return;
        }
        
        currentView = view;
        
        // Obtener el deckId de la vista si está disponible
        if (view.focusDeckId !== undefined) {
            deckId = view.focusDeckId;
        }
        
        try {
            // Intentar cargar el overlay desde archivo externo primero
            var component = Qt.createComponent("PluginOverlay.qml");
            
            if (component.status === Component.Ready) {
                // Crear la instancia del overlay
                overlayInstance = component.createObject(currentView, {
                    "title": "TRAKTOR DECK INFO",
                    "trackTitle": trackTitle,
                    "trackArtist": trackArtist,
                    "trackBpm": bpm,
                    "playProgress": 0.0,
                    "isPlaying": false,
                    "enableGlowEffect": true,
                    "enableDropShadow": true,
                    "screenScale": examplePlugin.screenScale,
                    "_isActive": true
                });
                
            } else if (component.status === Component.Error) {

            } else {

            }
        } catch (e) {

        }
    }
    
    // Actualizar información de la pista
    function updateTrackInfo() {
        if (!isInitialized || !overlayInstance) return;
        
        // Simulamos información cambiante
        bpm = 125 + (Math.random() * 5);
        
        // Actualizamos la pista cada cierto tiempo (simulado)
        if (Math.random() > 0.8) {
            var tracks = [
                {title: "Sunset Dreams", artist: "Deep Wave", album: "Midnight Sessions"},
                {title: "Electric Motion", artist: "Pulse Beat", album: "Neon Drive"},
                {title: "Neon Lights", artist: "Night Runner", album: "City Glow"},
                {title: "Midnight Drive", artist: "Synthwave", album: "Retro Future"},
                {title: "Urban Jungle", artist: "City Beats", album: "Downtown"}
            ];
            
            var track = tracks[Math.floor(Math.random() * tracks.length)];
            trackTitle = track.title;
            trackArtist = track.artist;
            var trackAlbum = track.album;
        }
        
        // Simulamos progreso y estado de reproducción
        playPosition = (playPosition + 0.01) % 1.0;
        var isPlaying = Math.random() > 0.2; // 80% de probabilidad de estar reproduciendo
        
        // Simulamos valor de clave musical (0-23)
        var trackKey = Math.floor(Math.random() * 24);
        
        // Actualizamos los valores en el overlay dependiendo del tipo
        if (typeof overlayInstance.updateTrackInfo === "function") {
            // Usamos el método updateTrackInfo del PluginOverlay.qml externo
            overlayInstance.updateTrackInfo(
                trackTitle, 
                trackArtist, 
                trackAlbum, 
                bpm, 
                trackKey, 
                playPosition, 
                isPlaying
            );
        } else if (typeof overlayInstance.updateValues === "function") {
            // Fallback para overlay integrado simple
            overlayInstance.updateValues(trackTitle, trackArtist, bpm);
        }
    }
    
    // Se llama cuando el plugin se descarga
    function onUnload() {        
        if (overlayInstance) {
            // Si el overlay tiene un método para ocultarse, lo usamos
            if (typeof overlayInstance.hideOverlay === "function") {
                overlayInstance.hideOverlay();
            }
            
            overlayInstance.destroy();
            overlayInstance = null;
        }
        
        isInitialized = false;
    }
} 