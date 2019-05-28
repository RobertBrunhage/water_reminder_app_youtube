import 'package:firebase_auth/firebase_auth.dart';
import 'package:water_reminder_app/src/global_blocs/auth/base_auth.dart';

class AuthBloc implements BaseAuth {
  final _firebaseAuth = FirebaseAuth.instance;

  @override
  Future<String> signInAnonymously() async {
    final user = await _firebaseAuth.signInAnonymously();
    return user.uid;
  }

  @override
  Future<void> signOut() async {
    return _firebaseAuth.signOut();
  }

  @override
  Stream<FirebaseUser> get onAuthStateChanged {
    return _firebaseAuth.onAuthStateChanged;
  }
}
