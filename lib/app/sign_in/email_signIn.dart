import 'package:flutter/material.dart';
import 'package:time_tracker/app/sign_in/email_signIn_form_bloc_base.dart';
import 'package:time_tracker/app/sign_in/email_signIn_form_change_notifier.dart';
import 'package:time_tracker/app/sign_in/email_signIn_form_stateful.dart';

class EmailSignIn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign In'), centerTitle: true,
        // elevation: 5, //elevation=Shodow
      ),
      backgroundColor: Colors.grey[200],
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Card(
            child: EmailSignInFormChangeNotifier.create(context),
          ),
        ),
      ),
    );
  }
}
