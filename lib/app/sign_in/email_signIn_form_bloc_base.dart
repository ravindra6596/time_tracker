import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker/app/sign_in/email_signIn_bloc.dart';
import 'package:time_tracker/common_widgets/exception_alert_dialog.dart';
import 'package:time_tracker/common_widgets/form_submit_btn.dart';
import 'package:time_tracker/services/auth.dart';

import 'email_signIn_model.dart';

//EmailSignInBlac + EmailSignInForm
//is it worth it ?
//Yes. BLoC moves business logic and state away from Widget class
//
class EmailSignInFormBlocBase extends StatefulWidget {
  EmailSignInFormBlocBase({@required this.bloc});
  final EmailSignInBloc bloc;
  static Widget create(BuildContext context) {
    final auth = Provider.of<AuthBase>(context, listen: false);
    return Provider<EmailSignInBloc>(
      create: (_) => EmailSignInBloc(auth: auth),
      child: Consumer<EmailSignInBloc>(
        builder: (_, bloc, __) => EmailSignInFormBlocBase(
          bloc: bloc,
        ),
      ),
      dispose: (_, bloc) => bloc.dispose(),
    );
  }

  @override
  _EmailSignInFormBlocBaseState createState() =>
      _EmailSignInFormBlocBaseState();
}

class _EmailSignInFormBlocBaseState extends State<EmailSignInFormBlocBase> {
  //Text Editing Controller
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  //Focusnode
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  //@override => add this annotaion when override superclass method
  //use dispose() to dispose object that are no longer needed when widgets
  //are removed
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  void _submit() async {
    try {
      await widget.bloc.submit();
      Navigator.of(context).pop();
    } on FirebaseAuthException catch (e) {
      showExceptionAlertDialog(
        context,
        title: 'Sign In Failed',
        exception: e, //'Invalid Credentials Please Try Again ! .',
      );
    }
  }

  void _toggleFormType() {
    widget.bloc.toggleFormType();
    _emailController.clear();
    _passwordController.clear();
  }

  void _emailEditingComplete(EmailSignInModel model) {
    final newFocus = model.emailValidator.isValid(model.email)
        ? _passwordFocusNode
        : _emailFocusNode;
    FocusScope.of(context).requestFocus(newFocus);
  }

  List<Widget> _buildChildern(EmailSignInModel model) {
    return [
      _buildEmailTextField(model),
      SizedBox(
        height: 8.0,
      ),
      _buildPasswordTextField(model),
      SizedBox(
        height: 8.0,
      ),
      FormSubmitButton(
        text: model.primaryButtonText,
        onPressed: model.canSubmit ? _submit : null,
      ),
      SizedBox(
        height: 8.0,
      ),
      FlatButton(
        onPressed: !model.isLoading ? _toggleFormType : null,
        child: Text(
          model.secondoryButtonText,
        ),
      ),
    ];
  }

//Important Note:
//email & password in textfield + TextEditingController
//must be always un sync with
//email and password inside email EmailSignInModel
  TextField _buildEmailTextField(EmailSignInModel model) {
    return TextField(
      controller: _emailController,
      decoration: InputDecoration(
        labelText: 'Email',
        hintText: 'example@gmail.com',
        errorText: model.emailErrorText,
        enabled: model.isLoading == false,
      ),
      //when u type any on textfields then keyboards shown the suggestion
      //if autocorrect is false then suggetions is not shown on keyboard
      //autocorrect: false,
      keyboardType: TextInputType.emailAddress,
      //the enter btn / -> is next field
      textInputAction: TextInputAction.next,
      focusNode: _emailFocusNode,
      onEditingComplete: () => _emailEditingComplete(model),
      onChanged: widget.bloc.updatePassword,
    );
  }

  TextField _buildPasswordTextField(EmailSignInModel model) {
    return TextField(
      controller: _passwordController,
      decoration: InputDecoration(
        labelText: 'Password',
        errorText: model.passwordErrorText,
        enabled: model.isLoading == false,
      ),
      obscureText: true,
      //the enter btn / -> is next field or dont click to sign in btn when u
      //tapped on Ok/->/Done/check sign btn then sign in or any action perform or jump to
      //next page or close to the keyboard
      textInputAction: TextInputAction.done,
      focusNode: _passwordFocusNode,
      onEditingComplete: _submit,
      onChanged: widget.bloc.updatePassword,
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<EmailSignInModel>(
        stream: widget.bloc.modelStream,
        initialData: EmailSignInModel(),
        builder: (context, snapshot) {
          final EmailSignInModel model = snapshot.data;
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: _buildChildern(model),
            ),
          );
        });
  }
}
