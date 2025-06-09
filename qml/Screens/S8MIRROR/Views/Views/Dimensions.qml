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
    
  // Todas las dimensiones se escalan por screenScale
  readonly property real infoBoxesWidth: 150 * screenScale   // 300px escalado
  readonly property real firstRowHeight: 33 * screenScale    // 66px escalado
  readonly property real secondRowHeight: 72 * screenScale   // 144px escalado
  readonly property real thirdRowHeight: 72 * screenScale    // 144px escalado
  readonly property real spacing: 6 * screenScale            // 12px escalado
  readonly property real cornerRadius: 5 * screenScale       // 10px escalado
  readonly property real screenTopMargin: 3 * screenScale    // 6px escalado
  readonly property real screenLeftMargin: spacing           // Ya escalado por spacing
  readonly property real titleTextMargin: spacing            // Ya escalado por spacing

  // largeBoxWidth se calcula usando valores ya escalados
  readonly property real largeBoxWidth: 2 * infoBoxesWidth + spacing

}