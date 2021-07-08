import 'package:flutter/material.dart';

class CustomInput extends StatelessWidget {

  final TextInputType? keyboardType;
  final String? hintText;
  final IconData? icon;
  final bool obscureText;
  final TextEditingController? textController;

  const CustomInput({
    Key? key,
    this.keyboardType = TextInputType.text,
    this.hintText = '',
    this.icon = Icons.android_outlined,
    this.obscureText = false,
    this.textController
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final screenSize = MediaQuery.of(context).size;

    return Container(
      padding: EdgeInsets.only( right: (screenSize.width * 0.08) * 0.5 ),
      margin: EdgeInsets.only( bottom: (screenSize.width * 0.08) * 0.55 ),

      child: TextField(
        autocorrect: false,
        keyboardType: this.keyboardType,
        cursorColor: Colors.teal,
        obscureText: this.obscureText,
        controller: this.textController,
      
        decoration: InputDecoration(
          prefixIcon: Icon( this.icon ),
          focusedBorder: InputBorder.none,
          border: InputBorder.none,
          hintText: this.hintText,
        )
      ),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular( screenSize.width * 0.1 ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            offset: Offset(0, 3),
            blurRadius: 5.0
          )
        ]
      ),
    );

  }
}