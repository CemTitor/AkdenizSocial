import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:senior_design_project/services/auth.dart';
import 'package:senior_design_project/services/firebase.dart';

class FeedServices extends ChangeNotifier {

  Future addComment(BuildContext context, String postId, String comment) async {
    await FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .doc(comment)
        .set({
      'comment': comment,
      'username': Provider.of<FirebaseOpertrations>(context, listen: false)
          .getInitUserName,
      'useruid': Provider.of<Authentication>(context, listen: false).getUserid,
      'userimage': Provider.of<FirebaseOpertrations>(context, listen: false)
          .getInitUserImage,
      'useremail': Provider.of<FirebaseOpertrations>(context, listen: false)
          .getInitUserEmail,
      'time': Timestamp.now()
    });
  }
}
