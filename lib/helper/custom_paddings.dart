import 'package:flutter/material.dart';

class CustomPaddings {
  static Widget horizontalPadding(double padding) {
    return SizedBox(
      width: padding,
    );
  }

  static Widget verticalPadding(double padding) {
    return SizedBox(
      height: padding,
    );
  }
}
