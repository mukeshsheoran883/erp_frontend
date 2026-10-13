
part of 'activate_account.dart';

void _setInitialValues(_ActivateAccountOtpRequestState state) {
  state.params.allParams().forEach((e) => e.reset(null));
  state.params.apiParam.setStatus(Status.none);
}

void _dispose(_ActivateAccountOtpRequestState state) {
  state.params.allParams().forEach((e) => e.dispose());
}

void _resetError(_ActivateAccountOtpRequestState state) {
  state.params.allParams().forEach((e) => e.resetError());
}

Future<void> _requestOtp(_ActivateAccountOtpRequestState state) async {
  _resetError(state);
  state._refresh();

  if (!_validate(state)) return;

  state.params.apiParam.setStatus(Status.loading);
  state._refresh();
  final response = await CommonApiServices.sendEmailOtp(
    email: state.params.email.text,
    employeeCode: state.params.employeeCode.text,
  );

  if (response.responseType.success) {
    state.params.apiParam.setStatus(Status.success);
    if (state.mounted) {
      AppNavigator.navigate(
        AppRoutes.createAccountPassword(data: CreateAccountPassword(email: state.params.email.text)),
      );
    }
    AppSnackBar.showSnackBarWithText(text: 'An email containing OTP has been sent to ${state.params.email.text}');
  } else {
    state.params.apiParam.setStatus(Status.error);
    if (state.mounted) showSingleButtonAlert(text: response.firstError(), title: 'Error');
  }

  state._refresh();
}

bool _validate(_ActivateAccountOtpRequestState state) {
  String privacyError = 'Review and accept to continue.';

  final isValid = Validator.validate(
    [
      CustomValidators.emailValidator(field: 'Email', email: state.params.email.text, error: state.params.email.error),
      ValidationModel(
        fieldName: 'Employee code',
        data: state.params.employeeCode.text,
        error: state.params.employeeCode.error,
        validators: [FastRequiredValidation()],
      ),
      ValidationModel(
        fieldName: 'Terms and conditions',
        data: state.params.termsAndPrivacy.value,
        error: state.params.termsAndPrivacy.error,
        validators: [
          FastRequiredValidation(customMessage: privacyError),
          FastExactValueValidation(value: true, customMessage: privacyError),
        ],
      ),
    ],
  );

  state._refresh();
  return isValid;
}
