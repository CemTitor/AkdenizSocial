import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:senior_design_project/constants(config)/color_constant.dart';
import 'package:senior_design_project/constants(config)/context_extension.dart';
import 'package:senior_design_project/screens/messages/private_chat_service.dart';
import 'package:senior_design_project/services/auth.dart';
import 'package:senior_design_project/services/firebase.dart';

import 'others/message.dart';
import 'others/model/chat_message.dart';

final _firestore = FirebaseFirestore.instance;

class PrivateChat extends StatelessWidget {
  PrivateChat({Key? key, required this.documentSnapshot}) : super(key: key);
  final _auth = FirebaseAuth.instance;

  final messageControler = TextEditingController();

  final DocumentSnapshot documentSnapshot;

  String? messageText;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            BackButton(),
            CircleAvatar(
              backgroundImage: NetworkImage(
                Provider.of<FirebaseOpertrations>(
                      context,
                      listen: false,
                    ).getInitUserImage ??
                    "https://www.solidbackgrounds.com/images/950x350/950x350-white-solid-color-background.jpg",
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Cem Yılmaz",
                  style: TextStyle(fontSize: 16),
                ),
                Text(
                  "Active 3m ago",
                  style: TextStyle(fontSize: 12),
                )
              ],
            )
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.local_phone),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.videocam),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(child: MessagesPart(context)),
          MessageBottomPart(context),
        ],
      ),
    );
  }

  AnimatedContainer MessagesPart(BuildContext context) {
    return AnimatedContainer(
      color: Colors.white,
      duration: const Duration(seconds: 5),
      curve: Curves.bounceOut,
      height: context.dynamicHeight(0.5),
      width: context.dynamicWidth(1),
      child: StreamBuilder<QuerySnapshot>(
        stream: _firestore
            .collection('chatrooms')
            .doc(documentSnapshot.id)
            .collection('messages')
            .orderBy('time')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else {
            return MessageList(snapshot, context);
          }
        },
      ),
    );
  }

  Padding MessageList(
      AsyncSnapshot<QuerySnapshot<Object?>> snapshot, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
      child: ListView(
        children: snapshot.data!.docs.map((DocumentSnapshot documentSnapshot) {
          return Message(
            message: ChatMessage(
              text: documentSnapshot['message'].toString(),
              messageType: ChatMessageType.text,
              messageStatus: MessageStatus.viewed,
              isSender: Provider.of<Authentication>(context, listen: false)
                      .getUserid ==
                  documentSnapshot['useruid'],
            ),
          );
        }).toList(),
      ),
    );
  }

  Container MessageBottomPart(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: kDefaultPadding,
        vertical: kDefaultPadding / 2,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            offset: Offset(0, 4),
            blurRadius: 32,
            color: Color(0xFF087949).withOpacity(0.08),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Icon(Icons.mic, color: aPrimaryColor),
            SizedBox(width: kDefaultPadding),
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: kDefaultPadding * 0.75,
                ),
                decoration: BoxDecoration(
                  color: kPrimaryColor.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(40),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.sentiment_satisfied_alt_outlined,
                      color: Theme.of(context)
                          .textTheme
                          .bodyText1!
                          .color!
                          .withOpacity(0.64),
                    ),
                    SizedBox(width: kDefaultPadding / 4),
                    Expanded(
                      child: TextField(
                        controller: messageControler,
                        onChanged: (value) {
                          messageText = value;
                        },
                        decoration: InputDecoration(
                          hintText: "Type message",
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    Icon(
                      Icons.attach_file,
                      color: Theme.of(context)
                          .textTheme
                          .bodyText1!
                          .color!
                          .withOpacity(0.64),
                    ),
                    SizedBox(width: kDefaultPadding / 4),
                    IconButton(
                      onPressed: () {
                        if (messageControler.text.isNotEmpty) {
                          Provider.of<PrivateChatServices>(context,
                                  listen: false)
                              .sendMessage(
                                  context, documentSnapshot, messageControler);
                        }
                      },
                      icon: Icon(Icons.send),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
