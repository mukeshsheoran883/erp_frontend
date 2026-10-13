import 'package:invently/models/common/common_id_value_model.dart';
import 'package:invently/models/common/form_models.dart';
import 'package:invently/models/customer/customer_quotation_model.dart';
import 'package:flutter/material.dart';

class AddCustomerQuotationParams {
  ApiParam<CustomerQuotationModel> customerQuotation = ApiParam<CustomerQuotationModel>();
  CommonKeyValueParam customer = CommonKeyValueParam();
  TextFieldParam customerName = TextFieldParam();
  TextFieldParam customerPhone = TextFieldParam();
  TextFieldParam customerEmail = TextFieldParam();
  DropDownListenableParam<CommonKeyValueModel> shop =
  DropDownListenableParam<CommonKeyValueModel>(options: ValueNotifier([]));
  List<CustomerQuotationItemEntry> items = [CustomerQuotationItemEntry.empty()];

  List<FormParam> allParams() => [customerQuotation, customer, customerName, customerPhone, customerEmail, shop];
}

class CustomerQuotationItemEntry {
  CommonKeyValueParam item;
  TextFieldParam quantity;

  CustomerQuotationItemEntry({required this.item, required this.quantity});

  factory CustomerQuotationItemEntry.empty() =>
      CustomerQuotationItemEntry(item: CommonKeyValueParam(), quantity: TextFieldParam()..reset('1'));
}