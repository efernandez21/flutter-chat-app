import 'package:flutter/material.dart';

class BotonAzul extends StatelessWidget {
  // Propiedades para el boton azul
  final String text;
  final VoidCallback onPressed;

  const BotonAzul({
    Key key, 
    @required this.text, 
    @required this.onPressed
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      onPressed: this.onPressed,
      elevation: 2,
      highlightElevation: 5,
      color: Colors.blue,
      shape: StadiumBorder(),
      child: Container(
        height: 50,
        width: double.infinity,
        child: Center(
          child: Text(
            this.text,
            style: TextStyle(color: Colors.white, fontSize: 17),
          ),
        ),
      ),
    );
  }
}
