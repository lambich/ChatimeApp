import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Add login form components here
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text('Welcome to Chatime!'),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Email'),
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Password'),
                  obscureText: true, // Hide the password
                ),
                ElevatedButton(
                  onPressed: () {
                    // Add logic for handling login here
                  },
                  child: Text('Login'),
                ),
                TextButton(
                  onPressed: () {
                    // Add logic for navigating to the forgot password screen
                  },
                  child: Text('Forgot Password?'),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
