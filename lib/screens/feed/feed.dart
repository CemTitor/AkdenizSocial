import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:senior_design_project/constants(config)/app_router.dart';
import 'package:senior_design_project/constants(config)/context_extension.dart';
import 'package:senior_design_project/screens/feed/view_post_screen.dart';
import 'package:senior_design_project/services/auth.dart';
import 'package:senior_design_project/services/firebase.dart';
import 'package:senior_design_project/theme.dart';

import '../../services/upload_post_firebase.dart';
import '../pageview.dart';

class FeedScreen extends StatefulWidget {
  @override
  _FeedScreenState createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  @override
  void initState() {
    Provider.of<FirebaseOpertrations>(context, listen: false)
        .initUserData(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Akdeniz Social'),
        actions: [
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: () => AppRouter.push(
              Messages(),
            ),
          ),
        ],
      ),
      backgroundColor: CustomTheme.loginGradientEnd,
      body: Column(
        children: [
          Expanded(
            flex: 1,
            child: storyPart(context),
          ),
          Expanded(
            flex: 7,
            child: StreamBuilder<QuerySnapshot>(
              stream: Provider.of<FirebaseOpertrations>(context, listen: false)
                  .fetchPostsByTime(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const RefreshProgressIndicator();
                } else {
                  return stackPost(context, snapshot);
                }
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: CustomTheme.loginGradientEnd,
        items: <Widget>[
          const Icon(Icons.home, size: 30),
          const Icon(
            Icons.search,
            size: 30,
          ),
          IconButton(
            onPressed: () {
              // Provider.of<UploadPost>(context, listen: false)
              //     .selectpostImageType(context);
            },
            icon: const Icon(Icons.place),
          ),
          Icon(Icons.notifications, size: 30),
          Icon(Icons.person, size: 30),
        ],
        onTap: (index) {
          //Handle button tap
        },
      ),
    );
  }

  Widget firebaseKismiTam(
      BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
    return ListView(
      children: snapshot.data!.docs.map((DocumentSnapshot documentSnapshot) {
        // Provider.of<PostFunctions>(context, listen: false)
        //     .showTimeAgo(documentSnapshot['time']);
        return Column(
          children: [
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    if (documentSnapshot['useruid'] !=
                        Provider.of<Authentication>(context, listen: false)
                            .getUserid) {
                      // Navigator.pushReplacement(
                      //     context,
                      //     PageTransition(
                      //         child: UserProfile(
                      //           userUid: documentSnapshot['useruid'],
                      //         ),
                      //         type: PageTransitionType.bottomToTop));
                    }
                  },
                  // child: CircleAvatar(
                  //   backgroundColor: Colors.blueGrey,
                  //   radius: 20.0,
                  //   backgroundImage:
                  //       NetworkImage(documentSnapshot!['userimage']),
                  // ),
                ),
                Container(
                  height: 50.0,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                          child: Text(documentSnapshot['caption'].toString(),
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16.0))),
                      Container(
                        child: RichText(
                          text: TextSpan(
                            text: documentSnapshot['useremail'].toString(),
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 16.0),
                            children: <TextSpan>[
                              // TextSpan(
                              //   text:
                              //       ' , ${Provider.of<PostFunctions>(context, listen: false).getImageTimePosted.toString()}',
                              //   style: TextStyle(color: Colors.black12),
                              // ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.46,
              width: MediaQuery.of(context).size.width,
              child: FittedBox(
                child: Image.network(
                  documentSnapshot['postimage'].toString(),
                  scale: 2,
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  width: 80.0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      GestureDetector(
                        // onLongPress: () {
                        //   Provider.of<PostFunctions>(context, listen: false)
                        //       .showlikes(context, documentSnapshot['caption']);
                        // },
                        // onTap: () {
                        //   Provider.of<PostFunctions>(context, listen: false)
                        //       .addlike(
                        //           context,
                        //           documentSnapshot['caption'],
                        //           Provider.of<Authentication>(context,
                        //                   listen: false)
                        //               .getUserid);
                        // },
                        child: Icon(
                          Icons.label,
                          color: Colors.red,
                          size: 22.0,
                        ),
                      ),
                      StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection('posts')
                              .doc(
                                  // documentSnapshot!['caption'],
                                  'caption')
                              .collection('likes')
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            } else {
                              return Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Text(
                                    snapshot.data!.docs.length.toString(),
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18.0)),
                              );
                            }
                          })
                    ],
                  ),
                ),
                Container(
                  width: 80.0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      GestureDetector(
                        // onTap: () {
                        //   Provider.of<PostFunctions>(context, listen: false)
                        //       .showCommentsSheet(context, documentSnapshot,
                        //           documentSnapshot['caption']);
                        // },
                        child: Icon(
                          Icons.label_important_outline,
                          color: Colors.blue,
                          size: 22.0,
                        ),
                      ),
                      StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection('posts')
                              .doc(
                                documentSnapshot['caption'].toString(),
                              )
                              .collection('comments')
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            } else {
                              return Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Text(
                                    snapshot.data!.docs.length.toString(),
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18.0)),
                              );
                            }
                          })
                    ],
                  ),
                ),
                Spacer(),
                Provider.of<Authentication>(context, listen: false).getUserid ==
                        documentSnapshot['useruid']
                    ? IconButton(
                        icon: Icon(
                          Icons.star,
                          color: Colors.black,
                        ),
                        onPressed: () {
                          //   Provider.of<PostFunctions>(context, listen: false)
                          //       .showPostOptions(
                          //           context, documentSnapshot['caption']);
                        },
                      )
                    : Container(
                        width: 0,
                        height: 0,
                      )
              ],
            ),
          ],
        );
      }).toList(),
    );
  }

  Widget stackPost(
      BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
    return ListView(
      children: snapshot.data!.docs.map((DocumentSnapshot documentSnapshot) {
        // Provider.of<PostFunctions>(context, listen: false)
        //     .showTimeAgo(documentSnapshot['time']);
        return Stack(alignment: Alignment.topLeft,
            // fit: StackFit.expand,
            children: <Widget>[
              Image.network(documentSnapshot['postimage'].toString()),
              //TODO cachednetwork for fast loading image
              // CachedNetworkImage(
              //   imageUrl: documentSnapshot!['postimage'],
              // ),
              Positioned(
                bottom: 10,
                child: Row(
                  children: const [
                    Text('Row1'),
                  ],
                ),
              ),
              Positioned(
                child: Row(
                  children: const [
                    Text('Row2'),
                  ],
                ),
              ),
            ]);
      }).toList(),
    );
  }

  Widget loadposts2(
      BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
    return ListView(
      children: snapshot.data!.docs.map((DocumentSnapshot documentSnapshot) {
        // Provider.of<PostFunctions>(context, listen: false)
        //     .showTimeAgo(documentSnapshot['time']);
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
          child: Container(
            height: context.dynamicHeight(0.7),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(25.0),
            ),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 10.0),
                  child: Column(
                    children: <Widget>[
                      ListTile(
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
                          // child: CircleAvatar(
                          //   child: ClipOval(
                          //     child: Image(
                          //       height: 50.0,
                          //       width: 50.0,
                          //       image: AssetImage(posts[index].authorImageUrl),
                          //       fit: BoxFit.cover,
                          //     ),
                          //   ),
                          // ),
                        ),
                        title: Text(
                          documentSnapshot['caption'].toString(),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        // subtitle: Text(documentSnapshot['caption'].timeAgo),
                        trailing: IconButton(
                          icon: Icon(Icons.more_horiz),
                          color: Colors.black,
                          onPressed: () => print('More'),
                        ),
                      ),
                      InkWell(
                        onDoubleTap: () => print('Like post'),
                        // onTap: () {
                        //   Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //       builder: (_) => ViewPostScreen(
                        //         post: posts[index],
                        //       ),
                        //     ),
                        //   );
                        // },
                        child: ClipRRect(
                          borderRadius:
                              BorderRadius.circular(20), // Image border
                          child: SizedBox.fromSize(
                            size: Size.fromRadius(150), // Image radius
                            child: Image.network(
                                documentSnapshot['postimage'].toString(),
                                fit: BoxFit.cover),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    IconButton(
                                      icon: Icon(Icons.favorite_border),
                                      iconSize: 30.0,
                                      onPressed: () => print('Like post'),
                                    ),
                                    Text(
                                      '2,515',
                                      style: TextStyle(
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(width: 20.0),
                                Row(
                                  children: <Widget>[
                                    IconButton(
                                        icon: Icon(Icons.chat),
                                        iconSize: 30.0,
                                        onPressed: null
                                        // ()
                                        // {
                                        //                                   Navigator.push(
                                        //                                     context,
                                        //                                     MaterialPageRoute(
                                        //                                       builder: (_) => ViewPostScreen(
                                        //                                         post: posts[index],
                                        //                                       ),
                                        //                                     ),
                                        //                                   );
                                        //                                 },
                                        ),
                                    Text(
                                      '350',
                                      style: TextStyle(
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            IconButton(
                              icon: Icon(Icons.bookmark_border),
                              iconSize: 30.0,
                              onPressed: () => print('Save post'),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Container storyPart(BuildContext context) {
    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.1,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: stories.length,
        itemBuilder: (BuildContext context, int index) {
          if (index == 0) {
            return SizedBox(width: 10.0);
          }
          return Container(
            margin: EdgeInsets.all(10.0),
            width: 60.0,
            height: 60.0,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.yellow,
                  offset: Offset(0, 2),
                  blurRadius: 10.0,
                ),
              ],
            ),
            child: CircleAvatar(
              child: ClipOval(
                child: Image(
                  height: 60.0,
                  width: 60.0,
                  image: AssetImage(stories[index - 1]),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
