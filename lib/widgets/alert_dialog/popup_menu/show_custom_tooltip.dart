
import 'package:invently/assortment/extensions/key_extensions.dart';
import 'package:invently/ui/splash/widgets/responsive_framework_builder.dart';
import 'package:invently/utils/globals.dart';
import 'package:flutter/material.dart';

class ToolTipParams {
  LayerLink link;
  Offset buttonPosition;
  Size buttonSize;

  ToolTipParams({required this.link, required this.buttonSize, required this.buttonPosition});
}

class CustomToolTipButton extends StatefulWidget {
  final Widget Function(ToolTipParams) buttonBuilder;

  const CustomToolTipButton({super.key, required this.buttonBuilder});

  @override
  State<CustomToolTipButton> createState() => _CustomToolTipButtonState();
}

class _CustomToolTipButtonState extends State<CustomToolTipButton> {
  LayerLink link = LayerLink();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((a) {
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: link,
      child: widget.buttonBuilder(
        ToolTipParams(link: link, buttonPosition: _getPosition(context), buttonSize: _getSize(context)),
      ),
    );
  }

  Offset _getPosition(BuildContext context) {
    if (!mounted) return Offset.zero;
    final RenderBox? renderBox = context.findRenderObject() as RenderBox?;
    if (renderBox == null) return Offset.zero;
    return renderBox.localToGlobal(Offset.zero);
  }

  Size _getSize(BuildContext context) {
    if (!mounted) return const Size(0, 0);
    final RenderBox? renderBox = context.findRenderObject() as RenderBox?;
    if (renderBox == null) return const Size(0, 0);
    return renderBox.size;
  }
}

Future<void> showCustomToolTip({
  required Widget Function(Function() close, Alignment finalizedAlignment) childBuilder,
  required ToolTipParams params,
  required Function() onClose,
  Color barrierColor = Colors.transparent,
  Size? childSize,
  Alignment alignment = Alignment.topRight,
  Offset? childPosition,
}) async {
  OverlayEntry? entry;
  BuildContext context = Globals.context();

  void close() {
    try {
      entry?.remove();
      entry?.dispose();
    } catch (_) {}
    onClose();
  }

  final Size screenSize = MediaQuery.of(context).size;

  if (childPosition != null && childSize != null) {
    final canFitIn = _checkCanFitIt(alignment, childSize, params.buttonPosition, params.buttonSize, screenSize);

    if (!canFitIn) {
      List<Alignment> items = [
        Alignment.topLeft,
        Alignment.bottomLeft,
        Alignment.topRight,
        Alignment.bottomRight,
        Alignment.centerLeft,
        Alignment.centerRight,
        Alignment.topCenter,
        Alignment.bottomCenter,
        Alignment.center,
      ];

      for (final i in items) {
        final isOk = _checkCanFitIt(i, childSize, params.buttonPosition, params.buttonSize, screenSize);
        if (isOk) {
          alignment = i;
          break;
        }
      }
    }
  }

  final off = _getOffset(alignment, params.buttonSize, childSize ?? Size.zero);

  entry = OverlayEntry(
    builder: (context) {
      return ResponsiveFrameworkBuilder(
        child: DefaultTextStyle(
          style: const TextStyle(),
          child: Stack(
            children: [
              Container(
                color: (childSize == null || childPosition == null) ? null : barrierColor,
                child: GestureDetector(onTap: close),
              ),
              Positioned(
                child: CompositedTransformFollower(
                  link: params.link,
                  followerAnchor: Alignment.center,
                  offset: off,
                  showWhenUnlinked: false,
                  child: _Child(
                    sizeCalculated: childSize != null,
                    onDispose: close,
                    onSizeGot: (size, pos) {
                      close();
                      if (size == null || pos == null) return;

                      showCustomToolTip(
                        childBuilder: childBuilder,
                        params: params,
                        childSize: size,
                        childPosition: pos,
                        barrierColor: barrierColor,
                        alignment: alignment,
                        onClose: onClose,
                      );
                    },
                    child: childBuilder(close, alignment),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );

  Overlay.of(context).insert(entry);
}

bool _checkCanFitIt(Alignment userPos, Size cSize, Offset bPos, Size bSize, Size sSize) {
  bool canWidth = false;
  bool canHeight = false;
  if (userPos == Alignment.topRight) {
    canWidth = bPos.dx + cSize.width < sSize.width;
    canHeight = bPos.dy - cSize.height > 0;
  } else if (userPos == Alignment.centerRight) {
    canWidth = bPos.dx + bSize.width + cSize.width < sSize.width;
    canHeight = bPos.dy + bSize.height / 2 - cSize.height / 2 > 0 &&
        bPos.dy + bSize.height / 2 + cSize.height / 2 < sSize.height;
  } else if (userPos == Alignment.bottomRight) {
    canWidth = bPos.dx + cSize.width < sSize.width;
    canHeight = bPos.dy + bSize.height + cSize.height < sSize.height;
  } else if (userPos == Alignment.bottomCenter) {
    canWidth = ((bPos.dx + bSize.width / 2) + cSize.width / 2 < sSize.width) &&
        (bPos.dx + bSize.width / 2 - cSize.width / 2 > 0);
    canHeight = bPos.dy + bSize.height + cSize.height < sSize.height;
  } else if (userPos == Alignment.bottomLeft) {
    canWidth = (bPos.dx + bSize.width) - cSize.width > 0;
    canHeight = bPos.dy + bSize.height + cSize.height < sSize.height;
  } else if (userPos == Alignment.centerLeft) {
    canWidth = bPos.dx - cSize.width > 0;
    canHeight = bPos.dy + bSize.height / 2 - cSize.height / 2 > 0 &&
        bPos.dy + bSize.height / 2 + cSize.height / 2 < sSize.height;
  } else if (userPos == Alignment.topLeft) {
    canWidth = (bPos.dx + bSize.width) - cSize.width > 0;
    canHeight = bPos.dy - cSize.height > 0;
  } else if (userPos == Alignment.topCenter) {
    canWidth = ((bPos.dx + bSize.width / 2) + cSize.width / 2 < sSize.width) &&
        (bPos.dx + bSize.width / 2 - cSize.width / 2 > 0);
    canHeight = bPos.dy - cSize.height > 0;
  } else if (userPos == Alignment.center) {
    canWidth = ((bPos.dx + bSize.width / 2) + cSize.width / 2 < sSize.width) &&
        (bPos.dx + bSize.width / 2 - cSize.width / 2 > 0);

    canHeight = bPos.dy + bSize.height / 2 - cSize.height / 2 > 0 &&
        bPos.dy + bSize.height / 2 + cSize.height / 2 < sSize.height;
  }

  return canWidth && canHeight;
}

Offset _getOffset(Alignment position, Size pSize, Size cSize) {
  Offset center = Offset(pSize.width / 2, pSize.height / 2);
  double getTop() => center.dy - cSize.height / 2 - pSize.height / 2;
  double getBottom() => center.dy + cSize.height / 2 + pSize.height / 2;
  double getRight() => center.dx + cSize.width / 2 - pSize.width / 2;
  double getLeft() => center.dx - cSize.width / 2 + pSize.width / 2;

  switch (position) {
    case Alignment.center:
      return center;
    case Alignment.topRight:
      return Offset(getRight(), getTop());
    case Alignment.centerRight:
      return Offset(getRight() + pSize.width, center.dy);
    case Alignment.bottomRight:
      return Offset(getRight(), getBottom());
    case Alignment.bottomCenter:
      return Offset(center.dx, getBottom());
    case Alignment.bottomLeft:
      return Offset(getLeft(), getBottom());
    case Alignment.centerLeft:
      return Offset(getLeft() - pSize.width, center.dy);
    case Alignment.topLeft:
      return Offset(getLeft(), getTop());
    case Alignment.topCenter:
      return Offset(center.dx, getTop());
  }

  return center;
}

class _Child extends StatefulWidget {
  final Widget child;
  final Function(Size?, Offset?) onSizeGot;
  final Function() onDispose;
  final bool sizeCalculated;

  const _Child({required this.child, required this.onSizeGot, required this.sizeCalculated, required this.onDispose});

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

  @override
  void dispose() {
    widget.onDispose();
    super.dispose();
  }

  void _calculatePosition() {
    if (widget.sizeCalculated) return;
    final position = gKey.getWidgetGlobalPosition();
    final size = gKey.getWidgetSize();
    widget.onSizeGot(size, position);
  }

  @override
  Widget build(BuildContext context) {
    return Offstage(offstage: !widget.sizeCalculated, child: SizedBox(key: gKey, child: widget.child));
  }
}
