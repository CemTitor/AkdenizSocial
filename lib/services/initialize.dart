import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../screens/signup/auth_services.dart';

class InitializeUser with ChangeNotifier {
  String? initUserName;
  String? initUserEmail;
  String? initUserImage;
  String? get getInitUserName => initUserName;
  String? get getInitUserEmail => initUserEmail;
  String? get getInitUserImage => initUserImage;

  Future initUserData(BuildContext context) async {
    return await FirebaseFirestore.instance
        .collection('users')
        .doc(Provider.of<Authentication>(context, listen: false).getUserid)
        .get()
        .then((doc) {
      if (kDebugMode) {
        print("Fetching user data");
      }
      initUserEmail = doc.data()!['useremail'].toString();
      initUserName = doc.data()!['username'].toString();
      initUserImage = doc.data()!['userimage'].toString();
      if (kDebugMode) {
        print(initUserName);
      }
      if (kDebugMode) {
        print(initUserEmail);
      }
      if (kDebugMode) {
        print(initUserImage);
      }
      notifyListeners();
    });
  }
}
