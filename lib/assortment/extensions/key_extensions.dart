
import 'package:flutter/cupertino.dart';

extension GlobalKeyExtensions on GlobalKey {
  Offset? getWidgetGlobalPosition() {
    if (currentContext == null) return null;
    final RenderBox? renderBox = currentContext!.findRenderObject() as RenderBox?;
    if (renderBox == null) return null;
    return renderBox.localToGlobal(Offset.zero);
  }

  Size? getWidgetSize() {
    if (currentContext == null) return null;
    final RenderBox? renderBox = currentContext!.findRenderObject() as RenderBox?;
    if (renderBox == null) return null;
    return renderBox.size;
  }
}
