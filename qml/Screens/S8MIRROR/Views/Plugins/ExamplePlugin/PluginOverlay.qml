import QtQuick
import QtQuick.Window 2.15
import Qt5Compat.GraphicalEffects

import CSI 1.0
import Traktor.Gui 1.0 as Traktor

// Overlay visual avanzado para el plugin - sin funcionalidad de arrastre
Item {
    id: pluginOverlay
    
    // Propiedades configurables
    property string title: "TRAKTOR DECK INFO"
    property bool autoHide: false
    property int displayTime: 0  // 0 = mostrar siempre
    
    // Factor de escala para adaptarse a diferentes resoluciones
    property real screenScale: 1.0
    
    // Datos de pista
    property string trackTitle: "Sin título"
    property string trackArtist: "Sin artista" 
    property string trackAlbum: "Sin álbum"
    property real trackBpm: 120.0
    property real trackKey: 0
    property real playProgress: 0.0
    property bool isPlaying: false
    
    // Efectos visuales
    property bool enableGlowEffect: true
    property bool enableDropShadow: true
    property bool enableBlurEffect: false
    
    // Referencias de utilidad
    property var colors: QtObject {
        property color primary: "#FF6600"      // Naranja Traktor más intenso
        property color secondary: "#00AAFF"    // Azul más brillante
        property color background: "#111111"   // Fondo más oscuro
        property color backgroundAlt: "#222222" // Gris oscuro
        property color textPrimary: "#FFFFFF"  // Texto blanco
        property color textSecondary: "#DDDDDD" // Texto gris claro más brillante
        property color accent: "#33FF33"       // Verde más brillante
    }
    
    // Propiedades internas
    property bool _isActive: true
    property real _opacity: 1.0
    
    // Quitar el anclaje del Item principal para evitar conflictos
    // anchors.centerIn: parent
    
    // Visibilidad
    width: mainPanel.width
    height: mainPanel.height
    visible: _isActive
    opacity: _isActive ? _opacity : 0.0
    
    // Propiedades para asegurar que el overlay no se salga de la pantalla
    property bool preventOffscreen: true
    
    // Observar cambios en las propiedades del padre para reposicionar
    onParentChanged: {
        if (parent) {
            centerOverlay();
            // Conectarse a cambios en el tamaño del padre
            parent.widthChanged.connect(centerOverlay);
            parent.heightChanged.connect(centerOverlay);
        }
    }
    
    // Observar cambios propios de tamaño
    onWidthChanged: centerOverlay()
    onHeightChanged: centerOverlay()
    
    // Panel principal
    Rectangle {
        id: mainPanel
        width: 350 * screenScale
        height: 280 * screenScale
        radius: 10 * screenScale
        color: colors.background
        opacity: _opacity
        
        // No usar anchors para evitar conflictos
        // anchors.centerIn: parent
        
        // Borde
        border.width: 3 * screenScale
        border.color: colors.primary
        
        // Efecto de glow
        Rectangle {
            id: glowBorder
            anchors.fill: parent
            radius: parent.radius
            color: "transparent"
            border.width: 4 * screenScale
            border.color: colors.primary
            visible: enableGlowEffect
            opacity: 0.0
            
            SequentialAnimation on opacity {
                running: enableGlowEffect
                loops: Animation.Infinite
                NumberAnimation { from: 0.0; to: 1.0; duration: 1200; easing.type: Easing.InOutQuad }
                NumberAnimation { from: 1.0; to: 0.0; duration: 1200; easing.type: Easing.InOutQuad }
            }
        }
        
        // Título del panel
        Rectangle {
            id: titleBar
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            height: 36 * screenScale
            color: colors.primary
            radius: 10 * screenScale
            
            // Ajustar las esquinas para que solo sea redondeada en la parte superior
            Rectangle {
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                height: parent.radius
                color: parent.color
            }
            
            Text {
                id: titleText
                text: pluginOverlay.title
                color: "white"
                font.pixelSize: 16 * screenScale
                font.bold: true
                anchors.centerIn: parent
            }
            
            // Botón de cerrar
            Rectangle {
                id: closeButton
                width: 22 * screenScale
                height: 22 * screenScale
                radius: 11 * screenScale
                color: "#FF3333"
                anchors.right: parent.right
                anchors.rightMargin: 7 * screenScale
                anchors.verticalCenter: parent.verticalCenter
                
                Text {
                    anchors.centerIn: parent
                    text: "×"
                    color: "white"
                    font.pixelSize: 18 * screenScale
                    font.bold: true
                }
                
                // Mantener solamente este MouseArea para la funcionalidad del botón cerrar
                MouseArea {
                    id: closeButtonArea
                    anchors.fill: parent
                    onClicked: hideOverlay()
                    z: 1000
                }
            }
        }
        
        // Información de pista
        Item {
            id: trackInfoSection
            anchors.top: titleBar.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.margins: 12 * screenScale
            height: 75 * screenScale
            
            Column {
                id: trackInfoColumn
                anchors.fill: parent
                spacing: 8 * screenScale
                
                Text {
                    text: "▶ " + pluginOverlay.trackTitle
                    color: colors.textPrimary
                    font.pixelSize: 18 * screenScale
                    font.bold: true
                    width: parent.width
                    elide: Text.ElideRight
                }
                
                Text {
                    text: "👤 " + pluginOverlay.trackArtist
                    color: colors.textSecondary
                    font.pixelSize: 16 * screenScale
                    width: parent.width
                    elide: Text.ElideRight
                }
                
                Text {
                    text: "💿 " + pluginOverlay.trackAlbum
                    color: colors.textSecondary
                    font.pixelSize: 14 * screenScale
                    width: parent.width
                    elide: Text.ElideRight
                    visible: pluginOverlay.trackAlbum !== "Sin álbum"
                }
            }
        }
        
        // Progreso de reproducción
        Rectangle {
            id: progressBar
            anchors.top: trackInfoSection.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.leftMargin: 12 * screenScale
            anchors.rightMargin: 12 * screenScale
            height: 8 * screenScale
            radius: 4 * screenScale
            color: colors.backgroundAlt
            
            Rectangle {
                id: progressIndicator
                anchors.left: parent.left
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                width: parent.width * pluginOverlay.playProgress
                radius: parent.radius
                color: colors.primary
                
                // Animación de pulso cuando está reproduciendo
                SequentialAnimation on opacity {
                    running: pluginOverlay.isPlaying
                    loops: Animation.Infinite
                    NumberAnimation { from: 1.0; to: 0.6; duration: 500 }
                    NumberAnimation { from: 0.6; to: 1.0; duration: 500 }
                }
            }
        }
        
        // Datos técnicos
        Flow {
            id: technicalData
            anchors.top: progressBar.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.margins: 12 * screenScale
            anchors.topMargin: 10 * screenScale
            spacing: 10 * screenScale
            
            Rectangle {
                width: 90 * screenScale
                height: 28 * screenScale
                radius: 5 * screenScale
                color: colors.backgroundAlt
                
                Text {
                    anchors.centerIn: parent
                    text: "BPM: " + pluginOverlay.trackBpm.toFixed(1)
                    color: colors.primary
                    font.pixelSize: 14 * screenScale
                    font.bold: true
                }
            }
            
            Rectangle {
                width: 70 * screenScale
                height: 28 * screenScale
                radius: 5 * screenScale
                color: colors.backgroundAlt
                
                Text {
                    anchors.centerIn: parent
                    text: getKeyName(pluginOverlay.trackKey)
                    color: colors.accent
                    font.pixelSize: 14 * screenScale
                    font.bold: true
                }
                
                // Función para convertir número de clave a nombre
                function getKeyName(keyNumber) {
                    var keys = ["8B", "3B", "10B", "5B", "12B", "7B", "2B", "9B", "4B", "11B", "6B", "1B", 
                               "8A", "3A", "10A", "5A", "12A", "7A", "2A", "9A", "4A", "11A", "6A", "1A"];
                    
                    // Ajustar al rango válido
                    var index = Math.round(keyNumber) % 24;
                    if (index < 0) index += 24;
                    
                    return keys[index];
                }
            }
            
            Rectangle {
                id: playButton
                width: 120 * screenScale
                height: 28 * screenScale
                radius: 5 * screenScale
                color: colors.primary
                opacity: pluginOverlay.isPlaying ? 1.0 : 0.7
                
                Text {
                    anchors.centerIn: parent
                    text: pluginOverlay.isPlaying ? "► PLAYING" : "❚❚ PAUSED"
                    color: "white"
                    font.pixelSize: 14 * screenScale
                    font.bold: true
                }
                
                MouseArea {
                    id: playButtonArea
                    anchors.fill: parent
                    onClicked: pluginOverlay.isPlaying = !pluginOverlay.isPlaying
                    z: 1000 // Alta prioridad para este botón
                    propagateComposedEvents: false
                }
            }
        }
        
        // Sección expandida
        Item {
            id: expandedSection
            anchors.top: technicalData.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: expandControls.top
            anchors.margins: 12 * screenScale
            visible: expandedView.checked
            clip: false // true
            
            Rectangle {
                anchors.fill: parent
                color: colors.backgroundAlt
                radius: 6 * screenScale
                
                // Simulación de forma de onda
                Canvas {
                    id: waveformCanvas
                    anchors.fill: parent
                    anchors.margins: 5 * screenScale
                    
                    onPaint: {
                        var ctx = getContext("2d");
                        ctx.clearRect(0, 0, width, height);
                        
                        // Dibujar forma de onda
                        ctx.lineWidth = 2 * screenScale;
                        ctx.strokeStyle = colors.secondary;
                        ctx.fillStyle = Qt.rgba(0.0, 0.5, 1.0, 0.3);
                        
                        ctx.beginPath();
                        ctx.moveTo(0, height/2);
                        
                        // Generar forma de onda
                        var amplitude = height / 3;
                        var frequency = 0.05;
                        
                        for (var x = 0; x < width; x++) {
                            // Calcular altura usando seno con frecuencia variable
                            var y = height/2 + Math.sin(x * frequency) * amplitude * 
                                Math.sin(x * 0.01) * (0.5 + 0.5 * Math.random());
                            
                            // Reducir la amplitud hacia el final
                            var fade = 1.0 - Math.max(0, (x / width - 0.8) * 5);
                            y = height/2 + (y - height/2) * fade;
                            
                            ctx.lineTo(x, y);
                        }
                        
                        // Completar la forma (hacia abajo)
                        ctx.lineTo(width, height/2);
                        ctx.lineTo(width, height);
                        ctx.lineTo(0, height);
                        ctx.lineTo(0, height/2);
                        
                        // Rellenar y trazar
                        ctx.fill();
                        ctx.stroke();
                        
                        // Añadir línea de reproducción actual
                        ctx.strokeStyle = colors.primary;
                        ctx.lineWidth = 3 * screenScale;
                        var playPosition = width * pluginOverlay.playProgress;
                        
                        ctx.beginPath();
                        ctx.moveTo(playPosition, 0);
                        ctx.lineTo(playPosition, height);
                        ctx.stroke();
                    }
                    
                    // Repintar periódicamente
                    Timer {
                        interval: 100
                        running: true
                        repeat: true
                        onTriggered: waveformCanvas.requestPaint()
                    }
                }
                
                Text {
                    anchors.centerIn: parent
                    text: "FORMA DE ONDA"
                    color: colors.textSecondary
                    font.pixelSize: 14 * screenScale
                    opacity: 0.3
                }
            }
        }
        
        // Controles de expansión
        Item {
            id: expandControls
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            height: 36 * screenScale
            
            Rectangle {
                anchors.fill: parent
                color: colors.backgroundAlt
                radius: 8 * screenScale
                anchors.margins: 8 * screenScale
                
                // Switch para expandir vista
                Rectangle {
                    id: expandedView
                    width: 46 * screenScale
                    height: 20 * screenScale
                    radius: 10 * screenScale
                    color: checked ? colors.primary : "#555555"
                    anchors.centerIn: parent
                    
                    property bool checked: false
                    
                    Rectangle {
                        width: 16 * screenScale
                        height: 16 * screenScale
                        radius: 8 * screenScale
                        color: "white"
                        anchors.verticalCenter: parent.verticalCenter
                        x: parent.checked ? (parent.width - width - 2 * screenScale) : (2 * screenScale)
                        
                        Behavior on x {
                            NumberAnimation { duration: 150 }
                        }
                    }
                    
                    MouseArea {
                        id: switchArea
                        anchors.fill: parent
                        onClicked: parent.checked = !parent.checked
                        z: 1000 // Alta prioridad para el switch
                        propagateComposedEvents: false
                    }
                }
                
                Text {
                    text: "MÁS DETALLES"
                    color: colors.textSecondary
                    font.pixelSize: 12 * screenScale
                    font.bold: true
                    anchors.right: expandedView.left
                    anchors.rightMargin: 8 * screenScale
                    anchors.verticalCenter: parent.verticalCenter
                }
            }
        }
    }
    
    // Animación de entrada/salida
    Behavior on opacity {
        NumberAnimation { 
            duration: 400
            easing.type: Easing.OutCubic
        }
    }
    
    // Timer para auto-ocultar
    Timer {
        id: hideTimer
        interval: displayTime
        repeat: false
        running: autoHide && displayTime > 0
        onTriggered: {
            hideOverlay();
        }
    }
    
    // Mostrar el overlay
    function showOverlay() {
        _isActive = true;
        if (autoHide && displayTime > 0) {
            hideTimer.restart();
        }
    }
    
    // Ocultar el overlay
    function hideOverlay() {
        _isActive = false;
    }
    
    // Actualizar información de la pista
    function updateTrackInfo(title, artist, album, bpm, key, progress, playing) {
        if (title !== undefined) trackTitle = title;
        if (artist !== undefined) trackArtist = artist;
        if (album !== undefined) trackAlbum = album;
        if (bpm !== undefined) trackBpm = bpm;
        if (key !== undefined) trackKey = key;
        if (progress !== undefined) playProgress = progress;
        if (playing !== undefined) isPlaying = playing;
        
        // Reiniciar timer si autoHide está activo
        if (autoHide && displayTime > 0) {
            hideTimer.restart();
        }
    }
    
    // Cuando el componente se completa, mostrar el overlay
    Component.onCompleted: {
        showOverlay();
        // Centrar explícitamente al inicio
        centerOverlay();
    }
    
    // Función para centrar el overlay en la pantalla
    function centerOverlay() {
        if (!parent) return;
        
        // Obtener las dimensiones disponibles
        var availableWidth = parent.width;
        var availableHeight = parent.height;
        
        // Calcular posición centrada
        var newX = Math.max(0, Math.min((availableWidth - width) / 2, availableWidth - width));
        var newY = Math.max(0, Math.min((availableHeight - height) / 2, availableHeight - height));
        
        // Aplicar posición
        x = newX;
        y = newY;
    }
} 
