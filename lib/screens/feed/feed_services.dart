import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:senior_design_project/screens/signup/auth_services.dart';
import 'package:senior_design_project/services/initialize.dart';

class FeedServices extends ChangeNotifier {
  Future addComment(BuildContext context, String postId, String comment) async {
    await FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .doc(comment)
        .set({
      'comment': comment,
      'username':
          Provider.of<InitializeUser>(context, listen: false).getInitUserName,
      'useruid': Provider.of<Authentication>(context, listen: false).getUserid,
      'userimage':
          Provider.of<InitializeUser>(context, listen: false).getInitUserImage,
      'useremail':
          Provider.of<InitializeUser>(context, listen: false).getInitUserEmail,
      'time': Timestamp.now()
    });
  }

  Stream<QuerySnapshot> fetchPostsByTime() {
    notifyListeners();
    return FirebaseFirestore.instance
        .collection('posts')
        .orderBy('time', descending: true)
        .snapshots();
  }
}
