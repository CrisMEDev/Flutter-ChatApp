import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:chat_app/services/auth_service.dart';


class ChatMessage extends StatelessWidget {

  final String text;
  final String uid;
  final animationController;

  const ChatMessage({
    Key? key,
    required this.text,
    required this.uid,
    required this.animationController
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final authService = Provider.of<AuthService>(context, listen: false);

    return FadeTransition(
      opacity: animationController,

      child: SizeTransition(
        sizeFactor: CurvedAnimation(parent: animationController, curve: Curves.linearToEaseOut),

        child: Container(
          child: this.uid == authService.usuario.uid
          ? _PersonalMessage( text: this.text )
          : _AnotherUserMessage( text: this.text )
        ),
      ),
    );
  }
}

class _AnotherUserMessage extends StatelessWidget {

  final String text;

  const _AnotherUserMessage({
    Key? key,
    required this.text
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final screenSize = MediaQuery.of(context).size;

    return Align(
      alignment: Alignment.centerLeft,

      child: Container(
        padding: EdgeInsets.all( screenSize.width * 0.03 ),
        margin: EdgeInsets.only( top: screenSize.width * 0.015, left: screenSize.width * 0.03 ),
        width: screenSize.width * 0.8,

        child: Container(
          padding: EdgeInsets.all( screenSize.width * 0.01 ),
          child: Text( this.text, style: TextStyle( color: Colors.black54, fontWeight: FontWeight.w500 ), )
        ),

        decoration: BoxDecoration(
          color: Color( 0xFF0ED0EC ),
          borderRadius: BorderRadius.only(
            topRight: Radius.circular( screenSize.width * 0.05 ),
            bottomRight: Radius.circular( screenSize.width * 0.05 ),
          )
        ),
      ),
    );
  }
}

class _PersonalMessage extends StatelessWidget {

  final String text;

  const _PersonalMessage({
    Key? key,
    required this.text
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final screenSize = MediaQuery.of(context).size;

    return Align(
      alignment: Alignment.centerRight,

      child: Container(
        padding: EdgeInsets.all( screenSize.width * 0.03 ),
        margin: EdgeInsets.only( top: screenSize.width * 0.015, right: screenSize.width * 0.03 ),
        width: screenSize.width * 0.8,

        child: Container(
          padding: EdgeInsets.all( screenSize.width * 0.01 ),
          child: Text( this.text, style: TextStyle( color: Colors.black54, fontWeight: FontWeight.w500 ), )
        ),

        decoration: BoxDecoration(
          color: Color( 0xFFCAF595 ),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular( screenSize.width * 0.05 ),
            bottomLeft: Radius.circular( screenSize.width * 0.05 ),
          )
        ),
      ),
    );
  }
}