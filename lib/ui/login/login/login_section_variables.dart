
import 'package:invently/models/common/form_models.dart';

class LoginSectionVariables {
  TextFieldParam email = TextFieldParam();
  TextFieldParam password = TextFieldParam();
  ApiParam api = ApiParam();

  List<FormParam> allParams() => [email, password, api];
}
