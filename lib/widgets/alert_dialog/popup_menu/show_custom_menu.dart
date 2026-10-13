
import 'package:invently/ui/splash/widgets/responsive_framework_builder.dart';
import 'package:invently/utils/globals.dart';
import 'package:invently/utils/theme/colors/colors.dart';
import 'package:invently/widgets/alert_dialog/popup_menu/show_app_menu.dart';
import 'package:flutter/material.dart';

Future<void> showCustomMenu({
  required Widget Function(Function() close) childBuilder,
  required AppMenuParams params,
  Color? barrierColor,
  Size? childSize,
}) async {
  OverlayEntry? entry;

  bool? showInLeft;
  bool? showInTop;
  BuildContext context = Globals.context();

  void close() {
    try {
      entry?.remove();
      entry?.dispose();
    } catch (_) {}
  }

  final double parentXPos = params.buttonPosition.dx;
  final double parentYPos = params.buttonPosition.dy;
  final double parentWidth = params.buttonSize.width;
  final double parentHeight = params.buttonSize.height;
  final double screenWidth = MediaQuery.of(context).size.width;
  final double screenHeight = MediaQuery.of(context).size.height;

  const int padding = 200;

  if ((parentXPos + parentWidth + (childSize?.width ?? 0) + padding) < screenWidth) {
    showInLeft = false;
  } else if ((parentXPos - (childSize?.width ?? 0) - padding) > 0) {
    showInLeft = true;
  }

  if ((parentYPos + (childSize?.height ?? 0) + padding) < screenHeight) {
    showInTop = false;
  } else if ((parentYPos - (childSize?.height ?? 0) - padding) > 0) {
    showInTop = true;
  }

  entry = OverlayEntry(
    builder: (context) {
      return PopScope(
        onPopInvokedWithResult: (a, b) {
          return;
        },
        child: ResponsiveFrameworkBuilder(
          child: DefaultTextStyle(
            style: const TextStyle(),
            child: Stack(
              children: [
                Container(
                  color: childSize == null
                      ? null
                      : barrierColor ??= Tm.isDarkTheme.value ? Colors.black26 : Colors.black12,
                  child: GestureDetector(onTap: close),
                ),
                Positioned(
                  child: CompositedTransformFollower(
                    link: params.link,
                    followerAnchor: Alignment.topLeft,
                    showWhenUnlinked: false,
                    offset: Offset(
                      showInLeft == null
                          ? 0
                          : showInLeft
                              ? -(childSize?.width ?? 0)
                              : parentWidth,
                      showInTop == null
                          ? 0
                          : showInTop
                              ? -((childSize?.height ?? 0) - parentHeight)
                              : 0,
                    ),
                    child: _Child(
                      sizeCalculated: childSize != null,
                      onSizeGot: (a) {
                        close();
                        if (a == null) return;
                        showCustomMenu(
                          childBuilder: childBuilder,
                          params: params,
                          childSize: a,
                          barrierColor: barrierColor,
                        );
                      },
                      child: childBuilder(close),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );

  Overlay.of(context).insert(entry);
}

class _Child extends StatefulWidget {
  final Widget child;
  final Function(Size?) onSizeGot;
  final bool sizeCalculated;

  const _Child({required this.child, required this.onSizeGot, required this.sizeCalculated});

  @override
  State<_Child> createState() => _ChildState();
}

class _ChildState extends State<_Child> {
  GlobalKey gKey = GlobalKey();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((a) => _calculatePosition());
    super.initState();
  }

  void _calculatePosition() {
    if (widget.sizeCalculated) return;
    final RenderBox? renderBox = gKey.currentContext?.findRenderObject() as RenderBox?;
    widget.onSizeGot(renderBox?.size);
  }

  @override
  Widget build(BuildContext context) {
    return Offstage(offstage: !widget.sizeCalculated, child: SizedBox(key: gKey, child: widget.child));
  }
}
