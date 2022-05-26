import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:senior_design_project/constants(config)/app_router.dart';
import 'package:senior_design_project/screens/chat/chats_view.dart';
import 'package:senior_design_project/screens/signup/auth_services.dart';
import 'package:senior_design_project/services/initialize.dart';

class PrivateChatServices with ChangeNotifier {
  showmessages(BuildContext context, DocumentSnapshot documentSnapshot) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('chatrooms')
            .doc(documentSnapshot.id)
            .collection('messages')
            .orderBy('time')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return ListView(
              reverse: true,
              children:
                  snapshot.data!.docs.map((DocumentSnapshot documentSnapshot) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 0.1,
                    child: Stack(
                      children: [
                        Row(
                          children: [
                            Container(
                              constraints: BoxConstraints(
                                  maxHeight:
                                      MediaQuery.of(context).size.height * 0.1,
                                  maxWidth:
                                      MediaQuery.of(context).size.width * 0.9),
                              decoration: BoxDecoration(
                                  color: Provider.of<Authentication>(context,
                                                  listen: false)
                                              .getUserid ==
                                          documentSnapshot['useruid']
                                      ? Colors.amber.withOpacity(0.2)
                                      : Colors.amber,
                                  borderRadius: BorderRadius.circular(8)),
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 8.0, right: 8.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: 120.0,
                                      child: Row(
                                        children: [
                                          Text(
                                            documentSnapshot['username']
                                                .toString(),
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16),
                                          )
                                        ],
                                      ),
                                    ),
                                    Text(
                                      '  ->  ' +
                                          documentSnapshot['message']
                                              .toString(),
                                      style: TextStyle(
                                          color: Colors.white.withOpacity(0.5),
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16),
                                    )
                                  ],
                                ),
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                );
              }).toList(),
            );
          }
        });
  }

  sendMessage(BuildContext context, DocumentSnapshot documentSnapshot,
      TextEditingController messageControler) {
    return FirebaseFirestore.instance
        .collection('chatrooms')
        .doc(documentSnapshot.id)
        .collection('messages')
        .add({
      'message': messageControler.text,
      'time': Timestamp.now(),
      'useruid': Provider.of<Authentication>(context, listen: false).getUserid,
      'username':
          Provider.of<InitializeUser>(context, listen: false).getInitUserName,
      'userimage':
          Provider.of<InitializeUser>(context, listen: false).getInitUserImage,
    }).whenComplete(() => messageControler.clear());
  }

  leaveGroupChat(BuildContext context, String chatRoomName) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('leave $chatRoomName'),
            actions: [
              MaterialButton(
                child: Text('no'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              MaterialButton(
                child: Text('yes'),
                onPressed: () {
                  FirebaseFirestore.instance
                      .collection('chatrooms')
                      .doc(chatRoomName)
                      .collection('members')
                      .doc(Provider.of<Authentication>(context, listen: false)
                          .getUserid)
                      .delete()
                      .whenComplete(() {
                    AppRouter.push(
                      ChatsScreen(),
                    );
                  });
                },
              ),
            ],
          );
        });
  }
}
