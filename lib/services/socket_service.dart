import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import 'package:chat_app/services/auth_service.dart';

import 'package:chat_app/global/enviroments.dart';


enum ServerStatus{
  Online,
  Offline,
  Connecting
}

class SocketService with ChangeNotifier{

  ServerStatus _serverStatus = ServerStatus.Connecting;
  late IO.Socket _socket;

  ServerStatus get serverStatus => this._serverStatus;
  IO.Socket get socket => this._socket;   // Ahora se pueden crear llamadas al on emit y off desde cualquier instancia de la clase

  void connect() async {

    final token = await AuthService.getToken();

    // Dart client
    this._socket = IO.io( Enviroment.socketUrl ,
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .enableAutoConnect()
          .enableForceNew()         // Para manejar y autenticar el inicio de sesión por sockets
          .setExtraHeaders({ 'x-token': token })  // Envio del token para autenticar
          .build()
    );

    this._socket.onConnect((_) {
      // print('Conectado');
      this._serverStatus = ServerStatus.Online;
      notifyListeners();
    });

    this._socket.onDisconnect((_) {
      // print('Desconectado');
      this._serverStatus = ServerStatus.Offline;
      notifyListeners();
    });

  }

  void disconnect(){
    this._socket.disconnect();
  }
  
}