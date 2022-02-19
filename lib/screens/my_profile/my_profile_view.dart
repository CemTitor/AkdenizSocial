import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:senior_design_project/constants(config)/app_router.dart';
import 'package:senior_design_project/screens/my_profile/my_profile_services.dart';
import 'package:senior_design_project/screens/user_profile/user_profile_view.dart';
import 'package:senior_design_project/services/auth.dart';
import 'package:senior_design_project/theme.dart';

class MyProfile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        actions: [
          IconButton(
            icon: Icon(
              Icons.logout,
            ),
            onPressed: () {
              Provider.of<MyProfileServices>(context, listen: false)
                  .logutdialog(context);
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        child: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection('users')
              .doc(Provider.of<Authentication>(context).getUserid)
              .snapshots(),
          builder: (context, dynamic snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else {
              return Stack(
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        height: size.height * 0.40,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage("assets/images/01.jpg"),
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: Column(
                          children: <Widget>[
                            SizedBox(
                              height: 36,
                            ),
                            if (snapshot.data.data()['userimage'] == null)
                              CircleAvatar(
                                  radius: 48,
                                  child: IconButton(
                                    icon: Icon(Icons.add_a_photo_rounded),
                                    onPressed: null,
                                  ))
                            else
                              CircleAvatar(
                                radius: 48,
                                backgroundImage: NetworkImage(
                                  snapshot.data.data()['userimage'].toString(),
                                ),
                              ),
                            SizedBox(
                              height: 16,
                            ),
                            Text(
                              snapshot.data.data()['username'].toString(),
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
                                  GestureDetector(
                                    onTap: () {
                                      checkFollowingSheet(context, snapshot);
                                    },
                                    child: Container(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
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
                                                    snapshot.data['useruid']
                                                        .toString(),
                                                  )
                                                  .collection('following')
                                                  .snapshots(),
                                              builder: (context, snapshot) {
                                                if (snapshot.connectionState ==
                                                    ConnectionState.waiting) {
                                                  return const Center(
                                                      child:
                                                          CircularProgressIndicator());
                                                } else {
                                                  return Text(
                                                    snapshot.data!.docs.length
                                                        .toString(),
                                                    style: const TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  );
                                                }
                                              }),
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Container(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
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
                                                .doc(snapshot.data['useruid']
                                                    .toString())
                                                .collection('followers')
                                                .snapshots(),
                                            builder: (context, snapshot) {
                                              if (snapshot.connectionState ==
                                                  ConnectionState.waiting) {
                                                return Center(
                                                    child:
                                                        CircularProgressIndicator());
                                              } else {
                                                return Text(
                                                  snapshot.data!.docs.length
                                                      .toString(),
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
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('users')
                            .doc(snapshot.data!['useruid'].toString())
                            .collection('posts')
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
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
                                children: snapshot.data!.docs
                                    .map((DocumentSnapshot documentSnapshot) {
                                  return GestureDetector(
                                    // onTap: () {
                                    //   showpostDetails(
                                    //       context, documentSnapshot);
                                    // },
                                    child: Padding(
                                      padding: EdgeInsets.all(10),
                                      child: Container(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.25,
                                          width:
                                              MediaQuery.of(context).size.width,
                                          child: FittedBox(
                                            child: Image.network(
                                                documentSnapshot['postimage']
                                                    .toString()),
                                          )),
                                    ),
                                  );
                                }).toList(),
                                // List.generate(
                                //   12,
                                //   (index) {
                                //     return Container(
                                //       decoration: BoxDecoration(
                                //         borderRadius: BorderRadius.all(
                                //           Radius.circular(10),
                                //         ),
                                //         image: DecorationImage(
                                //           image: AssetImage("assets/images/0" +
                                //               index.toString() +
                                //               ".jpg"),
                                //           fit: BoxFit.cover,
                                //         ),
                                //       ),
                                //     );
                                //   },
                                // ),
                              ),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }

  Future checkFollowingSheet(BuildContext context, dynamic snapshot) {
    return showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        builder: (context) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.4,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: CustomTheme.loginGradientStart,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(50),
              ),
            ),
            child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .doc(snapshot.data['useruid'].toString())
                    .collection('following')
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
                                AppRouter.push(
                                  UserProfile(
                                      userUid: documentSnapshot['useruid']
                                          .toString()),
                                );
                              },
                              trailing: MaterialButton(
                                  onPressed: () {},
                                  color: Colors.black,
                                  child: Text('Unfollow',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16.0))),
                              leading: CircleAvatar(
                                backgroundColor: Colors.transparent,
                                backgroundImage: NetworkImage(
                                    documentSnapshot['userimage'].toString()),
                              ),
                              title: Text(
                                documentSnapshot['username'].toString(),
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Text(
                                documentSnapshot['useremail'].toString(),
                                style: TextStyle(
                                  color: Colors.black,
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
}
