import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:telechat/Screens/ChatScreen.dart';
import 'package:telechat/models/chat_user.dart';
// import 'package:telechat/main.dart';

class ChatUserCard extends StatefulWidget {
  final ChatUser user;
  const ChatUserCard({super.key, required this.user});

  @override
  State<ChatUserCard> createState() => _ChatUserCardState();
}

class _ChatUserCardState extends State<ChatUserCard> {
  
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      color: Color.fromARGB(255, 237, 228, 228),
      elevation: 2,
      child: InkWell(
        onTap: (){
          Navigator.push(context, MaterialPageRoute(builder: (_)=> Chatscreen(user: widget.user,)));
        },
        child: ListTile(
          leading: CircleAvatar(child: Icon(CupertinoIcons.person),),
          title: Text(widget.user.email),
          subtitle: Text(widget.user.name, maxLines: 1,),
          trailing: Container(
            width: 15,
            height: 15,
            decoration: BoxDecoration(
              color: Colors.deepOrangeAccent,
              borderRadius: BorderRadius.circular(10)
            ),
          ),
        ),
      ),
    );
  }
}