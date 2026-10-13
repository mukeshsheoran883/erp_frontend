import 'package:invently/models/common/common_id_value_model.dart';
import 'package:invently/models/common/country_codes.dart';
import 'package:invently/models/common/form_models.dart';
import 'package:invently/models/customer/customer_model.dart';
import 'package:flutter/material.dart';

class AddCustomerParams {
  ApiParam<CustomerModel> customer = ApiParam<CustomerModel>();

  FileParam photo = FileParam();
  FileParam idProof = FileParam();
  TextFieldParam name = TextFieldParam();
  TextFieldParam email = TextFieldParam();
  TextFieldParam occupation = TextFieldParam();
  TextFieldParam education = TextFieldParam();
  TextFieldParam religion = TextFieldParam();
  TextFieldParam uniqueNumber = TextFieldParam();
  DateTimeParam dateBirth = DateTimeParam();
  TextFieldParam bloodGroup = TextFieldParam();
  TextFieldParam maritalStatus = TextFieldParam();
  DropDownListenableParam<CommonKeyValueModel> unique =
      DropDownListenableParam<CommonKeyValueModel>(options: ValueNotifier([]));
  DropDownListenableParam<CommonKeyValueModel> gender =
      DropDownListenableParam<CommonKeyValueModel>(options: ValueNotifier([]));
  PhoneNumberParam phone = PhoneNumberParam();
  DropDownParam<Country> country = DropDownParam(options: []);
  StringParam state = StringParam();
  TextFieldParam address = TextFieldParam();

  List<FormParam> allParams() => [
        customer,
        uniqueNumber,
        unique,
        maritalStatus,
        gender,
        dateBirth,
        religion,
        education,
        occupation,
        bloodGroup,
        name,
        email,
        phone,
        country,
        state,
        address,
        photo,
        idProof
      ];
}
