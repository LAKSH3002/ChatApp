import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:telechat/Screens/ChatScreen.dart';
import 'package:telechat/api/apis.dart';
import 'package:telechat/helper/date_util.dart';
import 'package:telechat/models/Messages.dart';
import 'package:telechat/models/chat_user.dart';
// import 'package:telechat/main.dart';

class ChatUserCard extends StatefulWidget {
  final ChatUser user;
  const ChatUserCard({super.key, required this.user});

  @override
  State<ChatUserCard> createState() => _ChatUserCardState();
}

class _ChatUserCardState extends State<ChatUserCard> {

  Messages? _message;
  
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
        child: StreamBuilder(
          stream: APIs.getLastMessage(widget.user),
          builder: (context, snapshot){
              final data = snapshot.data?.docs;
              final list =
                  data?.map((e) => Messages.fromJson(e.data())).toList() ?? [];
              if (list.isNotEmpty) _message = list[0];  
            return ListTile(
          leading: CircleAvatar(child: Icon(CupertinoIcons.person),),
          title: Text(widget.user.email),
          subtitle: Text(widget.user.about, maxLines: 1,),
          trailing:  _message == null
                    ? null //show nothing when no message is sent
                    : _message!.read.isEmpty &&
                            _message!.fromId != APIs.user.uid
                        ?
                        //show for unread message
                        const SizedBox(
                            width: 15,
                            height: 15,
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                  color: Color.fromARGB(255, 0, 230, 119),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                            ),
                          )
                        :
                        //message sent time
                        Text(
                            MyDateUtil.getLastMessageTime(
                                context: context, time: _message!.sent),
                            style: const TextStyle(color: Colors.black54),
                          ),
        );
          },
        )
      ),
    );
  }
}