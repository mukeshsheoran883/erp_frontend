import 'package:invently/models/common/common_id_value_model.dart';
import 'package:invently/models/common/country_codes.dart';
import 'package:invently/models/common/form_models.dart';
import 'package:invently/models/supplier/supplier_model.dart';
import 'package:flutter/material.dart';

class AddSupplierParams {
  ApiParam<SupplierModel> supplier = ApiParam<SupplierModel>();
  FileParam image = FileParam();
  FileParam idImage = FileParam();
  TextFieldParam name = TextFieldParam();
  TextFieldParam email = TextFieldParam();
  TextFieldParam idNumber = TextFieldParam();
  TextFieldParam gstNumber = TextFieldParam();
  DropDownListenableParam<CommonKeyValueModel> id =
      DropDownListenableParam<CommonKeyValueModel>(options: ValueNotifier([]));
  PhoneNumberParam phone = PhoneNumberParam();
  PhoneNumberParam altPhone = PhoneNumberParam();
  DropDownParam<Country> country = DropDownParam(options: []);
  StringParam state = StringParam();
  TextFieldParam address = TextFieldParam();

  List<FormParam> allParams() => [
        supplier,
        image,
        idImage,
        name,
        email,
        idNumber,
        gstNumber,
        id,
        phone,
        altPhone,
        country,
        state,
        address,
      ];
}
