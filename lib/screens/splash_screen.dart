import 'dart:developer';

import 'package:chatime/api/apis.dart';
import 'package:chatime/screens/home_screen.dart';
import 'package:chatime/screens/auth/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../main.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _isAnimated = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      //exit full screen
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
      SystemChrome.setSystemUIOverlayStyle(
          const SystemUiOverlayStyle(statusBarColor: Colors.transparent));

      if (APIs.auth.currentUser != null) {
        log('\nUser: ${APIs.auth.currentUser}');
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => HomeScreen()));
      } else {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => LoginScreen()));
      }
      //navigate to login screen
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => LoginScreen()));
    });
  }

  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.of(context).size;
    return Scaffold(
      //app bar
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Welcome to Chatime'),
      ),

      body: Stack(children: [
        //position of icon
        Positioned(
            top: mq.height * .15,
            width: mq.width * .5,
            right: mq.width * .25,
            child: Image.asset('images/paper-plane.png')),

        //position of login button
        Positioned(
            bottom: mq.height * .15,
            width: mq.width * .6,
            child: const Text('Made By LamBich')),
      ]),
    );
  }
}
