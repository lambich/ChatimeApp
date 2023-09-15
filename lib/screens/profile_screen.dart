import 'dart:convert';
import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatime/api/apis.dart';
import 'package:chatime/helper/dialogs.dart';
import 'package:chatime/models/chat_user.dart';
import 'package:chatime/screens/auth/login_screen.dart';
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
  final _formKey = GlobalKey<FormState>();
  List<ChatUser> list = [];

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      //for hinding keyboard
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
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
                //for showing progrss dialog
                Dialogs.showProgressBar(context);
                //sign out from app
                await APIs.auth.signOut().then((value) async {
                  await GoogleSignIn().signOut().then((value) {
                    //for hinding progress dialog
                    Navigator.pop(context);

                    //for moving to home screen
                    //Navigator.pop(context);

                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (_) => LoginScreen()));
                  });
                });
              },
              icon: Icon(Icons.logout),
              label: Text('Logout'),
            ),
          ),

          //body
          body: Form(
            key: _formKey,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: mq.width * .05),
              child: SingleChildScrollView(
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
                            errorWidget: (context, url, error) =>
                                const CircleAvatar(
                                    child: Icon(CupertinoIcons.person)),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: MaterialButton(
                            onPressed: () {},
                            elevation: 1,
                            shape: CircleBorder(),
                            color: Colors.white,
                            child: Icon(
                              Icons.edit,
                              color: Colors.blue,
                            ),
                          ),
                        ),
                      ],
                    ),
                    //for additional space
                    SizedBox(width: mq.width, height: mq.height * .03),

                    Text(widget.user.email,
                        style: const TextStyle(
                            color: Colors.black54, fontSize: 16)),

                    //for additional space
                    SizedBox(width: mq.width, height: mq.height * .03),

                    TextFormField(
                      initialValue: widget.user.firstName,
                      onSaved: (val) => APIs.me.firstName = val ?? '',
                      validator: (val) => val != null && val.isNotEmpty
                          ? null
                          : 'Required Field',
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
                      initialValue: widget.user.about,
                      onSaved: (val) => APIs.me.about = val ?? '',
                      validator: (val) => val != null && val.isNotEmpty
                          ? null
                          : 'Required Field',
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
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            _formKey.currentState!.save();
                            APIs.updateUserInfo().then((value) {
                              Dialogs.showSnackBar(
                                  context, 'Profile Updated Successfully');
                            });
                            log('Inside Validator');
                          }
                        },
                        icon: const Icon(Icons.edit),
                        label: const Text(
                          'UPDATE',
                          style: TextStyle(fontSize: 16),
                        ))
                  ],
                ),
              ),
            ),
          )),
    );
  }
}
