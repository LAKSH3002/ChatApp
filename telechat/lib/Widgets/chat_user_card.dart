import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:telechat/main.dart';

class ChatUserCard extends StatefulWidget {
  const ChatUserCard({super.key});

  @override
  State<ChatUserCard> createState() => _ChatUserCardState();
}

class _ChatUserCardState extends State<ChatUserCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      color: Color.fromARGB(255, 240, 179, 179),
      elevation: 1,
      child: InkWell(
        onTap: (){},
        child: ListTile(
          leading: CircleAvatar(child: Icon(CupertinoIcons.person),),
          title: Text('User 1'),
          subtitle: Text('Last User message', maxLines: 1,),
          trailing: Text('12:00pm', style: TextStyle(color: Colors.black54),),
        ),
      ),
    );
  }
}