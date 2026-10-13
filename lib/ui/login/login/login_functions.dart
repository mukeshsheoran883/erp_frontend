
part of 'package:invently/ui/login/login/login_section.dart';

void _setInitialValues(_LoginSectionState state) {
  state.params.allParams().forEach((e) => e.reset(null));
  state.params.api.setStatus(Status.none);
}

void _dispose(_LoginSectionState state) {
  state.params.allParams().forEach((e) => e.dispose());
}

Future<void> _login(_LoginSectionState state) async {
  if (state.params.api.status == Status.loading) return;

  state.params.api.setStatus(Status.loading);
  state._refresh();

  bool valid = Validator.validate([
    ValidationModel(
      error: state.params.email.error,
      validators: [FastRequiredValidation(), FastEmailValidation()],
      fieldName: 'Email',
      data: state.params.email.text,
    ),
    ValidationModel(
      error: state.params.password.error,
      data: state.params.password.text,
      validators: [FastRequiredValidation()],
      fieldName: 'Password',
    ),
  ]);

  state._refresh();
  if (!valid) {
    state.params.api.setStatus(Status.error);
    state._refresh();

    return;
  }

  final loginResponse = await CommonApiServices.loginUser(
    LoginModel(userName: state.params.email.text, password: state.params.password.text),
  );
  if (!state.mounted) return;

  if (!loginResponse.responseType.success || loginResponse.data == null) {
    state.params.api.setStatus(Status.error);
    state.params.password.setError(loginResponse.firstError());
    state._refresh();

    return;
  }

  String? employeeCode = UserModel.employeeCodeFromAccessToken(loginResponse.data!.accessToken);
  String? role = UserModel.roleFromAccessToken(loginResponse.data!.accessToken);

  if (employeeCode == null) {
    state.params.api.setStatus(Status.error);
    state.params.password.setError('Failed to get employee code');
    state._refresh();

    return;
  }
  if (role == null) {
    state.params.api.setStatus(Status.error);
    state.params.password.setError('Failed to get role');
    state._refresh();

    return;
  }

  if (!state.mounted) return;
  AppNavigator.navigate(
    AppRoutes.loginBranchSelection(
      data: SelectBranchSection(
        role:role,
        employeeCode: employeeCode,
        rememberMe: state.rememberMe,
        loginResponse: loginResponse.data!,
      ),
    ),
  );
}
