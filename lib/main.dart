import 'package:flutter/material.dart';
import 'package:senior_design_project/constants(config)/text_constant.dart';
import 'package:senior_design_project/screens/signup/pages/login.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Akdeniz Social',
      theme: ThemeData(
        primarySwatch: Colors.brown,
        scaffoldBackgroundColor: Colors.black45,
        textTheme: textThemeOrnek,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            onPrimary: Colors.white,
          ),
        ),
      ),
      home: const LoginPage(),
    );
  }
}
