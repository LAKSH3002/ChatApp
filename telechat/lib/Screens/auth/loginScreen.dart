import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:telechat/main.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: Icon(CupertinoIcons.home),
        title: Text('Welcome to TeleChat'),
      ),

      body: Stack(
        children: [
          Positioned(
            top: mq.height*.15,
            width: mq.width*.50,
            left: mq.width*.25,
            child: Image.asset('images/chat.png')),

            Positioned(
            bottom: mq.height*.15,
            width: mq.width*.9,
            left: mq.width*.1,
            child: ElevatedButton(onPressed: (){
            
            }, child: )
        ],
      ),
      
    );
  }
}