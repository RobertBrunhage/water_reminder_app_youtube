import 'dart:async';

import 'package:water_reminder_app/models/user.dart';
import 'package:water_reminder_app/services/firestore/firestore_user_service.dart';
import 'package:water_reminder_app/src/global_blocs/bloc_base.dart';
import 'package:rxdart/rxdart.dart';

class UserBloc implements BlocBase {
  UserBloc();

  User _user;
  StreamSubscription _userStreamSubscription;

  final _userController = BehaviorSubject<User>();
  Function(User) get _inUser => _userController.sink.add;
  Stream<User> get outUser => _userController.stream;

  Future<void> init() async {
    await FirestoreUserService.updateLastLoggedIn();
    final userStream = await FirestoreUserService.getUserStream();
    _userStreamSubscription = userStream.listen((doc) {
      _user = User.fromDb(doc.data);
      _inUser(_user);
    });
  }

  @override
  void dispose() {
    _userController.close();
    _userStreamSubscription.cancel();
  }
}
