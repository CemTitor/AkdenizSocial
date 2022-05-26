import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:senior_design_project/screens/chat/chats_services.dart';
import 'package:senior_design_project/screens/feed/post_services.dart';
import 'package:senior_design_project/screens/messages/private_chat_services.dart';
import 'package:senior_design_project/screens/feed/feed_view.dart';
import 'package:senior_design_project/screens/feed/feed_services.dart';
import 'package:senior_design_project/screens/my_profile/my_profile_view.dart';
import 'package:senior_design_project/screens/pageview.dart';
import 'package:senior_design_project/screens/search/search_services.dart';
import 'package:senior_design_project/screens/signup/pages/login.dart';
import 'package:senior_design_project/screens/signup/pages/signup.dart';
import 'package:senior_design_project/screens/signup/pages/verify.dart';
import 'package:senior_design_project/screens/welcome/welcome.dart';
import 'package:senior_design_project/screens/signup/auth_services.dart';
import 'package:senior_design_project/services/initialize.dart';
import 'package:senior_design_project/services/page_controller.dart';
import 'package:senior_design_project/screens/upload_post/upload_post_services.dart';
import 'package:senior_design_project/screens/upload_post/utils/counter_for_stepper.dart';
import 'package:senior_design_project/constants(config)/theme.dart';

import 'constants(config)/app_router.dart';
import 'screens/my_profile/my_profile_services.dart';
import 'screens/signup/pages/signin.dart';
import 'screens/user_profile/user_profile_services.dart';

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

        /// context(_) sayesinde diğer providerlarımda oluşan veya baska bir değeri de
        /// ordan alabilceğimi düşünüyorum.
        ChangeNotifierProvider(create: (_) => SignIn()),
        ChangeNotifierProvider(create: (_) => Authentication()),
        ChangeNotifierProvider(create: (_) => InitializeUser()),
        ChangeNotifierProvider(create: (_) => UploadPostServices()),
        ChangeNotifierProvider(create: (_) => Counter()),
        ChangeNotifierProvider(create: (_) => FeedServices()),
        ChangeNotifierProvider(create: (_) => ProfileServices()),
        ChangeNotifierProvider(create: (_) => MyProfileServices()),
        ChangeNotifierProvider(create: (_) => ChatServices()),
        ChangeNotifierProvider(create: (_) => PrivateChatServices()),
        ChangeNotifierProvider(create: (_) => SearchServices()),
        // Provider<SearchServices>(create: (context) => SearchServices()), //  denemek için
        ChangeNotifierProvider(create: (_) => PageControllerClass()),
        ChangeNotifierProvider(create: (_) => MyProfile()),
        ChangeNotifierProvider(create: (_) => PostServices()),
      ],
      child: MaterialApp(
        // showPerformanceOverlay: true, //run the application in profile mode
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

//TODO: notifications will be added
//TODO: one class max 200 line of code.
