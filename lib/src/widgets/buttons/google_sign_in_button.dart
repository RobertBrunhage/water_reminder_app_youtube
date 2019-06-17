import 'package:flutter/material.dart';

class GoogleSignInButton extends StatelessWidget {
  const GoogleSignInButton({
    Key key,
    @required this.onPressed,
  }) : super(key: key);

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return ButtonTheme(
      minWidth: 224,
      height: 48,
      child: FlatButton(
        onPressed: onPressed,
        child: Text('Google Sign in'),
      ),
    );
  }
}
