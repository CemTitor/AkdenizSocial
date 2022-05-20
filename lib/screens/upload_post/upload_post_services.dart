import 'dart:io';

//import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
//import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:senior_design_project/screens/upload_post/counter_for_stepper.dart';

class UploadPost with ChangeNotifier {
  TextEditingController captionController = TextEditingController();
  final picker = ImagePicker();

  String? uploadPostImageURL;
  String? get getUploadPostImageUrl => uploadPostImageURL;
  late UploadTask imagePostUploadTask;
  File? imageFile;
  File? get getUploadPostImage => imageFile;

  Future pickUserPostImage(
    BuildContext context,
    ImageSource imageSource,
  ) async {
    final pickedFile = await picker.pickImage(source: imageSource);
    cropUserPostImage(context, pickedFile!.path);
  }

  Future cropUserPostImage(BuildContext context, String filePath) async {
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
      uploadPostImageURL = imageUrl;
    });
    notifyListeners();
  }
}
