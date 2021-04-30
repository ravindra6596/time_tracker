import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker/app/sign_in/email_signIn.dart';
import 'package:time_tracker/app/sign_in/sign_in_manager.dart';
import 'package:time_tracker/common_widgets/exception_alert_dialog.dart';
import 'package:time_tracker/services/auth.dart';
import 'icon_sign_in_btn.dart';

//when can use stateless widget = >
//it is pure
//when it always look and behaves in same way based on the imput configuration
//
//stateless to stateful => ctrl+. in VS Code Alt+Enter in Android Studio
class SignIn extends StatelessWidget {
  const SignIn({
    Key key,
    @required this.manager,
    @required this.isLoading,
  }) : super(key: key);
  final SignInManager manager;
  final bool isLoading;

  //use a static create(context) method when creating widgets that require a bloc
  //benifits=>
  //- more maintainble code
  //- better separation of concerns
  //- better APIs
  static Widget create(BuildContext context) {
    final auth = Provider.of<AuthBase>(context, listen: false);
    return ChangeNotifierProvider<ValueNotifier<bool>>(
      create: (_) => ValueNotifier<bool>(false),
      child: Consumer<ValueNotifier<bool>>(
        builder: (_, isLoading, __) => Provider<SignInManager>(
          create: (_) => SignInManager(auth: auth, isLoading: isLoading),
          child: Consumer<SignInManager>(
            builder: (_, manager, __) => SignIn(
              manager: manager,
              isLoading: isLoading.value,
            ),
          ),
        ),
      ),
    );
  }

  void _showSignInError(BuildContext context, Exception exception) {
    if (exception is FirebaseException &&
        exception.code == 'ERROR_ABORTED_BY_USER') {
      return;
    }
    showExceptionAlertDialog(
      context,
      title: 'Sign In Failed!',
      exception: exception,
    );
  }

  Future<void> _signInAnonymously(BuildContext context) async {
    try {
      await manager.signInAnonymously();
    } on Exception catch (e) {
      _showSignInError(context, e);
    }
  }

  Future<void> _signInWithGoogle(BuildContext context) async {
    try {
      await manager.signInGoogle();
    } on Exception catch (e) {
      _showSignInError(context, e);
    }
  }

  Future<void> _signInWithFacebook(BuildContext context) async {
    try {
      await manager.signInWithFacebook();
    } on Exception catch (e) {
      _showSignInError(context, e);
    }
  }

  void _signInWithEmail(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        //==== fullscreenDialog  ==== >
        //we use fullscreen dialog is mean the app bar has a X symbol
        //like the page is close but if u dont use the App bar is like display
        //the <- or < Symbol fullScreenDialog is by Default FALSE
        //and one thing this is false the destination screen is slide is on the
        //right side & its TRUE the screen slide in bottom side Only For iOS
        //while android navigation take place on bottom
        fullscreenDialog: true,
        builder: (context) => EmailSignIn(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Time Tracker'), centerTitle: true,
        // elevation: 5, //elevation=Shodow
      ),
      backgroundColor: Colors.grey[200],
      body: _buildContent(context),
    );
  }

  Widget _buildContent(
    BuildContext context,
  ) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        //Main Axis Alignment = Vertical
        // Cross Axis Alignment = Horizontal
        //In sign in button we dont used the icon with btn just used simple
        //raised btn so u can use the SignInButton class inside sign_in_btn.dart file
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            height: 50.0,
            child: _buildHeader(),
          ),

          SizedBox(
            height: 50,
          ), //Its fixed space betwen widget
          IconSignInButton(
            icon: 'assets/images/google.png',
            text: 'Sign In With Google',
            textColor: Colors.black87,
            color: Colors.white,
            onPressed: isLoading ? null : () => _signInWithGoogle(context),
          ),
          SizedBox(
            height: 8,
          ),
          IconSignInButton(
            icon: 'assets/images/facebook.png',
            text: 'Sign In With Facebook',
            textColor: Colors.white,
            color: Color(0xFF334D92),
            onPressed: isLoading ? null : () => _signInWithFacebook(context),
          ),
          SizedBox(
            height: 8,
          ),
          IconSignInButton(
            icon: 'assets/images/gmail.png',
            text: 'Sign In With email',
            textColor: Colors.white,
            color: Colors.teal[700],
            onPressed: isLoading ? null : () => _signInWithEmail(context),
          ),
          SizedBox(
            height: 8,
          ),
          Text(
            'Or',
            style: TextStyle(
              fontSize: 14,
              color: Colors.black87,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: 8,
          ),
          IconSignInButton(
            icon: 'assets/images/user.png',
            text: 'Anonymous Sign In',
            textColor: Colors.black,
            color: Colors.lime[300],
            onPressed: () => _signInAnonymously(context),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    if (isLoading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
    return Text(
      'Sign In',
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}
