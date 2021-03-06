import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'package:chat_app/services/socket_service.dart';
import 'package:chat_app/services/chat_service.dart';
import 'package:chat_app/services/usuarios_service.dart';

import 'package:chat_app/models/models.dart';
import 'package:chat_app/services/auth_service.dart';


class UsuariosPage extends StatefulWidget {



  @override
  _UsuariosPageState createState() => _UsuariosPageState();
}

class _UsuariosPageState extends State<UsuariosPage> {

  RefreshController _refreshController = RefreshController(initialRefresh: false);
  final usuariosService = UsuariosService();

  List<Usuario> usuarios = [];

  // final List<Usuario> usuarios = [
  //   Usuario( uid: '1', name: 'Cristian', email: 'test1@test.com', online: true ),
  //   Usuario( uid: '2', name: 'Aurora', email: 'test2@test.com', online: true ),
  //   Usuario( uid: '3', name: 'Jesús', email: 'test3@test.com', online: false ),
  // ];

  @override
  void initState() {
    _cargarUsuarios();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    final authService = Provider.of<AuthService>(context);
    final socketService = Provider.of<SocketService>(context);

    return SafeArea(
      child: Scaffold(
    
        appBar: AppBar(
          title: Text(authService.usuario.name, style: TextStyle( color: Colors.black45 ),),
          centerTitle: true,
          elevation: 1,
          backgroundColor: Colors.blueGrey[100],
          leading: IconButton(
            icon: Icon( Icons.exit_to_app_outlined, color: Colors.black45, ),
            onPressed: (){

              // Desconectarnos del socket server
              socketService.disconnect();
              
              AuthService.deleteToken();
              Navigator.pushReplacementNamed(context, 'login');

            },
          ),
    
          actions: [
            Container(
              margin: EdgeInsets.only( right: 10 ),
    
              child: ( socketService.serverStatus == ServerStatus.Online )
                      ? Icon( Icons.check_circle_outline, color: Colors.teal, )
                      : Icon( Icons.offline_bolt_outlined, color: Colors.redAccent, ),
            )
          ],
        ),
    
        body: SmartRefresher(
          controller: _refreshController,
          enablePullDown: true,
          physics: BouncingScrollPhysics(),
          header: WaterDropMaterialHeader(
            backgroundColor: Colors.teal,
          ),

          onRefresh: (){
            setState(() {});
            _cargarUsuarios();
          },
          child: _UsersList(usuarios: usuarios)
        )
      ),
    );
  }

  _cargarUsuarios() async {

    this.usuarios = await usuariosService.getUsuarios();

    if ( this.mounted ) setState(() {});

    //monitor network fetch
    // await Future.delayed(Duration(milliseconds: 1000));

    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();

  }
  
}

class _UsersList extends StatelessWidget {
  const _UsersList({
    Key? key,
    required this.usuarios,
  }) : super(key: key);

  final List<Usuario> usuarios;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      physics: BouncingScrollPhysics(),
      separatorBuilder: ( _, index ) => Divider(),
      itemCount: usuarios.length,
      itemBuilder: ( _, index ) => _UsuarioTile(usuario: usuarios[index] ),
    );
  }
}

class _UsuarioTile extends StatelessWidget {
  const _UsuarioTile({
    Key? key,
    required this.usuario,
  }) : super(key: key);

  final Usuario usuario;

  @override
  Widget build(BuildContext context) {

    final screenSize = MediaQuery.of(context).size;

    return ListTile(
      title: Text( usuario.name ),
      subtitle: Text( usuario.email ),
      leading: CircleAvatar(
        child: Text( usuario.name.substring(0, 2), style: TextStyle(color: Colors.black), ),
        backgroundColor: Color( 0xFF06BED8 ),
      ),
      trailing: Container(
        width: screenSize.width * 0.04,
        height: screenSize.width * 0.04,

        decoration: BoxDecoration(
          color: ( usuario.online )  ? Colors.green[700] : Colors.redAccent[700],
          shape: BoxShape.circle
        ),
      ),

      onTap: (){
        final chatService = Provider.of<ChatService>(context, listen: false);
        chatService.usuarioPara = usuario;

        Navigator.pushNamed(context, 'chat');
      },
    );
  }
}