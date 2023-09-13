import 'dart:convert';
import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatime/api/apis.dart';
import 'package:chatime/models/chat_user.dart';
import 'package:chatime/screens/home_screen.dart';
import 'package:chatime/widgets/chat_user_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../main.dart';

class ProfileScreen extends StatefulWidget {
  final ChatUser user;

  const ProfileScreen({super.key, required this.user});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  List<ChatUser> list = [];

  @override
  Widget build(BuildContext context) {
    var _textFormFieldController;
    return Scaffold(
        //app bar
        appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (_) => HomeScreen()));
              },
              icon: const Icon(CupertinoIcons.back)),
          title: const Text('Profile screen'),
          actions: [],
        ),

        //floating button to add new user
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: FloatingActionButton.extended(
            backgroundColor: Colors.red,
            onPressed: () async {
              await APIs.auth.signOut();
              await GoogleSignIn().signOut();
            },
            icon: Icon(Icons.logout),
            label: Text('Logout'),
          ),
        ),

        //body
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: mq.width * .05),
          child: Column(
            children: [
              //for adding some space
              SizedBox(width: mq.width, height: mq.height * .03),

              //user profile picture
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(mq.height * .3),
                    child: CachedNetworkImage(
                      width: mq.height * .2,
                      height: mq.height * .2,
                      fit: BoxFit.fill,
                      imageUrl: widget.user.avatar,
                      placeholder: (context, url) =>
                          CircularProgressIndicator(),
                      errorWidget: (context, url, error) => const CircleAvatar(
                          child: Icon(CupertinoIcons.person)),
                    ),
                  ),
                  MaterialButton(
                    onPressed: () {},
                    color: Colors.white,
                    child: Icon(
                      Icons.edit,
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
              //for additional space
              SizedBox(width: mq.width, height: mq.height * .03),

              Text(widget.user.email,
                  style: const TextStyle(color: Colors.black54, fontSize: 16)),

              //for additional space
              SizedBox(width: mq.width, height: mq.height * .03),

              TextFormField(
                initialValue: widget.user.firstName,
                decoration: InputDecoration(
                  prefixIcon: Icon(
                    Icons.person,
                    color: Colors.blue,
                  ),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                  hintText: 'eg, John Smith',
                  label: Text('Name'),
                ),
              ),

              //for additional space
              SizedBox(width: mq.width, height: mq.height * .03),

              TextFormField(
                controller: _textFormFieldController,
                initialValue: widget.user.about,
                decoration: InputDecoration(
                  prefixIcon: Icon(
                    Icons.info,
                    color: Colors.blue,
                  ),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                  hintText: 'eg, I am a singer',
                  label: Text('About'),
                ),
              ),

              //for additional space
              SizedBox(width: mq.width, height: mq.height * .05),

              ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                      shape: StadiumBorder(),
                      fixedSize: Size(mq.width * .5, mq.height * .06)),
                  onPressed: () async {
                    String textValue = _textFormFieldController.text;
                    String userId = widget.user.id;
                    try {
                      await FirebaseFirestore.instance
                          .collection('users')
                          .doc(userId)
                          .update({'about': textValue});
                      log('Updated successfully');
                    } catch (e) {
                      log('Error: $e');
                    }
                  },
                  icon: const Icon(Icons.edit),
                  label: const Text(
                    'UPDATE',
                    style: TextStyle(fontSize: 16),
                  ))
            ],
          ),
        ));
  }
}
