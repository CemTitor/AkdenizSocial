import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:senior_design_project/constants(config)/color_constant.dart';
import 'package:senior_design_project/screens/chat/chats_services.dart';
import 'package:senior_design_project/screens/messages/private_chat_view.dart';
import 'package:senior_design_project/screens/signup/auth_services.dart';
import 'package:senior_design_project/services/initialize.dart';

class ChatsScreen extends StatelessWidget {
  const ChatsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 100,
        automaticallyImplyLeading: false,
        title: const Text('Chats'),
        actions: [
          IconButton(
            onPressed: () {
              // AppRouter.push(
              //   PrivateChat(documentSnapshot: ,),
              // );
            },
            icon: const Icon(Icons.search),
          ),
        ],
      ),
      body: chatRoomList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          createChatroomBottomSheet(context);
        },
        backgroundColor: kSecondaryColor,
        child: const Icon(
          Icons.person_add_alt_1,
          color: Colors.white,
        ),
      ),
    );
  }
}

StreamBuilder<QuerySnapshot<Object?>> chatRoomList() {
  return StreamBuilder<QuerySnapshot>(
    stream: FirebaseFirestore.instance
        .collection('chatrooms')
        .orderBy('time', descending: true)
        .snapshots(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      } else {
        return ListView(
          children:
              snapshot.data!.docs.map((DocumentSnapshot documentSnapshot) {
            Provider.of<ChatServices>(context, listen: false)
                .showTimeAgo(documentSnapshot['time'] as Timestamp);
            return InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) =>
                        PrivateChat(documentSnapshot: documentSnapshot),
                  ),
                );
                // AppRouter.push(
                //   PrivateChat(
                //     documentSnapshot: documentSnapshot,
                //   ),
                // );
                // Navigator.pushReplacement(
                //     context,
                //     PageTransition(
                //     child: GroupMessages(
                //     documentSnapshot: documentSnapshot),
                // type: PageTransitionType.bottomToTop),
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: kDefaultPadding,
                  vertical: kDefaultPadding * 0.75,
                ),
                child: Row(
                  children: [
                    Stack(
                      children: [
                        CircleAvatar(
                          radius: 24,
                          backgroundImage: NetworkImage(
                            Provider.of<InitializeUser>(
                                  context,
                                  listen: false,
                                ).getInitUserImage ??
                                "https://www.solidbackgrounds.com/images/950x350/950x350-white-solid-color-background.jpg",
                          ),
                        ),
                        // if (isOnline)
                        //   Positioned(
                        //     right: 0,
                        //     bottom: 0,
                        //     child: Container(
                        //       height: 16,
                        //       width: 16,
                        //       decoration: BoxDecoration(
                        //         color: kPrimaryColor,
                        //         shape: BoxShape.circle,
                        //         border: Border.all(
                        //             color: Theme.of(context)
                        //                 .scaffoldBackgroundColor,
                        //             width: 3),
                        //       ),
                        //     ),
                        //   )
                      ],
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: kDefaultPadding,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              documentSnapshot['chatroomname'].toString(),
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Opacity(
                              opacity: 0.64,
                              child: StreamBuilder<QuerySnapshot>(
                                stream: FirebaseFirestore.instance
                                    .collection('chatrooms')
                                    .doc(documentSnapshot.id)
                                    .collection('messages')
                                    .orderBy('time', descending: true)
                                    .snapshots(),
                                builder: (context, snapshot) {
                                  if (!snapshot.hasData) {
                                    return const Center(
                                      child: Text("Error"),
                                    );
                                  } else if (snapshot
                                              .data!.docs.first['username'] !=
                                          null &&
                                      snapshot.data!.docs.first['message'] !=
                                          null) {
                                    return Text(
                                      "${snapshot.data!.docs.first['username']}: ${snapshot.data!.docs.first['message']}",
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    );
                                  }
                                  return const SizedBox(
                                    height: 10,
                                    width: 10,
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Opacity(
                      opacity: 0.64,
                      child: Text(
                        Provider.of<ChatServices>(context, listen: false)
                            .getImageTimePosted
                            .toString(),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        );
      }
    },
  );
}

Future createChatroomBottomSheet(BuildContext context) {
  final TextEditingController chatnameController = TextEditingController();

  return showModalBottomSheet(
    isScrollControlled: true,
    context: context,
    builder: (context) {
      return Padding(
        padding: MediaQuery.of(context).viewInsets,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            TextField(
              textAlign: TextAlign.center,
              textCapitalization: TextCapitalization.words,
              decoration: const InputDecoration(
                hintText: 'Enter Chatroom ID',
              ),
              controller: chatnameController,
            ),
            ElevatedButton(
              child: const Text('Create Chatroom'),
              onPressed: () {
                Provider.of<ChatServices>(context, listen: false)
                    .submitChatroomData(chatnameController.text, {
                  'chatroomname': chatnameController.text,
                  'username': Provider.of<InitializeUser>(
                    context,
                    listen: false,
                  ).initUserName,
                  'userimage': Provider.of<InitializeUser>(
                    context,
                    listen: false,
                  ).initUserImage,
                  'useremail': Provider.of<InitializeUser>(
                    context,
                    listen: false,
                  ).initUserEmail,
                  'useruid': Provider.of<Authentication>(context, listen: false)
                      .getUserid,
                  'time': Timestamp.now()
                }).whenComplete(() {
                  chatnameController.clear();
                  Navigator.pop(context);
                });
              },
            )
          ],
        ),
      );
    },
  );
}
