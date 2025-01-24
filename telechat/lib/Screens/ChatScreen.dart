// import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';

import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'package:flutter/material.dart';
import 'package:telechat/Screens/HomeScreen.dart';
import 'package:telechat/Widgets/MessageCard.dart';
import 'package:telechat/api/apis.dart';
import 'package:telechat/models/Messages.dart';
import 'package:telechat/models/chat_user.dart';

class Chatscreen extends StatefulWidget {
  final ChatUser user;
  const Chatscreen({super.key, required this.user});

  @override
  State<Chatscreen> createState() => _ChatscreenState();
}

class _ChatscreenState extends State<Chatscreen> {
  List<Messages> _list = [];
  final TextEditingController textcontroller = TextEditingController();
  bool _showEmoji = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: PopScope(
        canPop: false,
        onPopInvokedWithResult: (_, __) {
          if (_showEmoji) {
            setState(() => _showEmoji = !_showEmoji);
            return;
          }

          // some delay before pop
          Future.delayed(const Duration(milliseconds: 300), () {
            try {
              if (Navigator.canPop(context)) Navigator.pop(context);
            } catch (e) {
              print('ErrorPop: $e');
            }
          });
        },
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            flexibleSpace: _appbar(),
          ),
          backgroundColor: Color.fromARGB(255, 234, 248, 255),
          body: Column(
            children: [
              Expanded(
                child: StreamBuilder(
                  stream: APIs.getAllMsg(widget.user),
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                      case ConnectionState.none:
                        return const Center(
                          child: SizedBox(),
                        );
                      case ConnectionState.active:
                      case ConnectionState.done:
                        final data = snapshot.data?.docs;
                        // print('data: ${jsonEncode(data![0].data())}');
                        _list = data
                                ?.map((e) => Messages.fromJson(e.data()))
                                .toList() ??
                            [];
                    }

                    // _list.add(Messages(toId: 'xyz', msg: 'Hey Bro', read: '', type: 'text', fromId: APIs.user.uid, sent: '1:04 AM'));
                    // _list.add(Messages(toId: APIs.user.uid, msg: 'Hey Bro wassup', read: '', type: 'text', fromId: 'xyz', sent: '1:05 AM'));

                    if (_list.isNotEmpty) {
                      return ListView.builder(
                          itemCount: _list.length,
                          padding: EdgeInsets.only(top: 8),
                          physics: BouncingScrollPhysics(),
                          itemBuilder: (context, index) {
                            return Messagecard(
                              message: _list[index],
                            );
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
              _chatInput(),

              //show emojis on keyboard emoji button click & vice versa
              if (_showEmoji)
                SizedBox(
                  height: 10,
                  child: EmojiPicker(
                    textEditingController: textcontroller,
                    config: Config(
                      height: 256,
                      checkPlatformCompatibility: true,
                      emojiViewConfig: EmojiViewConfig(
                        // Issue: https://github.com/flutter/flutter/issues/28894
                        emojiSizeMax: 20 * (Platform.isIOS ? 1.30 : 1.0),
                      ),
                      viewOrderConfig: const ViewOrderConfig(
                        top: EmojiPickerItem.categoryBar,
                        middle: EmojiPickerItem.emojiView,
                        bottom: EmojiPickerItem.searchBar,
                      ),
                      skinToneConfig: const SkinToneConfig(),
                      categoryViewConfig: const CategoryViewConfig(),
                      bottomActionBarConfig: const BottomActionBarConfig(),
                      searchViewConfig: const SearchViewConfig(),
                    ),
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }

  // AppBar
  Widget _appbar() {
    return InkWell(
        onTap: () {},
        child: StreamBuilder(
            stream: APIs.getUserInfo(widget.user),
            builder: (context, snapshot) {
              final data = snapshot.data?.docs;
              final list =
                  data?.map((e) => ChatUser.fromJson(e.data())).toList() ?? [];

              return Row(
                children: [
                  IconButton(
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (_) => Homescreen()));
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
                        list.isNotEmpty
                            ? list[0].lastActive
                            : widget.user.lastActive,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black54,
                        ),
                      )
                    ],
                  )
                ],
              );
            }));
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
                      onPressed: () {
                        setState(() {
                          _showEmoji = !_showEmoji;
                        });
                      },
                      icon: const Icon(
                        Icons.emoji_emotions,
                        color: Colors.blueAccent,
                        size: 28,
                      )),
                  Expanded(
                      child: TextField(
                    keyboardType: TextInputType.multiline,
                    controller: textcontroller,
                    onTap: () {
                      if (_showEmoji)
                        setState(() {
                          FocusScope.of(context).unfocus();
                          _showEmoji = !_showEmoji;
                        });
                    },
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
            onPressed: () {
              if (textcontroller.text.isNotEmpty) {
                APIs.sendMessage(widget.user, textcontroller.text);
                textcontroller.text = '';
              }
            },
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
