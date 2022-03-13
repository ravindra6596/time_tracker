import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker/app/home/home_page.dart';
import 'package:time_tracker/app/sign_in/sign_in.dart';
import 'package:time_tracker/services/auth.dart';
import 'package:time_tracker/services/database.dart';

//This is home page of our app

class LandingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthBase>(context, listen: false);
    return StreamBuilder<User>(
      stream: auth.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          final User user = snapshot.data;

          if (user == null) {
            // onSignIn: _updateUser,
            return SignIn.create(context);
          } else {
            // onSignOut: () => _updateUser(null),
            return Provider<Database>(
              create: (_)=> FirestoreDatabase(uid: user.uid),
              child: HomePage(),);
          }
        }
        return Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}
