// Configuracion de mi provider de Socket Service basado en la aplicacion de BandNames

import 'package:chat_app/src/global/environment.dart';
import 'package:chat_app/src/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

// Enumeracion para los estados del server
enum ServerStatus { Online, Offline, Connecting }

// Configuracion del servicio del servidor socket con provider
class SocketService with ChangeNotifier {
  // Inicializacion de las propiedades
  // Status inicial de conexion se intenta la conexion
  ServerStatus _serverStatus = ServerStatus.Connecting;
  // Expongo el socket para poder enviar mensajes directamente desde flutter, de manera privada
  IO.Socket _socket;

  // Getters  de la clase
  ServerStatus get serverStatus => this._serverStatus;
  IO.Socket get socket => this._socket;
  Function get emit => this._socket.emit;

  // Metodo para inicializar la configuracion usado solo en el
  void connect() async {
    // Comprobar el token
    final token = await AuthService.getToken();
    // En la conexion añadimos el token para enviarlo en el intento de conexion
    this._socket = IO.io(
        Environment.socketUrl,
        IO.OptionBuilder()
            .setTransports(['websocket'])
            .enableAutoConnect()
            .enableForceNew()
            .setExtraHeaders({
              'x-token': token
            }) // for Flutter or Dart VM
            .build());

    // Conexion al socket cambiamos el status del servidor a conectado
    this._socket.onConnect((_) {
      // print('connect');
      this._serverStatus = ServerStatus.Online;
      notifyListeners();
    });
    // Evento de desconexion
    this._socket.onDisconnect((_) {
      // print('disconnect');
      this._serverStatus = ServerStatus.Offline;
      notifyListeners();
    });
  }

  // Funcion para desconectarnos del servidor
  void disconnect() {
    this._socket.disconnect();
  }
}
