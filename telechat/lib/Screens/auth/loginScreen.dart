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
            left: mq.width*.05,
            height: mq.height*.07,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
              backgroundColor: Colors.lightGreenAccent.shade100, 
              shape: StadiumBorder(), 
              elevation: 1),
            onPressed: (){},
            icon: Image.asset('images/google.png', height: mq.height*0.6,),
            label: RichText(text: TextSpan(
              style: TextStyle(
                color: Colors.black,
                fontSize: 19
              ),
              children: [
                TextSpan(text:'SignIn with'),
                TextSpan(text: 'Google')
              ]
            )) )
      )],
      ),
      
    );
  }
}