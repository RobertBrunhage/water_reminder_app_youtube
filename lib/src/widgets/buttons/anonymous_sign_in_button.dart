import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:water_reminder_app/src/global_blocs/auth/auth_bloc.dart';

class AnonymousSignInButton extends StatelessWidget {
  const AnonymousSignInButton({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authBloc = Provider.of<AuthBloc>(context);
    return ButtonTheme(
      minWidth: 224,
      child: FlatButton(
        onPressed: authBloc.signInAnonymously,
        color: Colors.green.shade800,
        child: Text('Anonymous Sign in'),
      ),
    );
  }
}
