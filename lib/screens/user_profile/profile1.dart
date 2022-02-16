import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:senior_design_project/services/auth.dart';

class UserProfile extends StatelessWidget {
  final String userUid;

  const UserProfile({Key? key, required this.userUid}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      extendBodyBehindAppBar: true,
      body: SingleChildScrollView(
          child: StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(Provider.of<Authentication>(context).getUserid)
                  .snapshots(),
              builder: (context, AsyncSnapshot snapshot) {
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
                                // CircleAvatar(
                                //   radius: 48,
                                //   backgroundImage:
                                //   NetworkImage(snapshot.data
                                //       .data()['userimage'] ??
                                //       "https://www.solidbackgrounds.com/images/950x350/950x350-white-solid-color-background.jpg"),,
                                // ),
                                SizedBox(
                                  height: 16,
                                ),
                                Text(
                                  '${snapshot.data.data()['username']}',
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
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: <Widget>[
                                      Expanded(
                                        child: Container(),
                                      ),
                                      Container(
                                        width: 110,
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
                                            Text(
                                              "364",
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        width: 110,
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
                                            Text(
                                              "175",
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        child: Container(),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
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
                              children: List.generate(12, (index) {
                                return Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(10),
                                    ),
                                    image: DecorationImage(
                                      image: AssetImage("assets/images/0" +
                                          index.toString() +
                                          ".jpg"),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                );
                              }),
                            ),
                          ),
                        ],
                      ),
                      Positioned(
                        top: 32,
                        left: 16,
                        child: GestureDetector(
                          onTap: () {
                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(builder: (context) => Profile2()),
                            // );
                          },
                          child: Icon(
                            Icons.keyboard_arrow_left,
                            color: Colors.white,
                            size: 32,
                          ),
                        ),
                      ),
                    ],
                  );
                }
              })),
    );
  }
}
