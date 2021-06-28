import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'package:chat_app/src/services/auth_service.dart';
import 'package:chat_app/src/services/chat_service.dart';
import 'package:chat_app/src/services/socket_service.dart';
import 'package:chat_app/src/services/usuarios_service.dart';

import 'package:chat_app/src/models/usuario_model.dart';

class UsuariosPage extends StatefulWidget {
  @override
  _UsuariosPageState createState() => _UsuariosPageState();
}

class _UsuariosPageState extends State<UsuariosPage> {
  // Inicializamos el servicio de mis usuarios
  final usuarioService = new UsuariosService();
  // Propiedades para mostrar la lista de usuarios conectados
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  // Inicializacion de la lista de usuarios en Blanco
  List<Usuario> usuarios = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this._cargarUsuarios();
  }

  @override
  Widget build(BuildContext context) {
    // Llamamos al provider
    final authService = Provider.of<AuthService>(context);
    final socketService = Provider.of<SocketService>(context);
    final usuario = authService.usuario;

    return Scaffold(
        appBar: AppBar(
          title: Text(
            usuario.nombre,
            style: TextStyle(color: Colors.black87),
          ),
          centerTitle: true,
          elevation: 1,
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: Icon(
              Icons.exit_to_app,
              color: Colors.black87,
            ),
            onPressed: () {
              socketService.disconnect();
              // Hago la referencia al metodo estatico para borrar el token
              Navigator.pushReplacementNamed(context, 'login');
              AuthService.deleteToken();
            },
          ),
          actions: [
            // Icono que aparecera cuando tengamos conexion
            Container(
                margin: EdgeInsets.only(right: 10),
                child: (socketService.serverStatus == ServerStatus.Online)
                    ? Icon(
                        Icons.check_circle,
                        color: Colors.blue[400],
                      )
                    : Icon(
                        Icons.offline_bolt,
                        color: Colors.red,
                      ))
          ],
        ),
        // El header me mostrara la parte del refresh indicator en pantalla y su respectiva forma de carga total, el smartRefresher es como el RefreshIndicator
        body: SmartRefresher(
          controller: _refreshController,
          enablePullDown: true,
          onRefresh: _cargarUsuarios,
          header: WaterDropHeader(
            complete: Icon(
              Icons.check,
              color: Colors.blue[400],
            ),
            waterDropColor: Colors.blue[400],
          ),
          child: _ListViewUsuarios(usuarios: usuarios),
        ));
  }

  // Metodo para cargar la informacion de un endpoint, con su respectivo realizado
  _cargarUsuarios() async {
    // Carga de usuarios en la peticion, y asignacion a mi lista vacia
    this.usuarios = await usuarioService.getUsuarios();
    setState(() {});
    // await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
  }
}

// Widget que contiene la lista de usuarios
class _ListViewUsuarios extends StatelessWidget {
  _ListViewUsuarios({
    Key key,
    @required this.usuarios,
  }) : super(key: key);
  // Lista de usuarios que recibira este widget
  final List<Usuario> usuarios;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        physics: BouncingScrollPhysics(),
        itemBuilder: (_, i) => _UsuarioListTile(usuarios[i]),
        separatorBuilder: (_, i) => Divider(),
        itemCount: usuarios.length);
  }
}

// Widget que contiene la construccion del ListTile para el usuario en la lista
class _UsuarioListTile extends StatelessWidget {
  // Propiedades
  final Usuario usuario;
  _UsuarioListTile(this.usuario);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(usuario.nombre),
      subtitle: Text(usuario.email),
      leading: CircleAvatar(
        child: Text(usuario.nombre.substring(0, 2)),
        backgroundColor: Colors.blue[100],
      ),
      trailing: Container(
        width: 10,
        height: 10,
        decoration: BoxDecoration(
            color: usuario.online ? Colors.green[300] : Colors.red,
            borderRadius: BorderRadius.circular(100)
            // shape: BoxShape.circle
            ),
      ),
      onTap: () {
        // Obteniendo la informacion del usuario para pasarla al chatService
        final chatService = Provider.of<ChatService>(context, listen: false);
        chatService.usuarioPara = usuario;
        Navigator.pushNamed(context, 'chat');
      },
    );
  }
}
