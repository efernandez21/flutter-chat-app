// Archivo que manejara las rutas de mi aplicacion

import 'package:chat_app/src/pages/chat_page.dart';
import 'package:chat_app/src/pages/loading_page.dart';
import 'package:chat_app/src/pages/login_page.dart';
import 'package:chat_app/src/pages/register_page.dart';
import 'package:chat_app/src/pages/usuarios_page.dart';
import 'package:flutter/cupertino.dart';
/// Rutas de la aplicacion expuestas para hacer de manera mas facil la agregacion de nuevos
final Map<String, Widget Function(BuildContext)> appRoutes = {

  'usuarios' : (_) => UsuariosPage(),
  'chat'     : (_) => ChatPage(),
  'login'    : (_) => LoginPage(),
  'register' : (_) => RegisterPage(),
  'loading'  : (_) => LoadingPage(),
};
