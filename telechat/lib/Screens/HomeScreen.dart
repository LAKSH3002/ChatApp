import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:telechat/Screens/ProfileScreen.dart';
import 'package:telechat/Widgets/chat_user_card.dart';
import 'package:telechat/api/apis.dart';
import 'package:telechat/models/chat_user.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  List<ChatUser> list = [];

  @override
  void initState() {
    super.initState();
    APIs.getSelfInfo();
    APIs.updateActiveStatus(true);

    //for updating user active status according to lifecycle events
    //resume -- active or online
    //pause  -- inactive or offline
    SystemChannels.lifecycle.setMessageHandler((message) {
      print('Message: $message');

      if (APIs.auth.currentUser != null) {
        if (message.toString().contains('resume')) {
          APIs.updateActiveStatus(true);
        }
        if (message.toString().contains('pause')) {
          APIs.updateActiveStatus(false);
        }
      }

      return Future.value(message);
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Focus.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 239, 239, 206),
          leading: Icon(CupertinoIcons.home),
          title: Text('TeleChat'),
          actions: [
            // Icon to move to profile page
            IconButton(
                onPressed: () {
                  // Navigator.push(context, MaterialPageRoute(builder: (_)=> Profilescreen(user: APIs.me)));
                  // ignore: unnecessary_null_comparison
                  if (APIs.me != null) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => Profilescreen(user: APIs.me!),
                      ),
                    );
                  } else {
                    // Show a loading message or prevent navigation
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('User data is not yet loaded.')),
                    );
                  }
                },
                icon: Icon(Icons.account_box))
          ],
        ),
        body: StreamBuilder(
          stream: APIs.getAllUsers(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
              case ConnectionState.none:
                return const Center(
                  child: CircularProgressIndicator(),
                );
              case ConnectionState.active:
              case ConnectionState.done:
                final data = snapshot.data?.docs;
                list = data?.map((e) => ChatUser.fromJson(e.data())).toList() ??
                    [];
            }

            if (list.isNotEmpty) {
              return ListView.builder(
                  itemCount: list.length,
                  padding: EdgeInsets.only(top: 8),
                  physics: BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    return ChatUserCard(user: list[index]);
                  });
            } else {
              return Center(
                child: Text('No connections found'),
              );
            }
          },
        ),
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: FloatingActionButton(
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              await GoogleSignIn().signOut();
            },
            child: Icon(Icons.add_circle_outlined),
          ),
        ),
      ),
    );
  }
}
