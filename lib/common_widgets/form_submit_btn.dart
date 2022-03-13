import 'package:flutter/material.dart';
import 'package:time_tracker/common_widgets/raised_buttons.dart';

class FormSubmitButton extends RaisedButtons {
  FormSubmitButton({
    @required String text,
    VoidCallback onPressed,
  }) : super(
          child: Text(
            text,
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
            ),
          ),
          onPressed: onPressed,
          color: Colors.indigo,
          height: 44.0,
          borderRadius: 4.0,
        );
}
