
import 'package:flutter/services.dart';

extension KeyEventExtension on KeyEvent {
  bool isPressed() => runtimeType == KeyDownEvent;
  bool isPressedKey(LogicalKeyboardKey key) => isPressed() && logicalKey == key;
  bool isPressedEnter() => isPressed() && logicalKey == LogicalKeyboardKey.enter;
  bool isPressedEsc() => isPressed() && logicalKey == LogicalKeyboardKey.escape;
}
