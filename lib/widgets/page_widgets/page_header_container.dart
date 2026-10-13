
import 'package:invently/assortment/status.dart';
import 'package:invently/assortment/widgets/svg_image.dart';
import 'package:invently/utils/theme/colors/colors.dart';
import 'package:invently/widgets/alert_dialog/alert_bottom_buttons.dart';
import 'package:invently/widgets/text_widget/text_field.dart';
import 'package:flutter/material.dart';

class PageHeaderContainer extends StatelessWidget {
  final List<Widget> widgets;
  final double bottomSpacing;
  final double topSpacing;

  const PageHeaderContainer({super.key, required this.widgets, this.bottomSpacing = 20, this.topSpacing = 20});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Tm.color(Tc.comCardBg), borderRadius: BorderRadius.all(Radius.circular(24))),
      padding: EdgeInsets.only(bottom: bottomSpacing, top: topSpacing, right: 20, left: 20),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, spacing: 16, children: widgets),
    );
  }
}

class PageHeaderTextField extends StatelessWidget {
  final String hint;
  final TextEditingController controller;
  final String? error;
  final Function(String)? onChange;

  const PageHeaderTextField({
    super.key,
    required this.hint,
    required this.controller,
    required this.error,
    this.onChange,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 260,
      child: TextFieldWithTitle(
        title: null,
        hint: hint,
        controller: controller,
        required: true,
        removeAllProps: true,
        showError: true,
        error: error,
        onChanged: onChange,
      ),
    );
  }
}

class PageHeaderButton extends StatelessWidget {
  final String label;
  final Function()? onTap;
  final Color? buttonColor;
  final Color? textColor;
  final String icon;
  final double iconSize;
  final Status? status;

  const PageHeaderButton({
    super.key,
    required this.label,
    required this.onTap,
    required this.icon,
    this.buttonColor,
    this.textColor,
    this.iconSize = 22,
    this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: status == Status.loading ? 0.7 : 1,
      child: AlertButton(
        text: label,
        onTap: status == Status.loading ? null : onTap,
        color: textColor ?? Tm.color(Tc.comBtnTxt),
        buttonColor: buttonColor ?? Tm.color(Tc.priDef),
        icon: SvgImage(icon, height: iconSize, width: iconSize, color: textColor ?? Tm.color(Tc.comBtnTxt)),
        iconPadding: const EdgeInsets.only(right: 4),
      ),
    );
  }
}

class PageHeaderBorderButton extends StatelessWidget {
  final String label;
  final Function()? onTap;
  final Color? buttonColor;
  final Color? textColor;
  final String icon;
  final double iconSize;
  final Color borderColor;
  final double borderWidth;

  const PageHeaderBorderButton({
    super.key,
    required this.label,
    required this.onTap,
    required this.icon,
    required this.borderColor,
    this.buttonColor,
    this.textColor,
    this.iconSize = 22,
    this.borderWidth = 1,
  });

  @override
  Widget build(BuildContext context) {
    return AlertButton(
      text: label,
      onTap: onTap,
      color: textColor ?? Tm.color(Tc.comBtnTxt),
      buttonColor: buttonColor ?? Colors.white,
      icon: SvgImage(icon, height: iconSize, width: iconSize, color: textColor ?? Tm.color(Tc.comBtnTxt)),
      iconPadding: const EdgeInsets.only(right: 4),
      border: Border.all(color: borderColor, width: borderWidth),
    );
  }
}
