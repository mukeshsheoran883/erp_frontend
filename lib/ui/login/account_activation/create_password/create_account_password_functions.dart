
part of 'create_account_password.dart';

void _setInitialValues(_CreateAccountPasswordState state) {
  state.params.allParams().forEach((e) => e.reset(null));
  state.params.apiParam.setStatus(Status.none);
}

void _dispose(_CreateAccountPasswordState state) {
  state.params.allParams().forEach((e) => e.dispose());
}

void _resetError(_CreateAccountPasswordState state) {
  state.params.allParams().forEach((e) => e.resetError());
}

Future<void> _activateAccount(_CreateAccountPasswordState state) async {
  _resetError(state);
  state._refresh();

  if (!_validate(state)) return;

  state.params.apiParam.setStatus(Status.loading);
  state._refresh();
  final response = await CommonApiServices.activateAccount(
    email: state.widget.email,
    password: state.params.confirmedPassword.text,
    otp: state.params.otp.text,
  );

  if (response.responseType.success) {
    state.params.apiParam.setStatus(Status.success);
    if (state.mounted) AppNavigator.navigate(AppRoutes.login);
    AppSnackBar.showSnackBarWithText(text: 'Account activated successfully. Please login to continue.');
  } else {
    state.params.apiParam.setStatus(Status.error);
    if (state.mounted) showSingleButtonAlert(text: response.firstError(), title: 'Error');
  }

  state._refresh();
}

bool _validate(_CreateAccountPasswordState state) {
  final isValid = Validator.validate(
    [
      ValidationModel(
        fieldName: 'OTP',
        data: state.params.otp.text,
        error: state.params.otp.error,
        validators: [FastRequiredValidation()],
      ),
      ...CustomValidators.passwordValidator(
        passwordField: 'Password',
        confirmField: 'Confirm password',
        newPassword: state.params.password.text,
        confirmPassword: state.params.confirmedPassword.text,
        newPasswordError: state.params.password.error,
        confirmPasswordError: state.params.confirmedPassword.error,
      ),
    ],
  );

  state._refresh();
  return isValid;
}
