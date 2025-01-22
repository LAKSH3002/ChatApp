// import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:telechat/api/apis.dart';
import 'package:telechat/helper/date_util.dart';
import 'package:telechat/models/Messages.dart';

class Messagecard extends StatefulWidget {
  const Messagecard({super.key, required this.message});
  final Messages message;

  @override
  State<Messagecard> createState() => _MessagecardState();
}

class _MessagecardState extends State<Messagecard> {

  

  @override
  Widget build(BuildContext context) {
    return APIs.user.uid == widget.message.fromId ? _greenMessage(): _blueMessage() ;
  }

  Widget _blueMessage(){

     //update last read message if sender and receiver are different
    if (widget.message.read.isEmpty) {
      APIs.updateMessageReadStatus(widget.message);
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Container(
            padding: EdgeInsets.all(10),
            margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            decoration: BoxDecoration(
            color: Color.fromARGB(255, 221, 245, 255),
            border: Border.all(color: Colors.lightBlue),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
              bottomRight: Radius.circular(30)
            )
            ),
            child: Text(
              widget.message.msg,
              style: TextStyle(fontSize: 15, color: Colors.black),
            ),
          ),
        ),
        Padding(
        padding: EdgeInsets.only(right: 10),
        child: Text(
          MyDateUtil.getFormattedTime(context: context, time: widget.message.sent),
          style: TextStyle(fontSize: 15, color: Colors.black54),
        ),),
      ],
    );
  }

  Widget _greenMessage(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            SizedBox(width: 10,),

            if(widget.message.read.isNotEmpty) 
            const Icon(Icons.done_all_rounded, color: Colors.blue, size: 20,),

            const SizedBox(width: 2,),

            Text(
              MyDateUtil.getFormattedTime(context: context, time: widget.message.sent),
              style: TextStyle(fontSize: 15, color: Colors.black54),
            ),
          ],
        ),

        Flexible(
          child: Container(
            padding: EdgeInsets.all(10),
            margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            decoration: BoxDecoration(
            color: Color.fromARGB(255, 218, 255, 176),
            border: Border.all(color: Colors.lightBlue),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
              bottomLeft: Radius.circular(30)
            )
            ),
            child: Text(
              widget.message.msg,
              style: TextStyle(fontSize: 15, color: Colors.black),
            ),
          ),
        ),
      ],
    );
  }
}