import 'dart:async';
import 'dart:core';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'auth.dart';

class FirebaseOpertrations with ChangeNotifier {
  String? initUserName;
  String? initUserEmail;
  String? initUserImage;
  String? get getInitUserName => initUserName;
  String? get getInitUserEmail => initUserEmail;
  String? get getInitUserImage => initUserImage;

  Future createUserCollection(
      BuildContext context, Map<String, dynamic> data) async {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(Provider.of<Authentication>(context, listen: false).getUserid)
        .set(data);
  }

  Future updateProfilePicture(
      BuildContext context, Map<String, dynamic> data) async {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(Provider.of<Authentication>(context, listen: false).getUserid)
        .update(data);
  }

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
      print(initUserName);
      print(initUserEmail);
      print(initUserImage);
      notifyListeners();
    });
  }

  Future uploadPostData(String postId, Map<String, dynamic> data) async {
    return FirebaseFirestore.instance.collection('posts').doc(postId).set(data);
  }

  Future deleteUserData(String postId, String collection) async {
    return FirebaseFirestore.instance
        .collection(collection)
        .doc(postId)
        .delete();
  }

  Future updateCaption(String postId, Map<String, dynamic> data) async {
    return FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .update(data);
  }

  Stream<QuerySnapshot> fetchPostsByTime() {
    return FirebaseFirestore.instance
        .collection('posts')
        .orderBy('time', descending: true)
        .snapshots();
  }
}
