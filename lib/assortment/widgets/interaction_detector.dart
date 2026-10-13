
import 'package:flutter/material.dart';

class InteractionDetector extends StatefulWidget {
  final Widget child;
  final Function() onInteraction;
  const InteractionDetector({super.key, required this.child, required this.onInteraction});

  @override
  State<InteractionDetector> createState() => _InteractionDetectorState();
}

class _InteractionDetectorState extends State<InteractionDetector> {
  late FocusNode focusNode;

  @override
  void initState() {
    focusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (a) => widget.onInteraction(),
      onPointerMove: (a) => widget.onInteraction(),
      onPointerUp: (a) => widget.onInteraction(),
      onPointerHover: (a) => widget.onInteraction(),
      behavior: HitTestBehavior.translucent,
      child: KeyboardListener(focusNode: focusNode, onKeyEvent: (a) => widget.onInteraction(), child: widget.child),
    );
  }
}
