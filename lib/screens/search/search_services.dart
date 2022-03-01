import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class SearchServices extends ChangeNotifier {
  Future<QuerySnapshot>? searchResultsFuture;

  handleSearch(String query) {
    Future<QuerySnapshot>? users = FirebaseFirestore.instance
        .collection('users')
        .where(
          'username',
          // isEqualTo: query,
          isLessThanOrEqualTo: query,
        )
        .get();
    searchResultsFuture = users;
    notifyListeners();
  }
}
