import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:senior_design_project/constants(config)/color_constant.dart';
import 'package:senior_design_project/constants(config)/context_extension.dart';
import 'package:senior_design_project/screens/feed/feed_services.dart';
import 'package:senior_design_project/screens/feed/post_services.dart';
import 'package:senior_design_project/screens/signup/auth_services.dart';

import '../../constants(config)/app_router.dart';
import '../../services/initialize.dart';
import '../user_profile/user_profile_view.dart';

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
        title: const Text('Yorumlar'),
      ),
      body: Column(
        children: <Widget>[
          postTitle(context),
          commentList(context),
        ],
      ),
      bottomNavigationBar: Transform.translate(
        offset: Offset(0.0, -1 * MediaQuery.of(context).viewInsets.bottom),
        child: Padding(
          padding: EdgeInsets.all(12.0),
          child: TextField(
            controller: commentController,
            decoration: InputDecoration(
              border: InputBorder.none,
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30.0),
                // borderSide: BorderSide(color: Colors.grey),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30.0),
                // borderSide: BorderSide(color: Colors.grey),
              ),
              contentPadding: EdgeInsets.all(20.0),
              hintText: 'Add a comment',
              // hintStyle: TextStyle(color: Colors.grey),
              prefixIcon: Container(
                margin: EdgeInsets.all(4.0),
                width: 48.0,
                height: 48.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      // color: Colors.black45,
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
                      image: NetworkImage(
                        Provider.of<InitializeUser>(
                              context,
                              listen: false,
                            ).getInitUserImage ??
                            "https://www.solidbackgrounds.com/images/950x350/950x350-white-solid-color-background.jpg",
                      ),
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
                  child: const Icon(
                    Icons.send,
                    size: 25.0,
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
      // flex: 1,
      child: Container(
        decoration: const BoxDecoration(
          // color: Colors.white,
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
                      padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
                      child: ListTile(
                        leading: Container(
                          width: 50.0,
                          height: 50.0,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                // color: Colors.black45,
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
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => UserProfile(
                                      userUid: documentSnapshot['useruid']
                                          .toString(),
                                    ),
                                  ),
                                );
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
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: kPrimaryColor),
                        ),
                        subtitle: Text(
                          documentSnapshot['comment'].toString(),
                        ),
                        trailing: IconButton(
                          icon: const Icon(
                            Icons.favorite_border,
                          ),
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
      flex: 2,
      child: Padding(
        padding: context.paddingAllow,
        child: Stack(
          ///dont use expanded in stack widget.
          // alignment: Alignment.topLeft,
          children: <Widget>[
            PostImage(context, snapshot),
            PostTopPart(snapshot, context),
          ],
        ),
      ),
    );
  }
}

ListTile PostTopPart(
    DocumentSnapshot<Object?> documentSnapshot, BuildContext context) {
  // Provider.of<PostFunctions>(context, listen: false)
  //     .showTimeAgo(documentSnapshot['time'] as Timestamp);
  return ListTile(
    // hoverColor: Colors.yellow,
    // textColor: Colors.white,
    leading: Container(
      width: 50.0,
      height: 50.0,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            // color: Colors.black45,
            offset: Offset(0, 2),
            blurRadius: 6.0,
          ),
        ],
      ),
      child: GestureDetector(
        onTap: () {
          if (documentSnapshot['useruid'] !=
              Provider.of<Authentication>(context, listen: false).getUserid) {
            AppRouter.push(
              UserProfile(
                userUid: documentSnapshot['useruid'].toString(),
              ),
            );
          }
        },
        child: CircleAvatar(
          child: ClipOval(
            child: Image(
              height: 50.0,
              width: 50.0,
              image: NetworkImage(documentSnapshot['userimage'].toString()),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    ),
    title: Text(
      documentSnapshot['caption'].toString(),
    ),
    subtitle: RichText(
      text: TextSpan(
          text: documentSnapshot['username'].toString(),
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
          children: <TextSpan>[
            TextSpan(
              text:
                  ' , ${Provider.of<PostServices>(context, listen: false).getImageTimePosted.toString()}',
              style: TextStyle(),
            )
          ]),
    ),
    // trailing: Icon(Icons.more_vert),
    trailing: Provider.of<Authentication>(context, listen: false).getUserid ==
            documentSnapshot['useruid']
        ? IconButton(
            icon: Icon(Icons.more_vert),
            onPressed: () {
              Provider.of<PostServices>(context, listen: false).showPostOptions(
                context,
                documentSnapshot.id,
                // documentSnapshot['caption'].toString(),
              );
            })
        : Container(
            width: 0,
            height: 0,
          ),
  );
}

InkWell PostImage(
    BuildContext context, DocumentSnapshot<Object?> documentSnapshot) {
  return InkWell(
    onDoubleTap: () {
      Provider.of<PostServices>(context, listen: false).addlike(
          context,
          documentSnapshot['caption'].toString(),
          Provider.of<Authentication>(context, listen: false).getUserid);
    },
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => PostScreen(
            snapshot: documentSnapshot,
            docID: documentSnapshot['caption'].toString(),
          ),
        ),
      );
    },
    child: (documentSnapshot['postimage'] != null)
        ? ClipRRect(
            borderRadius: BorderRadius.circular(20), // Image border
            child:
                // Image.network(
                //   documentSnapshot['postimage'].toString(),
                //   // fit: BoxFit.cover,
                // ),
                CachedNetworkImage(
              imageUrl: documentSnapshot['postimage'].toString(),
            ),
          )
        : Center(
            child: SizedBox(
              height: context.dynamicHeight(0.5),
              width: context.dynamicWidth(0.5),
              child: const RefreshProgressIndicator(
                strokeWidth: 10,
                // color: Colors.yellow,
              ),
            ),
          ),
  );
}
