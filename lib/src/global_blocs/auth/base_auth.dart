import 'package:firebase_auth/firebase_auth.dart';

abstract class BaseAuth {
  Stream<FirebaseUser> get onAuthStateChanged;
  Future<String> signInAnonymously();
  Future<String> signInWithGoogle();
  Future<String> syncWithGoogle();
  Future<void> signOut();
}
