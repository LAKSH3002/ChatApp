import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:telechat/Screens/HomeScreen.dart';
import 'package:telechat/main.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isAnimate = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 500));
    setState(() {
      _isAnimate = true;
    });
  }

  _handleGoogleButtonClick(){
    _signInWithGoogle().then((user){
      print('\nUser: ${user.user}');
      print('\nUseradditionalInfo: ${user.additionalUserInfo}');
      Navigator.of(context).push(MaterialPageRoute(
      builder: (BuildContext context) =>
      const Homescreen()));
    });
  }

  Future<UserCredential> _signInWithGoogle() async {
  // Trigger the authentication flow
  final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

  // Obtain the auth details from the request
  final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

  // Create a new credential
  final credential = GoogleAuthProvider.credential(
    accessToken: googleAuth?.accessToken,
    idToken: googleAuth?.idToken,
  );

  // Once signed in, return the UserCredential
  return await FirebaseAuth.instance.signInWithCredential(credential);
}


  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Welcome to TeleChat', 
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w700),),
      ),

      body: Stack(
        children: [
          AnimatedPositioned(
            right: _isAnimate? mq.width*.25: -mq.width*.5,
            top: mq.height*.15,
            width: mq.width*.50,
            duration: Duration(seconds: 1),
            child: Image.asset('images/chat.png')),

            Positioned(
            bottom: mq.height*.20,
            width: mq.width*.9,
            right: mq.width*.05,
            height: mq.height*.07,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
              backgroundColor: Colors.lightGreenAccent.shade100, 
              shape: StadiumBorder(), 
              elevation: 1),
            onPressed: (){
               _handleGoogleButtonClick();
            },
            icon: Image.asset('images/google.png', height: 35),
            label: RichText(text: TextSpan(
              style: TextStyle(
                color: Colors.black,
                fontSize: 19
              ),
              children: [
                TextSpan(text:'SignIn with '),
                TextSpan(text: 'Google', style: TextStyle(fontWeight: FontWeight.bold))
              ]
            )) )
      ),
      
      Positioned(
            bottom: mq.height*.20,
            width: mq.width*.9,
            right: mq.width*.05,
            height: mq.height*.07,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
              backgroundColor: Colors.lightGreenAccent.shade100, 
              shape: StadiumBorder(), 
              elevation: 1),
            onPressed: (){
               Navigator.of(context).push(MaterialPageRoute(
                        builder: (BuildContext context) =>
                            const Homescreen()));
            },
            icon: Image.asset('images/google.png', height: 35),
            label: RichText(text: TextSpan(
              style: TextStyle(
                color: Colors.black,
                fontSize: 19
              ),
              children: [
                TextSpan(text:'SignIn with '),
                TextSpan(text: 'Google', style: TextStyle(fontWeight: FontWeight.bold))
              ]
            )) )
      )],
      ),
      
    );
  }
}