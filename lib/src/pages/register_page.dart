import 'package:chat_app/src/services/socket_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:chat_app/src/helpers/mostrar_alerta.dart';
import 'package:chat_app/src/services/auth_service.dart';
import 'package:chat_app/src/widgets/boton_azul.dart';
import 'package:chat_app/src/widgets/labels.dart';
import 'package:chat_app/src/widgets/custom_input.dart';
import 'package:chat_app/src/widgets/logo.dart';


class RegisterPage extends StatelessWidget {

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
                  titulo: 'Registro',
                ),
                _Form(),
                // Labels de la parte inferior
                Labels(
                  ruta: 'login',
                  titulo: '¿Ya tienes Cuenta?',
                  subtitulo: 'Ingresa con tu cuenta',
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
  final nameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // Invocamos la instancia del authServiceProvider
    final authService = Provider.of<AuthService>(context);
    final socketService = Provider.of<SocketService>(context);
    return Container(
      margin: EdgeInsets.only(top: 40),
      // color: Colors.blue,
      padding: EdgeInsets.symmetric(horizontal: 50),
      child: Column(
        children: [
          // Campos de texto usados en el formulario de registro, el paddin se usa para darle espacio en la parte interior del input text
          CustomInput(
            icon: Icons.perm_identity,
            placeHolder: 'Nombre',
            keyboardType: TextInputType.text,
            textController: nameCtrl,
          ),

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
            text: 'Crear cuenta', 
            onPressed: authService.autenticando ? null : () async{  
              
              // Quitar el teclado el foco en este campo al presionar el ingresar
              FocusScope.of(context).unfocus();
              // Ejecucion del Login con la peticion http
              // Enviando la informacion al login, comprobado que funciona
              final registroOk = await authService.register(nameCtrl.text.trim(), emailCtrl.text.trim(), passCtrl.text.trim());
              // Comprobando la autenticacion si fue exitosa, si el registro es valor booleano
              if (registroOk == true) {
                socketService.connect();
                // Moviendonos a la pantalla ya autenticado
                Navigator.pushReplacementNamed(context, 'usuarios');
              } else {
                // Mostrar Alerta llamada del alert de helpers, al no realizarse el login
                mostrarAlerta(context, 'Registro Incorrecto', registroOk);
              }

            }
          )
        ],
      ),
    );
  }
}
