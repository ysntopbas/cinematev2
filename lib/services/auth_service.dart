import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User?> login(String email, String password) async {
    try {
      final logauth = await _auth.signInWithEmailAndPassword(
          email: email, password: password);

      return logauth.user;
    } catch (e) {
      log(e.toString());
      return null;
    }
  }

  Future<User?> register(String email, String password) async {
    try {
      final regauth = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      return regauth.user;
    } catch (e) {
      log(e.toString());
      return null;
    }
  }

  void logout() {
    _auth.signOut();
  }

  get user {
    return _auth.authStateChanges();
  }
}
