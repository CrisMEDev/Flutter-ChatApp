import 'package:flutter/material.dart';

import 'package:chat_app/pages/chat_page.dart';
import 'package:chat_app/pages/loading_page.dart';
import 'package:chat_app/pages/login_page.dart';
import 'package:chat_app/pages/register.dart';
import 'package:chat_app/pages/usuarios_page.dart';

final Map<String, Widget Function( BuildContext )> appRoutes = {
  'chat':             ( _ ) => ChatPage(),
  'loading':          ( _ ) => LoadingPage(),
  'login':            ( _ ) => LoginPage(),
  'register':         ( _ ) => RegisterPage(),
  'usuarios':         ( _ ) => UsuariosPage()
};

