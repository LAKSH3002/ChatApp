import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
// import 'package:google_api_availability/google_api_availability.dart';
// import 'package:provider/provider.dart';
// import 'package:flutter/services.dart';
import 'package:telechat/Screens/HomeScreen.dart';
import 'package:telechat/Screens/auth/loginscreen2.dart';
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
    // _updateSecurityProvider();
    Future.delayed(Duration(milliseconds: 500), (){
    setState(() {
      _isAnimate = true;
    });
    });

  }

  _handleGoogleButtonClick() async{
    showDialog(context: context, builder: (_)=>const CircularProgressIndicator());
    
      final user = await signInWithGoogle();
      Navigator.pop(context);
      // ignore: unnecessary_null_comparison
      if(user != null){
      print('\nUser: ${user.user}');
      print('\nUseradditionalInfo: ${user.additionalUserInfo}');

      Navigator.of(context).push(MaterialPageRoute(
      builder: (BuildContext context) =>
      const Homescreen()));
      }
     
  }

  Future<UserCredential?> signInWithGoogle() async {
  try{
  await GoogleSignIn().disconnect(); 
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
  }catch(e){
    print(e);
    ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text('Something Went wrong - Check Internet'), backgroundColor: Colors.blue.withOpacity(.8),));
    return null;
  }
  
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
            right: _isAnimate? mq.width * .25: -mq.width * .5,
            top: mq.height*.15,
            width: mq.width*.5,
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
      ),

      Positioned(
            bottom: mq.height*.10,
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
                            const Login_Screen2()));
            },
            label: RichText(text: TextSpan(
              style: TextStyle(
                color: Colors.black,
                fontSize: 19
              ),
              children: [
                TextSpan(text:'SignIn without '),
                TextSpan(text: 'Google', style: TextStyle(fontWeight: FontWeight.bold))
              ]
            )) )
      ),
      ],
      ),
      
      
    );
  }
}

// void _updateSecurityProvider() async {
//   try {
//     await ProviderInstaller.installIfNeeded();
//     print('ProviderInstaller: Security provider updated successfully.');
//   } on PlatformException catch (e) {
//     print('ProviderInstaller: Failed to update security provider - $e');
//   }
// }