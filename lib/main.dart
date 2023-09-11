import 'package:chatime/screens/home_screen.dart';
import 'package:chatime/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'screens/auth/login_screen.dart'; // Import your login screen file
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

//import 'package:firebase_core/firebase_core.dart'; // Add this line
//global object for accessing device screen size
late Size mq;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  _initializeFirebase();
  runApp(const MyApp()); //should have this
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chatime Application',
      theme: ThemeData(
          appBarTheme: const AppBarTheme(
        centerTitle: true,
        elevation: 1,
        iconTheme: IconThemeData(color: Colors.white),
        titleTextStyle: TextStyle(
            color: Colors.white, fontWeight: FontWeight.normal, fontSize: 19),
        backgroundColor: Colors.blue,
      )),
      //home: LoginScreen(), // Set the login screen as the initial screen
      home: const SplashScreen(),
    );
  }
}

_initializeFirebase() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}
