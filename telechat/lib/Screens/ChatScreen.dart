import 'dart:convert';
// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
// import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:telechat/api/apis.dart';
import 'package:telechat/models/chat_user.dart';

class Chatscreen extends StatefulWidget {
  final ChatUser user;
  const Chatscreen({super.key, required this.user});

  @override
  State<Chatscreen> createState() => _ChatscreenState();
}

class _ChatscreenState extends State<Chatscreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        flexibleSpace: _appbar(),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: APIs.getAllMsg(),
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
                    print('data: ${jsonEncode(data![0].data())}');
                  // list = data?.map((e) => ChatUser.fromJson(e.data())).toList() ??
                  //     [];
                }
            
                final list = [];
            
                if (list.isNotEmpty) {
                  return ListView.builder(
                      itemCount: list.length,
                      padding: EdgeInsets.only(top: 8),
                      physics: BouncingScrollPhysics(),
                      itemBuilder: (context, index) {
                        return Text('Message: ${list[index]}');
                      });
                } else {
                  return Center(
                    child: Text(
                      'Say Hii!',
                      style: TextStyle(fontSize: 24),
                    ),
                  );
                }
              },
            ),
          ),
          _chatInput()
        ],
      ),
    );
  }

  // AppBar
  Widget _appbar() {
    return InkWell(
      onTap: () {},
      child: Row(
        children: [
          IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.arrow_back,
                color: Colors.black54,
              )),
          
          const SizedBox(
            width: 15,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 10,
              ),
              Text(
                widget.user.email,
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.black54,
                    fontWeight: FontWeight.w500),
              ),
              const SizedBox(
                height: 3,
              ),
              Text(
                'Last seen not availaible',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  // Bottom chat input box
  Widget _chatInput() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Row(
        children: [
          Expanded(
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              child: Row(
                children: [
                  IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.emoji_emotions,
                        color: Colors.blueAccent,
                        size: 28,
                      )),
                  const Expanded(
                      child: TextField(
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    decoration: InputDecoration(
                        hintText: 'Type Something:',
                        hintStyle: TextStyle(color: Colors.blueAccent),
                        border: InputBorder.none),
                  )),
                  IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.image,
                        color: Colors.blueAccent,
                        size: 27,
                      )),
                  IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.camera_alt,
                        color: Colors.blueAccent,
                        size: 27,
                      )),
                  const SizedBox(
                    width: 5,
                  ),
                ],
              ),
            ),
          ),
          MaterialButton(
            onPressed: () {},
            shape: const CircleBorder(),
            minWidth: 0,
            padding: EdgeInsets.only(top: 10, bottom: 10, right: 5, left: 10),
            color: Colors.green,
            child: Icon(
              Icons.send,
              color: Colors.white,
            ),
          )
        ],
      ),
    );
  }
}
