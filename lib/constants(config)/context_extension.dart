import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

extension ContextExtension on BuildContext {
  // when used,context.dynamicWidth(0.2),
  double dynamicWidth(double val) => MediaQuery.of(this).size.width * val;
  double dynamicHeight(double val) => MediaQuery.of(this).size.height * val;

  ThemeData get theme => Theme.of(this);
}

// when used, context.lowValue
extension NumberExtension on BuildContext {
  double get value1 => dynamicHeight(0.01);
  double get value2 => dynamicHeight(0.02);
  double get value3 => dynamicHeight(0.03);
}

extension PaddingExtension on BuildContext {
  EdgeInsets get paddingAllow => EdgeInsets.all(value2);
}
