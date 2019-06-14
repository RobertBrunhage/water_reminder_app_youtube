import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:water_reminder_app/src/global_blocs/auth/auth_bloc.dart';
import 'package:water_reminder_app/src/global_blocs/drink_bloc.dart';
import 'package:water_reminder_app/src/global_blocs/user_bloc.dart';
import 'package:water_reminder_app/src/root_page.dart';

void main() => runApp(WaterReminderApp());

class WaterReminderApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthBloc>(
          builder: (_) => AuthBloc(),
        ),
        Provider<UserBloc>(
          builder: (_) => UserBloc(),
          dispose: (_, userBloc) => userBloc.dispose(),
        ),
        Provider<DrinkBloc>(
          builder: (_) => DrinkBloc(),
          dispose: (_, drinkBloc) => drinkBloc.dispose(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Water Reminder',
        theme: ThemeData(
          brightness: Brightness.light,
          primaryColor: Colors.white,
          accentColor: Colors.blue,
        ),
        home: RootPage(),
      ),
    );
  }
}
