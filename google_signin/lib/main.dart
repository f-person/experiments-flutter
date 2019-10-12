import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

GoogleSignIn googleSignIn = GoogleSignIn(
  scopes: [
    'profile',
    'email',
  ],
);

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Google signin',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  GoogleSignInAccount _currentUser;

  @override
  void initState() async {
    googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount account) {
      setState(() {
        _currentUser = account;
      });
    });
    googleSignIn.signInSilently();
    super.initState();
    GoogleSignInAuthentication googleAuth = await _currentUser.authentication;
    print(googleAuth.idToken);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Google Signin'),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_currentUser != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            ListTile(
              leading: GoogleUserCircleAvatar(
                identity: _currentUser,
              ),
              title: Text(_currentUser.displayName ?? ''),
              subtitle: Text(_currentUser.email ?? ''),
            ),
            RaisedButton(
              onPressed: _handleSignOut,
              child: Text('sign out'),
            )
          ],
        ),
      );
    } else {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text('you are not signed in'),
            RaisedButton(
              onPressed: _handleSignIn,
              child: Text('sign in'),
            )
          ],
        ),
      );
    }
  }

  Future<void> _handleSignIn() async {
    try {
      print('_handleSignIn');
      await googleSignIn.signIn();
    } catch (error) {
      print(error);
    }
  }

  Future<void> _handleSignOut() async {
    await googleSignIn.disconnect();
  }
}
