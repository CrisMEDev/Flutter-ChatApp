import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:chat_app/services/auth_service.dart';


class LoadingPage extends StatelessWidget {

  Future<void> checkLoginState( BuildContext context )async{

    final authService = Provider.of<AuthService>( context, listen: false );

    final autenticado = await authService.isLoggedIn();

    if ( autenticado ){
      // TODO: Conectar al socket server


      Navigator.pushReplacementNamed(context, 'usuarios');

      return;
    }

    Navigator.pushReplacementNamed(context, 'login');
    return;

  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(

        body: FutureBuilder(
          builder: ( context , snapshot ) {
            return Center(
              child: Text('Espere...'),
            );
          },
          future: checkLoginState( context ),
        ),
      ),
    );
  }
  
}