import QtQuick

//------------------------------------------------------------------------------------------------------------------
//  LIST HIGHLIGHT - Define la apariencia visual del elemento seleccionado en el browser
//
//  Características:
//  - Dibuja dos líneas horizontales (superior e inferior) para resaltar el elemento seleccionado
//  - El color cambia según el deck seleccionado (A/B vs C/D)
//  - Usa colores predefinidos del tema para mantener consistencia visual
//------------------------------------------------------------------------------------------------------------------

Item { 
    // Añadir después de las propiedades existentes
    property real screenScale: prefs.screenScale
    
    // Línea superior del highlight
    Rectangle {
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        height: 1 * screenScale
        // Color azul para decks A/B (0,1), gris para decks C/D (2,3)
        color: (screen.focusDeckId < 2) ? colors.colorBrowserBlueBright56Full : colors.colorGrey64
    }

    // Línea inferior del highlight
    Rectangle {
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        height: 1 * screenScale
        // Color azul para decks A/B (0,1), gris para decks C/D (2,3)
        color: (screen.focusDeckId < 2) ? colors.colorBrowserBlueBright56Full : colors.colorGrey64
    }
}   
