import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:chat_app/services/auth_service.dart';

import 'package:chat_app/helpers/mostrar_alerta.dart';
import 'package:chat_app/widgets/widgets.dart';


class LoginPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    final screenSize = MediaQuery.of(context).size;

    return SafeArea(

      child: Scaffold(

        backgroundColor: Colors.grey[100],

        body: Stack(
          children: [
            HeaderCurvoAfuera( color: Color(0xFF0D8B5E) ),
            HeaderLogo( titulo: 'Messenger' ),
            SingleChildScrollView(
              padding: EdgeInsets.only( top: screenSize.height * 0.4 ),
              physics: BouncingScrollPhysics(),
              child: _LoginComponents()
            )
          ],
        )
      ),
    );
  }
}

class _LoginComponents extends StatelessWidget {
  const _LoginComponents({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final screenSize = MediaQuery.of(context).size;

    return Container(
      height: screenSize.height * 0.5,

      child: Column(
        
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
    
        children: [
          _Form(),
          Labels( navigationRoute: 'register', label1: '¿No tienes una cuenta?', label2: 'Unete a nosotros, ¡pulsa aquí para crearla!' ),
    
          Text(
            'Terminos y condiciones de uso',
            style: TextStyle(
              fontSize: screenSize.width * 0.045,
              fontWeight: FontWeight.w300,
              color: Colors.grey
            )
          ),
        ],
      ),
    );
  }
}


class _Form extends StatefulWidget {
  const _Form({ Key? key }) : super(key: key);

  @override
  __FormState createState() => __FormState();
}

class __FormState extends State<_Form> {

  final emailController = TextEditingController();
  final passController  = TextEditingController();

  @override
  Widget build(BuildContext context) {

    final screenSize = MediaQuery.of(context).size;
    final authService = Provider.of<AuthService>( context );

    return Container(

      margin: EdgeInsets.only( top: screenSize.width * 0.08 ),
      padding: EdgeInsets.symmetric( horizontal: screenSize.width * 0.08 ),

      child: Column(
        children: [
          CustomInput(
            keyboardType: TextInputType.emailAddress,
            icon: Icons.email_outlined,
            obscureText: false,
            hintText: 'ejemplo@correo.com',
            textController: emailController,
          ),
          CustomInput(
            keyboardType: TextInputType.visiblePassword,
            icon: Icons.password,
            obscureText: true,
            hintText: 'contraseña',
            textController: passController,
          ),

          BotonVerde(
            text: 'Acceder',

            funcionBoton: authService.autenticando ? null : ()async{

              // Cerrar el teclado despues de presionar el botón
              FocusScope.of(context).unfocus();

              final loginOk = await authService.login( emailController.text.trim(), passController.text.trim() );

              if ( loginOk ){
                // TODO: Conectar a sockets
                Navigator.pushReplacementNamed(context, 'usuarios');
              } else{
                // Mostrar alerta
                mostrarAlerta(context, 'Credenciales incorrectas', 'El correo y/o la contraseña son incorrectos');
              }
            },
          )
        ],
      ),
    );
  }
}


