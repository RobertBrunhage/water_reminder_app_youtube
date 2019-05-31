import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:water_reminder_app/models/user.dart';
import 'package:water_reminder_app/src/global_blocs/drink_bloc.dart';
import 'package:water_reminder_app/src/global_blocs/user_bloc.dart';
import 'package:water_reminder_app/src/home/page_container.dart';

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
      final drinkBloc = Provider.of<DrinkBloc>(context);
      await userBloc.init();
      await drinkBloc.init();
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
          return PageContainer(user: user);
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
