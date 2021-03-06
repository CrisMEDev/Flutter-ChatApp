import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';

import 'package:chat_app/services/auth_service.dart';
import 'package:chat_app/services/socket_service.dart';


class LoadingPage extends StatelessWidget {

  // TODO: La conexión con el future hacia el backen realiza multiples peticiones
  // debido a que se redibuja varias veces, creo se puede manejar con el snapshot
  Future<void> checkLoginState( BuildContext context )async{

    final authService = Provider.of<AuthService>( context, listen: false );
    final socketService = Provider.of<SocketService>( context, listen: false );

    final autenticado = await authService.isLoggedIn();

    if ( autenticado ){

      // Como este future es parte de un builder y estos se redibujan constantemente, se envuelve el
      // navigator en la siguiente instrucción para evitar perder el manejo en el context y esperar la renderización del builder
      SchedulerBinding.instance?.addPostFrameCallback((_) {
        // Conectar al socket server
        socketService.connect();

        Navigator.pushReplacementNamed(context, 'usuarios');
      });

      return;
    }

    SchedulerBinding.instance?.addPostFrameCallback((_) {
      Navigator.pushReplacementNamed(context, 'login');
    });
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