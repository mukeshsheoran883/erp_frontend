import 'package:invently/models/common/common_id_value_model.dart';
import 'package:invently/models/common/form_models.dart';
import 'package:invently/models/quotations/quotations_model.dart';
import 'package:flutter/material.dart';

class AddQuotationsParams {
  ApiParam<QuotationsModel> quotation = ApiParam<QuotationsModel>();
  TextFieldParam description = TextFieldParam();
  DropDownListenableParam<CommonKeyValueModel> brand =
  DropDownListenableParam<CommonKeyValueModel>(options: ValueNotifier([]));
  TextFieldParam quantity = TextFieldParam()..reset('1');
  TextFieldParam price = TextFieldParam();
  TextFieldParam tax = TextFieldParam();
  CheckboxParam purchase = CheckboxParam();
  CheckboxParam sales = CheckboxParam();
  DropDownListenableParam<CommonKeyValueModel> supplier =
  DropDownListenableParam<CommonKeyValueModel>(options: ValueNotifier([]));
  DropDownListenableParam<CommonKeyValueModel> organisation =
  DropDownListenableParam<CommonKeyValueModel>(options: ValueNotifier([]));
  DropDownListenableParam<CommonKeyValueModel> item =
  DropDownListenableParam<CommonKeyValueModel>(options: ValueNotifier([]));

  List<FormParam> allParams() =>
      [quotation, description, brand, quantity, price, tax, purchase, sales,organisation, supplier, item];
}