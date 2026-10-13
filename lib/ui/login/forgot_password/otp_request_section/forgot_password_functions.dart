
part of '../otp_request_section/forgot_password_section.dart';

void _setInitialValues(_ForgotPasswordSectionState state) {
  state.params.allParams().forEach((e) => e.reset(null));
  state.params.emailSendParam.setStatus(Status.none);
}

void _dispose(_ForgotPasswordSectionState state) {
  state.params.allParams().forEach((e) => e.dispose());
}

void _resetError(_ForgotPasswordSectionState state) {
  state.params.allParams().forEach((e) => e.resetError());
}

Future<void> _sendEmail(_ForgotPasswordSectionState state) async {
  _resetError(state);
  state._refresh();

  if (!_validate(state)) return;

  state.params.emailSendParam.setStatus(Status.loading);
  state._refresh();
  final response = await CommonApiServices.sendEmailOtp(
    email: state.params.email.text,
    employeeCode: state.params.employeeCodeParam.text,
  );

  if (!state.mounted) return;
  if (response.responseType.success) {
    state.params.emailSendParam.setStatus(Status.success);
    AppNavigator.navigate(
      AppRoutes.forgotPasswordResetSection(data: ForgotPasswordResetSection(email: state.params.email.text)),
    );
    AppSnackBar.showSnackBarWithText(text: 'An email containing OTP has been sent to ${state.params.email.text}');
  } else {
    state.params.emailSendParam.setStatus(Status.error);
    showSingleButtonAlert(text: response.firstError(), title: 'Error');
  }
  state._refresh();
}

bool _validate(_ForgotPasswordSectionState state) {
  final isValid = Validator.validate(
    [
      ValidationModel(
        fieldName: 'Email',
        data: state.params.email.text,
        error: state.params.email.error,
        validators: [FastRequiredValidation(), FastEmailValidation()],
      ),
      ValidationModel(
        fieldName: 'Employee code',
        data: state.params.employeeCodeParam.text,
        error: state.params.employeeCodeParam.error,
        validators: [FastRequiredValidation()],
      ),
    ],
  );

  state._refresh();
  return isValid;
}
