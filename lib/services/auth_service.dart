import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:chat_app/models/login_response.dart';
import 'package:chat_app/models/usuario.dart';
import 'package:chat_app/global/enviroments.dart';

class AuthService with ChangeNotifier{

  late Usuario usuario;

  // Variable para desactivar el boton de post y evitar sobrecarga de peticiones
  bool _autenticando = false;

  // Create storage
  final _storage = new FlutterSecureStorage();

  bool get autenticando => this._autenticando;

  set autenticando(bool autenticando) {
    this._autenticando = autenticando;
    notifyListeners();
  }

  // Getters del token de forma estática
  static Future<String> getToken()async{
    final _storage = new FlutterSecureStorage();
    final token = await _storage.read(key: 'token');

    return token ?? 'No token in device';
  }

  static Future<void> deleteToken()async{
    final _storage = new FlutterSecureStorage();
    await _storage.delete(key: 'token');
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

    // print( resp.body );
    if ( resp.statusCode == 200 ){
      final loginResponse = loginResponseFromJson( resp.body );
      this.usuario = loginResponse.usuario;

      // Guardar token en lugar seguro
      await this._guardarToken( loginResponse.token );

      this.autenticando = false;
      return true;
    }


    this.autenticando = false;
    return false;

  }

  Future<bool> register( String name, String email, String password )async{

    this.autenticando = true;

    final data = {
      'name': name,
      'email': email,
      'password': password
    };

    final url = Uri.parse( '${ Enviroment.apiURL }/new/' );

    final resp = await http.post( url, 
      body: jsonEncode(data),
      headers: {
        'Content-Type': 'application/json'
      }
    );

    // print( resp.body );
    if ( resp.statusCode == 201 ){
      final loginResponse = loginResponseFromJson( resp.body );
      this.usuario = loginResponse.usuario;

      // Guardar token en lugar seguro
      await this._guardarToken( loginResponse.token );

      this.autenticando = false;
      return true;
    }

    this.autenticando = false;
    return false;

  }

  Future<bool> isLoggedIn()async{

    final String token = await getToken();


    final url = Uri.parse( '${ Enviroment.apiURL }/renew' );

    final resp = await http.get( url, headers: {
      'Content-Type': 'application/json',
      'x-token': token
    });

    // print(resp.body);
    if ( resp.statusCode == 200 ){
      final loginResponse = loginResponseFromJson( resp.body );
      this.usuario = loginResponse.usuario;

      // Guardar token en lugar seguro
      await this._guardarToken( loginResponse.token );

      return true;
    } else {
      this.logout();

      return false;
    }

  }

  Future _guardarToken( String token )async{
    // Write value 
    return await _storage.write(key: 'token', value: token);
  }

  Future logout()async{
    // Delete value 
    await _storage.delete(key: 'token');
  }

}