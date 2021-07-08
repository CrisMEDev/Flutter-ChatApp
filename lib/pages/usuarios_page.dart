import 'package:flutter/material.dart';

import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'package:chat_app/models/models.dart';


class UsuariosPage extends StatefulWidget {



  @override
  _UsuariosPageState createState() => _UsuariosPageState();
}

class _UsuariosPageState extends State<UsuariosPage> {

  RefreshController _refreshController = RefreshController(initialRefresh: false);

  final List<Usuario> usuarios = [
    Usuario( uid: '1', nombre: 'Cristian', email: 'test1@test.com', online: true ),
    Usuario( uid: '2', nombre: 'Aurora', email: 'test2@test.com', online: true ),
    Usuario( uid: '3', nombre: 'Jesús', email: 'test3@test.com', online: false ),
  ];

  @override
  Widget build(BuildContext context) {

    final screenSize = MediaQuery.of(context).size;

    return SafeArea(
      child: Scaffold(
    
        appBar: AppBar(
          title: Text('Mi nombre', style: TextStyle( color: Colors.black45 ),),
          centerTitle: true,
          elevation: 1,
          backgroundColor: Colors.blueGrey[100],
          leading: IconButton(
            icon: Icon( Icons.exit_to_app_outlined, color: Colors.black45, ),
            onPressed: (){},
          ),
    
          actions: [
            Container(
              margin: EdgeInsets.only( right: 10 ),
    
              // child: Icon( Icons.offline_bolt_outlined ),
              child: Icon( Icons.check_circle_outline, color: Colors.teal, ),
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

          onRefresh: _cargarUsuarios,
          child: _UsersList(usuarios: usuarios)
        )
      ),
    );
  }

  _cargarUsuarios() async {

    //monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
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
      title: Text( usuario.nombre ),
      subtitle: Text( usuario.email ),
      leading: CircleAvatar(
        child: Text( usuario.nombre.substring(0, 2), style: TextStyle(color: Colors.black), ),
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
    );
  }
}