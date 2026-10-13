import 'package:invently/models/common/common_id_value_model.dart';
import 'package:invently/models/common/form_models.dart';
import 'package:invently/models/pos/pos_model.dart';
import 'package:flutter/material.dart';

class AddPosParams {
  ApiParam<PosModel> pos = ApiParam<PosModel>();
  CommonKeyValueParam customer = CommonKeyValueParam();
  DropDownListenableParam<CommonKeyValueModel> shop =
  DropDownListenableParam<CommonKeyValueModel>(options: ValueNotifier([]));
  // CommonKeyValueParam customerQuotation = CommonKeyValueParam();
  List<PosItemEntry> items = [PosItemEntry.empty()];

  List<FormParam> allParams() => [pos, customer, shop,
    // customerQuotation
  ];
}

class PosItemEntry {
  CommonKeyValueParam item;
  TextFieldParam quantity;
  TextFieldParam price;
  TextFieldParam tax;
  TextFieldParam discount;

  PosItemEntry({
    required this.item,
    required this.quantity,
    required this.price,
    required this.tax,
    required this.discount,
  });

  factory PosItemEntry.empty() => PosItemEntry(
    item: CommonKeyValueParam(),
    quantity: TextFieldParam(),
    price: TextFieldParam(),
    tax: TextFieldParam(),
    discount: TextFieldParam(),
  );
}