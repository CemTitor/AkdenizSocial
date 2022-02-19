import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:senior_design_project/screens/feed/feed_view.dart';
import 'package:senior_design_project/screens/my_profile/my_profile_services.dart';
import 'package:senior_design_project/screens/upload_post/upload_post_widget.dart';
import 'package:senior_design_project/services/auth.dart';
import 'package:senior_design_project/services/firebase.dart';
import 'package:senior_design_project/theme.dart';

class AppPageView extends StatefulWidget {
  @override
  _AppPageViewState createState() => _AppPageViewState();
}

class _AppPageViewState extends State<AppPageView> {
  PageController pageController = PageController(
    initialPage: 1,
    keepPage: true,
  );
//TODO kaydırma dışında tıklayarak sayfa geçişlerini yapmak için
// bu classı stateless yapıp counter for stepperı provide etmem gerekebilir
  Widget buildPageView() {
    return PageView(
      controller: pageController,
      children: <Widget>[
        UploadPostScreen(),
        FeedScreen(),
        Messages(),
      ],
    );
  }

  @override
  void initState() {
    Provider.of<FirebaseOpertrations>(context, listen: false)
        .initUserData(context);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final isFeedPage =
            pageController.page!.round() == pageController.initialPage;
        if (isFeedPage) {
          final shouldPop =
              await Provider.of<MyProfileServices>(context, listen: false)
                  .logutdialog(context);
          return shouldPop ?? false;
        } else {
          pageController.previousPage(
            duration: const Duration(milliseconds: 300),
            curve: Curves.bounceOut,
          );
          return false;
        }
      },
      child: Scaffold(
        body: buildPageView(),
      ),
    );
  }
}

class Messages extends StatefulWidget {
  @override
  _MessagesState createState() => _MessagesState();
}

class _MessagesState extends State<Messages> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.yellowAccent,
      child: const Center(child: Text('MESAJLAR')),
    );
  }
}
