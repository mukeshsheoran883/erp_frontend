import 'package:invently/assortment/extensions/text_formatters.dart';
import 'package:invently/assortment/widgets/button/hover_gesture_detector.dart';
import 'package:invently/assortment/widgets/svg_image.dart';
import 'package:invently/gen/assets.gen.dart';
import 'package:invently/utils/common_functions.dart';
import 'package:invently/utils/theme/colors/colors.dart';
import 'package:invently/utils/theme/text_style/text_styles.dart';
import 'package:flutter/material.dart';

class IncrementDecrementButton extends StatelessWidget {
  final double count;
  final Function(double) onTap;
  final String? error;
  final bool removeAllProps;
  final EdgeInsets errorPadding;

  const IncrementDecrementButton({
    super.key,
    required this.count,
    required this.onTap,
    this.error,
    this.removeAllProps = false,
    this.errorPadding = const EdgeInsets.only(bottom: 8),
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 184,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 48,
            decoration: BoxDecoration(
              color: Tm.color(Tc.secDefLight),
              borderRadius: const BorderRadius.all(Radius.circular(12)),
              border: Border.all(color: Tm.color(Tc.secFocLight)),
            ),
            child: Row(
              children: [
                _Button(
                  icon: Assets.icons.minus,
                  onTap: count <= 1
                      ? null
                      : () {
                          final newValue = double.parse((count - 1).toStringAsFixed(3));
                          if (newValue >= 0) {
                            onTap(newValue);
                          }
                        },
                ),
                Expanded(child: _PageNumberWidget(selectedCount: count, onCountChanged: onTap)),
                _Button(icon: Assets.icons.add, onTap: () => onTap(double.parse((count + 1).toStringAsFixed(3)))),
              ],
            ),
          ),
          if (!removeAllProps)
            Padding(
              padding: errorPadding,
              child: Text(error ?? '', style: Ts.rgSemiRegular(color: Tm.color(Tc.redDef))),
            ),
        ],
      ),
    );
  }
}

class _DecorationContainer extends StatelessWidget {
  final Widget child;
  final double? width;

  const _DecorationContainer({required this.child, this.width});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      decoration: BoxDecoration(
        color: Tm.color(Tc.comCardBg),
        borderRadius: const BorderRadius.all(Radius.circular(8)),
        border: Border.all(color: Tm.color(Tc.secFocLight), width: 2),
      ),
      child: child,
    );
  }
}

class _Button extends StatelessWidget {
  final String icon;
  final Function()? onTap;

  const _Button({required this.icon, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: HoverGD(
        onTap: onTap,
        onLongTapping: () async => onTap?.call(),
        borderRadius: const BorderRadius.all(Radius.circular(8)),
        child: SizedBox(
          height: 32,
          width: 32,
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: SvgImage(
              icon,
              width: 16,
              height: 16,
              color: Tm.color(onTap == null ? Tc.secIconLight : Tc.secIconLight),
            ),
          ),
        ),
      ),
    );
  }
}

class _PageNumberWidget extends StatefulWidget {
  final double selectedCount;
  final Function(double) onCountChanged;

  const _PageNumberWidget({required this.selectedCount, required this.onCountChanged});

  @override
  State<_PageNumberWidget> createState() => _PageNumberWidgetState();
}

class _PageNumberWidgetState extends State<_PageNumberWidget> {
  late TextEditingController controller;

  double _containerWidth = 28;
  double defaultWidth = 28;
  double calculatedWidth = 28;
  late FocusNode node;

  void _updateWidth() {
    final TextPainter textPainter = TextPainter(
      text: TextSpan(text: controller.text, style: Ts.rgRegular(color: Tm.color(Tc.ipfTxt))),
      maxLines: 1,
      textDirection: TextDirection.ltr,
    )..layout();

    if (textPainter.size.width > defaultWidth) {
      calculatedWidth = textPainter.size.width;
    } else {
      calculatedWidth = defaultWidth;
    }

    setState(() => _containerWidth = calculatedWidth + 30);
  }

  @override
  void initState() {
    super.initState();
    controller = TextEditingController(text: widget.selectedCount.toString());
    node = FocusNode();
    node.addListener(_focusListener);
    _updateWidth();
    controller.addListener(_updateWidth);
  }

  @override
  void dispose() {
    controller.removeListener(_updateWidth);
    controller.dispose();
    node.removeListener(_focusListener);
    node.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant _PageNumberWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    controller.text = widget.selectedCount.toString();
  }

  void _focusListener() {
    double? typedCount;
    CommonFunctions.removeTextSelection(controller);

    // check number
    try {
      typedCount = double.parse(controller.text.trim());
      if (typedCount < 0) typedCount = null;
    } catch (_) {}

    // check decimal length
    if (controller.text.contains('.') && typedCount != null) {
      try {
        String decimal = controller.text.trim().split('.').last;
        if (decimal.length > 3) typedCount = null;
      } catch (_) {}
    }

    if (!node.hasFocus) {
      if (typedCount == null) {
        controller.text = widget.selectedCount.toString();
        return;
      }
      widget.onCountChanged(typedCount);
    }
  }

  @override
  Widget build(BuildContext context) {
    return _DecorationContainer(
      width: _containerWidth,
      child: Focus(
        focusNode: node,
        child: TextField(
          controller: controller,
          maxLines: 1,
          maxLength: 10,
          inputFormatters: [NumberOrDecimalNumberFormatter()],
          decoration: const InputDecoration(
            counterText: '',
            isDense: true,
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          ),
          cursorHeight: 18,
          textAlign: TextAlign.center,
          style: Ts.lgRegular(color: Tm.color(Tc.ipfTxt)),
        ),
      ),
    );
  }
}
