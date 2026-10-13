import 'package:invently/models/common/common_id_value_model.dart';
import 'package:invently/models/common/form_models.dart';
import 'package:invently/models/sales/bill_history_model.dart';
import 'package:flutter/material.dart';

class AddInvoiceParams {
  ApiParam<BillHistoryModel> bill = ApiParam<BillHistoryModel>();
  CommonKeyValueParam customer = CommonKeyValueParam(); // NEW: replaces plain text customer fields
  TextFieldParam customerName = TextFieldParam();
  TextFieldParam customerPhone = TextFieldParam();
  List<InvoiceItemEntry> items = [InvoiceItemEntry.empty()]; // NEW: multiple items like POS

  List<FormParam> allParams() => [bill, customer, customerName, customerPhone];
}

class InvoiceItemEntry {
  CommonKeyValueParam item;
  TextFieldParam quantity;
  TextFieldParam price;
  TextFieldParam tax;
  TextFieldParam discount;

  InvoiceItemEntry({
    required this.item,
    required this.quantity,
    required this.price,
    required this.tax,
    required this.discount,
  });

  factory InvoiceItemEntry.empty() => InvoiceItemEntry(
    item: CommonKeyValueParam(),
    quantity: TextFieldParam()..reset('1'),
    price: TextFieldParam(),
    tax: TextFieldParam()..reset('0'),
    discount: TextFieldParam()..reset('0'),
  );
}