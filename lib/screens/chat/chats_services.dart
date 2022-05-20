import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:timeago/timeago.dart' as timeago;

class ChatServices with ChangeNotifier {
  String? imageTimePosted;
  String? get getImageTimePosted => imageTimePosted;

  Future submitChatroomData(
    String chatroomName,
    Map<String, dynamic> chatroomData,
  ) async {
    return FirebaseFirestore.instance
        .collection('chatrooms')
        .doc(chatroomName)
        .set(chatroomData);
  }

  showTimeAgo(Timestamp timedata) {
    final Timestamp time = timedata;
    final DateTime dateTime = time.toDate();
    imageTimePosted = timeago.format(dateTime);
    print(imageTimePosted);
    notifyListeners();
  }
}
