import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

// Helper para mostrar la alerta con la logica separada del boton principal
mostrarAlerta(BuildContext context, String titulo, String subtitulo) {

  if (Platform.isAndroid) {
    // Mostramos el Dialog con diseño de Material
    return showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(titulo),
        content: Text(subtitulo),
        actions: [
          MaterialButton(
            child: Text('Ok'),
            elevation: 5,
            textColor: Colors.blue,
            onPressed: () => Navigator.pop(context)
          )
        ],
      )
    );
  }
  // Mostramos el estilo de Ios
  showCupertinoDialog(
    context: context, 
    builder: (_) => CupertinoAlertDialog(
      title: Text(titulo),
      content: Text(subtitulo),
      actions: [
        CupertinoDialogAction(
          isDefaultAction: true,
          child: Text('Ok'),
          onPressed: () => Navigator.pop(context),
        )
      ],
    )
  );
  


}