import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:senior_design_project/constants(config)/app_router.dart';
import 'package:senior_design_project/constants(config)/color_constant.dart';
import 'package:senior_design_project/screens/user_profile/user_profile_service.dart';
import 'package:senior_design_project/services/auth.dart';
import 'package:senior_design_project/services/firebase.dart';

class UserProfile extends StatelessWidget {
  final String userUid;

  const UserProfile({Key? key, required this.userUid}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final Stream<DocumentSnapshot> userSnapshots =
        FirebaseFirestore.instance.collection('users').doc(userUid).snapshots();

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
      ),
      body: StreamBuilder<DocumentSnapshot>(
          stream: userSnapshots,
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return Stack(
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      UpperProfilePart(size, context, snapshot),
                      ProfilePostPart(snapshot, size),
                    ],
                  ),
                ],
              );
            }
          }),
    );
  }

  Container UpperProfilePart(
      Size size, BuildContext context, AsyncSnapshot<dynamic> snapshot) {
    return Container(
      height: size.height * 0.40,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/02.jpg"),
          fit: BoxFit.cover,
        ),
      ),
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 36,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              ElevatedButton(
                onPressed: () {
                  Provider.of<ProfileServices>(context, listen: false)
                      .followUser(
                          userUid,
                          Provider.of<Authentication>(context, listen: false)
                              .getUserid,
                          {
                            'username': Provider.of<FirebaseOpertrations>(
                                    context,
                                    listen: false)
                                .getInitUserName,
                            'userimage': Provider.of<FirebaseOpertrations>(
                                    context,
                                    listen: false)
                                .getInitUserImage,
                            'useruid': Provider.of<Authentication>(context,
                                    listen: false)
                                .getUserid,
                            'useremail': Provider.of<FirebaseOpertrations>(
                                    context,
                                    listen: false)
                                .getInitUserEmail,
                            'time': Timestamp.now()
                          },
                          Provider.of<Authentication>(context, listen: false)
                              .getUserid,
                          userUid,
                          {
                            'username': snapshot.data.data()['username'],
                            'userimage': snapshot.data.data()['userimage'],
                            'useremail': snapshot.data.data()['useremail'],
                            'useruid': snapshot.data.data()['useruid'],
                            'time': Timestamp.now(),
                          })
                      .whenComplete(() {
                    followedNotification(
                      context,
                      snapshot.data['username'].toString(),
                    );
                  });
                },
                child: Text('Follow'),
              ),
              (snapshot.data.data()['userimage'] == null)
                  ? CircleAvatar(
                      radius: 48,
                      child: IconButton(
                        icon: Icon(Icons.person),
                        onPressed: null,
                      ))
                  : CircleAvatar(
                      radius: 48,
                      backgroundImage: NetworkImage(
                        snapshot.data.data()['userimage'].toString(),
                      ),
                    ),
              ElevatedButton(
                onPressed: null,
                child: Text('Message'),
              ),
            ],
          ),
          SizedBox(
            height: 16,
          ),
          Text(
            '${snapshot.data['username']}',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 22,
            ),
          ),
          SizedBox(
            height: 4,
          ),
          Text(
            "Flutter Developer",
            style: TextStyle(
              color: Colors.white70,
              fontSize: 14,
            ),
          ),
          Expanded(
            child: Container(),
          ),
          Container(
            height: 64,
            color: Colors.black.withOpacity(0.4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "FOLLOWING",
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection('users')
                              .doc(
                                snapshot.data['useruid'].toString(),
                              )
                              .collection('following')
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                  child: CircularProgressIndicator());
                            } else {
                              return Text(
                                snapshot.data!.docs.length.toString(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              );
                            }
                          }),
                    ],
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                GestureDetector(
                  onTap: () {
                    checkFollowersSheet(context, snapshot);
                  },
                  child: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "FOLLOWER",
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                          ),
                        ),
                        SizedBox(
                          height: 4,
                        ),
                        StreamBuilder<QuerySnapshot>(
                            stream: FirebaseFirestore.instance
                                .collection('users')
                                .doc(snapshot.data['useruid'].toString())
                                .collection('followers')
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Center(
                                    child: CircularProgressIndicator());
                              } else {
                                return Text(
                                  snapshot.data!.docs.length.toString(),
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                );
                              }
                            }),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  StreamBuilder<QuerySnapshot<Object?>> ProfilePostPart(
      AsyncSnapshot<dynamic> snapshot, Size size) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(snapshot.data!['useruid'].toString())
          .collection('posts')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else {
          return Container(
            height: size.height * 0.60 - 56,
            padding: EdgeInsets.only(
              left: 16,
              right: 16,
              top: 0,
              bottom: 24,
            ),
            child: GridView.count(
              crossAxisCount: 3,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              physics: BouncingScrollPhysics(),
              children:
                  snapshot.data!.docs.map((DocumentSnapshot documentSnapshot) {
                return GestureDetector(
                  // onTap: () {
                  //   showpostDetails(
                  //       context, documentSnapshot);
                  // },
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Container(
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          ),
                        ),
                        height: MediaQuery.of(context).size.height * 0.25,
                        width: MediaQuery.of(context).size.width,
                        child: FittedBox(
                          child: Image.network(
                              documentSnapshot['postimage'].toString()),
                        )),
                  ),
                );
              }).toList(),
            ),
          );
        }
      },
    );
  }
}

Future followedNotification(BuildContext context, String name) {
  return showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 150.0),
                child: Divider(
                  thickness: 4.0,
                  color: Colors.black,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text("You just Followed $name",
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0)),
              )
            ],
          ),
          height: MediaQuery.of(context).size.height * 0.1,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              color: Colors.yellow, borderRadius: BorderRadius.circular(12.0)),
        );
      });
}

Future checkFollowersSheet(BuildContext context, dynamic snapshot) {
  return showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.4,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(50),
            ),
            color: kSecondaryColor,
          ),
          child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(snapshot.data['useruid'].toString())
                  .collection('followers')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListView(
                      children: snapshot.data!.docs
                          .map((DocumentSnapshot documentSnapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        } else {
                          return ListTile(
                            onTap: () {
                              if (documentSnapshot['useruid'] !=
                                  Provider.of<Authentication>(context,
                                          listen: false)
                                      .getUserid) {
                                AppRouter.push(
                                  UserProfile(
                                    userUid:
                                        documentSnapshot['useruid'].toString(),
                                  ),
                                );
                              }
                            },
                            trailing: documentSnapshot['useruid'] ==
                                    Provider.of<Authentication>(context,
                                            listen: false)
                                        .getUserid
                                ? Container(
                                    width: 0.0,
                                    height: 0.0,
                                  )
                                : MaterialButton(
                                    onPressed: () {
                                      /*Provider.of<FirebaseOpertrations>(context, listen: false)
                                    .unFollowUser(userUid, followingDocid)*/
                                    },
                                    color: Colors.black,
                                    child: Text(
                                      'Unfollow',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16.0),
                                    ),
                                  ),
                            leading: CircleAvatar(
                              backgroundColor: Colors.transparent,
                              backgroundImage: NetworkImage(
                                documentSnapshot['userimage'].toString(),
                              ),
                            ),
                            title: Text(
                              documentSnapshot['username'].toString(),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text(
                              documentSnapshot['useremail'].toString(),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          );
                        }
                      }).toList(),
                    ),
                  );
                }
              }),
        );
      });
}

// showpostDetails(BuildContext context, DocumentSnapshot documentSnapshot) {
//   return showModalBottomSheet(
//       context: context,
//       builder: (context) {
//         return Container(
//           height: MediaQuery.of(context).size.height * 0.6,
//           width: MediaQuery.of(context).size.width,
//           decoration: BoxDecoration(
//               color: Colors.yellow, borderRadius: BorderRadius.circular(12)),
//           child: Column(
//             children: [
//               Container(
//                   height: MediaQuery.of(context).size.height * 0.4,
//                   width: MediaQuery.of(context).size.width,
//                   child: FittedBox(
//                     child: Image.network(documentSnapshot['postimage']),
//                   )),
//               Text(
//                 documentSnapshot['caption'],
//                 style: TextStyle(
//                     color: constantColors.blackColor,
//                     fontWeight: FontWeight.bold,
//                     fontSize: 16.0),
//               ),
//               Container(
//                 margin: const EdgeInsets.only(left: 15.0),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                   children: [
//                     Container(
//                       width: 80.0,
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.start,
//                         children: [
//                           GestureDetector(
//                             onLongPress: () {
//                               Provider.of<PostFunctions>(context, listen: false)
//                                   .showlikes(
//                                       context, documentSnapshot['caption']);
//                             },
//                             onTap: () {
//                               Provider.of<PostFunctions>(context, listen: false)
//                                   .addlike(
//                                       context,
//                                       documentSnapshot['caption'],
//                                       Provider.of<Authentication>(context,
//                                               listen: false)
//                                           .getUserid);
//                             },
//                             child: Icon(
//                               FontAwesomeIcons.solidHeart,
//                               color: constantColors.redColor,
//                               size: 22.0,
//                             ),
//                           ),
//                           StreamBuilder<QuerySnapshot>(
//                               stream: FirebaseFirestore.instance
//                                   .collection('posts')
//                                   .doc(
//                                     documentSnapshot['caption'],
//                                   )
//                                   .collection('likes')
//                                   .snapshots(),
//                               builder: (context, snapshot) {
//                                 if (snapshot.connectionState ==
//                                     ConnectionState.waiting) {
//                                   return Center(
//                                     child: CircularProgressIndicator(),
//                                   );
//                                 } else {
//                                   return Padding(
//                                     padding: const EdgeInsets.only(left: 8.0),
//                                     child: Text(
//                                         snapshot.data.docs.length.toString(),
//                                         style: TextStyle(
//                                             color: constantColors.blackColor,
//                                             fontWeight: FontWeight.bold,
//                                             fontSize: 18.0)),
//                                   );
//                                 }
//                               })
//                         ],
//                       ),
//                     ),
//                     Container(
//                       width: 80.0,
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.start,
//                         children: [
//                           GestureDetector(
//                             onTap: () {
//                               Provider.of<PostFunctions>(context, listen: false)
//                                   .showCommentsSheet(context, documentSnapshot,
//                                       documentSnapshot['caption']);
//                             },
//                             child: Icon(
//                               FontAwesomeIcons.solidComment,
//                               color: constantColors.blueColor,
//                               size: 22.0,
//                             ),
//                           ),
//                           StreamBuilder<QuerySnapshot>(
//                               stream: FirebaseFirestore.instance
//                                   .collection('posts')
//                                   .doc(
//                                     documentSnapshot['caption'],
//                                   )
//                                   .collection('comments')
//                                   .snapshots(),
//                               builder: (context, snapshot) {
//                                 if (snapshot.connectionState ==
//                                     ConnectionState.waiting) {
//                                   return Center(
//                                     child: CircularProgressIndicator(),
//                                   );
//                                 } else {
//                                   return Padding(
//                                     padding: const EdgeInsets.only(left: 8.0),
//                                     child: Text(
//                                         snapshot.data.docs.length.toString(),
//                                         style: TextStyle(
//                                             color: constantColors.blackColor,
//                                             fontWeight: FontWeight.bold,
//                                             fontSize: 18.0)),
//                                   );
//                                 }
//                               })
//                         ],
//                       ),
//                     ),
//                     Spacer(),
//                     Provider.of<Authentication>(context, listen: false)
//                                 .getUserid ==
//                             documentSnapshot['useruid']
//                         ? IconButton(
//                             icon: Icon(
//                               EvaIcons.moreVertical,
//                               color: constantColors.blackColor,
//                             ),
//                             onPressed: () {
//                               Provider.of<PostFunctions>(context, listen: false)
//                                   .showPostOptions(
//                                       context, documentSnapshot['caption']);
//                             })
//                         : Container(
//                             width: 0,
//                             height: 0,
//                           )
//                   ],
//                 ),
//               )
//             ],
//           ),
//         );
//       });
// }
