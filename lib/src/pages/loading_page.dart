import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:chat_app/src/services/socket_service.dart';
import 'package:chat_app/src/services/auth_service.dart';

import 'package:chat_app/src/pages/login_page.dart';
import 'package:chat_app/src/pages/usuarios_page.dart';

class LoadingPage extends StatelessWidget {
  // Pagina para manejar el loading de las paginas
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: checkLoginState(context),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          return Center(
            child: Text('Espere...'),
          );
        },
      ),
    );
  }

  // Revision de mi estado del Login, no necesitamos redibujar
  Future checkLoginState(BuildContext context) async {
    final authService = Provider.of<AuthService>(context, listen: false);
    final socketService = Provider.of<SocketService>(context, listen: false);
    // Obtenemos si el usuario sigue autenticado, si no lo sacaremos de la pantalla principal
    final autenticado = await authService.isLoggedIn();
    if (autenticado) {
      socketService.connect();
      // Podemos animar mejor la transicion para hacerla mejor
      // Navigator.pushReplacementNamed(context, 'usuarios');
      Navigator.pushReplacement(
        context, 
        PageRouteBuilder(
          pageBuilder: ( _, __, ___) => UsuariosPage(),
          transitionDuration: Duration(milliseconds: 0)
        )
      );
    } else {
      Navigator.pushReplacement(
        context, 
        PageRouteBuilder(
          pageBuilder: ( _, __, ___) => LoginPage(),
          transitionDuration: Duration(milliseconds: 0)
        )
      );
    }
  }
}
