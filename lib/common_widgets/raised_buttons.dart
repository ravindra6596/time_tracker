import 'package:flutter/material.dart';

class RaisedButtons extends StatelessWidget {
  RaisedButtons({
    this.child,
    this.color,
    this.borderRadius: 5,
    this.height: 50,
    this.onPressed,
  });
  final Widget child;
  final Color color;
  final double borderRadius;
  final double height;
  final VoidCallback onPressed;
  @override
  Widget build(BuildContext context) {
    //Button=> its Widget when u tap it its tapable like press and
    // when action is perform this is callback
    return SizedBox(
      height: height,
      child: RaisedButton(
        child: child,
        color: color,
        disabledColor: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(
              borderRadius,
            ),
          ),
        ),
        onPressed: onPressed,
      ),
    );
  }
}
