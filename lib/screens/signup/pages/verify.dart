import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:senior_design_project/constants(config)/app_router.dart';
import 'package:senior_design_project/screens/pageview.dart';

class VerifyScreen extends StatefulWidget {
  @override
  _VerifyScreenState createState() => _VerifyScreenState();
}

class _VerifyScreenState extends State<VerifyScreen> {
  late final GlobalKey<NavigatorState> navigatorKey;

  final auth = FirebaseAuth.instance;
  late User user;
  late Timer timer;

  @override
  void initState() {
    user = auth.currentUser!;
    user.sendEmailVerification();

    timer = Timer.periodic(Duration(seconds: 5), (timer) {
      checkEmailVerified();
    });
    super.initState();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'An email has been sent to ${user.email} please verify',
            textAlign: TextAlign.center,
          ),
          CircularProgressIndicator(),
          Text(
            'When you confirm via e-mail, the login will be opened.',
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }

  Future<void> checkEmailVerified() async {
    user = auth.currentUser!;
    await user.reload();
    if (user.emailVerified) {
      timer.cancel();
      AppRouter.push(AppPageView());

      // navigatorKey.currentState!.pushNamed('feed');
      // Navigator.pushNamed(context, 'feed');
    }
  }
}
