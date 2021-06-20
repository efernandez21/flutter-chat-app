import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

import 'package:chat_app/src/services/auth_service.dart';

import 'package:chat_app/src/helpers/mostrar_alerta.dart';
import 'package:chat_app/src/widgets/boton_azul.dart';
import 'package:chat_app/src/widgets/labels.dart';
import 'package:chat_app/src/widgets/custom_input.dart';
import 'package:chat_app/src/widgets/logo.dart';


class LoginPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    // Uso el media query para indicarle al column el espacio disponible que tiene para ocupar

    return Scaffold(
      backgroundColor: Color(0xffF2F2F2),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Container(
            height: MediaQuery.of(context).size.height * 0.93,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Logo de la app
                Logo(
                  titulo: 'Messenger',
                ),
                _Form(),
                // Labels de la parte inferior
                Labels(
                  ruta: 'register',
                  titulo: '¿No tienes cuenta?',
                  subtitulo: 'Crea una Ahora!',
                ),
                // SizedBox Agregados por mi
                SizedBox(height: 2,),
                Text(' Términos y condiciones de uso', style: TextStyle(fontWeight: FontWeight.w200),),
                // SizedBox(height: 2,)
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Seccion del Formulario del Login
class _Form extends StatefulWidget {
  @override
  __FormState createState() => __FormState();
}

class __FormState extends State<_Form> {

  // Definicion de los controladores de los campos
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // Invocamos la instancia del authServiceProvider
    final authService = Provider.of<AuthService>(context);
    return Container(
      margin: EdgeInsets.only(top: 40),
      // color: Colors.blue,
      padding: EdgeInsets.symmetric(horizontal: 50),
      child: Column(
        children: [
          // Campos de texto usados en el formulario del login, el paddin se usa para darle espacio en la parte interior del input text
          CustomInput(
            icon: Icons.mail_outline,
            placeHolder: 'Correo',
            keyboardType: TextInputType.emailAddress,
            textController: emailCtrl,
          ),
          // SizedBox(height: 10,),
          CustomInput(
            icon: Icons.lock_outline,
            placeHolder: 'Contraseña',
            isPassword: true,
            textController: passCtrl,
          ),
          // Boton usado para el ingreso y el post de los valores de los campos
          BotonAzul(
            text: 'Ingresar', 
            onPressed: authService.autenticando ? null : () async{
              // Quitar el teclado el foco en este campo al presionar el ingresar
              FocusScope.of(context).unfocus();
              // Ejecucion del Login con la peticion http
              // Enviando la informacion al login, comprobado que funciona
              final loginOk = await authService.login(emailCtrl.text.trim(), passCtrl.text.trim());
              // Comprobando la autenticacion si fue exitosa
              if (loginOk) {
                // TODO: Conectar a nuestro socket server
                // Moviendonos a la pantalla ya autenticado
                Navigator.pushReplacementNamed(context, 'usuarios');
              } else {
                // Mostrar Alerta llamada del alert de helpers, al no realizarse el login
                mostrarAlerta(context, 'Login Incorrecto', 'Revise las credenciales digitadas nuevamente');
              }
            }
          )
        ],
      ),
    );
  }
}
