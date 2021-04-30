import 'package:flutter/cupertino.dart';
import 'package:time_tracker/common_widgets/raised_buttons.dart';

class IconSignInButton extends RaisedButtons {
  //@required => it specified that a property must be included not its what value
  //should be
  IconSignInButton({
    @required String icon,
    @required String text,
    Color color,
    Color textColor,
    VoidCallback onPressed,
  })  : assert(icon != null),
        assert(text != null),
        super(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Image.asset(
                icon,
                width: 35,
                height: 35,
              ),
              Text(
                text,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: textColor,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Opacity(
                opacity: 0,
                child: Image.asset(
                  'assets/images/user.png',
                  width: 35,
                  height: 35,
                ),
              )
            ],
          ),
          color: color,
          onPressed: onPressed,
        );
}
