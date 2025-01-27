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
    bool isMe = APIs.user.uid == widget.message.fromId;
    return InkWell(
      onLongPress: () {
        _showBottomSheet();
      },
      child: isMe ? _greenMessage() : _blueMessage(),
    );
  }

  Widget _blueMessage() {
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
                    bottomRight: Radius.circular(30))),
            child: Text(
              widget.message.msg,
              style: TextStyle(fontSize: 15, color: Colors.black),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(right: 10),
          child: Text(
            MyDateUtil.getFormattedTime(
                context: context, time: widget.message.sent),
            style: TextStyle(fontSize: 15, color: Colors.black54),
          ),
        ),
      ],
    );
  }

  Widget _greenMessage() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            SizedBox(
              width: 10,
            ),
            Text(
              MyDateUtil.getFormattedTime(
                  context: context, time: widget.message.sent),
              style: TextStyle(fontSize: 15, color: Colors.black54),
            ),
            const SizedBox(
              width: 2,
            ),
            if (widget.message.read.isNotEmpty)
              const Icon(
                Icons.done_all_rounded,
                color: Colors.blue,
                size: 20,
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
                    bottomLeft: Radius.circular(30))),
            child: Text(
              widget.message.msg,
              style: TextStyle(fontSize: 15, color: Colors.black),
            ),
          ),
        ),
      ],
    );
  }

  // bottom sheet
  void _showBottomSheet() {
    showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        builder: (_) {
          return ListView(
            shrinkWrap: true,
            padding: EdgeInsets.only(top: 20, bottom: 20),
            children: [ 
              
              Container(
                height: 4,
                margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(10)
                ),
              ),

              Divider(
                color: Colors.black54,
                endIndent: 15,
                indent: 20,
              ),

              OptionItem(icon: Icon(Icons.copy_all_rounded), name: 'Copy Text', onTap: (){}),

              OptionItem(icon: Icon(Icons.edit, color: Colors.blue,), name: 'Edit Message', onTap: (){}),

              OptionItem(icon: Icon(Icons.delete_forever, color: Colors.red,), name: 'Delete Message', onTap: (){}),

              Divider(
                color: Colors.black54,
                endIndent: 15,
                indent: 20,
              ),

              OptionItem(icon: Icon(Icons.remove_red_eye, color: Colors.blue,), name: 'Sent At', onTap: (){}),

              OptionItem(icon: Icon(Icons.remove_red_eye, color: Colors.red,), name: 'Read At', onTap: (){}),

              //pick profile picture label
              const Text('Pick Profile Picture',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),

              //for adding some space
              SizedBox(height: 20),
            ],
          );
        });
  }
}

class OptionItem extends StatelessWidget {
  final Icon icon;
  final String name;
  final VoidCallback onTap;
  const OptionItem({ required this.icon, required this.name, required this.onTap });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        onTap;
      },
      child: Padding(
        padding: const EdgeInsets.only(left: 10, top: 10, bottom: 10),
        child: Row(
          children: [
            icon,Flexible(child: Text('     $name')),
          ],
        ),
      ),
    );
  }
}
