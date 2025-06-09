import QtQuick

//----------------------------------------------------------------------------------------------------------------------
// DIMENSIONS - Objeto que define las dimensiones estándar para la interfaz
//
// PROPIEDADES PRINCIPALES:
//
// 1. Dimensiones de Cajas de Información
//    - infoBoxesWidth: 150px (ancho estándar de cajas info)
//    - largeBoxWidth: 306px (ancho para cajas grandes, 2*infoBoxesWidth + spacing)
//
// 2. Alturas de Filas
//    - firstRowHeight: 33px (altura primera fila)
//    - secondRowHeight: 72px (altura segunda fila) 
//    - thirdRowHeight: 72px (altura tercera fila)
//
// 3. Espaciado y Márgenes
//    - spacing: 6px (espaciado estándar entre elementos)
//    - cornerRadius: 5px (radio de esquinas redondeadas)
//    - screenTopMargin: 3px (margen superior de pantalla)
//    - screenLeftMargin: 6px (margen izquierdo de pantalla)
//    - titleTextMargin: 6px (margen para textos de título)
//
// NOTAS:
// - Los márgenes de pantalla pueden requerir ajustes según tolerancias de fabricación
// - Todas las propiedades son readonly para prevenir modificaciones accidentales
//----------------------------------------------------------------------------------------------------------------------

QtObject {
  
  readonly property real infoBoxesWidth:   150
  readonly property real firstRowHeight:   33
  readonly property real secondRowHeight:  72
  readonly property real thirdRowHeight:   72 
  readonly property real spacing:          6
  readonly property real largeBoxWidth:    2*infoBoxesWidth + spacing
  readonly property real cornerRadius:     5
  readonly property real screenTopMargin:  3 // Ajustable según tolerancias de fabricación
  readonly property real screenLeftMargin: spacing // Ajustable según tolerancias de fabricación
  readonly property real titleTextMargin:  spacing

}