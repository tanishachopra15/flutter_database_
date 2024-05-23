import 'package:firebase_auth/firebase_auth.dart';

class Authentication {
  final _firebaseAuth = FirebaseAuth.instance;

  Future<User?> singUpUser(String email, String password) async {
    try {
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      return credential.user;
    } catch (e) {
      print('error $e');
    }
    return null;
  }

  Future<User?> logInUser(
      {required String email, required String password}) async {
    try {
      final credential = await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      return credential.user;
    } catch (e) {
      print('error $e');
    }
    return null;
  }

  Future<void> signOutUser() async {
    try {
      await _firebaseAuth.signOut();
    } catch (e) {
      print('error $e');
    }
  }
}
