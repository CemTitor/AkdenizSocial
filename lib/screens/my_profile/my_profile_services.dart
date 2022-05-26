import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:senior_design_project/constants(config)/app_router.dart';
import 'package:senior_design_project/screens/signup/pages/login.dart';
import 'package:senior_design_project/screens/signup/auth_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';

import 'my_profile_view.dart';

class MyProfileServices with ChangeNotifier {
  late String userAvatarUrl = "";
  String get getUserAvatarUrl => userAvatarUrl;
  late UploadTask imageAvatarUploadTask;
  late File userAvatar;
  File get getUserAvatar => userAvatar;

  final picker = ImagePicker();

  //TODO => yerine {} kullanınca calısmıyor neden ?
  Future<bool?> logutdialog(BuildContext context) async => showDialog<bool>(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Colors.black,
            title: Text(
              "Log Out?",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold),
            ),
            actions: [
              MaterialButton(
                  child: Text(
                    "No",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0,
                        decoration: TextDecoration.underline,
                        decorationColor: Colors.white),
                  ),
                  onPressed: () {
                    Navigator.pop(context, false);
                  }),
              MaterialButton(
                color: Colors.red,
                child: Text(
                  "Yes",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0,
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context, true);
                  Provider.of<Authentication>(context, listen: false)
                      .logOutViaEmail()
                      .whenComplete(
                    () {
                      AppRouter.push(
                        const LoginPage(),
                      );
                    },
                  );
                },
              )
            ],
          );
        },
      );

  Future updateUserAvatar(BuildContext context) {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(Provider.of<Authentication>(context, listen: false).getUserid)
        .update({'userimage': getUserAvatarUrl})
        .then((value) => print("User Updated"))
        .catchError((error) => print("Failed to update user: $error"));
  }

  Future uploadUserAvatarToFirebaseStorage(BuildContext context) async {
    Reference imageRefrence = FirebaseStorage.instance
        .ref()
        .child('userProfileAvatar/${getUserAvatar.path}${TimeOfDay.now()}');

    imageAvatarUploadTask = imageRefrence.putFile(getUserAvatar);

    await imageAvatarUploadTask.whenComplete(() async {
      await imageRefrence.getDownloadURL().then((url) {
        userAvatarUrl = url.toString();
        notifyListeners();
      });
      print('Image uploaded');
    });
  }

  Future pickUserAvatar(BuildContext context, ImageSource imageSource) async {
    final pickeduserAvatar = await picker.pickImage(source: imageSource);
    pickeduserAvatar == null
        ? print('Select Image')
        : userAvatar = File(pickeduserAvatar.path);
    print(userAvatar.path);

    userAvatar != null
        ? Provider.of<MyProfile>(context, listen: false).showUserAvatar(context)
        : print('Image upload error');
    notifyListeners();
  }
}
