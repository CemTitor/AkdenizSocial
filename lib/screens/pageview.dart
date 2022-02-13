import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:senior_design_project/screens/upload_post/upload_post_widget.dart';
import 'package:senior_design_project/services/firebase.dart';

import 'feed/feed_view.dart';

class AppPageView extends StatefulWidget {
  @override
  _AppPageViewState createState() => _AppPageViewState();
}

class _AppPageViewState extends State<AppPageView> {
  PageController pageController = PageController(
    initialPage: 1,
    keepPage: true,
  );
//TODO kaydırma dışında tıklayarak sayfa geçişlerini yapmak için bu classı stateless yapıp counter for stepperı provide etmem gerekebilir
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
    return Scaffold(
      body: buildPageView(),
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
      child: Center(child: Text('MESAJLAR')),
    );
  }
}
