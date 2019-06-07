import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:water_reminder_app/src/global_blocs/auth/auth_bloc.dart';

class GoogleSignInButton extends StatelessWidget {
  const GoogleSignInButton({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthBloc>(context);
    return ButtonTheme(
      minWidth: 224,
      child: FlatButton(
        onPressed: auth.signInWithGoogle,
        child: Text('Google Sign in'),
      ),
    );
  }
}
