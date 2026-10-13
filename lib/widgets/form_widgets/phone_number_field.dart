
import 'package:invently/assortment/extensions/text_formatters.dart';
import 'package:invently/assortment/widgets/svg_image.dart';
import 'package:invently/gen/assets.gen.dart';
import 'package:invently/utils/theme/colors/colors.dart';
import 'package:invently/utils/theme/text_style/text_styles.dart';
import 'package:invently/widgets/text_widget/text_field.dart';
import 'package:flutter/material.dart';

class PhoneNumberField extends StatelessWidget {
  final String? title;
  final String? error;
  final bool required;
  final String? hint;
  final Color? borderColor;
  final Color? fillColor;
  final double borderRadius;
  final bool autoFocus;
  final EdgeInsets errorPadding;
  final bool readOnly;
  final TextEditingController phoneNumberController;
  final TextEditingController countryCodeController;
  final Function(String)? onChanged;

  const PhoneNumberField({
    super.key,
    required this.title,
    required this.phoneNumberController,
    required this.countryCodeController,
    this.required = false,
    this.error,
    this.hint,
    this.readOnly = false,
    this.autoFocus = false,
    this.borderColor,
    this.borderRadius = 12,
    this.fillColor,
    this.errorPadding = const EdgeInsets.only(bottom: 8),
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null)
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
            Expanded(
              flex: 2,
              child: TextFieldWithTitle(
                title: '',
                controller: countryCodeController,
                hint: 'Code',
                inputFormatters: [NumbersOnlyFormatter()],
                prefixIcon: Container(
                  width: 12,
                  height: 12,
                  alignment: Alignment.center,
                  child: SvgImage(Assets.icons.add, width: 10, color: Tm.color(Tc.tabDefTxt)),
                ),
                error: '',
                readOnly: readOnly,
                borderColor: borderColor,
                fillColor: fillColor,
                borderRadius: borderRadius,
                autoFocus: autoFocus,
                errorPadding: errorPadding,
                removeAllProps: true,
                maxLen: 4,
                onChanged: onChanged,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              flex: 4,
              child: TextFieldWithTitle(
                title: '',
                controller: phoneNumberController,
                hint: 'Phone',
                error: '',
                maxLen: 12,
                inputFormatters: [NumbersOnlyFormatter()],
                readOnly: readOnly,
                borderColor: borderColor,
                fillColor: fillColor,
                borderRadius: borderRadius,
                autoFocus: autoFocus,
                errorPadding: errorPadding,
                removeAllProps: true,
                onChanged: onChanged,
              ),
            ),
          ],
        ),
        Padding(
          padding: errorPadding,
          child: Text(error ?? '', style: Ts.rgSemiRegular(color: Tm.color(Tc.redDef))),
        ),
      ],
    );
  }
}
