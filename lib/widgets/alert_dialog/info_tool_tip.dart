
import 'package:invently/assortment/extensions/context_extensions.dart';
import 'package:invently/assortment/utils/custom_timer.dart';
import 'package:invently/assortment/utils/message_time_calculator.dart';
import 'package:invently/assortment/widgets/button/hover_button_base.dart';
import 'package:invently/assortment/widgets/button/hover_gesture_detector.dart';
import 'package:invently/assortment/widgets/svg_image.dart';
import 'package:invently/gen/assets.gen.dart';
import 'package:invently/utils/theme/colors/colors.dart';
import 'package:invently/utils/theme/text_style/text_styles.dart';
import 'package:invently/widgets/alert_dialog/popup_menu/show_custom_tooltip.dart';
import 'package:flutter/material.dart';

class InfoToolTip extends StatefulWidget {
  final Widget? icon;
  final Color? iconColor;
  final String message;
  final bool showOnHover;
  final double? maxWidth;
  final double iconWidth;
  final bool autoClose;
  final Alignment? direction;
  final bool focusable;

  const InfoToolTip({
    super.key,
    this.icon,
    this.iconColor,
    required this.message,
    this.showOnHover = false,
    this.maxWidth,
    this.autoClose = false,
    this.focusable = false,
    this.direction,
    this.iconWidth = 24,
  });

  @override
  State<InfoToolTip> createState() => _InfoToolTipState();
}

class _InfoToolTipState extends State<InfoToolTip> {
  CustomTimer timer = CustomTimer(const Duration(seconds: 1));
  late CustomTimer closeTimer;

  bool isShowing = false;

  @override
  void initState() {
    closeTimer = CustomTimer(calculateMessageDuration(widget.message));

    timer.reset();
    closeTimer.reset();
    closeTimer.onTimeout((a) => closeTooltip());

    timer.onTimeout((a) {
      if (p != null && widget.message.trim().isNotEmpty) {
        _onTap(p!);
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    timer.cancel();
    closeTimer.cancel();
    closeTooltip();
    super.dispose();
  }

  void _startTimer() {
    if (timer.isActive) return;
    timer.start();
  }

  ToolTipParams? p;
  Function()? closeFun;

  @override
  Widget build(BuildContext context) {
    return Focus(
      canRequestFocus: widget.focusable,
      descendantsAreFocusable: widget.focusable,
      child: CustomToolTipButton(
        buttonBuilder: (params) {
          p = params;
          return Container(
            width: widget.iconWidth,
            height: widget.iconWidth,
            alignment: Alignment.center,
            child: HoverGD(
              onTap: widget.message.trim().isNotEmpty ? () => _onTap(params) : null,
              builder: (context, bState) {
                if (widget.showOnHover) {
                  if (bState.isHovering) {
                    _startTimer();
                  } else {
                    timer.reset();
                  }
                }
                return SvgImage(
                  Assets.icons.info,
                  width: widget.iconWidth,
                  height: widget.iconWidth,
                  color: widget.iconColor ??
                      (bState.isHovering
                          ? Tm.colorSeparate(PC.colorYellow500, PC.colorYellow700)
                          : Tm.color(Tc.ipfHint)),
                );
              },
            ),
          );
        },
      ),
    );
  }

  void _onTap(ToolTipParams params) async {
    if (isShowing) return;
    isShowing = true;

    showCustomToolTip(
      alignment: widget.direction ?? Alignment.topRight,
      onClose: () {
        isShowing = false;
        closeFun = null;
      },
      childBuilder: (c, finalAlignment) {
        closeFun = c;
        return Padding(
          padding: _getPadding(finalAlignment),
          child: CustomPaint(
            painter: _ArrowTooltipPainter(
              arrowAlign: finalAlignment,
              decoration: BoxDecoration(
                color: Tm.color(Tc.comCardBg),
                borderRadius: const BorderRadius.all(Radius.circular(12)),
                border: Border.all(color: Tm.color(Tc.tableDivider), width: 2),
              ),
            ),
            child: Container(
              constraints: BoxConstraints(maxWidth: widget.maxWidth ?? context.percentHeight * 35, minWidth: 120),
              child: Padding(
                padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16, top: 12),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [Flexible(child: Text(widget.message, style: Ts.rgLight()))],
                ),
              ),
            ),
          ),
        );
      },
      params: params,
    );

    if (widget.autoClose) {
      closeTimer.reset();
      closeTimer.start();
    }
  }

  void closeTooltip() {
    closeFun?.call();
    closeFun = null;
    isShowing = false;
    closeTimer.reset();
  }

  EdgeInsets _getPadding(Alignment alignment) {
    if (alignment == Alignment.topLeft || alignment == Alignment.topCenter || alignment == Alignment.topRight) {
      return const EdgeInsets.only(bottom: 12);
    }
    if (alignment == Alignment.centerRight) {
      return const EdgeInsets.only(left: 12);
    }
    if (alignment == Alignment.centerLeft) {
      return const EdgeInsets.only(right: 12);
    }
    if (alignment == Alignment.bottomLeft ||
        alignment == Alignment.bottomCenter ||
        alignment == Alignment.bottomRight) {
      return const EdgeInsets.only(top: 12);
    }

    return EdgeInsets.zero;
  }
}

class _ArrowTooltipPainter extends CustomPainter {
  final Alignment arrowAlign;
  final BoxDecoration decoration;
  final Size arrow = const Size(12, 12);

  _ArrowTooltipPainter({required this.decoration, required this.arrowAlign});

  @override
  void paint(Canvas canvas, Size size) {
    final borderPaint = Paint()
      ..color = decoration.border?.top.color ?? Colors.transparent
      ..strokeWidth = (decoration.border?.top.width ?? 0)
      ..style = PaintingStyle.stroke;

    final fillPaint = Paint()
      ..color = decoration.color ?? Colors.transparent
      ..style = PaintingStyle.fill;

    final path = Path();

    double radius = decoration.borderRadius?.resolve(TextDirection.ltr).topRight.x ?? 0;

    Offset leftTop = const Offset(0, 0);
    Offset leftBottom = Offset(0, size.height);
    Offset rightTop = Offset(size.width, 0);
    Offset rightBottom = Offset(size.width, size.height);

    void drawLeftSide({Offset? end}) => path.lineTo(end?.dx ?? leftBottom.dx, end?.dy ?? (leftBottom.dy - radius));
    void drawBottomSide({Offset? end}) => path.lineTo(end?.dx ?? (rightBottom.dx - radius), end?.dy ?? rightBottom.dy);
    void drawRightSide({Offset? end}) => path.lineTo(end?.dx ?? rightTop.dx, end?.dy ?? (rightTop.dy + radius));
    void drawTopSide({Offset? end}) => path.lineTo(end?.dx ?? (leftTop.dx + radius), end?.dy ?? leftTop.dy);
    void drawBottomLeftCorner() =>
        path.quadraticBezierTo(leftBottom.dx, leftBottom.dy, leftBottom.dx + radius, leftBottom.dy);
    void drawBottomRightCorner() =>
        path.quadraticBezierTo(rightBottom.dx, rightBottom.dy, rightBottom.dx, rightBottom.dy - radius);
    void drawTopRightCorner() => path.quadraticBezierTo(rightTop.dx, rightTop.dy, rightTop.dx - radius, rightTop.dy);
    void drawTopLeftCorner() => path.quadraticBezierTo(leftTop.dx, leftTop.dy, leftTop.dx, leftTop.dy + radius);

    path.moveTo(leftTop.dx, (leftTop.dy + radius));

    switch (arrowAlign) {
      case Alignment.topCenter:
        final arrowStart = Offset(leftBottom.dx + size.width / 2 - arrow.width / 2, leftBottom.dy);
        final arrowEnd = Offset(leftBottom.dx + size.width / 2 + arrow.width / 2, leftBottom.dy);

        drawLeftSide();
        drawBottomLeftCorner();
        drawBottomSide(end: arrowStart);
        path.lineTo(arrowStart.dx + arrow.width / 2, arrowStart.dy + arrow.height);
        path.lineTo(arrowEnd.dx, arrowEnd.dy);
        drawBottomSide();
        drawBottomRightCorner();
        drawRightSide();
        drawTopRightCorner();
        drawTopSide();
        drawTopSide();
        drawTopLeftCorner();
        break;

      case Alignment.topRight:
        final arrowStart = Offset(leftBottom.dx + radius, leftBottom.dy);
        final arrowEnd = Offset(leftBottom.dx + arrow.width + radius, size.height);

        drawLeftSide();
        drawBottomLeftCorner();
        path.lineTo(arrowStart.dx + arrow.width / 2, size.height + arrow.height);
        path.lineTo(arrowEnd.dx, arrowEnd.dy);
        drawBottomSide();
        drawBottomRightCorner();
        drawRightSide();
        drawTopRightCorner();
        drawTopSide();
        drawTopLeftCorner();

        break;

      case Alignment.centerRight:
        final arrowStart = Offset(leftTop.dx, size.height / 2 - arrow.width / 2);
        final arrowEnd = Offset(leftTop.dx, size.height / 2 + arrow.width / 2);

        drawLeftSide(end: arrowStart);
        path.lineTo(arrowStart.dx - arrow.height, size.height / 2);
        path.lineTo(arrowEnd.dx, arrowEnd.dy);
        drawLeftSide();
        drawBottomLeftCorner();
        drawBottomSide();
        drawBottomRightCorner();
        drawRightSide();
        drawTopRightCorner();
        drawTopSide();
        drawTopLeftCorner();

        break;

      case Alignment.bottomRight:
        final arrowStart = Offset(leftTop.dx + radius + arrow.width, leftTop.dy);
        final arrowEnd = Offset(leftTop.dx + radius, leftTop.dy);

        drawLeftSide();
        drawBottomLeftCorner();
        drawBottomSide();
        drawBottomRightCorner();
        drawRightSide();
        drawTopRightCorner();
        drawTopSide(end: arrowStart);
        path.lineTo(arrowStart.dx - arrow.width / 2, -arrow.height);
        path.lineTo(arrowEnd.dx, arrowEnd.dy);
        drawTopLeftCorner();

        break;

      case Alignment.bottomCenter:
        final arrowStart = Offset(size.width / 2 + arrow.width / 2, leftTop.dy);
        final arrowEnd = Offset(size.width / 2 - arrow.width / 2, leftTop.dy);

        drawLeftSide();
        drawBottomLeftCorner();
        drawBottomSide();
        drawBottomRightCorner();
        drawRightSide();
        drawTopRightCorner();
        drawTopSide(end: arrowStart);
        path.lineTo(size.width / 2, -arrow.height);
        path.lineTo(arrowEnd.dx, arrowEnd.dy);
        drawTopSide();
        drawTopLeftCorner();

        break;

      case Alignment.bottomLeft:
        final arrowStart = Offset(rightTop.dx - radius, rightTop.dy);
        final arrowEnd = Offset(rightTop.dx - radius - arrow.width, rightTop.dy);

        drawLeftSide();
        drawBottomLeftCorner();
        drawBottomSide();
        drawBottomRightCorner();
        drawRightSide();
        drawTopRightCorner();
        path.lineTo(arrowStart.dx - arrow.width / 2, -arrow.height);
        path.lineTo(arrowEnd.dx, arrowEnd.dy);
        drawTopSide();
        drawTopLeftCorner();

        break;

      case Alignment.centerLeft:
        final arrowStart = Offset(rightBottom.dx, rightBottom.dy / 2 + arrow.width / 2);
        final arrowEnd = Offset(rightBottom.dx, rightBottom.dy / 2 - arrow.width / 2);

        drawLeftSide();
        drawBottomLeftCorner();
        drawBottomSide();
        drawBottomRightCorner();
        drawRightSide(end: arrowStart);
        path.lineTo(arrowStart.dx + arrow.height, arrowStart.dy - arrow.width / 2);
        path.lineTo(arrowEnd.dx, arrowEnd.dy);
        drawRightSide();
        drawTopRightCorner();
        drawTopSide();
        drawTopLeftCorner();

        break;

      case Alignment.topLeft:
        final arrowStart = Offset(rightBottom.dx - radius - arrow.width, rightBottom.dy);

        drawLeftSide();
        drawBottomLeftCorner();
        drawBottomSide(end: arrowStart);
        path.lineTo(arrowStart.dx + arrow.width / 2, arrowStart.dy + arrow.height);
        path.lineTo(arrowStart.dx + arrow.width, arrowStart.dy);
        drawBottomRightCorner();
        drawRightSide();
        drawTopRightCorner();
        drawTopSide();
        drawTopLeftCorner();

        break;

      case Alignment.center:
        drawLeftSide();
        drawBottomLeftCorner();
        drawBottomSide();
        drawBottomRightCorner();
        drawRightSide();
        drawTopRightCorner();
        drawTopSide();
        drawTopLeftCorner();

        break;
    }

    path.close();

    canvas.drawPath(path, fillPaint);
    if (decoration.border != null) canvas.drawPath(path, borderPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
