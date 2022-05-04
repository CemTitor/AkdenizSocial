import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:senior_design_project/constants(config)/color_constant.dart';
import 'package:senior_design_project/constants(config)/context_extension.dart';
import 'package:senior_design_project/screens/chat/chats_services.dart';
import 'package:senior_design_project/screens/messages/private_chat_view.dart';
import 'package:senior_design_project/services/auth.dart';
import 'package:senior_design_project/services/firebase.dart';

class ChatsView extends StatelessWidget {
  const ChatsView({Key? key}) : super(key: key);

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
            icon: Icon(Icons.search),
          ),
        ],
      ),
      body: chatRoomList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          createChatroomBottomSheet(context);
        },
        backgroundColor: kSecondaryColor,
        child: Icon(
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
                padding: EdgeInsets.symmetric(
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
                            Provider.of<FirebaseOpertrations>(
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
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(height: 8),
                            Opacity(
                              opacity: 0.64,
                              // child: FutureBuilder<QuerySnapshot>(
                              //   future: FirebaseFirestore.instance
                              //       .collection('chatrooms')
                              //       .doc(documentSnapshot.id)
                              //       .collection('messages')
                              //       .snapshots()
                              //       .last, // async work
                              //   builder: (BuildContext context,
                              //       AsyncSnapshot<QuerySnapshot> snapshot) {
                              //     switch (snapshot.connectionState) {
                              //       case ConnectionState.waiting:
                              //         return Text('Loading....');
                              //       default:
                              //         if (!snapshot.hasData)
                              //           return Text(
                              //             'Error: ${snapshot.error}',
                              //           );
                              //         else
                              //           return Text(
                              //             'Result: ${snapshot.data}',
                              //           );
                              //     }
                              //   },
                              // ),
                              child: Text(
                                "Last message :)",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Opacity(
                      opacity: 0.64,
                      child: Text(
                        '${Provider.of<ChatServices>(context, listen: false).getImageTimePosted.toString()}',
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
        child: Container(
          height: context.dynamicHeight(0.3),
          color: Colors.amber,
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
                    'username': Provider.of<FirebaseOpertrations>(
                      context,
                      listen: false,
                    ).initUserName,
                    'userimage': Provider.of<FirebaseOpertrations>(
                      context,
                      listen: false,
                    ).initUserImage,
                    'useremail': Provider.of<FirebaseOpertrations>(
                      context,
                      listen: false,
                    ).initUserEmail,
                    'useruid':
                        Provider.of<Authentication>(context, listen: false)
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
        ),
      );
    },
  );
}
