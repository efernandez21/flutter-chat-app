import 'package:chat_app/src/services/chat_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:chat_app/src/routes/routes.dart';
import 'package:chat_app/src/services/auth_service.dart';
import 'package:chat_app/src/services/socket_service.dart';
 
void main() => runApp(MyApp());
 
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Instanci global de mi Auth Service, como si fuese un singleton, junto con mi socket Service
        ChangeNotifierProvider(create: (_) => new AuthService()),
        ChangeNotifierProvider(create: (_) => new SocketService()),
        ChangeNotifierProvider(create: (_) => new ChatService()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Chat App',
        initialRoute: 'loading',
        routes: appRoutes,
      ),
    );
  }
}