import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'package:telechat/Screens/auth/loginScreen.dart';
import 'package:telechat/api/apis.dart';
import 'package:telechat/helper/dialogs.dart';
import 'package:telechat/models/chat_user.dart';

class Profilescreen extends StatefulWidget {
  final ChatUser user;
  const Profilescreen({super.key, 
  required this.user
  });

  @override
  State<Profilescreen> createState() => _ProfilescreenState();
}

class _ProfilescreenState extends State<Profilescreen> {

  final _formkey = GlobalKey<FormState>();
  String? _image;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ()=>FocusScope.of(context).unfocus,
      child: Scaffold(
        appBar: AppBar(
          title: Text('TeleChat'),
        ),
      
        body: Form(
          key: _formkey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(width: 10, height: 40,),
                  Stack(
                    children: [
                      _image !=null ? 
                      // image from local
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.file(
                          File(_image!),
                          width: 200,
                          height: 125,
                          fit: BoxFit.cover,
                        )
                      )
                      :
                      //image from server
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: CachedNetworkImage(
                          width: 200,
                          height: 125,
                          fit: BoxFit.fill,
                          imageUrl: 'images/user.png',
                          errorWidget: (context, url, error)=>
                          const CircleAvatar(child: Icon(CupertinoIcons.person, size: 70,),),),
                      ),
                      Positioned(
                       bottom: 0,
                       right: 0, 
                        child: MaterialButton(onPressed: (){
                        showModalBottomSheet(
                        context: context,
                        shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20), topRight: Radius.circular(20))),
                        builder: (_) {
                        return ListView(
                        shrinkWrap: true,
                        padding:
                        EdgeInsets.only(top: 20, bottom: 20),
                        children: [
                        //pick profile picture label
                        const Text('Pick Profile Picture',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),

                        //for adding some space
                        SizedBox(height: 20),

                        //buttons
                        Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                        //pick from gallery button
                        ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape: const CircleBorder(),
                          ),
                        onPressed: () async {
                          final ImagePicker picker = ImagePicker();
                          // Pick an image.
                          final XFile? image = await picker.pickImage(source: ImageSource.gallery);
                          if(image != null){
                            setState(() {
                              _image = image.path;
                            });
                            print('Image path: ${image.path} -- MimeType: ${image.mimeType}');
                          Navigator.pop(context);
                          }
                        },
                        child: Image.asset('images/image-gallery.png', height: 70, width: 50,)),

                        //take picture from camera button
                        ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape: const CircleBorder(),
                          ),
                        onPressed: () async {
                          final ImagePicker picker = ImagePicker();
                          // Pick an image.
                          final XFile? image = await picker.pickImage(source: ImageSource.camera);
                          if(image != null){
                            setState(() {
                              _image = image.path;
                            });
                            print('Image path: ${image.path} -- MimeType: ${image.mimeType}');
                          Navigator.pop(context);
                          }
                        },
                        child: Image.asset('images/photo-camera-interface-symbol-for-button.png', height: 70, width: 50,)),
                         ],)
                         ],);
                        }); },
                        shape: CircleBorder(),
                        elevation: 1,
                        color: Colors.white,
                        child: Icon(Icons.edit, color: Colors.blue,),
                        ))
                    ],
                  ),
                  SizedBox(width: 10, height: 20,),
                  Text('', style: TextStyle(
                    fontSize: 16, color: Colors.black54
                  ),),
                  SizedBox(width: 10, height: 20,),
                  TextFormField(
                    initialValue: widget.user.email,
                    onSaved: (val) => APIs.me?.email = val ?? '',
                    validator: (val)=> val != null && val.isNotEmpty ? null :'Required',
                    decoration: InputDecoration(
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      prefixIcon: Icon(Icons.person, color: Colors.blue,),
                      hintText: 'eg. abc@gmail.com',
                      label: Text('Email')
                    ),
                  ),
                 SizedBox(width: 10, height: 20,),
                  TextFormField(
                    onSaved: (val)=>APIs.me?.about = val?? '',
                    validator: (val)=> val!= null && val.isNotEmpty?null:'Required',
                    initialValue: widget.user.about,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      prefixIcon: Icon(Icons.person, color: Colors.blue,),
                      hintText: 'eg. Feeling Happy',
                      label: Text('Name')
                    ),
                  ),
                  SizedBox(width: 10, height: 30,),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      elevation: 2,
                      shape: StadiumBorder(),
                      fixedSize: Size(200, 50)
                    ),
                  onPressed: (){
                    if(_formkey.currentState!.validate()){
                      _formkey.currentState!.save();
                      print('inside validator');
                      APIs.updateUserInfo().then((onValue){
                        Dialogs.showSnackBar(context, 'Profile updated successfuly');
                      });

                    }
                  }, icon: Icon(Icons.edit, size: 28,), label: const Text('Update', style: TextStyle(
                    fontSize: 16
                  ),), )
                ],
              ),
            ),
          ),
        ),
      
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: FloatingActionButton.extended(
            backgroundColor: Colors.redAccent,
            onPressed: () async {
            Dialogs.showProgressBar(context);
            await FirebaseAuth.instance.signOut().then((value) async{
              await GoogleSignIn().signOut().then((value){
                Navigator.pop(context);
                Navigator.pop(context);
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=> LoginScreen()));
              });
            });
            
          },
          icon: Icon(Icons.add_circle_outlined, color: Colors.white,),label: Text('Logout',style: TextStyle(color: Colors.white),),),
        ),
      ),
    );
  }
}

