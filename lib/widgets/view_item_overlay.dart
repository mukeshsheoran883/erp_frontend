
import 'package:invently/utils/globals.dart';
import 'package:invently/utils/theme/colors/colors.dart';
import 'package:flutter/material.dart';

Future<void> showRightMenu(Widget widget) async {
  await showDialog(
    context: Globals.context(),
    barrierColor: Colors.black12,
    builder: (context) {
      return _AnimationWidget(child: widget);
    },
  );
}

class _AnimationWidget extends StatefulWidget {
  final Widget child;

  const _AnimationWidget({required this.child});

  @override
  State<_AnimationWidget> createState() => _AnimationWidgetState();
}

class _AnimationWidgetState extends State<_AnimationWidget> {
  Offset offset = const Offset(1, 0);

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((s) {
      offset = const Offset(0, 0);
      if (mounted) setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSlide(
      offset: offset,
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOut,
      child: Dialog(
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.zero)),
        insetPadding: EdgeInsets.zero,
        alignment: Alignment.centerRight,
        shadowColor: Colors.transparent,
        backgroundColor: Tm.color(Tc.comCardBg),
        child: widget.child,
      ),
    );
  }
}
