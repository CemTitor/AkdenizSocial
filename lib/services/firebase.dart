import 'dart:async';
import 'dart:core';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'auth.dart';

class FirebaseOpertrations with ChangeNotifier {
  UploadTask? imageuploadTask;

  dynamic initUserName;
  dynamic initUserEmail;
  dynamic initUserImage;
  dynamic get getInitUserName => initUserName;
  dynamic get getInitUserEmail => initUserEmail;
  dynamic get getInitUserImage => initUserImage;

  //TODO instead of dynamic you can use String for this variables
  // String? initUserName;
  // String? get getInitUserName => initUserName;

  // Future uploaduserAvatar(BuildContext context) async {
  //   Reference imageRefrence = FirebaseStorage.instance.ref().child(
  //       'userProfileAvatar/${Provider.of<WelcomeUtils>(context, listen: false).getuserAvatar.path}${TimeOfDay.now()}');
  //
  //   imageuploadTask = imageRefrence.putFile(
  //       Provider.of<WelcomeUtils>(context, listen: false).getuserAvatar);
  //
  //   await imageuploadTask.whenComplete(() {
  //     print('Image uploaded');
  //   });
  //
  //   imageRefrence.getDownloadURL().then((url) {
  //     Provider.of<WelcomeUtils>(context, listen: false).userAvatarUrl =
  //         url.toString();
  //     print(
  //         'the provile user avatar url => $Provider.of<landingutls>(context,listen: false).userAvatarUrl');
  //     notifyListeners();
  //   });
  // }

  Future createUserCollection(
      BuildContext context, Map<String, dynamic> data) async {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(Provider.of<Authentication>(context, listen: false).getUserid)
        .set(data);
  }

  Future initUserData(BuildContext context) async {
    return await FirebaseFirestore.instance
        .collection('users')
        .doc(Provider.of<Authentication>(context, listen: false).getUserid)
        .get()
        .then((doc) {
      print("Fetching user data");
      initUserEmail = doc.data()!['username'];
      initUserName = doc.data()!['useremail'];
      initUserImage = doc.data()!['userimage'];
      print(initUserName);
      print(initUserEmail);
      print(initUserImage);
      notifyListeners();
    });
  }

  Future uploadPostData(String postId, Map<String, dynamic> data) async {
    return FirebaseFirestore.instance.collection('posts').doc(postId).set(data);
  }

  Future deleteUserData(String useruid, String collection) async {
    return FirebaseFirestore.instance
        .collection(collection)
        .doc(useruid)
        .delete();
  }

  Future updateCaption(String postId, Map<String, dynamic> data) async {
    return FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .update(data);
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> fetchPostsByTime() {
    return FirebaseFirestore.instance
        .collection('posts')
        .orderBy('time', descending: true)
        .snapshots();
  }
}
