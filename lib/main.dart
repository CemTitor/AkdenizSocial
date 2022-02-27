import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:senior_design_project/screens/chat/chats_services.dart';
import 'package:senior_design_project/screens/messages/private_chat_service.dart';
import 'package:senior_design_project/screens/feed/feed_view.dart';
import 'package:senior_design_project/screens/feed/feed_service.dart';
import 'package:senior_design_project/screens/pageview.dart';
import 'package:senior_design_project/screens/signup/pages/login.dart';
import 'package:senior_design_project/screens/signup/pages/signup.dart';
import 'package:senior_design_project/screens/signup/pages/verify.dart';
import 'package:senior_design_project/screens/welcome/welcome.dart';
import 'package:senior_design_project/services/auth.dart';
import 'package:senior_design_project/services/firebase.dart';
import 'package:senior_design_project/services/upload_post_firebase.dart';
import 'package:senior_design_project/screens/upload_post/counter_for_stepper.dart';
import 'package:senior_design_project/theme2.dart';

import 'constants(config)/app_router.dart';
import 'screens/my_profile/my_profile_services.dart';
import 'screens/signup/pages/signin.dart';
import 'screens/user_profile/user_profile_service.dart';

Future<void> main() async {
  //following tho method for firebase initiliazing
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SignUp()),
        ChangeNotifierProvider(create: (_) => SignIn()),
        ChangeNotifierProvider(create: (_) => Authentication()),
        ChangeNotifierProvider(create: (_) => FirebaseOpertrations()),
        ChangeNotifierProvider(create: (_) => UploadPost()),
        ChangeNotifierProvider(create: (_) => Counter()),
        ChangeNotifierProvider(create: (_) => FeedServices()),
        ChangeNotifierProvider(create: (_) => ProfileServices()),
        ChangeNotifierProvider(create: (_) => MyProfileServices()),
        ChangeNotifierProvider(create: (_) => ChatServices()),
        ChangeNotifierProvider(create: (_) => PrivateChatServices()),
      ],
      child: MaterialApp(
        navigatorKey: AppRouter.navigatorKey,
        debugShowCheckedModeBanner: false,
        title: 'Akdeniz Social',
        theme: lightThemeData(context),
        darkTheme: darkThemeData(context),
        // theme: ThemeData(
        //   primarySwatch: Colors.deepOrange,
        //   scaffoldBackgroundColor: kPrimaryColor,
        //   // textTheme: textThemeOrnek,
        //   elevatedButtonTheme: ElevatedButtonThemeData(
        //     style: ElevatedButton.styleFrom(
        //       onPrimary: Colors.white,
        //     ),
        //   ),
        // ),
        // home: HomeScreen(),
        initialRoute: 'welcome',

        routes: {
          'welcome': (context) => Welcome(),
          'login': (context) => const LoginPage(),
          'pageview': (context) => AppPageView(),
          'feed': (context) => FeedScreen(),
          'verify': (context) => VerifyScreen(),
        },
      ),
    );
  }
}
