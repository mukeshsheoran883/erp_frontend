import 'package:invently/models/administration/organization_model.dart';
import 'package:invently/models/administration/organization_plan_model.dart';
import 'package:invently/models/common/form_models.dart';
import 'package:flutter/material.dart';

class AddAdministrationParams {
  ApiParam<AdministrationModel> organization = ApiParam<AdministrationModel>();
  FileParam image = FileParam();
  TextFieldParam name = TextFieldParam();
  TextFieldParam contactPersonName = TextFieldParam();
  TextFieldParam contactEmailId = TextFieldParam();
  TextFieldParam branchCount = TextFieldParam();
  TextFieldParam userCount = TextFieldParam();
  PhoneNumberParam phone = PhoneNumberParam();
  PhoneNumberParam altPhone = PhoneNumberParam();
  DropDownListenableParam<OrganizationPlanModel> plan =
      DropDownListenableParam<OrganizationPlanModel>(options: ValueNotifier([]));
  DateTimeParam expiryDate = DateTimeParam();
  CheckboxParam paymentGateway = CheckboxParam();
  CheckboxParam approval = CheckboxParam();

  List<FormParam> allParams() => [
        organization,
        image,
        name,
        contactPersonName,
        phone,
        altPhone,
        contactEmailId,
        expiryDate,
        paymentGateway,
        approval,
        branchCount,
        userCount,
      ];
}
