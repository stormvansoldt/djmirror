import QtQuick

//----------------------------------------------------------------------------------------------------------------------
//  ARC - Componente Canvas que dibuja un arco o segmento circular
//
//  COLORES:
//     - // TODO: strokeStyle: Color del borde del arco (default: '#00FF00' - verde)
//     - // TODO: fillStyle: Color de relleno (default: 'transparent')
//
//  CARACTERÍSTICAS:
//  - Usa Canvas 2D para dibujar
//  - Los ángulos se convierten de grados a radianes (Math.PI * angle/180)
//  - El arco se centra automáticamente en el componente
//  - Se resetea el contexto en cada repintado
//
//  NOTAS:
//  - El componente es puramente visual, sin interacción
//  - El tamaño del arco se ajusta automáticamente al tamaño del componente
//  - Los colores pueden ser cambiados dinámicamente mediante las propiedades
//  - Asume que 'colors' existe en la jerarquía
//
//----------------------------------------------------------------------------------------------------------------------

Canvas {
  property real lineWidth:     1.0
  property real startAngle:    0.0
  property real endAngle:      45.0
  property bool anticlockwise: false
  property variant strokeStyle: '#00FF00'
  property variant fillStyle: 'transparent'
  
  onPaint: {
    var ctx = getContext("2d");
    ctx.reset();

    var centerX = width / 2;
    var centerY = height / 2;
    var arcRadius = width / 2 - lineWidth;

    ctx.beginPath();
    ctx.fillStyle = fillStyle;
    ctx.arc(centerX, centerY, arcRadius, Math.PI * startAngle/180, Math.PI * endAngle/180, anticlockwise);
    ctx.lineWidth = lineWidth;
    ctx.strokeStyle = strokeStyle;
    ctx.stroke();
  }
}
