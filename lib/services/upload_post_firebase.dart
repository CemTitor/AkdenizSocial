import 'dart:io';

//import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
//import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:senior_design_project/screens/upload_post/counter_for_stepper.dart';
import 'package:senior_design_project/services/auth.dart';

import '../screens/my_profile/my_profile_view.dart';

class UploadPost with ChangeNotifier {
  TextEditingController captionController = TextEditingController();
  final picker = ImagePicker();

  String? uploadpostImageURL;
  String? get getUploadPostImageUrl => uploadpostImageURL;
  late UploadTask imagePostUploadTask;
  File? imageFile;
  File? get getUploadPostImage => imageFile;

  String? userAvatarUrl;
  String? get getuserAvatarUrl => userAvatarUrl;
  UploadTask? imageAvatarUploadTask;
  late File userAvatar;
  File get getuserAvatar => userAvatar;

  Future pickuserPostImage(
    BuildContext context,
    ImageSource imageSource,
  ) async {
    final pickedFile = await picker.pickImage(source: imageSource);
    cropuserPostImage(context, pickedFile!.path);
  }

  Future cropuserPostImage(BuildContext context, String filePath) async {
    final File? croppedImage = await ImageCropper().cropImage(
      sourcePath: filePath,
      aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
    );
    if (croppedImage != null) {
      imageFile = croppedImage;
      Provider.of<Counter>(context, listen: false).increaseCounter();
      notifyListeners();
    }
  }

  Future uploadPostImageToFirebaseStorage() async {
    Reference imageReferance = FirebaseStorage.instance
        .ref()
        .child('posts/${imageFile?.path}/${TimeOfDay.now()}');
    imagePostUploadTask = imageReferance.putFile(imageFile!);
    await imagePostUploadTask.whenComplete(() {
      print("Posting image to firebase storage");
    });
    imageReferance.getDownloadURL().then((imageUrl) {
      uploadpostImageURL = imageUrl;
    });
    notifyListeners();
  }

  Future updateUserAvatar(BuildContext context) {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(Provider.of<Authentication>(context, listen: false).getUserid)
        .update({'userimage': getuserAvatarUrl})
        .then((value) => print("User Updated"))
        .catchError((error) => print("Failed to update user: $error"));
  }

  Future uploadUserAvatartoFirebaseStorage(BuildContext context) async {
    Reference imageRefrence = FirebaseStorage.instance
        .ref()
        .child('userProfileAvatar/${getuserAvatar.path}${TimeOfDay.now()}');

    imageAvatarUploadTask = imageRefrence.putFile(getuserAvatar);

    await imageAvatarUploadTask?.whenComplete(() {
      print('Image uploaded');
    });

    imageRefrence.getDownloadURL().then((url) {
      userAvatarUrl = url.toString();
      notifyListeners();
    });
  }

  Future pickuserAvatar(BuildContext context, ImageSource imageSource) async {
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
