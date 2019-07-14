import 'package:water_reminder_app/src/global_blocs/bloc_base.dart';
import 'package:water_reminder_app/src/global_blocs/drink_bloc.dart';
import 'package:water_reminder_app/src/global_blocs/notification_bloc.dart';
import 'package:water_reminder_app/src/global_blocs/user_bloc.dart';

class AppBloc implements BlocBase {
  UserBloc _userBloc;
  DrinkBloc _drinkBloc;
  NotificationBloc _notificationBloc;

  AppBloc() {
    _userBloc = UserBloc();
    _drinkBloc = DrinkBloc();
    _notificationBloc = NotificationBloc();
  }

  Future<void> init() async {
    await _userBloc.init();
    await _drinkBloc.init();
    await _notificationBloc.init();
  }

  UserBloc get userBloc => _userBloc;
  DrinkBloc get drinkBloc => _drinkBloc;
  NotificationBloc get notificationBloc => _notificationBloc;

  @override
  void dispose() {
    _userBloc.dispose();
    _drinkBloc.dispose();
    _notificationBloc.dispose();
  }
}
