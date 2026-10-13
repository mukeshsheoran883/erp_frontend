
import 'package:flutter/material.dart';

class CustomScrollBar extends StatelessWidget {
  final Widget child;
  final ScrollController controller;
  final Axis axis;

  const CustomScrollBar({
    required this.child,
    required this.controller,
    this.axis = Axis.vertical,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return RawScrollbar(
      controller: controller,
      thickness: 16,
      thumbVisibility: true,
      trackVisibility: true,
      child: ScrollConfiguration(behavior: const ScrollBehavior().copyWith(scrollbars: false), child: child),
    );
  }
}
