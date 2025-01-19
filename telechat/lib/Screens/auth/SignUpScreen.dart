import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/src/widgets/placeholder.dart';
import 'package:email_validator/email_validator.dart';
import 'package:telechat/Screens/HomeScreen.dart';
import 'package:telechat/Screens/auth/loginscreen2.dart';

class OnBoarding4 extends StatefulWidget {
  const OnBoarding4({super.key});

  @override
  State<OnBoarding4> createState() => _OnBoarding4State();
}

class _OnBoarding4State extends State<OnBoarding4> {
  // text editing controller
  final _formkey = GlobalKey<FormState>();
  bool passwordVisible = true;
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController passwordcontroller = TextEditingController();
  TextEditingController namecontroller = TextEditingController();
  // bool _validate = false;

  @override
  void dispose() {
    emailcontroller.dispose();
    super.dispose();
  }

  // Method to validate the email the take
  // the user email as an input and
  // print the bool value in the console.
  // Function to validate email id.
  void Validate(String email) {
    bool isvalid = EmailValidator.validate(email);
    print(isvalid);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenwidth = MediaQuery.of(context).size.width;

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
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.italic),
        ),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formkey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // const SizedBox(height:15),
              // Text(screenwidth.toString()),
              const SizedBox(height: 35),

              Padding(
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                child: const Text(
                  "Enter The Following Details to get Started with the App",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
              ),

              SizedBox(height: 25),

              Center(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 10, 0, 15),
                  child: SizedBox(
                    width: screenwidth * 0.93,
                    child: TextFormField(
                      controller: namecontroller,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a name';
                        }
                        if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value)) {
                          return 'Name must only contain letters';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.person),
                        hintText: "Enter Your Full name*",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25.0)),
                        errorBorder: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ),
              ),

              Center(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 10, 0, 15),
                  child: SizedBox(
                    width: screenwidth * 0.93,
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
                ),
              ),

              Center(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 10, 0, 15),
                  child: SizedBox(
                    width: screenwidth * 0.93,
                    child: TextFormField(
                        controller: passwordcontroller,
                        obscureText: passwordVisible,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.password_rounded),
                          hintText: "Create Your Own Password*",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25.0)),
                          errorBorder: OutlineInputBorder(),
                          helperText: "Password must be 6 characters long",
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
                ),
              ),

              const SizedBox(height: 50),

              Center(
                child: TextButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (BuildContext context) =>
                              const Login_Screen2()));
                    },
                    child: Text(
                      'Already Have an Account?? Log_In',
                      style: TextStyle(fontSize: 19),
                    )),
              ),

              const SizedBox(
                height: 50,
              ),

              Center(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                  child: SizedBox(
                    width: screenwidth * 0.65,
                    height: 45,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.yellowAccent,
                            backgroundColor: Colors.deepPurple),
                        // User entry with email and password.
                        onPressed: () async {
                          try {
                            if (_formkey.currentState!.validate()) {
                              print('Name: ${namecontroller.text}');
                              print('Email: ${emailcontroller.text}');
                              print('Password: ${passwordcontroller.text}');
                            }
                            await FirebaseAuth.instance
                                .createUserWithEmailAndPassword(
                                    email: emailcontroller.text,
                                    password: passwordcontroller.text)
                                .then((value) {
                              print("New Account Created");
                              showDialog(
                                context: context,
                                builder: (ctx) => AlertDialog(
                                  title:
                                      const Text("Successful registration!!"),
                                  content: const Text(
                                      "You have Created A New Account!!"),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context)
                                            .push(MaterialPageRoute(
                                                builder:
                                                    (BuildContext context) =>
                                                        Homescreen()))
                                            .onError((error, stackTrace) {});
                                      },
                                      child: Container(
                                        color: Colors.green,
                                        padding: const EdgeInsets.all(14),
                                        child: const Text("okay"),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            });
                          } catch (e) {
                            print(e);
                            print("Incomplete Entries");
                          }
                        },
                        child: const Text(
                          "Proceed to App",
                          style: TextStyle(
                              fontSize: 22, fontStyle: FontStyle.italic),
                        )),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

//   Widget dialogbox() {
//     return Container(
//         child: ElevatedButton(
//       onPressed: () {
//         showDialog(
//           context: context,
//           builder: (ctx) => AlertDialog(
//             title: const Text("Successful registration!!"),
//             content: const Text("You have Created A New Account!!"),
//             actions: <Widget>[
//               TextButton(
//                 onPressed: () {
//                   Navigator.of(context)
//                       .push(MaterialPageRoute(
//                           builder: (BuildContext context) => HomeScreen(
//                                 name: namecontroller,
//                                 email: emailcontroller,
//                               )))
//                       .onError((error, stackTrace) {});
//                 },
//                 child: Container(
//                   color: Colors.green,
//                   padding: const EdgeInsets.all(14),
//                   child: const Text("okay"),
//                 ),
//               ),
//             ],
//           ),
//         );
//       },
//       child: null,
//     ));
//   }

// Email Validation done.
// Password Validation done.
// Password icon visibility on and off done.
// Firebase Authentiaction done.
// Firebase Auth done.
// Navigating to home screen on successful registration done.
