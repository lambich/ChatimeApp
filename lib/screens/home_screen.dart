import 'dart:convert';
import 'dart:developer';
import 'package:chatime/api/apis.dart';
import 'package:chatime/models/chat_user.dart';
import 'package:chatime/screens/profile_screen.dart';
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
  List<ChatUser> _list = [];
  List<ChatUser> _searchList = [];
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    APIs.getSelfInfo();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: WillPopScope(
        //If search is on then back button is pressed then close the search
        //or else simple close current screen on Back button click
        onWillPop: () {
          if (_isSearching) {
            setState(() {
              _isSearching = !_isSearching;
            });
            return Future.value(false);
          } else {
            return Future.value(true);
          }
        },
        child: Scaffold(
          //app bar
          appBar: AppBar(
            leading: IconButton(
                onPressed: () {
                  Navigator.pushReplacement(
                      context, MaterialPageRoute(builder: (_) => HomeScreen()));
                },
                icon: const Icon(CupertinoIcons.home)),
            title: _isSearching
                ? TextField(
                    decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Name, Email, etc...',
                        hintStyle: TextStyle(color: Colors.white)),
                    autofocus: true,
                    style: const TextStyle(
                        fontSize: 17, letterSpacing: 0.5, color: Colors.white),
                    //when search list changes then updated search list
                    onChanged: (val) {
                      //search logic
                      _searchList.clear();

                      for (var i in _list) {
                        if (i.firstName
                                .toLowerCase()
                                .contains(val.toLowerCase()) ||
                            i.email.toLowerCase().contains(val.toLowerCase())) {
                          _searchList.add(i);
                        }
                        setState(() {
                          _searchList;
                        });
                      }
                    },
                  )
                : Text('Chatime'),
            actions: [
              //search user button
              IconButton(
                  onPressed: () {
                    setState(() {
                      _isSearching = !_isSearching;
                    });
                  },
                  icon: Icon(_isSearching
                      ? CupertinoIcons.clear_circled_solid
                      : Icons.search)),

              //more features button
              IconButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => ProfileScreen(
                                  user: APIs.me,
                                )));
                  },
                  icon: const Icon(CupertinoIcons.profile_circled))
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
            stream: APIs.getAllUser(),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                //if data is loading
                case ConnectionState.waiting:
                case ConnectionState.none:
                  return const Center(child: CircularProgressIndicator());

                //if some or all data is loaded then show it
                case ConnectionState.active:
                case ConnectionState.done:
                  final data = snapshot.data?.docs;
                  _list =
                      data?.map((e) => ChatUser.fromJson(e.data())).toList() ??
                          [];

                  if (_list.isNotEmpty) {
                    return ListView.builder(
                        itemCount:
                            _isSearching ? _searchList.length : _list.length,
                        padding: EdgeInsets.only(top: mq.height * .01),
                        physics: BouncingScrollPhysics(),
                        itemBuilder: (context, index) {
                          return ChatUserCard(
                            user: _isSearching
                                ? _searchList[index]
                                : _list[index],
                          );
                        });
                  } else {
                    return Center(
                      child: Text(
                        'No data found!',
                        style: TextStyle(fontSize: 18),
                      ),
                    );
                  }
              }
            },
          ),
        ),
      ),
    );
  }
}
