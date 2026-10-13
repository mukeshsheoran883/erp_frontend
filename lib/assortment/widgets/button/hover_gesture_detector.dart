import 'package:invently/assortment/widgets/custom_tooltip.dart';
import 'package:invently/utils/theme/colors/colors.dart';
import 'package:flutter/material.dart';


import 'hover_button_base.dart';

class HoverGD extends StatefulWidget {
  final Function()? onTap;
  final Function()? onLongTap;
  final Future<void> Function()? onLongTapping;
  final Function()? onHover;
  final Widget Function(BuildContext context, Set<ButtonStates> state)? builder;
  final Widget? child;
  final Color? hoverColor;
  final Color? clickColor;
  final bool clickCursor;
  final BorderRadiusGeometry? borderRadius;
  final BoxShape shape;
  final String? tooltip;
  final Duration longPressDuration;
  final FocusNode? focusNode;
  const HoverGD({
    super.key,
    required this.onTap,
    this.onLongTap,
    this.onLongTapping,
    this.child,
    this.onHover,
    this.hoverColor,
    this.clickColor,
    this.borderRadius,
    this.builder,
    this.tooltip,
    this.shape = BoxShape.rectangle,
    this.clickCursor = true,
    this.longPressDuration = const Duration(milliseconds: 50),
    this.focusNode,
  });

  @override
  State<HoverGD> createState() => _HoverGDState();
}

class _HoverGDState extends State<HoverGD> {
  bool pressing = false;
  bool hovering = false;

  Future<void> _longPressing() async {
    while (pressing) {
      await widget.onLongTapping?.call();
      await Future.delayed(widget.longPressDuration);
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomTooltip(
      message: widget.tooltip ?? '',
      child: HoverButton(
        onPressed: widget.onTap,
        onLongPress: widget.onLongTap,
        onLongPressStart: () => {pressing = true, _longPressing()},
        onLongPressEnd: () => pressing = false,
        focusNode: widget.focusNode,
        builder: (context, state) {
          widget.onHover?.call();
          return widget.builder != null
              ? widget.builder!(context, state)
              : Container(
                  foregroundDecoration: BoxDecoration(
                    borderRadius: widget.borderRadius,
                    shape: widget.shape,
                    color: widget.onTap == null
                        ? null
                        : state.isPressing
                            ? widget.clickColor ?? Tm.color(Tc.hoverClickColor)
                            : state.isHovering
                                ? widget.hoverColor ?? Tm.color(Tc.hoverColor)
                                : Colors.transparent,
                  ),
                  child: widget.child,
                );
        },
        cursor: widget.clickCursor && widget.onTap != null ? SystemMouseCursors.click : null,
      ),
    );
  }
}
