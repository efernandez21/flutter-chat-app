import 'package:chat_app/src/global/environment.dart';
import 'package:chat_app/src/models/mensajes_response.dart';
import 'package:chat_app/src/models/usuario_model.dart';
import 'package:chat_app/src/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// El chat Service usado para cargar lo necesario en la comunicacion del chat
class ChatService with ChangeNotifier {
  // Usuario para el cual van los mensajes
  Usuario usuarioPara;

  // Peticion al servicio de mensajes, recibe el id del usuarioPara
  Future<List<Mensaje>> getChat(String usuarioID) async {
    // Peticion http al endpoint de los mensajes
    final resp = await http.get('${Environment.apiUrl}/mensajes/$usuarioID',
        headers: {
          'Content-Type': 'application/json',
          'x-token': await AuthService.getToken()
        });
    // Validfacion para respuesta correcta
    if (resp.statusCode == 200) {
      // Mapear la respuesta obtenida, en caso de error agregar validacion vasada en el statuscode
      final mensajesResp = mensajesResponseFromJson(resp.body);
      return mensajesResp.mensajes;
    } else {
      // REtornamos lista vacia y podemo retornar un error en este caso para hacer mas solida mi seguridad en la app
      return [];
    }
  }
}
