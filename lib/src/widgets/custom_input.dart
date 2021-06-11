import 'package:flutter/material.dart';

/// Widget del TextField personalizado enfocado en personalizar los campos para su estilizacion
class CustomInput extends StatelessWidget {
  // Definiendo argumentos para trabajar con el input
  final IconData icon;
  final String placeHolder;
  final TextEditingController textController;
  final TextInputType keyboardType;
  final bool isPassword;

  const CustomInput({
    Key key, 
    @required this.icon, 
    @required  this.placeHolder, 
    @required  this.textController, 
    this.keyboardType = TextInputType.text, 
    this.isPassword = false
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // El padding interno es para manejar el espacio interior del textfield que es el child de este container
    return Container(
      padding: EdgeInsets.only(top: 5, left: 5, bottom: 5, right: 20),
      margin: EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.05),
                offset: Offset(0, 5),
                blurRadius: 5)
          ]),
      // Definimos el autocorrect en false, el borde molesto inferior en none para no mostrarlo
      child: TextField(
        controller: textController,
        autocorrect: false,
        keyboardType: this.keyboardType,
        obscureText: this.isPassword,
        decoration: InputDecoration(
            prefixIcon: Icon(this.icon),
            focusedBorder: InputBorder.none,
            border: InputBorder.none,
            hintText: this.placeHolder
        ),
      ),
    );
  }
}
