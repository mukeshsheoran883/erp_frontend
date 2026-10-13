import 'package:invently/models/common/common_id_value_model.dart';
import 'package:invently/models/common/form_models.dart';
import 'package:invently/models/items/item_model.dart';
import 'package:flutter/material.dart';

class AddItemsParams {
  ApiParam<ItemModel> item = ApiParam<ItemModel>();
  FileParam image = FileParam();
  TextFieldParam name = TextFieldParam();
  TextFieldParam hsnCode = TextFieldParam();
  TextFieldParam qrCode = TextFieldParam();
  CheckboxParam barQrAuto = CheckboxParam();
  TextFieldParam description = TextFieldParam();
  DateTimeParam date = DateTimeParam();
  DropDownListenableParam<CommonKeyValueModel> brand =
  DropDownListenableParam<CommonKeyValueModel>(options: ValueNotifier([]));
  DropDownListenableParam<CommonKeyValueModel> category =
  DropDownListenableParam<CommonKeyValueModel>(options: ValueNotifier([]));
  DropDownListenableParam<CommonKeyValueModel> supplier =
  DropDownListenableParam<CommonKeyValueModel>(options: ValueNotifier([]));
  DropDownListenableParam<CommonKeyValueModel> tax =
  DropDownListenableParam<CommonKeyValueModel>(options: ValueNotifier([]));

  // ---- New fields from POST body ----
  TextFieldParam noOfPackets = TextFieldParam()..reset('1');
  TextFieldParam skuCode = TextFieldParam();
  TextFieldParam plainPrice = TextFieldParam();
  TextFieldParam printedPrice = TextFieldParam();
  TextFieldParam moq = TextFieldParam()..reset('1');
  List<AttributeEntry> attributes = [AttributeEntry.empty()];
  List<FileParam> otherImages = [];

  List<FormParam> allParams() => [
    item,
    image,
    name,
    hsnCode,
    tax,
    qrCode,
    barQrAuto,
    description,
    date,
    brand,
    category,
    supplier,
    noOfPackets,
    skuCode,
    plainPrice,
    printedPrice,
    moq,
  ];
}

class AttributeEntry {
  TextFieldParam key;
  TextFieldParam value;
  TextFieldParam unit;

  AttributeEntry({required this.key, required this.value, required this.unit});

  factory AttributeEntry.empty() =>
      AttributeEntry(key: TextFieldParam(), value: TextFieldParam(), unit: TextFieldParam());
}