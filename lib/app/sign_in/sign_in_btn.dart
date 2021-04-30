import 'package:flutter/cupertino.dart';
import 'package:time_tracker/common_widgets/raised_buttons.dart';

class SignInButton extends RaisedButtons {
  SignInButton({
    @required String text,
    Color color,
    Color textColor,
    VoidCallback onPressed,
  })  
//assertion(assert) => is useful runtime checks to highlight programming errors
  : assert(text != null),
        super(
          child: Text(
            text,
            style: TextStyle(color: textColor, fontSize: 15),
          ),
          color: color,
          onPressed: onPressed,
        );
}
