import 'package:flutter/material.dart';

extension ContextExtensions on BuildContext {
  /// Screen Size
  MediaQueryData get mq => MediaQuery.of(this);
  double get statusBarHeight => mq.padding.top;
  double get screenWidth => mq.size.width;
  double get screenHeight => mq.size.height;
  double get screenRatio => screenHeight / screenWidth;
  double get percentWidth => screenWidth / 100;
  double get percentHeight => screenHeight / 100;
}
