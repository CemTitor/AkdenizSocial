import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:senior_design_project/screens/pageview.dart';
import 'package:senior_design_project/screens/signup/pages/login.dart';
import 'package:senior_design_project/screens/signup/pages/signup.dart';
import 'package:senior_design_project/screens/signup/pages/verify.dart';
import 'package:senior_design_project/screens/upload_post/upload_post_widget.dart';
import 'package:senior_design_project/screens/welcome/welcome.dart';
import 'package:senior_design_project/services/auth.dart';
import 'package:senior_design_project/services/firebase.dart';
import 'package:senior_design_project/services/upload_post_firebase.dart';
import 'package:senior_design_project/screens/upload_post/counter_for_stepper.dart';

import 'constants(config)/app_router.dart';
import 'screens/signup/pages/signin.dart';

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
      ],
      child: MaterialApp(
        navigatorKey: AppRouter.navigatorKey,

        debugShowCheckedModeBanner: false,

        title: 'Akdeniz Social',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          scaffoldBackgroundColor: Colors.white,
          // textTheme: textThemeOrnek,
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              onPrimary: Colors.white,
            ),
          ),
        ),
        // home: HomeScreen(),
        initialRoute: 'welcome',

        routes: {
          'welcome': (context) => Welcome(),
          'login': (context) => const LoginPage(),
          'feed2': (context) => Feed2(),
          'verify': (context) => VerifyScreen(),
        },
      ),
    );
  }
}
