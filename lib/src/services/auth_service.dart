import 'dart:convert';
import 'package:chat_app/src/models/usuario_model.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/material.dart';

import 'package:chat_app/src/global/environment.dart';
import 'package:chat_app/src/models/login_response.dart';

// Clase para trabajar la autenticacion de forma global

class AuthService with ChangeNotifier {
  // Informacion del usuario actualmente logueado, inicializa en null, usamos la propiedad booleana para trabajar el estado de autenticacion y bloquear cosas
  Usuario usuario;
  // Podria usar el usuario privado pa usar los getters y setters para trabajar con el y no tener problemas 
  bool _autenticando = false;
  // Create storage
  final _storage = new FlutterSecureStorage();

  // Getters y setters respectivos
  bool get autenticando => this._autenticando;
  set autenticando(bool valor) {
    this._autenticando = valor;
    notifyListeners();
  }

  // Metodos estaticos para usar en cualquier pantalla para trabajar con el token si necesidad de instanciar el provider
  // Getters del token de forma estatica
  static Future<String> getToken() async {
    final _storage = new FlutterSecureStorage();
    final token = await _storage.read(key: 'token');
    return token;
  }

  // Getters del token de forma estatica
  static Future<void> deleteToken() async {
    final _storage = new FlutterSecureStorage();
    await _storage.delete(key: 'token');
  }

  // Metodo para el login del servicio, lo pondremos a regresar un valor booleano
  Future<bool> login(String email, String password) async {
    // Empezamos el autenticando para bloquear el boton
    this.autenticando = true;
    // data a enviar al backend
    final data = {'email': email, 'password': password};
    // Realizacion de una peticion http, teniendo en cuenta que las variables cambian dependiendo de la plataforma

    final resp = await http.post('${Environtment.apiUrl}/login',
        body: jsonEncode(data), headers: {'Content-Type': 'application/json'});
    // Probamos la respuesta, debemos mapearla usando los modelos, confirmar si la peticion es correcta
    // print(resp.body);
    // Autenticando en false
    this.autenticando = false;
    // Comprobamos si el statusCode fue exitoso para continuar
    if (resp.statusCode == 200) {
      // Usar mi loginresponse, para guardar la respuesta
      final loginResponse = loginResponseFromJson(resp.body);
      this.usuario = loginResponse.usuario;
      // Almacenando el token en el storage seguro
      await this._guardarToken(loginResponse.token);

      return true;
    } else {
      // Si no tenemos status code 200 retornamos falso
      return false;
    }
  }

  // Registro de la aplicacion
  Future register(String nombre, String email, String password) async {
    this.autenticando = true;
    // Recibir los valores y los mapeamos para enviarlos en la peticion
    final data = {'nombre': nombre, 'email': email, 'password': password};

    final resp = await http.post('${Environtment.apiUrl}/login/new',
        body: jsonEncode(data), headers: {'Content-Type': 'application/json'});
    // Probamos la respuesta, debemos mapearla usando los modelos, confirmar si la peticion es correcta
    // print(resp.body);
    // Autenticando en false
    this.autenticando = false;
    // Comprobamos si el statusCode fue exitoso para continuar
    if (resp.statusCode == 200) {
      // Usar mi loginresponse, para guardar la respuesta
      final loginResponse = loginResponseFromJson(resp.body);
      this.usuario = loginResponse.usuario;
      // Almacenando el token en el storage seguro
      await this._guardarToken(loginResponse.token);

      return true;
    } else {
      // Si no tenemos status code 200 retornamos la respuesta del servidor en el error
      final respBody = jsonDecode(resp.body);
      return respBody['msg'];
    }
  }

  // Metodo para guardar el token de manera segura en la aplicacion
  Future _guardarToken(String token) async {
    // Guardar el valor en el storage
    return await _storage.write(key: 'token', value: token);
  }

  // Eliminacion del token, colocandolo con el logout
  Future logout() async {
    // Delete value
    await _storage.delete(key: 'token');
  }

  // Verificacion del token si es valido y se esta loggeado
  Future<bool> isLoggedIn() async {
    // Leemos el token
    final token = await this._storage.read(key: 'token');
    final resp = await http.get('${Environtment.apiUrl}/login/renew',
        headers: {'Content-Type': 'application/json', 'x-token': token});
    // Probamos la respuesta, debemos mapearla usando los modelos, confirmar si la peticion es correcta
    // Comprobamos si el statusCode fue exitoso para continuar
    if (resp.statusCode == 200) {
      // Usar mi loginresponse, para guardar la respuesta
      final loginResponse = loginResponseFromJson(resp.body);
      this.usuario = loginResponse.usuario;
      // Almacenando el token en el storage seguro
      await this._guardarToken(loginResponse.token);
      return true;
    } else {
      // Borramos el token porque no sirve
      this.logout();
      return false;
    }
  }
}
