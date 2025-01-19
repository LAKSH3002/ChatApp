import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:telechat/Widgets/chat_user_card.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(CupertinoIcons.home),
        title: Text('TeleChat'),
        actions: [
          // Icon to search
          IconButton(onPressed: (){}, icon: Icon(Icons.search)),
          // Icon to move to profile page
          IconButton(onPressed: (){}, icon: Icon(Icons.account_box))
        ],
      ),

      body: ListView.builder(
        itemCount: 9,
        padding: EdgeInsets.only(top:8),
        physics: BouncingScrollPhysics(),
        itemBuilder: (context, index){
          return ChatUserCard();
        }),

      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: FloatingActionButton(onPressed: () async {
          await FirebaseAuth.instance.signOut();
          await GoogleSignIn().signOut();
        },
        child: Icon(Icons.add_circle_outlined),),
      ),
    );
  }
}