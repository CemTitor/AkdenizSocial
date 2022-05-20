import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:senior_design_project/screens/feed/feed_view.dart';
import 'package:senior_design_project/screens/my_profile/my_profile_services.dart';
import 'package:senior_design_project/screens/upload_post/upload_post_view.dart';
import 'package:senior_design_project/services/firebase.dart';
import 'package:senior_design_project/services/page_controller.dart';

import 'chat/chats_view.dart';

class AppPageView extends StatefulWidget {
  @override
  _AppPageViewState createState() => _AppPageViewState();
}

class _AppPageViewState extends State<AppPageView> {
  // PageController pageController = PageController(
  //   initialPage: 1,
  //   // keepPage: true,
  // );

//TODO kaydırma dışında tıklayarak sayfa geçişlerini yapmak için
// bu classı stateless yapıp counter for stepperı provide etmem gerekebilir

  @override
  void initState() {
    Provider.of<FirebaseOpertrations>(context, listen: false)
        .initUserData(context);

    super.initState();
  }

  Future<bool?> showWarning(BuildContext context) async =>
      Provider.of<MyProfileServices>(context, listen: false)
          .logutdialog(context);
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        body: buildPageView(),
      ),
      onWillPop: () async {
        final isFeedPage =
            Provider.of<PageControllerClass>(context, listen: false)
                    .pageController
                    .page!
                    .round() ==
                Provider.of<PageControllerClass>(context, listen: false)
                    .pageController
                    .initialPage;
        if (isFeedPage) {
          final shouldPop = await showWarning(context);
          return shouldPop ?? false;
        } else {
          Provider.of<PageControllerClass>(context, listen: false)
              .pageController
              .animateToPage(
                1,
                duration: const Duration(milliseconds: 1000),
                curve: Curves.bounceOut,
              );

          return false;
        }
      },
    );
  }

  Widget buildPageView() {
    return PageView(
      controller: Provider.of<PageControllerClass>(context).pageController,
      children: <Widget>[
        UploadPostScreen(),
        FeedScreen(),
        ChatsView(),
      ],
    );
  }
}

// class Messages extends StatefulWidget {
//   @override
//   _MessagesState createState() => _MessagesState();
// }
//
// class _MessagesState extends State<Messages> {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       color: Colors.yellowAccent,
//       child: const Center(child: Text('MESAJLAR')),
//     );
//   }
// }
