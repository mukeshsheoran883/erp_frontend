
import 'package:invently/models/common/common_id_value_model.dart';
import 'package:invently/models/common/country_codes.dart';
import 'package:invently/models/common/form_models.dart';
import 'package:invently/models/user/employee_model.dart';
import 'package:invently/models/user/employee_permission_model.dart';
import 'package:invently/models/user/employee_permissions.dart';
import 'package:invently/utils/validation/validator.dart';
import 'package:flutter/material.dart';

class AddEmployeeParams {
  ApiParam<UserModel> employee = ApiParam<UserModel>();
  FileParam image = FileParam();
  TextFieldParam name = TextFieldParam();
  TextFieldParam email = TextFieldParam();
  DateTimeParam dateOfBirth = DateTimeParam();
  DropDownListenableParam<CommonKeyValueModel> status =
      DropDownListenableParam<CommonKeyValueModel>(options: ValueNotifier([]));
  PhoneNumberParam phone = PhoneNumberParam();
  PhoneNumberParam altPhone = PhoneNumberParam();
  DropDownParam<Country> country = DropDownParam(options: []);
  StringParam state = StringParam();
  TextFieldParam address = TextFieldParam();
  MultiDropDownParam<List<CommonKeyValueModel>> shop = MultiDropDownParam(selected: [], options: []);
  EmployeePermissionPram permission = EmployeePermissionPram();

  EmployeePermissionGroupModel? openedGroup;

  List<FormParam> allParams() =>
      [employee, image, name, email, dateOfBirth, status, phone, altPhone, country, state, address, shop, permission];
}

class EmployeePermissionPram extends FormParam<EmployeePermission> {
  EmployeePermission value = EmployeePermission();
  EmployeePermissionGroupModel? openedModel;
  ValidationError error = ValidationError.none();

  @override
  void dispose() {}

  @override
  void resetData(data) => value = data;

  @override
  void resetError() => error = ValidationError.none();

  @override
  void setError(String errorMsg) => error = ValidationError(errorMessage: errorMsg, isError: true);
}
