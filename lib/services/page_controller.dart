import 'package:flutter/material.dart';

class PageControllerClass extends ChangeNotifier {
  PageController pageController = PageController(
    initialPage: 1,
    keepPage: true,
  );
}
