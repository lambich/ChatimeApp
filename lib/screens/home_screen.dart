import 'dart:developer';
import 'package:chatime/api/apis.dart';
import 'package:chatime/widgets/chat_user_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../main.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //app bar
      appBar: AppBar(
        leading: Icon(CupertinoIcons.home),
        title: const Text('Chatime'),
        actions: [
          //search user button
          IconButton(onPressed: () {}, icon: const Icon(Icons.search)),

          //more features button
          IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert))
        ],
      ),

      //floating button to add new user
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: FloatingActionButton(
            onPressed: () {}, child: Icon(Icons.add_comment_rounded)),
      ),
      //body
      body: StreamBuilder(
        stream: APIs.firestore.collection('users').snapshots(),
        builder: (context, snapshot) {
          final list = [];

          if (snapshot.hasData) {
            final data = snapshot.data?.docs;
            for (var i in data!) {
              log('Data: ${i.data()}');
              list.add(i.data()['name']);
            }
          }
          return ListView.builder(
              itemCount: list.length,
              padding: EdgeInsets.only(top: mq.height * .01),
              physics: BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                return const ChatUserCard();
                //return Text('Name ${list[index]}');
              });
        },
      ),
    );
  }
}
