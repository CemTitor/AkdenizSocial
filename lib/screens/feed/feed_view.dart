import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:senior_design_project/constants(config)/app_router.dart';
import 'package:senior_design_project/constants(config)/color_constant.dart';
import 'package:senior_design_project/constants(config)/context_extension.dart';
import 'package:senior_design_project/screens/feed/feed_services.dart';
import 'package:senior_design_project/screens/feed/post_view.dart';
import 'package:senior_design_project/screens/feed/post_services.dart';
import 'package:senior_design_project/screens/my_profile/my_profile_view.dart';
import 'package:senior_design_project/screens/search/search_view.dart';
import 'package:senior_design_project/screens/user_profile/user_profile_view.dart';
import 'package:senior_design_project/screens/signup/auth_services.dart';
import 'package:senior_design_project/services/initialize.dart';
import 'package:senior_design_project/services/page_controller.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class FeedScreen extends StatefulWidget {
  @override
  _FeedScreenState createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> with TickerProviderStateMixin {
  // late AnimationController controller;

  @override
  void initState() {
    Provider.of<InitializeUser>(context, listen: false).initUserData(context);

    // controller = AnimationController(
    //   duration: Duration(seconds: 1),
    //   vsync: this,
    // );
    super.initState();
  }

  // void dispose() {
  //   controller.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Akdeniz Social'),
        actions: [
          IconButton(
            onPressed: () {
              showSearch(
                context: context,
                delegate: CustomSearch(),
              );
            },
            icon: Icon(Icons.search),
          ),
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: () {
              Provider.of<PageControllerClass>(context, listen: false)
                  .pageController
                  .nextPage(
                      duration: Duration(seconds: 1),
                      curve: Curves.easeInOutExpo);
            },
          ),
        ],
      ),
      // backgroundColor: kPrimaryColor,
      body: Column(
        children: [
          //TODO story kısmı
          // Expanded(
          //   flex: 1,
          //   child: storyPart(context),
          // ),
          Expanded(
            flex: 7,
            child: StreamBuilder<QuerySnapshot>(
              stream: Provider.of<FeedServices>(context, listen: false)
                  .fetchPostsByTime(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  // return SpinKitSquareCircle(
                  //   color: Colors.orange,
                  //   size: 50.0,
                  //   controller: controller,
                  // );
                  return Center(
                    child: RefreshProgressIndicator(
                      semanticsLabel: 'asdsa',
                      color: Colors.orange,
                      strokeWidth: 5,
                    ),
                  );
                } else {
                  return stackPost(context, snapshot);
                }
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: kPrimaryColor,
        color: kSecondaryColor,
        buttonBackgroundColor: kSecondaryColor,
        items: <Widget>[
          const Icon(Icons.home, size: 30),
          IconButton(
            icon: const Icon(Icons.add_circle_rounded),
            onPressed: () {
              Provider.of<PageControllerClass>(context, listen: false)
                  .pageController
                  .previousPage(
                      duration: Duration(seconds: 1),
                      curve: Curves.easeInOutExpo);
            },
          ),
          IconButton(
            onPressed: () {
              Provider.of<PageControllerClass>(context, listen: false)
                  .pageController
                  .nextPage(
                      duration: Duration(seconds: 1),
                      curve: Curves.easeInOutExpo);
            },
            icon: const Icon(Icons.chat_bubble),
          ),
          const Icon(Icons.notifications, size: 30),
          IconButton(
            icon: CircleAvatar(
              radius: 35.0,
              backgroundColor: Colors.blueGrey,
              backgroundImage: NetworkImage(
                Provider.of<InitializeUser>(
                      context,
                      listen: false,
                    ).getInitUserImage ??
                    "https://www.solidbackgrounds.com/images/950x350/950x350-white-solid-color-background.jpg",
              ),
            ),
            onPressed: () {
              AppRouter.push(
                MyProfile(),
              );
            },
          ),
        ],
        onTap: (index) {
          //Handle button tap
        },
      ),
    );
  }

  Widget stackPost(
      BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
    return ListView(
      children: snapshot.data!.docs.map((DocumentSnapshot documentSnapshot) {
        Provider.of<PostServices>(context, listen: false)
            .showTimeAgo(documentSnapshot['time'] as Timestamp);

        return AspectRatio(
          aspectRatio: 3 / 3, //not neccesary, just tried aspectratio widget.
          child: Padding(
            padding: context.paddingAllow,
            child: Stack(
              alignment: Alignment.topLeft,
              children: <Widget>[
                PostImage(context, documentSnapshot),
                PostTopPart(documentSnapshot, context),
                PostBottomPart(documentSnapshot, context),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Positioned PostBottomPart(
      DocumentSnapshot<Object?> documentSnapshot, BuildContext context) {
    return Positioned(
      bottom: 10,
      left: context.dynamicWidth(0.2),
      child: Card(
        color: Colors.white24,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        elevation: 12,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: GestureDetector(
                onLongPress: () {
                  Provider.of<PostServices>(context, listen: false).showlikes(
                      context, documentSnapshot['caption'].toString());
                },
                onTap: () {
                  Provider.of<PostServices>(context, listen: false).addlike(
                      context,
                      documentSnapshot['caption'].toString(),
                      Provider.of<Authentication>(context, listen: false)
                          .getUserid);
                },
                child: Icon(
                  Icons.favorite_border,
                  size: 30.0,
                ),
              ),
            ),
            StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('posts')
                    .doc(
                      documentSnapshot['caption'].toString(),
                    )
                    .collection('likes')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: Text('0'),
                    );
                  } else {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        snapshot.data!.docs.length.toString(),
                        style: TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    );
                  }
                }),
            GestureDetector(
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
              child: Icon(
                Icons.chat,
                size: 30.0,
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
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('0'),
                      ),
                    );
                  } else {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        snapshot.data!.docs.length.toString(),
                        style: TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    );
                  }
                }),
            IconButton(
              icon: Icon(Icons.share),
              iconSize: 30.0,
              onPressed: () => print('Share post'),
            ),
            IconButton(
              icon: Icon(Icons.bookmark_border),
              iconSize: 30.0,
              onPressed: () => print('Save post'),
            ),
          ],
        ),
      ),
    );
  }

  Positioned PostTopPart(
      DocumentSnapshot<Object?> documentSnapshot, BuildContext context) {
    // Provider.of<PostFunctions>(context, listen: false)
    //     .showTimeAgo(documentSnapshot['time'] as Timestamp);
    return Positioned(
      child: Expanded(
        child: ListTile(
          hoverColor: Colors.yellow,
          textColor: Colors.white,
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
                    Provider.of<Authentication>(context, listen: false)
                        .getUserid) {
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
                    image: NetworkImage(documentSnapshot['userimage'].toString()
                        // Provider.of<FirebaseOpertrations>(
                        //       context,
                        //       listen: false,
                        //     ).getInitUserImage ??
                        //     "https://www.solidbackgrounds.com/images/950x350/950x350-white-solid-color-background.jpg",
                        ),
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
          trailing:
              Provider.of<Authentication>(context, listen: false).getUserid ==
                      documentSnapshot['useruid']
                  ? IconButton(
                      icon: Icon(Icons.more_vert),
                      onPressed: () {
                        Provider.of<PostServices>(context, listen: false)
                            .showPostOptions(
                          context,
                          documentSnapshot.id,
                          // documentSnapshot['caption'].toString(),
                        );
                      })
                  : Container(
                      width: 0,
                      height: 0,
                    ),
        ),
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
                  color: Colors.yellow,
                ),
              ),
            ),
    );
  }

  Widget storyPart(BuildContext context) {
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
                  color: kPrimaryColor,
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
                  image: AssetImage(stories[index - 1].toString()),
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

List stories = [
  'dsadsa',
  'dsadsa',
  'dsadsa',
  'dsadsa',
  'dsadsa',
  'dsadsa',
  'dsadsa',
  'dsadsa',
];
