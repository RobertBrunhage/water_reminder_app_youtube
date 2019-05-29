import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:water_reminder_app/models/user.dart';
import 'package:water_reminder_app/services/firestore/firestore_user_service.dart';
import 'package:water_reminder_app/src/global_blocs/auth/auth_bloc.dart';
import 'package:water_reminder_app/src/global_blocs/user_bloc.dart';
import 'package:water_reminder_app/src/login/login_page.dart';

/// This RootPage will display the home page
/// or the login page depending if we are
/// authenticated
class RootPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthBloc>(context);
    return StreamBuilder<FirebaseUser>(
      stream: auth.onAuthStateChanged,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return HomePageSetup();
        }
        return LoginPage();
      },
    );
  }
}

class HomePageSetup extends StatefulWidget {
  @override
  _HomePageSetupState createState() => _HomePageSetupState();
}

class _HomePageSetupState extends State<HomePageSetup> {
  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () async {
      final userBloc = Provider.of<UserBloc>(context);

      await FirestoreUserService.checkAndCreateUser();
      await userBloc.init();
    });
  }

  @override
  Widget build(BuildContext context) {
    final userBloc = Provider.of<UserBloc>(context);
    return StreamBuilder<User>(
      stream: userBloc.outUser,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Text(
                snapshot.error.toString(),
              ),
            ),
          );
        } else if (snapshot.hasData) {
          final user = snapshot.data;
          return HomePage(user: user);
        }
        return Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({
    Key key,
    @required this.user,
  }) : super(key: key);

  final User user;

  @override
  Widget build(BuildContext context) {
    final authBloc = Provider.of<AuthBloc>(context);
    return Scaffold(
      body: Center(
        child: FlatButton(
          onPressed: authBloc.signOut,
          child: Text('Sign out'),
        ),
      ),
    );
  }
}
