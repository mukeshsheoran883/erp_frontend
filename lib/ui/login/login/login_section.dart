
import 'package:invently/assortment/services/navigation_service/navigation_service.dart';
import 'package:invently/assortment/status.dart';
import 'package:invently/assortment/widgets/button/hover_button_base.dart';
import 'package:invently/assortment/widgets/button/hover_gesture_detector.dart';
import 'package:invently/models/user/employee_model.dart';
import 'package:invently/models/user/login_model.dart';
import 'package:invently/network/common_api_services.dart';
import 'package:invently/ui/login/login/login_section_variables.dart';
import 'package:invently/ui/login/select_branch/select_branch_section.dart';
import 'package:invently/ui/login/widgets/common_widgets.dart';
import 'package:invently/utils/theme/colors/colors.dart';
import 'package:invently/utils/theme/text_style/text_styles.dart';
import 'package:invently/utils/validation/validator.dart';
import 'package:invently/widgets/app_version_text.dart';
import 'package:invently/widgets/form_widgets/check_box_field.dart';
import 'package:invently/widgets/text_widget/text_field.dart';
import 'package:fast_validator/fast_validator.dart';
import 'package:flutter/material.dart';

part 'package:invently/ui/login/login/login_functions.dart';

class LoginSection extends StatefulWidget {
  const LoginSection({super.key});

  @override
  State<LoginSection> createState() => _LoginSectionState();
}

class _LoginSectionState extends State<LoginSection> {
  LoginSectionVariables params = LoginSectionVariables();
  bool rememberMe = false;

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
        Text('Welcome Back', style: Ts.xl3Semibold(color: Tm.color(Tc.txtH2))),
        const SizedBox(height: 4),
        Text('Hi there. Please login to continue.', style: Ts.rgRegular(color: Tm.color(Tc.txtH4))),
        const SizedBox(height: 45),
        TextFieldWithTitle(
          title: null,
          hint: 'Email',
          controller: params.email.controller,
          error: params.email.error.errorMessage,
          onChanged: (a) => {params.email.resetError(), params.password.resetError(), _refresh()},
        ),
        PasswordField(
          param: params.password,
          hint: 'Password',
          refresh: _refresh,
          otherParam: params.email,
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            CheckBoxField(
              checkText: 'Remember me',
              checked: rememberMe,
              onCheckTap: _rememberMeTapped,
              onTextTap: _rememberMeTapped,
              removeAllProps: true,
            ),
            const Spacer(),
            _TextButton(
              text: 'Forgot Password?',
              onTap: () => AppNavigator.navigate(AppRoutes.forgotPasswordEmailSection),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Align(
          alignment: Alignment.centerRight,
          child: _TextButton(
            text: 'Set Up Account',
            onTap: () => AppNavigator.navigate(AppRoutes.activateAccount),
          ),
        ),
        const SizedBox(height: 52),
        StatsTextButton(param: params.api, onTap: () => _login(this), text: 'Log In'),
        const SizedBox(height: 32),
        const AppVersionText(),
      ],
    );
  }

  void _refresh() => mounted ? setState(() => {}) : null;

  void _rememberMeTapped(bool a) => {rememberMe = a, _refresh()};
}

class _TextButton extends StatelessWidget {
  final String text;
  final Function() onTap;

  const _TextButton({required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return HoverGD(
      onTap: onTap,
      builder: (context, bState) {
        return Text(
          text,
          style: Ts.mdRegular(
            color: Tm.color(
              bState.isPressing
                  ? Tc.secIconLight
                  : bState.isHovering
                      ? Tc.secIconLight
                      : Tc.secDef,
            ),
          ),
        );
      },
    );
  }
}
