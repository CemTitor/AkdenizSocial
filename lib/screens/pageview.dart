import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:senior_design_project/screens/upload_post/upload_post_widget.dart';
import 'package:senior_design_project/services/firebase.dart';

class Feed2 extends StatefulWidget {
  @override
  _Feed2State createState() => _Feed2State();
}

class _Feed2State extends State<Feed2> {
  PageController pageController = PageController(
    initialPage: 1,
    keepPage: true,
  );

  Widget buildPageView() {
    return PageView(
      controller: pageController,
      children: <Widget>[
        UploadPostScreen(),
        // FeedScreen(),
        Yellow(),
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

class Yellow extends StatefulWidget {
  @override
  _YellowState createState() => _YellowState();
}

class _YellowState extends State<Yellow> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text('MESAJLAR'),
      color: Colors.yellowAccent,
    );
  }
}
