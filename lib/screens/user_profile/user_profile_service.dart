import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class ProfileService with ChangeNotifier {
  Future followUser(
    String followingUid,
    String? followingDocid,
    Map<String, dynamic> followingData,
    String? followerUid,
    String followerDocid,
    Map<String, dynamic> followerData,
  ) async {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(followingUid)
        .collection('followers')
        .doc(followingDocid)
        .set(followingData)
        .whenComplete(() async {
      return FirebaseFirestore.instance
          .collection('users')
          .doc(followerUid)
          .collection('following')
          .doc(followerDocid)
          .set(followerData);
    });
  }

  Future unFollowUser(String followingUid, String followingDocid) async {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(followingUid)
        .collection('followers')
        .doc(followingDocid)
        .delete();
  }
}
