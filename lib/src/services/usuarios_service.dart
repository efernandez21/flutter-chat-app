// Clase de servicios para devolver la lista de usuarios al hacer la consulta http
import 'package:chat_app/src/global/environment.dart';
import 'package:chat_app/src/models/usuarios_response.dart';
import 'package:chat_app/src/services/auth_service.dart';
import 'package:http/http.dart' as http;
import 'package:chat_app/src/models/usuario_model.dart';

class UsuariosService {

  // Funcion para obtener los usuarios
  Future<List<Usuario>> getUsuarios() async{
    // Usaremos un Try Catch para mantener un manejo en los errores
    try {
      // Construimos la peticion http a realizar
      final resp = await http.get('${Environment.apiUrl}/usuarios', 
        headers: {
          'Content-Type': 'application/json', 
          'x-token': await AuthService.getToken()
        }
      );
      // Recibimos la respuesta y la mapeamos
      final usuariosResponse = usuariosResponseFromJson(resp.body);
      
      return usuariosResponse.usuarios;
    } catch (e) {
      return [];
    }
  }
}