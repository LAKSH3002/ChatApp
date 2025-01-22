import 'package:flutter/material.dart';
// import 'package:quizapp/InstructionScreen.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:telechat/Screens/auth/loginScreen.dart';

class Splashscreen extends StatefulWidget {
  const Splashscreen({super.key});

  @override
  State<Splashscreen> createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {
   // bool _isAnimate = false;

  @override
  void initState() {
    super.initState();
    // _updateSecurityProvider();
    Future.delayed(Duration(milliseconds: 500), (){
    });

  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Container(
        // Animated Splash Screen
        child: AnimatedSplashScreen(   
        duration: 3000,
        backgroundColor: const Color.fromARGB(255, 239, 239, 206),
        // splash - is the animation.
        splash: 
        Container(
          height: 400,
        child: Stack(
          children: [
            AnimatedPositioned(
              duration: const Duration(seconds: 1),
              child: Image.asset('images/chat.png', height: 400,)),
        ],
        ),),
        // The Navigation to the next Screen and then Transition to reach there. 
        nextScreen: const LoginScreen(),
        splashTransition: SplashTransition.fadeTransition),
      ),    
    );
  }
}