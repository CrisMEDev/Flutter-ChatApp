import 'package:flutter/material.dart';

class HeaderPicoAfuera extends StatelessWidget {

  final Color color;

  const HeaderPicoAfuera({
    Key? key,
    this.color = Colors.blue
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final screenSize = MediaQuery.of(context).size;
    
    return SingleChildScrollView( // Se agrego este widget pra evitar el resize cuando aparece el teclado al pulsar un textField
      physics: NeverScrollableScrollPhysics(),
      child: Container(
        width: screenSize.width,
        height: screenSize.height,
    
        child: CustomPaint(
          painter: _HeaderPicoAfueraPainter(this.color),
        ),
      ),
    );
  }
}

class _HeaderPicoAfueraPainter extends CustomPainter {

  final Color color;

  _HeaderPicoAfueraPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {

    final paint = new Paint();
    final path = new Path();

    // Propiedades
    paint.color = this.color;
    paint.style = PaintingStyle.fill;

    // Dibujar con el path y el paint; El path por defecto esta en (0, 0)
    path.lineTo(0, size.height * 0.30);
    path.lineTo(size.width * 0.5, size.height * 0.4);
    path.lineTo(size.width, size.height * 0.30);
    path.lineTo(size.width, 0);


    canvas.drawPath(path, paint);
  }
  
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;

}

class HeaderCurvoAfuera extends StatelessWidget {

  final Color color;

  const HeaderCurvoAfuera({
    Key? key,
    this.color = Colors.blue
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final screenSize = MediaQuery.of(context).size;

    return SingleChildScrollView( // Se agrego este widget pra evitar el resize cuando aparece el teclado al pulsar un textField
      physics: NeverScrollableScrollPhysics(),

      child: Container(
        width: screenSize.width,
        height: screenSize.height,
    
        child: CustomPaint(
          painter: _HeaderCurvoAfueraPainter( this.color ),
        ),
      ),
    );
  }
}

class _HeaderCurvoAfueraPainter extends CustomPainter{

  final Color color;

  _HeaderCurvoAfueraPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
      final paint = new Paint();
      final path = new Path();

      // Propiedades
      paint.color = this.color;
      paint.style = PaintingStyle.fill;

      // Camino del path
      path.lineTo(0, size.height * 0.30);
      path.quadraticBezierTo(size.width * 0.5, size.height * 0.45, size.width, size.height * 0.30);  
      // El primer punto solicitado es el eje de la curvatura
      // El segundo es el punto donde termina
      // El tercer punto es donde termina de dibujar

      // path.lineTo(size.width, size.height / 3);  // Linea en vez de curvatura
      path.lineTo(size.width, 0);


      canvas.drawPath(path, paint);
  }
  
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }

}

