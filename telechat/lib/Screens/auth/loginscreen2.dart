import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// import 'package:telechat/Screens/HomeScreen.dart';
import 'package:telechat/Screens/auth/SignUpScreen.dart';

class Login_Screen2 extends StatefulWidget {
  const Login_Screen2({super.key});

  @override
  State<Login_Screen2> createState() => _Login_Screen2State();
}

class _Login_Screen2State extends State<Login_Screen2> {
  final _formkey = GlobalKey<FormState>();
  bool passwordVisible = true;
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController passwordcontroller = TextEditingController();

  @override
  @override
  Widget build(BuildContext context) {
    FirebaseAuth auth = FirebaseAuth.instance;
    final screenwidth = MediaQuery.of(context).size.width;
    // final screenheight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        elevation: 5,
        centerTitle: true,
        title: Text(
          'TeleChat',
          style: TextStyle(
              fontSize: 20,
              color: Colors.greenAccent,
              fontWeight: FontWeight.bold),
        ),
      ),
      body: Form(
        key: _formkey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height:150),
          
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                child: TextFormField(
                  controller: emailcontroller,
                  keyboardType: TextInputType.multiline,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.email),
                    hintText: "Enter Your Email id*",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0)),
                    errorBorder: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an email';
                    }
                    final emailRegex =
                        RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                    if (!emailRegex.hasMatch(value)) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),
              ),
          
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                child: TextFormField(
                    obscureText: passwordVisible,
                    controller: passwordcontroller,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.password_rounded),
                      hintText: "Enter Your Password*",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0)),
                      errorBorder: OutlineInputBorder(),
                      // helperText:"Password must contain special character",
                      suffixIcon: IconButton(
                        icon: Icon(passwordVisible
                            ? Icons.visibility_off
                            : Icons.visibility),
                        onPressed: () {
                          setState(
                            () {
                              passwordVisible = !passwordVisible;
                            },
                          );
                        },
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      }
                      // Validate password length between 6 to 13 characters
                      if (value.length < 6 || value.length > 13) {
                        return 'Password must be 6 to 13 characters long';
                      }
                      return null;
                    },
                    keyboardType: TextInputType.visiblePassword,
                    textInputAction: TextInputAction.done),
              ),
          
              const SizedBox(height: 50),
              Center(
                child: SizedBox(
                  width: screenwidth * 0.6,
                  height: 45,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.yellowAccent, backgroundColor: Colors.deepPurple),
                    onPressed: () async {
                      if (_formkey.currentState!.validate()) {
                        print('Email: ${emailcontroller.text}');
                        print('Password: ${passwordcontroller.text}');
                      }
                      try {
                        // ignore: unused_local_variable
                        final userCredential =
                            await auth.signInWithEmailAndPassword(
                          email: emailcontroller.text.trim(),
                          password: passwordcontroller.text.trim(),
                        );
                      } catch (e) {
                        print('Error: $e');
                      }
                    },
                    child: const Text(
                      "Login",
                      style:
                          TextStyle(fontSize: 22, fontStyle: FontStyle.italic),
                    ),
                  ),
                ),
              ),
          
              const SizedBox(height: 20),
          
              Center(
                child: TextButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (BuildContext context) =>
                              const OnBoarding4()));
                    },
                    child: Text(
                      'Dont have an Account?? Sign_Up',
                      style: TextStyle(fontSize: 19),
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Email Validation is done
// Password validation is done
// Email and Password Credentials checking is left - The Major Part.