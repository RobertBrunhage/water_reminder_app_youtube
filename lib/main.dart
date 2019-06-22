import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:water_reminder_app/src/global_blocs/auth/auth_bloc.dart';
import 'package:water_reminder_app/src/global_blocs/drink_bloc.dart';
import 'package:water_reminder_app/src/global_blocs/notification_bloc.dart';
import 'package:water_reminder_app/src/global_blocs/theme_provider.dart';
import 'package:water_reminder_app/src/global_blocs/user_bloc.dart';
import 'package:water_reminder_app/src/root_page.dart';

void main() => runApp(WaterReminderApp());

final lightTheme = ThemeData.light().copyWith(
  primaryColor: Colors.white,
  accentColor: Colors.blue,
  primaryIconTheme: IconThemeData(color: Colors.black),
);

final darkTheme = ThemeData.dark().copyWith(
  primaryColor: Colors.white,
  accentColor: Colors.blue,
  primaryIconTheme: IconThemeData(color: Colors.white),
);

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
        Provider<NotificationBloc>(
          builder: (_) => NotificationBloc(),
          dispose: (_, notificationBloc) => notificationBloc.dispose(),
        ),
        ChangeNotifierProvider<ThemeChanger>(
          builder: (_) => ThemeChanger(),
        ),
      ],
      child: MaterialAppWithTheme(),
    );
  }
}

class MaterialAppWithTheme extends StatelessWidget {
  const MaterialAppWithTheme({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeChanger = Provider.of<ThemeChanger>(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Water Reminder',
      theme: themeChanger.getTheme(),
      home: RootPage(),
    );
  }
}
