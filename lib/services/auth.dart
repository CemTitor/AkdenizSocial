import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';

class Authentication with ChangeNotifier {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  String? userUid;
  String? get getUserid => userUid;

  static bool successLogin = false;
  static bool successSignup = false;
  static bool verifiedMail = false;

  Future logIntoAccount(String email, String password) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      if (userCredential.user != null) {
        User? user = userCredential.user;
        userUid = user!.uid;
        print(userUid);
        successLogin = true;
        if (user.emailVerified) {
          verifiedMail = true;
        }
        notifyListeners();
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        successLogin = false;
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        successLogin = false;
        print('Wrong password provided for that user.');
      }
    }
  }

  Future createAccount(String email, String password) async {
    try {
      UserCredential userCredential = await firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
      if (userCredential.user != null) {
        User? user = userCredential.user;
        userUid = user!.uid;
        print(userUid);
        successSignup = true;
        notifyListeners();
      }
    } on FirebaseAuthException catch (e) {
      return null;
    }
  }

  Future logOutViaEmail() {
    return firebaseAuth.signOut();
  }
}
