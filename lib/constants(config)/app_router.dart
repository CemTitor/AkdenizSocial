import 'package:flutter/material.dart';

///Class for navigating between pages.
class AppRouter {
  static final navigatorKey = GlobalKey<NavigatorState>();

  static Future? push(Widget page) => navigatorKey.currentState?.push(
        MaterialPageRoute(builder: (_) => page),
      );
}
