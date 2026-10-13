
import 'package:invently/assortment/services/navigation_service/navigation_service.dart';
import 'package:invently/assortment/status.dart';
import 'package:invently/network/common_api_services.dart';
import 'package:invently/ui/login/account_activation/account_activation_variables.dart';
import 'package:invently/ui/login/account_activation/create_password/create_account_password.dart';
import 'package:invently/ui/login/forgot_password/otp_request_section/forgot_password_section.dart';
import 'package:invently/ui/login/widgets/back_to_login_button.dart';
import 'package:invently/ui/login/widgets/common_widgets.dart';
import 'package:invently/utils/theme/colors/colors.dart';
import 'package:invently/utils/theme/text_style/text_styles.dart';
import 'package:invently/utils/validation/validator.dart';
import 'package:invently/utils/validation/validators.dart';
import 'package:invently/widgets/alert_dialog/show_notification_alert.dart';
import 'package:invently/widgets/alert_dialog/show_terms_and_conditions_alert.dart';
import 'package:invently/widgets/app_snack_bar.dart';
import 'package:invently/widgets/form_widgets/check_box_field.dart';
import 'package:fast_validator/fast_validator.dart';
import 'package:flutter/material.dart';

part 'activate_account_functions.dart';

class ActivateAccountOtpRequest extends StatefulWidget {
  const ActivateAccountOtpRequest({super.key});

  @override
  State<ActivateAccountOtpRequest> createState() => _ActivateAccountOtpRequestState();
}

class _ActivateAccountOtpRequestState extends State<ActivateAccountOtpRequest> {
  ActivateAccountVariables params = ActivateAccountVariables();
  bool obfuscatePassword = true;
  bool obfuscateConfirmPassword = true;

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
        Text('Activate Account', style: Ts.xl3Semibold(color: Tm.color(Tc.txtH2))),
        const SizedBox(height: 4),
        Text(
          'An OTP will be sent to your email for activation. Ensure your email is registered by your store manager.',
          textAlign: TextAlign.center,
          style: Ts.rgRegular(color: Tm.color(Tc.txtH4)),
        ),
        const SizedBox(height: 25),
        EmailIdField(param: params.email, reset: _refresh),
        UserCodeField(param: params.employeeCode, reset: _refresh),
        Align(
          alignment: Alignment.centerLeft,
          child: CheckBoxField(
            checkText: 'Terms, conditions and privacy policy',
            checked: params.termsAndPrivacy.value ?? false,
            error: params.termsAndPrivacy.error.errorMessage,
            onCheckTap: _onPrivacyCheckTap,
            onTextTap: _onPrivacyCheckTap,
            removeAllProps: true,
            showError: true,
            checkTextStyle: Ts.mdRegular(color: Tm.color(Tc.txtH4)),
          ),
        ),
        const SizedBox(height: 12),
        StatsTextButton(param: params.apiParam, onTap: () => _requestOtp(this), text: 'Send Email OTP'),
        const SizedBox(height: 20),
        const BackToLoginButton(),
      ],
    );
  }

  void _refresh() => mounted ? setState(() => {}) : null;

  void _onPrivacyCheckTap(bool a) => showTermsAndConditionsPopup(
        accepted: params.termsAndPrivacy.value ?? false,
        onChange: (a) => {params.termsAndPrivacy.resetData(a), _refresh()},
        showAcceptButton: true,
      );
}
