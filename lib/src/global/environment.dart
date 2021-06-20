// Clase con metodos globales y estaticos para trabajar con las urls api

import 'dart:io';

class Environtment {
  // Propiedad estatica para la url
  static String apiUrl = Platform.isAndroid
      ? 'http://192.168.1.3:3000/api'
      : 'http://localhost:3000/api';
  // Url del socket server, es la misma solo no incluye el api
   static String sockerUrl = Platform.isAndroid
      ? 'http://192.168.1.3:3000'
      : 'http://localhost:3000';
}
