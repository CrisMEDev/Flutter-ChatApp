import 'package:chat_app/pages/login_page.dart';
import 'package:chat_app/pages/usuarios_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';

import 'package:chat_app/services/auth_service.dart';


class LoadingPage extends StatelessWidget {

  Future<void> checkLoginState( BuildContext context )async{

    final authService = Provider.of<AuthService>(context, listen: false);

    final autenticado = await authService.isLoggedIn();

    SchedulerBinding.instance!.addPostFrameCallback(( _ ) {

      if ( autenticado ){
        // TODO: Conectar al socket server


        // Navigator.pushReplacementNamed(context, 'usuarios');

        // Se usó esto para usar un Navigator sin animaciones, necesario el SchedulerBinding.instance!.addPostFrameCallback
        Navigator.pushReplacement(context, PageRouteBuilder(
          pageBuilder: ( _, __, ___ ) => UsuariosPage()
        ));

        return;
      }

      // Navigator.pushReplacementNamed(context, 'login');
      // Se usó esto para usar un Navigator sin animaciones, necesario el SchedulerBinding.instance!.addPostFrameCallback
        Navigator.pushReplacement(context, PageRouteBuilder(
          pageBuilder: ( _, __, ___ ) => LoginPage()
        ));
      return;

    });

  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(

        body: FutureBuilder(
          builder: ( _ , snapshot ) {
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