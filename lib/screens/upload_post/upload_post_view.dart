import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:senior_design_project/constants(config)/color_constant.dart';
import 'package:senior_design_project/screens/upload_post/counter_for_stepper.dart';
import 'package:senior_design_project/services/auth.dart';
import 'package:senior_design_project/services/firebase.dart';
import 'package:senior_design_project/screens/upload_post/upload_post_services.dart';

import '../../services/page_controller.dart';

//TODO bu classı stateles yaparak çalıştırmayı denedim ama olmadı, geçici olarak stateful yapıcam
//TODO make control for stepping up,down
class UploadPostScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // int currentStep = Provider.of<CounterBloc>(context, listen: false).counter;

    return Scaffold(
      // backgroundColor: kPrimaryColor,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text('Yeni Gönderi'),
        leading: IconButton(
          icon: Icon(Icons.done),
          onPressed: () {},
        ),
        backgroundColor: kPrimaryColor,
        foregroundColor: Colors.white,
        shadowColor: kPrimaryColor,
        elevation: 5,
      ),
      body: Theme(
        data: Theme.of(context).copyWith(
          colorScheme: ColorScheme.light(primary: kSecondaryColor),
        ),
        child: Stepper(
          type: StepperType.horizontal,
          steps: [
            Step(
              state: Provider.of<Counter>(context, listen: false).counter > 0
                  ? StepState.complete
                  : StepState.indexed,
              isActive:
                  Provider.of<Counter>(context, listen: false).counter >= 0,
              title: const Text('Choose'),
              content: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      MaterialButton(
                        onPressed: () {
                          Provider.of<UploadPost>(context, listen: false)
                              .pickUserPostImage(context, ImageSource.gallery);
                        },
                        child: Text(
                          "Gallery",
                        ),
                      ),
                      MaterialButton(
                        onPressed: () {
                          Provider.of<UploadPost>(context, listen: false)
                              .pickUserPostImage(context, ImageSource.camera);
                        },
                        child: Text(
                          "Camera",
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
            Step(
              state: Provider.of<Counter>(context, listen: false).counter > 1
                  ? StepState.complete
                  : StepState.indexed,
              isActive:
                  Provider.of<Counter>(context, listen: false).counter >= 1,
              title: Text('Confirm'),
              content:
                  (Provider.of<UploadPost>(context).getUploadPostImage == null)
                      ? Text('Boş')
                      : Image.file(
                          Provider.of<UploadPost>(context, listen: false)
                              .imageFile!,
                        ),
            ),
            Step(
              state: Provider.of<Counter>(context, listen: false).counter > 2
                  ? StepState.complete
                  : StepState.indexed,
              isActive:
                  Provider.of<Counter>(context, listen: false).counter >= 2,
              title: Text('Upload'),
              content: Column(
                children: [
                  if (Provider.of<UploadPost>(context).getUploadPostImage ==
                      null)
                    const Placeholder()
                  else
                    Image.file(
                      Provider.of<UploadPost>(context, listen: false)
                          .imageFile!,
                    ),
                  TextField(
                    maxLines: 5,
                    textCapitalization: TextCapitalization.words,
                    inputFormatters: [LengthLimitingTextInputFormatter(200)],
                    maxLengthEnforcement: MaxLengthEnforcement.enforced,
                    maxLength: 200,
                    controller: Provider.of<UploadPost>(context, listen: false)
                        .captionController,
                    decoration: const InputDecoration(
                      hintText: "Add a caption..",
                    ),
                  ),
                  MaterialButton(
                    onPressed: () => sharePost(context),
                    child: const Text(
                      "Share",
                    ),
                  )
                ],
              ),
            ),
          ],
          currentStep: Provider.of<Counter>(context, listen: false).counter,
          onStepContinue: () {
            if (Provider.of<Counter>(context, listen: false).counter == 1) {
              Provider.of<UploadPost>(context, listen: false)
                  .uploadPostImageToFirebaseStorage()
                  .whenComplete(() {
                Provider.of<Counter>(context, listen: false).increaseCounter();
              });
            } else if (Provider.of<Counter>(context, listen: false).counter !=
                2) {
              Provider.of<Counter>(context, listen: false).increaseCounter();
            }
          },
          onStepCancel: () {
            if (Provider.of<Counter>(context, listen: false).counter != 0) {
              Provider.of<Counter>(context, listen: false).decreaseCounter();
            }
          },
          controlsBuilder: (BuildContext context, ControlsDetails details) {
            final isLastStep =
                Provider.of<Counter>(context, listen: false).counter == 2;
            return Row(
              children: <Widget>[
                if (Provider.of<Counter>(context, listen: false).counter != 0)
                  TextButton(
                    onPressed: details.onStepCancel,
                    child: Text('BACK'),
                  ),
                TextButton(
                  onPressed: details.onStepContinue,
                  child: Text(isLastStep ? '' : 'NEXT'),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

Future<void> sharePost(BuildContext context) async {
  {
    Provider.of<UploadPost>(context, listen: false)
        .uploadPostImageToFirebaseStorage();
    Provider.of<FirebaseOpertrations>(context, listen: false).uploadPostData(
        Provider.of<UploadPost>(context, listen: false).captionController.text,
        {
          'caption': Provider.of<UploadPost>(context, listen: false)
              .captionController
              .text,
          'postimage': Provider.of<UploadPost>(context, listen: false)
              .getUploadPostImageUrl,
          'username': Provider.of<FirebaseOpertrations>(
            context,
            listen: false,
          ).getInitUserName,
          'userimage': Provider.of<FirebaseOpertrations>(context, listen: false)
              .getInitUserImage,
          'useruid':
              Provider.of<Authentication>(context, listen: false).getUserid,
          'time': Timestamp.now(),
          'useremail': Provider.of<FirebaseOpertrations>(context, listen: false)
              .getInitUserEmail,
          'userimage': Provider.of<FirebaseOpertrations>(context, listen: false)
              .getInitUserImage,
        }).whenComplete(() {
      FirebaseFirestore.instance
          .collection('users')
          .doc(Provider.of<Authentication>(context, listen: false).getUserid)
          .collection('posts')
          .add({
        'caption': Provider.of<UploadPost>(context, listen: false)
            .captionController
            .text,
        'postimage': Provider.of<UploadPost>(context, listen: false)
            .getUploadPostImageUrl,
        'username': Provider.of<FirebaseOpertrations>(context, listen: false)
            .getInitUserName,
        'userimage': Provider.of<FirebaseOpertrations>(context, listen: false)
            .getInitUserImage,
        'useruid':
            Provider.of<Authentication>(context, listen: false).getUserid,
        'time': Timestamp.now(),
        'useremail': Provider.of<FirebaseOpertrations>(context, listen: false)
            .getInitUserEmail,
      });
    }).whenComplete(() {
      Provider.of<PageControllerClass>(context, listen: false)
          .pageController
          .nextPage(
              duration: Duration(seconds: 1), curve: Curves.easeInOutExpo);
      Provider.of<UploadPost>(context, listen: false).captionController.clear();
      Provider.of<Counter>(context, listen: false).resetCounter();
    });
  }
}
