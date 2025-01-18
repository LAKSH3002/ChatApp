import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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

      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: FloatingActionButton(onPressed: (){},
        child: Icon(Icons.add_circle_outlined),),
      ),
    );
  }
}