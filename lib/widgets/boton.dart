import 'package:flutter/material.dart';

class BotonVerde extends StatelessWidget {

  final String text;
  final void Function()? funcionBoton;

  const BotonVerde({
    Key? key,
    required this.text,
    this.funcionBoton
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final screenSize = MediaQuery.of(context).size;

    return ElevatedButton(
      child: Container(
        width: double.infinity,
        height: screenSize.height * 0.06,

        child: Center(
          child: Text( this.text , style: TextStyle( color: Colors.white, fontSize: (screenSize.height * 0.06) * 0.35  ),)
        )
      ),
      onPressed: this.funcionBoton,

      style: ButtonStyle(
        elevation: MaterialStateProperty.all<double>( 1.0 ),
        backgroundColor: MaterialStateProperty.all<Color>( ( this.funcionBoton != null ) ? Colors.teal: Colors.grey ),
        shape: MaterialStateProperty.all<OutlinedBorder>( StadiumBorder() ),
      ),
    );
  }
}