import 'package:chat_app/src/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Widget que sera la parte grafica de un mensaje en el chat
class ChatMessage extends StatelessWidget {
  // Propiedades para usar en el widget como el texto a mostrar y el uid que identifica el mensaje
  final String texto;
  final String uid;
  // Propiedad de Animacion del widget, solo declarada el parametro del controller es pasado por parametro con nombre a este widget
  final AnimationController animationController;
  // Constructor con nombre de los parametros del widget
  const ChatMessage(
      {Key key,
      @required this.texto,
      @required this.uid,
      @required this.animationController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Usamos el provider para manejar el authservice identificar el usuario conectado
    final authService = Provider.of<AuthService>(context, listen: false);

    return FadeTransition(
      opacity: animationController,
      child: SizeTransition(
        sizeFactor:
            CurvedAnimation(parent: animationController, curve: Curves.easeOut),
        child: Container(
          child: this.uid == authService.usuario.uid ? _myMessage() : _notMyMessage(),
        ),
      ),
    );
  }

  // Metodo que devolvera mi widget de mensaje propio
  Widget _myMessage() {
    // Coloque el qtexto justificado en busca de hacerlo un poco mas comprensible
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        padding: EdgeInsets.all(9.0),
        margin: EdgeInsets.only(right: 5, bottom: 5.0, left: 50),
        child: Text(
          this.texto,
          style: TextStyle(color: Colors.white),
          textAlign: TextAlign.justify,
        ),
        decoration: BoxDecoration(
            color: Color(0xff4D9Ef6), borderRadius: BorderRadius.circular(20)),
      ),
    );
  }

  // Metodo que devolvera mi widget de mensaje de otra persona
  Widget _notMyMessage() {
    // Alineamos el mensaje respectivo a como aparecera en el chat, con el tamaño reducido
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.all(9.0),
        margin: EdgeInsets.only(
          left: 5,
          right: 50,
          bottom: 5,
        ),
        child: Text(
          this.texto,
          style: TextStyle(color: Colors.black87),
          textAlign: TextAlign.justify,
        ),
        decoration: BoxDecoration(
            color: Color(0xffE4E5E8), borderRadius: BorderRadius.circular(20)),
      ),
    );
  }
}
