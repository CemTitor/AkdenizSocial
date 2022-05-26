import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:senior_design_project/constants(config)/app_router.dart';
import 'package:senior_design_project/screens/user_profile/user_profile_view.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../signup/auth_services.dart';
import '../../services/initialize.dart';

class PostServices with ChangeNotifier {
  TextEditingController commentContrller = TextEditingController();
  TextEditingController updatedCaptionController = TextEditingController();

  String? imageTimePosted;
  String? get getImageTimePosted => imageTimePosted;

  showTimeAgo(Timestamp timedata) {
    Timestamp time = timedata;
    DateTime dateTime = time.toDate();
    imageTimePosted = timeago.format(dateTime);
    print(imageTimePosted);
    notifyListeners();
  }

  Future showPostOptions(BuildContext context, String postId) {
    return showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.1,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12.0),
                    topRight: Radius.circular(12.0))),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 150.0),
                  child: Divider(
                    thickness: 4.0,
                  ),
                ),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      MaterialButton(
                          child: Text("Edit Caption",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16.0)),
                          onPressed: () {
                            showModalBottomSheet(
                                context: context,
                                builder: (context) {
                                  return Container(
                                    child: Center(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Container(
                                            width: 300.0,
                                            height: 50.0,
                                            child: TextField(
                                              decoration: InputDecoration(
                                                  hintText: "Add New Caption",
                                                  hintStyle: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 16)),
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16),
                                              controller:
                                                  updatedCaptionController,
                                            ),
                                          ),
                                          FloatingActionButton(
                                            onPressed: () {
                                              updateCaption(postId, {
                                                'caption':
                                                    updatedCaptionController
                                                        .text
                                              }).whenComplete(() {
                                                updatedCaptionController
                                                    .clear();
                                                // AppRouter.push(FeedScreen());
                                              });
                                            },
                                            backgroundColor: Colors.black,
                                            child: Icon(
                                              FontAwesomeIcons.fileUpload,
                                              color: Colors.white,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  );
                                });
                          }),
                      MaterialButton(
                          child: Text("Delete Post",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16.0)),
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: Text("Delete this Post ?",
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold)),
                                    actions: [
                                      MaterialButton(
                                          child: Text("No",
                                              style: TextStyle(
                                                  decoration:
                                                      TextDecoration.underline,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16.0)),
                                          onPressed: () {
                                            Navigator.pop(context);
                                          }),
                                      MaterialButton(
                                        child: Text("Yes",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16.0)),
                                        onPressed: () {
                                          deleteUserData(postId, "posts")
                                              .whenComplete(() {
                                            deleteFromUserCollection(
                                              Provider.of<Authentication>(
                                                context,
                                                listen: false,
                                              ).getUserid,
                                              postId,
                                              "users",
                                              "posts",
                                            );
                                          }).whenComplete(
                                            () => Navigator.pop(context),
                                          );
                                        },
                                      ),
                                    ],
                                  );
                                });
                          }),
                    ],
                  ),
                )
              ],
            ),
          );
        });
  }

  Future addlike(BuildContext context, String postId, String? subDocId) async {
    FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('likes')
        .doc(subDocId)
        .set({
      'likes': FieldValue.increment(1),
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

  Future addcomment(BuildContext context, String postId, String comment) async {
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

  Future showlikes(BuildContext context, String postId) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 150.0),
                  child: Divider(
                    thickness: 4.0,
                  ),
                ),
                Container(
                  width: 100.0,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  child: Center(
                    child: Text(
                      "Likes",
                      style: TextStyle(
                          fontSize: 16.0, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.2,
                  width: MediaQuery.of(context).size.width,
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('posts')
                        .doc(postId)
                        .collection('likes')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      } else {
                        return ListView(
                          children: snapshot.data!.docs
                              .map((DocumentSnapshot documentSnapshot) {
                            return ListTile(
                              leading: GestureDetector(
                                onTap: () {
                                  if (documentSnapshot['useruid'] !=
                                      Provider.of<Authentication>(context,
                                              listen: false)
                                          .getUserid) {
                                    AppRouter.push(UserProfile(
                                        userUid: documentSnapshot['useruid']
                                            .toString()));
                                  }
                                },
                                child: CircleAvatar(
                                  backgroundImage: NetworkImage(
                                    documentSnapshot['userimage'].toString(),
                                  ),
                                ),
                              ),
                              title: Text(
                                documentSnapshot['username'].toString(),
                                style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text(
                                documentSnapshot['useremail'].toString(),
                                style: TextStyle(
                                    fontSize: 12.0,
                                    fontWeight: FontWeight.bold),
                              ),
                              trailing: Provider.of<Authentication>(context,
                                              listen: false)
                                          .getUserid ==
                                      documentSnapshot['useruid']
                                  ? Container(
                                      width: 0.0,
                                      height: 0.0,
                                    )
                                  : MaterialButton(
                                      child: Text("Follow",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14.0)),
                                      onPressed: () {},
                                    ),
                            );
                          }).toList(),
                        );
                      }
                    },
                  ),
                )
              ],
            ),
            height: MediaQuery.of(context).size.height * 0.50,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12.0),
                    topRight: Radius.circular(12.0))),
          );
        });
  }

  Future deleteUserData(String postId, String collection) async {
    return FirebaseFirestore.instance
        .collection(collection)
        .doc(postId)
        .delete();
  }

  Future deleteFromUserCollection(String? userId, String postId,
      String collection1, String collection2) async {
    return FirebaseFirestore.instance
        .collection(collection1)
        .doc(userId)
        .collection(collection2)
        .doc(postId)
        .delete();
  }

  Future updateCaption(String postId, Map<String, dynamic> data) async {
    return FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .update(data);
  }
}
