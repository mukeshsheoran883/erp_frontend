import 'package:invently/utils/theme/colors/colors.dart';
import 'package:invently/utils/theme/text_style/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_switch/flutter_advanced_switch.dart';

class ToggleButtonField extends StatelessWidget {
  final bool isOn;
  final void Function(bool)? onChange;
  final String? title;
  final String? error;
  final bool required;
  final bool removeAllProps;
  final EdgeInsets errorPadding;
  final String? offText;
  final String? onText;

  const ToggleButtonField({
    super.key,
    required this.title,
    required this.error,
    required this.isOn,
    required this.onChange,
    this.required = false,
    this.removeAllProps = false,
    this.errorPadding = const EdgeInsets.only(bottom: 8),
    this.offText = 'Off',
    this.onText = 'On',
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null && !removeAllProps)
          Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Text.rich(
              TextSpan(
                text: title,
                style: Ts.lgRegular(color: Tm.color(Tc.ipfTitle)),
                children: required ? [TextSpan(text: ' *', style: Ts.lgRegular(color: Tm.color(Tc.redDef)))] : [],
              ),
            ),
          ),
        Row(
          children: [
            if (offText != null)
              Flexible(child: Padding(padding: const EdgeInsets.only(right: 8.0), child: _BtnText(text: offText!))),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 6.5),
              child: AdvancedSwitch(
                width: 60,
                height: 35,
                initialValue: isOn,
                thumb: Container(
                  margin: const EdgeInsets.all(2),
                  decoration: BoxDecoration(shape: BoxShape.circle, color: Tm.color(Tc.toggleDot)),
                ),
                onChanged: onChange == null
                    ? null
                    : (a) {
                        if (a == true || a == false) onChange?.call(a);
                      },
              ),
            ),
            if (onText != null)
              Flexible(child: Padding(padding: const EdgeInsets.only(left: 8), child: _BtnText(text: onText!))),
          ],
        ),
        if (!removeAllProps)
          Padding(
            padding: errorPadding,
            child: Text(error ?? '', style: Ts.rgSemiRegular(color: Tm.color(Tc.redDef))),
          ),
      ],
    );
  }
}

class _BtnText extends StatelessWidget {
  final String text;

  const _BtnText({required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(text, style: Ts.rgRegular(color: Tm.color(Tc.ipfTxt)), overflow: TextOverflow.ellipsis);
  }
}
