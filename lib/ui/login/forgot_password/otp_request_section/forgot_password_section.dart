
import 'package:invently/assortment/services/navigation_service/navigation_service.dart';
import 'package:invently/assortment/status.dart';
import 'package:invently/models/common/form_models.dart';
import 'package:invently/network/common_api_services.dart';
import 'package:invently/ui/login/forgot_password/forgot_password_variables.dart';
import 'package:invently/ui/login/forgot_password/reset_section/forgot_password_reset_section.dart';
import 'package:invently/ui/login/widgets/back_to_login_button.dart';
import 'package:invently/ui/login/widgets/common_widgets.dart';
import 'package:invently/utils/theme/colors/colors.dart';
import 'package:invently/utils/theme/text_style/text_styles.dart';
import 'package:invently/utils/validation/validator.dart';
import 'package:invently/widgets/alert_dialog/info_tool_tip.dart';
import 'package:invently/widgets/alert_dialog/show_notification_alert.dart';
import 'package:invently/widgets/app_snack_bar.dart';
import 'package:invently/widgets/text_widget/text_field.dart';
import 'package:fast_validator/fast_validator.dart';
import 'package:flutter/material.dart';

part 'forgot_password_functions.dart';

class ForgotPasswordSection extends StatefulWidget {
  const ForgotPasswordSection({super.key});

  @override
  State<ForgotPasswordSection> createState() => _ForgotPasswordSectionState();
}

class _ForgotPasswordSectionState extends State<ForgotPasswordSection> {
  ForgotPasswordVariables params = ForgotPasswordVariables();

  @override
  void initState() {
    _setInitialValues(this);
    super.initState();
  }

  @override
  void dispose() {
    _dispose(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('Forgot Password?', style: Ts.xl3Semibold(color: Tm.color(Tc.txtH2))),
        const SizedBox(height: 4),
        Text(
          'There’s nothing to worry about! We’ll send an OTP to your registered email ID to help you reset your password.',
          textAlign: TextAlign.center,
          style: Ts.rgRegular(color: Tm.color(Tc.txtH4)),
        ),
        const SizedBox(height: 45),
        EmailIdField(param: params.email, reset: _refresh),
        UserCodeField(param: params.employeeCodeParam, reset: _refresh),
        const SizedBox(height: 16),
        StatsTextButton(param: params.emailSendParam, onTap: () => _sendEmail(this), text: 'Send Email OTP'),
        const SizedBox(height: 46),
        const BackToLoginButton(),
      ],
    );
  }

  void _refresh() => mounted ? setState(() => {}) : null;
}

class UserCodeField extends StatelessWidget {
  final TextFieldParam param;
  final Function() reset;

  const UserCodeField({super.key, required this.param, required this.reset});

  @override
  Widget build(BuildContext context) {
    return TextFieldWithTitle(
      title: null,
      hint: 'Employee Code',
      controller: param.controller,
      error: param.error.errorMessage,
      onChanged: (a) => {param.resetError(), reset()},
      suffixIcon: const InfoToolTip(
        message:
            'If you\'re unsure of your user ID, check your account activation email or contact your store manager.',
      ),
    );
  }
}

class EmailIdField extends StatelessWidget {
  final TextFieldParam param;
  final Function() reset;

  const EmailIdField({super.key, required this.param, required this.reset});

  @override
  Widget build(BuildContext context) {
    return TextFieldWithTitle(
      title: null,
      hint: 'Your Registered Email',
      controller: param.controller,
      error: param.error.errorMessage,
      onChanged: (a) => {param.resetError(), reset()},
      suffixIcon: const InfoToolTip(
        message:
            'If you\'re unsure of your registered email, kindly reach out to your store manager, and they\'ll be happy to assist you.',
      ),
    );
  }
}
