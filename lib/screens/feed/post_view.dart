import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:senior_design_project/screens/feed/feed_service.dart';
import 'package:senior_design_project/services/auth.dart';

class PostScreen extends StatelessWidget {
  TextEditingController commentController = TextEditingController();

  final DocumentSnapshot snapshot;
  final String docID;

  PostScreen({Key? key, required this.snapshot, required this.docID})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Yorumlar'),
      ),
      body: Column(
        children: <Widget>[
          postTitle(context),
          commentList(context),
        ],
      ),
      bottomNavigationBar: Transform.translate(
        offset: Offset(0.0, -1 * MediaQuery.of(context).viewInsets.bottom),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30.0),
              topRight: Radius.circular(30.0),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                offset: Offset(0, -2),
                blurRadius: 6.0,
              ),
            ],
            color: Colors.white,
          ),
          child: Padding(
            padding: EdgeInsets.all(12.0),
            child: TextField(
              controller: commentController,
              decoration: InputDecoration(
                border: InputBorder.none,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide(color: Colors.grey),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide(color: Colors.grey),
                ),
                contentPadding: EdgeInsets.all(20.0),
                hintText: 'Add a comment',
                prefixIcon: Container(
                  margin: EdgeInsets.all(4.0),
                  width: 48.0,
                  height: 48.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black45,
                        offset: Offset(0, 2),
                        blurRadius: 6.0,
                      ),
                    ],
                  ),
                  child: CircleAvatar(
                    child: ClipOval(
                      child: Image(
                        height: 48.0,
                        width: 48.0,
                        image: AssetImage('imageurl'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                suffixIcon: Container(
                  margin: EdgeInsets.only(right: 4.0),
                  width: 70.0,
                  child: TextButton(
                    onPressed: () {
                      print("Adding comment");
                      Provider.of<FeedServices>(context, listen: false)
                          .addComment(
                        context,
                        snapshot['caption'].toString(),
                        commentController.text,
                      )
                          .whenComplete(() {
                        commentController.clear();
                        // notifyListeners();
                      });
                    },
                    child: Icon(
                      Icons.send,
                      size: 25.0,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Expanded commentList(BuildContext context) {
    return Expanded(
      flex: 8,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30.0),
            topRight: Radius.circular(30.0),
          ),
        ),
        child: Container(
          height: MediaQuery.of(context).size.height * 0.3,
          width: MediaQuery.of(context).size.width,
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('posts')
                .doc(docID)
                .collection('comments')
                .orderBy('time')
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
                    return Padding(
                      padding: EdgeInsets.all(10.0),
                      child: ListTile(
                        leading: Container(
                          width: 50.0,
                          height: 50.0,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black45,
                                offset: Offset(0, 2),
                                blurRadius: 6.0,
                              ),
                            ],
                          ),
                          child: GestureDetector(
                            onTap: () {
                              if (documentSnapshot['useruid'] !=
                                  Provider.of<Authentication>(context,
                                          listen: false)
                                      .getUserid) {
                                // Navigator.pushReplacement(
                                //     context,
                                //     PageTransition(
                                //         child: UserProfile(
                                //           userUid:
                                //               documentSnapshot[
                                //                   'useruid'],
                                //         ),
                                //         type: PageTransitionType
                                //             .bottomToTop));
                              }
                            },
                            child: CircleAvatar(
                              child: ClipOval(
                                child: Image(
                                  height: 50.0,
                                  width: 50.0,
                                  image: AssetImage(
                                    documentSnapshot['userimage'].toString(),
                                  ),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        ),
                        title: Text(
                          documentSnapshot['username'].toString(),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(
                          documentSnapshot['comment'].toString(),
                        ),
                        trailing: IconButton(
                          icon: Icon(
                            Icons.favorite_border,
                          ),
                          color: Colors.grey,
                          onPressed: () => print('Like comment'),
                        ),
                      ),
                    );
                  }).toList(),
                );
              }
            },
          ),
        ),
      ),
    );
  }

  Expanded postTitle(BuildContext context) {
    return Expanded(
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 8.0, left: 8.0),
            child: GestureDetector(
              onTap: () {
                if (snapshot['useruid'] !=
                    Provider.of<Authentication>(context, listen: false)
                        .getUserid) {
                  // Navigator.pushReplacement(
                  //     context,
                  //     PageTransition(
                  //         child: UserProfile(
                  //           userUid:
                  //               documentSnapshot[
                  //                   'useruid'],
                  //         ),
                  //         type: PageTransitionType
                  //             .bottomToTop));
                }
              },
              child: CircleAvatar(
                backgroundColor: Colors.black,
                radius: 15.0,
                backgroundImage: NetworkImage(
                  snapshot['userimage'].toString(),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8),
            child: Container(
              child: Text(
                snapshot['username'].toString(),
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 14.0,
                ),
              ),
            ),
          ),
          Container(
            child: Text(
              snapshot['caption'].toString(),
            ),
          )
        ],
      ),
    );
  }
}
