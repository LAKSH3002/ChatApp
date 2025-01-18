import 'package:flutter/material.dart';
import 'package:telechat/Screens/auth/loginScreen.dart';

late Size mq;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TeleChat',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
        appBarTheme: AppBarTheme(
        titleTextStyle: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.normal,
          fontSize: 19
        ),
        iconTheme: IconThemeData(
          color: Colors.black
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 1,
        )
      ),
      home: const LoginScreen()
    );
  }
}