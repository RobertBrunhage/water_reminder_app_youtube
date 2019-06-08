import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:water_reminder_app/src/global_blocs/auth/base_auth.dart';

class AuthBloc implements BaseAuth {
  final _firebaseAuth = FirebaseAuth.instance;

  GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
      'https://www.googleapis.com/auth/contacts.readonly',
    ],
  );

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

  @override
  Future<String> signInWithGoogle() async {
    try {
      final googleUser = await _googleSignIn.signIn();
      final googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.getCredential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final user = await _firebaseAuth.signInWithCredential(credential);
      print("Signed in ${user.uid}");
      return user.uid;
    } catch (e) {
      print(e);
      throw e;
    }
  }

  @override
  Future<String> syncWithGoogle() async {
    final anonymousUser = await _firebaseAuth.currentUser();
    final googleUser = await _googleSignIn.signIn();
    final googleAuth = await googleUser.authentication;

    final credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final user = await anonymousUser.linkWithCredential(credential);
    return user?.uid;
  }

  @override
  Future<FirebaseUser> currentUser() {
    return _firebaseAuth.currentUser();
  }
}
