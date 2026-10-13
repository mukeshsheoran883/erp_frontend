
import 'package:invently/assortment/status.dart';
import 'package:invently/assortment/widgets/error_loading_and_empty_widgets/custom_progress_indicator.dart';
import 'package:invently/gen/assets.gen.dart';
import 'package:invently/models/common/form_models.dart';
import 'package:invently/utils/theme/colors/colors.dart';
import 'package:invently/utils/theme/text_style/text_styles.dart';
import 'package:invently/widgets/buttons/rounded_rect_button.dart';
import 'package:invently/widgets/text_widget/text_field.dart';
import 'package:invently/widgets/text_widget/text_icon.dart';
import 'package:flutter/material.dart';

class PasswordField extends StatefulWidget {
  final TextFieldParam param;
  final TextFieldParam? otherParam;
  final Function() refresh;
  final String hint;

  const PasswordField({
    super.key,
    required this.param,
    required this.refresh,
    required this.hint,
    required this.otherParam,
  });

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool obfuscate = true;

  @override
  Widget build(BuildContext context) {
    return TextFieldWithTitle(
      title: null,
      hint: widget.hint,
      controller: widget.param.controller,
      error: widget.param.error.errorMessage,
      obfuscate: obfuscate,
      suffixIcon: TextIcon(
        icon: obfuscate ? Assets.icons.eyeClosed : Assets.icons.eye,
        onTap: () => setState(() => obfuscate = !obfuscate),
        iconColor: Tm.color(Tc.ipfTxt),
      ),
      onChanged: (a) => {widget.param.resetError(), widget.otherParam?.resetError(), widget.refresh()},
    );
  }
}

class StatsTextButton extends StatelessWidget {
  final ApiParam param;
  final Function() onTap;
  final String text;

  const StatsTextButton({super.key, required this.param, required this.onTap, required this.text});

  @override
  Widget build(BuildContext context) {
    return RRectButton(
      widget: param.status == Status.loading
          ? CustomProgressIndicator(color: Tm.color(Tc.comCardBg), size: 32)
          : Text(text, style: Ts.rgMedium(color: Tm.color(Tc.comBtnTxt))),
      height: 44,
      onTap: param.status == Status.loading ? null : onTap,
    );
  }
}
