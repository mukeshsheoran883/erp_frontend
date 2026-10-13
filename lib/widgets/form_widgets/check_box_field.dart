
import 'package:invently/assortment/widgets/button/hover_gesture_detector.dart';
import 'package:invently/utils/theme/colors/colors.dart';
import 'package:invently/utils/theme/text_style/text_styles.dart';
import 'package:invently/widgets/custom_check_box.dart';
import 'package:flutter/material.dart';

class CheckBoxField extends StatefulWidget {
  final String? title;
  final String? error;
  final bool required;
  final bool checked;
  final String? checkText;
  final bool readOnly;
  final Function(bool)? onTextTap;
  final Function(bool)? onCheckTap;
  final EdgeInsets errorPadding;
  final bool removeAllProps;
  final bool? showError;
  final TextStyle? checkTextStyle;

  const CheckBoxField({
    super.key,
    required this.checkText,
    required this.checked,
    required this.onCheckTap,
    required this.onTextTap,
    this.required = false,
    this.error,
    this.readOnly = false,
    this.removeAllProps = false,
    this.errorPadding = const EdgeInsets.only(bottom: 8),
    this.checkTextStyle,
    this.showError,
    this.title,
  });

  @override
  State<CheckBoxField> createState() => _CheckBoxFieldState();
}

class _CheckBoxFieldState extends State<CheckBoxField> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.title != null && !widget.removeAllProps)
          Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Text.rich(
              TextSpan(
                text: widget.title,
                style: Ts.lgRegular(color: Tm.color(Tc.ipfTitle)),
                children:
                    widget.required ? [TextSpan(text: ' *', style: Ts.lgRegular(color: Tm.color(Tc.redDef)))] : [],
              ),
            ),
          ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomCheckBox(isChecked: widget.checked, onChange: widget.onCheckTap),
            if (widget.checkText != null)
              HoverGD(
                onTap: () => widget.onTextTap?.call(!widget.checked),
                child: Padding(
                  padding: const EdgeInsets.only(left: 12),
                  child:
                      Text(widget.checkText!, style: widget.checkTextStyle ?? Ts.mdRegular(color: Tm.color(Tc.txtH3))),
                ),
              ),
          ],
        ),
        if (!widget.removeAllProps || (widget.showError ?? !widget.removeAllProps))
          Padding(
            padding: widget.errorPadding,
            child: Text(widget.error ?? '', style: Ts.rgSemiRegular(color: Tm.color(Tc.redDef))),
          ),
      ],
    );
  }
}
