import 'dart:io';

//import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
//import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:senior_design_project/screens/upload_post/counter_for_stepper.dart';

class UploadPost with ChangeNotifier {
  TextEditingController captionController = TextEditingController();
  String? uploadpostImageURL;

  String? get getUploadPostImageUrl => uploadpostImageURL;

  late UploadTask imagePostUploadTask;
  File? uploadPostImage;

  File? get getUploadPostImage => uploadPostImage;
  final picker = ImagePicker();

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
}
