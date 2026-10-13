import 'package:invently/models/common/form_models.dart';

class AddDispatchDetailsParams {
  TextFieldParam logisticsCompany = TextFieldParam();
  TextFieldParam logisticsCharges = TextFieldParam();

  List<FormParam> allParams() => [
    logisticsCompany,
    logisticsCharges,
  ];

  void dispose() {
    logisticsCompany.dispose();
    logisticsCharges.dispose();
  }
}