import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:chat_app/services/auth_service.dart';
import 'package:chat_app/services/chat_service.dart';
import 'package:chat_app/services/socket_service.dart';
import 'package:chat_app/models/mensajes_response.dart';

import 'package:chat_app/widgets/widgets.dart';


class ChatPage extends StatefulWidget {

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with TickerProviderStateMixin {

  final List<ChatMessage> _messages = [];
  final _textController = TextEditingController();
  final _focusNode = FocusNode();

  bool _estaEscribiendo = false;
  late ChatService chatService;
  late SocketService socketService;
  late AuthService authService;

  @override
  void initState() {
    this.chatService   = Provider.of<ChatService>(context, listen: false);
    this.socketService = Provider.of<SocketService>(context, listen: false);
    this.authService   = Provider.of<AuthService>(context, listen: false);

    this.socketService.socket.on( 'mensaje-personal' , _escucharMensajePersonal );

    _cargarHistorial( this.chatService.usuarioPara.uid );

    super.initState();
  }

  _escucharMensajePersonal( dynamic payload ){

    // TODO: Este if consume mucho tiempo, habrá que cambiarlo
    if ( payload['de'] != chatService.usuarioPara.uid ) return;
    
    ChatMessage message = ChatMessage(
      text: payload['mensaje'],
      uid: payload['de'],
      animationController: AnimationController(
        vsync: this,
        duration: Duration( milliseconds: 1000 )
      ),
    );

    setState(() {
      _messages.insert(0, message);
    });

    message.animationController.forward();

  }

  _cargarHistorial( String usuarioPara ) async {

    List<Mensaje> chat = await this.chatService.getChat( usuarioPara );

    final history = chat.map(( mensaje ) => ChatMessage(
      text: mensaje.mensaje,
      uid: mensaje.de,
      animationController: AnimationController( vsync: this, duration: Duration( milliseconds: 0) )..forward(),
    ) ).toList();

    if ( this.mounted ) setState(() { _messages.insertAll(0, history); });

  }

  @override
  void dispose() {
    _textController.dispose();
    _focusNode.dispose();

    for (ChatMessage message in _messages){
      message.animationController.dispose();
    }

    // Al salir de la pantalla de cierto usuario se cierra el canal de comunicación, para no escuchar sus mensajes
    // con el objetivo de evitar mayor consumo de datos
    this.socketService.socket.off( 'mensaje-personal' );
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final screenSize = MediaQuery.of(context).size;

    return SafeArea(
      child: Scaffold(

        backgroundColor: Color( 0xFFE4F8EF ),
        
        appBar: AppBar(
          centerTitle: true,
          elevation: 1,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                child: Text( chatService.usuarioPara.name.substring(0, 2).toUpperCase() , style: TextStyle( fontSize: 12 ),),
                backgroundColor: Colors.teal,
              ),
              SizedBox( width: screenSize.width * 0.02, ),
              Text( chatService.usuarioPara.name, style: TextStyle( color: Colors.black54, fontSize: screenSize.width * 0.04 ), )
            ],
          ),
          backgroundColor: Colors.white,
        ),

        body: Container(
          child: Column(
            children: [

              Flexible(
                child: ListView.builder(
                  physics: BouncingScrollPhysics(),
                  reverse: true,
                  itemCount: _messages.length,
                  itemBuilder: ( _, index ) => _messages[index]
                )
              ),

              Divider( thickness: 1 ),

              // Caja de texto
              Container(
                color: Colors.white70,
                child: _inputChat( context ),
              )

            ],
          ),
        ),

      ),
    );
  }

  _inputChat( BuildContext context ){

    final screenSize = MediaQuery.of(context).size;

    return Container(
      margin: EdgeInsets.symmetric( horizontal: screenSize.width * 0.05 ),

      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _textController,
              onSubmitted: _handleSubmited,
              onChanged: ( texto ){
                setState(() {
                  if ( texto.trim().length > 0 ) _estaEscribiendo = true;
                  else _estaEscribiendo = false;
                });
              },
              decoration: InputDecoration.collapsed(
                hintText: 'Enviar mensaje'
              ),

              focusNode: _focusNode,
            ),

          ),

          // Botón enviar
          Container(
            margin: EdgeInsets.symmetric( horizontal: screenSize.width * 0.02 ),

            child: Platform.isAndroid 
            ? Container(
              margin: EdgeInsets.symmetric( horizontal: screenSize.width * 0.02 ),
              child: IconTheme(
                data: IconThemeData(
                  color: Colors.teal
                ),

                child: IconButton(
                  highlightColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  icon: Icon( Icons.send ),
                  onPressed: ( _estaEscribiendo ) ? () => _handleSubmited( _textController.text.trim() ) : null,
                ),
              ),
            )
            : CupertinoButton(
              onPressed: ( _estaEscribiendo ) ? () => _handleSubmited( _textController.text.trim() ) : null,
              child: Text('Enviar'),
            ),
          )
        ],
      ),
    );
  }

  _handleSubmited( String text ){

    if (text.length == 0) return;

    _textController.clear();
    _focusNode.requestFocus();

    final newMessage = new ChatMessage(
      uid: this.authService.usuario.uid,
      text: text,
      animationController: AnimationController( vsync: this, duration: Duration(milliseconds: 1000) )
    );


    setState(() {
      _messages.insert(0, newMessage);
      newMessage.animationController.forward();

      _estaEscribiendo = false;
    });

    // Emitir mensaje al backend
    this.socketService.socket.emit( 'mensaje-personal', {
      'de': this.authService.usuario.uid,
      'para': this.chatService.usuarioPara.uid,
      'mensaje': text
    });
  }

}
