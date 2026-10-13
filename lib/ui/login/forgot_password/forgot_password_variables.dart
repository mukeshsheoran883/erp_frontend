
import 'package:invently/models/common/form_models.dart';

class ForgotPasswordVariables {
  TextFieldParam email = TextFieldParam();
  TextFieldParam employeeCodeParam = TextFieldParam();
  ApiParam emailSendParam = ApiParam();

  List<FormParam> allParams() => [email, employeeCodeParam, emailSendParam];
}

class ResetPasswordVariables {
  TextFieldParam otp = TextFieldParam();
  TextFieldParam newPassword = TextFieldParam();
  TextFieldParam confirmedPassword = TextFieldParam();
  ApiParam apiParam = ApiParam();

  List<FormParam> allParams() => [otp, newPassword, confirmedPassword, apiParam];
}
