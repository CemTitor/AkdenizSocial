import 'dart:io';

//import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
//import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:senior_design_project/screens/upload_post/counter_for_stepper.dart';

import '../screens/my_profile/my_profile_view.dart';

class UploadPost with ChangeNotifier {
  TextEditingController captionController = TextEditingController();
  String? uploadpostImageURL;

  String? get getUploadPostImageUrl => uploadpostImageURL;

  late UploadTask imagePostUploadTask;
  File? uploadPostImage;

  File? get getUploadPostImage => uploadPostImage;
  final picker = ImagePicker();

  UploadTask? imageuploadTask;

  File? userAvatar;
  File? get getuserAvatar => userAvatar;
  String? userAvatarUrl;
  String? get getuserAvatarUrl => userAvatarUrl;

  Future pickuserPostImage(
    BuildContext context,
    ImageSource imageSource,
  ) async {
    final uploadpostImageVal = await picker.pickImage(source: imageSource);
    uploadpostImageVal == null
        ? print('Select Image')
        : uploadPostImage = File(uploadpostImageVal.path);
    print(uploadpostImageVal!.path);

    uploadPostImage != null
        ? Provider.of<Counter>(context, listen: false).increaseCounter()
        : print('Image upload error');
    notifyListeners();
  }

  Future uploadPostImageToFirebaseStorage() async {
    Reference imageReferance = FirebaseStorage.instance
        .ref()
        .child('posts/${uploadPostImage?.path}/${TimeOfDay.now()}');
    imagePostUploadTask = imageReferance.putFile(uploadPostImage!);
    await imagePostUploadTask.whenComplete(() {
      print("Posting image to firebase storage");
    });
    imageReferance.getDownloadURL().then((imageUrl) {
      uploadpostImageURL = imageUrl;
    });
    notifyListeners();
  }

  Future uploaduserAvatar(BuildContext context) async {
    Reference imageRefrence = FirebaseStorage.instance
        .ref()
        .child('userProfileAvatar/${getuserAvatar?.path}${TimeOfDay.now()}');

    imageuploadTask = imageRefrence.putFile(getuserAvatar!);

    await imageuploadTask?.whenComplete(() {
      print('Image uploaded');
    });

    imageRefrence.getDownloadURL().then((url) {
      userAvatarUrl = url.toString();
      print(
          'the provile user avatar url => $Provider.of<landingutls>(context,listen: false).userAvatarUrl');
      notifyListeners();
    });
  }

  Future pickuserAvatar(BuildContext context, ImageSource imageSource) async {
    final pickeduserAvatar = await picker.getImage(source: imageSource);
    pickeduserAvatar == null
        ? print('Select Image')
        : userAvatar = File(pickeduserAvatar.path);
    print(userAvatar?.path);

    // userAvatar != null
    //     ? Provider.of<MyProfile>(context, listen: false).showUserAvatar(context)
    //     : print('Image upload error');
    notifyListeners();
  }
}
