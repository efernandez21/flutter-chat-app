import 'dart:io';
import 'dart:ui';

import 'package:chat_app/src/widgets/chat_message.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  // Construccion de la pantalla del chat
  @override
  _ChatPageState createState() => _ChatPageState();
}

// Mezclamos este state con el mixin de TickerProvider para que se adecue cuadro a cuadro para poder realizar una animacion
class _ChatPageState extends State<ChatPage> with TickerProviderStateMixin {
  // Propiedades para trabajar el textfield que es la caja de texto
  final _textController = new TextEditingController();
  final _focusNode = new FocusNode();
  bool _estaEscribiendo = false;
  // Lista temporal de mensajes de chat
  List<ChatMessage> _messages = [
    // ChatMessage(uid: '123', texto: 'Hola Mundo',),
    // ChatMessage(uid: '123', texto: 'Hola Mundo',),
    // ChatMessage(uid: '12345', texto: 'Hola Mundo',),
    // ChatMessage(uid: '123', texto: 'Hola Mundo',),
    // ChatMessage(uid: '12345', texto: 'Hola Mundo',),
    // ChatMessage(uid: '123', texto: 'Hola Mundo',),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Column(
          children: [
            CircleAvatar(
              child: Text(
                'Te',
                style: TextStyle(fontSize: 12),
              ),
              backgroundColor: Colors.blue[100],
              maxRadius: 14,
            ),
            SizedBox(
              height: 3,
            ),
            Text(
              'Melissa Flores',
              style: TextStyle(color: Colors.black87, fontSize: 12),
            )
          ],
        ),
        elevation: 1,
      ),
      // Donde contendremos todos los mensajes
      body: Container(
        child: Column(
          children: [
            // Widget que es capaz de expandirse y se puede usar para colocar los listile, el flexible que contendra la lista de mensajes
            Flexible(
                child: ListView.builder(
              physics: BouncingScrollPhysics(),
              itemCount: _messages.length,
              itemBuilder: (_, i) => _messages[i],
              reverse: true,
            )),
            Divider(
              height: 1,
            ),
            // El contenedor siguiente sera mi caja de texto donde escribiremos cada mensaje del chat
            Container(
              color: Colors.white,
              // height: 50,
              child: _inputChat(),
            )
          ],
        ),
      ),
    );
  }

  // Widget con la caja de texto para escribir el mensaje, con el safe Area para cuidarse de la parte inferior
  Widget _inputChat() {
    return SafeArea(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          children: [
            // Caja de Texto, para recibier el texto actual, expandible en su totalidad hasta casi el boton de enviado
            Flexible(
                child: TextField(
              controller: _textController,
              onSubmitted: _handleSubmit,
              onChanged: (String texto) {
                setState(() {
                  if (texto.trim().length > 0) {
                    _estaEscribiendo = true;
                  } else {
                    _estaEscribiendo = false;
                  }
                });
              },
              // Input deciration collapsed permite eliminar la linea, es deecir no tenemos borde y hacer lucir la caja como la de un chat, se usa el focusNode para al enviar el texto mantener el foco en este campo
              decoration: InputDecoration.collapsed(hintText: 'Enviar Mensaje'),
              focusNode: _focusNode,
            )),
            // Boton de enviar dependiendo del dispositivo, ademas activar el boton si hay texto si no no para mandar nada, evitar los mensajes vacios, con miras en mejorar la experiencia de usuario
            Container(
              margin: EdgeInsets.symmetric(horizontal: 4.0),
              child: Platform.isIOS
                  ? CupertinoButton(
                      child: Text('Enviar'),
                      onPressed: (_estaEscribiendo)
                          ? () => _handleSubmit(_textController.text.trim())
                          : null,
                    )
                  : Container(
                      margin: EdgeInsets.symmetric(horizontal: 4.0),
                      child: IconTheme(
                        data: IconThemeData(color: Colors.blue[400]),
                        child: IconButton(
                          highlightColor: Colors.transparent,
                          splashColor: Colors.transparent,
                          icon: Icon(
                            Icons.send,
                          ),
                          onPressed: (_estaEscribiendo)
                              ? () => _handleSubmit(_textController.text.trim())
                              : null,
                        ),
                      ),
                    ),
            )
          ],
        ),
      ),
    );
  }

  // funcion para obtener el texto enviado por el campo, enviarlo y limpiar la cahja de texto
  _handleSubmit(String texto) {
    // Si el texto es vacio no lo agrege a mi lista
    if (texto.length == 0) return;

    print('-------------------');
    print(texto);
    print('--------------------');
    // Limpia el texto del textField
    _textController.clear();
    // Llama al foco en el input, para que continue seleccionando este input
    _focusNode.requestFocus();
    // Creando la nueva instancia del chat Message
    final newMessage = new ChatMessage(
      uid: '123',
      texto: texto,
      animationController: AnimationController(
          vsync: this, duration: Duration(milliseconds: 400)),
    );
    // Agregacion a la lista de mensajes
    _messages.insert(0, newMessage);
    // Disparamos el proceso de animaccion del nuevo mensaje
    newMessage.animationController.forward();
    setState(() {
      // Actualizamos el estado del estaEscribiendo a false porque ya enviamos el mensaje
      _estaEscribiendo = false;
    });
  }
  // Dispose de los animation controller de los mensajes
  @override
  void dispose() {
    //Limpiar cosas de la pantalla del chat
    //TODO: Off del Socket
    // Limpiar las instancias del manejo de mensajes, para eliminar el consumo de memoria por los mensajes
    for (ChatMessage message in _messages) {
      message.animationController.dispose();
    }
    super.dispose();
  }
}
