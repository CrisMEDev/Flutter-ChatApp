import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:chat_app/models/login_response.dart';
import 'package:chat_app/models/usuario.dart';
import 'package:chat_app/global/enviroments.dart';

class AuthService with ChangeNotifier{

  late Usuario usuario;
  bool _autenticando = false;

  bool get autenticando => this._autenticando;

  set autenticando(bool autenticando) {
    this._autenticando = autenticando;
    notifyListeners();
  }

  Future<bool> login( String email, String password )async{

    this.autenticando = true;
    
    final data = {
      'email': email,
      'password': password
    };

    final url = Uri.parse( '${ Enviroment.apiURL }' );

    final resp = await http.post( url, 
      body: jsonEncode(data),
      headers: {
        'Content-Type': 'application/json'
      }
    );

    print( resp.body );
    if ( resp.statusCode == 200 ){
      final loginResponse = loginResponseFromJson( resp.body );
      this.usuario = loginResponse.usuario;

      // TODO: guardar token en lugar seguro

      return true;
    }



    this.autenticando = false;
    return false;

  }

}