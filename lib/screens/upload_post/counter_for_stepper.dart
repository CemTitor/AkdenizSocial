import 'package:flutter/material.dart';

class Counter extends ChangeNotifier {
  int _currentStep = 0;
  bool isCompleted = false;

  int get counter {
    return _currentStep;
  }

  set counter(int val) {
    _currentStep = val;
    notifyListeners();
  }

  void increaseCounter() {
    _currentStep++;
    notifyListeners();
    print(_currentStep);
  }

  void decreaseCounter() {
    _currentStep--;
    notifyListeners();
    print(_currentStep);
  }
}
