import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:chat_app/services/auth_service.dart';
import 'package:chat_app/services/socket_service.dart';

import 'package:chat_app/widgets/widgets.dart';
import 'package:chat_app/helpers/mostrar_alerta.dart';


class RegisterPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    final screenSize = MediaQuery.of(context).size;

    return SafeArea(

      child: Scaffold(

        backgroundColor: Colors.grey[100],

        body: Stack(
          children: [
            HeaderCurvoAfuera( color: Color(0xFF0D8B5E) ),
            HeaderLogo( titulo: 'Registrar', ),
            SingleChildScrollView(
              padding: EdgeInsets.only( top: screenSize.height * 0.4 ),
              physics: BouncingScrollPhysics(),
              child: _RegisterComponents()
            )
          ],
        )
       ),
    );
  }
}

class _RegisterComponents extends StatelessWidget {
  const _RegisterComponents({
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
          Labels( navigationRoute: 'login', label1: '¿Ya una cuenta?', label2: '¡Pulsa aquí para acceder!' ),
    
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

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passController  = TextEditingController();

  @override
  Widget build(BuildContext context) {

    final screenSize = MediaQuery.of(context).size;
    final authService = Provider.of<AuthService>(context);
    final socketService = Provider.of<SocketService>(context);

    return Container(

      margin: EdgeInsets.only( top: screenSize.width * 0.08 ),
      padding: EdgeInsets.symmetric( horizontal: screenSize.width * 0.08 ),

      child: Column(
        children: [
          CustomInput(
            keyboardType: TextInputType.name,
            icon: Icons.person,
            obscureText: false,
            hintText: 'Nombre',
            textController: nameController,
          ),
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
            text: 'Registrar',

            funcionBoton: authService.autenticando ? null : ()async{

              // Cerrar el teclado despues de presionar el botón
              FocusScope.of(context).unfocus();

              final registerOk = await authService.register(
                nameController.text.trim(),
                emailController.text.trim().toLowerCase(),
                passController.text.trim());
              
              if ( registerOk ){
                // Conectar al socket server
                socketService.connect();

                Navigator.pushReplacementNamed(context, 'usuarios');
              } else {
                mostrarAlerta(context, 'Registro inválido', 'El correo y/o la contraseña con incorrectos, debe llenar todos los campos');
              }
            },
          )
        ],
      ),
    );
  }
}


