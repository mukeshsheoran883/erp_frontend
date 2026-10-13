
import 'package:invently/models/common/form_models.dart';

class ActivateAccountVariables {
  TextFieldParam email = TextFieldParam();
  TextFieldParam employeeCode = TextFieldParam();
  ApiParam apiParam = ApiParam();
  CheckboxParam termsAndPrivacy = CheckboxParam();

  List<FormParam> allParams() => [email, employeeCode, apiParam, termsAndPrivacy];
}

class SetPasswordVariables {
  TextFieldParam otp = TextFieldParam();
  TextFieldParam password = TextFieldParam();
  TextFieldParam confirmedPassword = TextFieldParam();
  ApiParam apiParam = ApiParam();

  List<FormParam> allParams() => [otp, password, confirmedPassword, apiParam];
}
