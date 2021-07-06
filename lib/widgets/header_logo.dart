import 'package:flutter/material.dart';

class HeaderLogo extends StatelessWidget {

  final String titulo;

  const HeaderLogo({
    Key? key,
    this.titulo = ''
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final screenSize = MediaQuery.of(context).size;

    return Center(
      child: Container(

        width: screenSize.width * 0.5,

        child: Column(
          children: [
            SizedBox( height: 25.0 ),
            ClipRRect(
              borderRadius: BorderRadius.circular(screenSize.width * 0.1),


              child: Container(
                width: screenSize.width * 0.40,
                child: Image(image: AssetImage('assets/img/cute-robot-chat.jpg')),
            
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                ),
              ),
            ),
            SizedBox( height: 20.0, ),
            Text(this.titulo, style: TextStyle( fontSize: screenSize.width * 0.07, color: Colors.white ),)
          ],
        )
      ),
    );
  }
}
