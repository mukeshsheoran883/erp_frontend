
import 'package:invently/assortment/services/navigation_service/navigation_service.dart';
import 'package:invently/assortment/status.dart';
import 'package:invently/network/common_api_services.dart';
import 'package:invently/ui/login/forgot_password/forgot_password_variables.dart';
import 'package:invently/ui/login/forgot_password/widgets/password_constrains_widget.dart';
import 'package:invently/ui/login/widgets/back_to_login_button.dart';
import 'package:invently/ui/login/widgets/common_widgets.dart';
import 'package:invently/utils/theme/colors/colors.dart';
import 'package:invently/utils/theme/text_style/text_styles.dart';
import 'package:invently/utils/validation/validator.dart';
import 'package:invently/utils/validation/validators.dart';
import 'package:invently/widgets/alert_dialog/show_notification_alert.dart';
import 'package:invently/widgets/app_snack_bar.dart';
import 'package:invently/widgets/text_widget/text_field.dart';
import 'package:fast_validator/fast_validator.dart';
import 'package:flutter/material.dart';

part 'forgot_password_reset_functions.dart';

class ForgotPasswordResetSection extends StatefulWidget {
  final String email;

  const ForgotPasswordResetSection({super.key, required this.email});

  @override
  State<ForgotPasswordResetSection> createState() => _ForgotPasswordResetSectionState();
}

class _ForgotPasswordResetSectionState extends State<ForgotPasswordResetSection> {
  ResetPasswordVariables params = ResetPasswordVariables();

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
        Text('Create New Password', style: Ts.xl3Semibold(color: Tm.color(Tc.txtH2))),
        const SizedBox(height: 4),
        Text(
          'Let’s create a new strong password.',
          textAlign: TextAlign.center,
          style: Ts.rgRegular(color: Tm.color(Tc.txtH4)),
        ),
        const SizedBox(height: 45),
        TextFieldWithTitle(
          title: null,
          hint: 'OTP',
          controller: params.otp.controller,
          error: params.otp.error.errorMessage,
          onChanged: (a) => {params.otp.resetError(), _refresh()},
        ),
        PasswordField(
          hint: 'New Password',
          param: params.newPassword,
          otherParam: params.confirmedPassword,
          refresh: _refresh,
        ),
        PasswordField(
          hint: 'Confirm Password',
          param: params.confirmedPassword,
          otherParam: params.newPassword,
          refresh: _refresh,
        ),
        const SizedBox(height: 16),
        StatsTextButton(param: params.apiParam, onTap: () => _changePassword(this), text: 'Reset Password'),
        const SizedBox(height: 23),
        const PasswordConstrainsWidget(),
        const SizedBox(height: 23),
        const BackToLoginButton(),
      ],
    );
  }

  void _refresh() => mounted ? setState(() => {}) : null;
}
