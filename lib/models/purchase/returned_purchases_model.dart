import 'package:invently/assortment/utils/json_utils.dart';
import 'package:invently/models/common/common_id_value_model.dart';
import 'package:invently/models/common/form_models.dart';
import 'package:invently/models/common/listing_model.dart';

class ReturnedPurchaseModel implements ListingModel {
  String returnId;
  String supplierName;
  String returnCode;
  String purchaseCode;
  String purchaseId;
  String itemCode;
  String itemName;
  String date;
  String time;
  String amount;
  String customerName;
  String returnIds;
  String photoUrl;
  List<ReturnedItem> items;

  ReturnedPurchaseModel({
    required this.purchaseCode,
    required this.purchaseId,
    required this.itemCode,
    required this.itemName,
    required this.returnCode,
    required this.items,
    required this.returnId,
    required this.supplierName,
    required this.date,
    required this.time,
    required this.amount,
    required this.customerName,
    required this.returnIds,
    required this.photoUrl,
    required this.disabled,
    required this.selected,
  });

  factory ReturnedPurchaseModel.fromJson(Map<String, dynamic> json) => ReturnedPurchaseModel(
        purchaseCode: json['purchaseCode'] ?? '',
        purchaseId: json['purchaseId'] ?? '',
        itemCode: json['itemCode'] ?? '',
        itemName: json['itemName'] ?? '',
        returnCode: json['return_code'] ?? '',
        returnId: json['returnId'].toString() ?? '',
        supplierName: json['supplierName'] ?? '',
        date: json['date'] ?? '',
        time: json['time'] ?? '',
        amount: json['amount'] ?? '',
        customerName: json['customerName'] ?? '',
        returnIds: json['returnIds'] ?? '',
        photoUrl: json['photoUrl'] ?? '',
        items: (json['items'] as List<dynamic>? ?? []).map((item) => ReturnedItem.fromJson(item)).toList(),
        disabled: json['isActive'] == false,
        selected: false,
      );

  Map<String, dynamic> toJson() => {
        'purchaseCode': purchaseCode,
        'purchaseId': purchaseId,
        'itemCode': itemCode,
        'itemName': itemName,
        'items': items.map((item) => item.toJson()).toList(),
      };

  static List<ReturnedPurchaseModel> listFromJson(Map<String, dynamic> json) =>
      List<ReturnedPurchaseModel>.from((Ju.gV(json, 'data') ?? []).map((x) => ReturnedPurchaseModel.fromJson(x)));

  @override
  bool disabled;

  @override
  bool selected;
}

class ReturnedItem implements ListingModel {
  CommonKeyValueParam item;
  TextFieldParam tax;
  TextFieldParam label;
  TextFieldParam totalPrice;
  TextFieldParam qty;
  String hsnCode;
  String itemName;
  String returnReason;

  @override
  bool disabled;

  @override
  bool selected;

  ReturnedItem({
    required this.item,
    required this.itemName,
    required this.returnReason,
    required this.tax,
    required this.totalPrice,
    required this.qty,
    required this.hsnCode,
    required this.label,
    required this.disabled,
    required this.selected,
  });

  factory ReturnedItem.empty() => ReturnedItem(
        item: CommonKeyValueParam(),
        label: TextFieldParam()..resetData(''),
        qty: TextFieldParam()..resetData('1'),
        totalPrice: TextFieldParam()..resetData(''),
        tax: TextFieldParam()..resetData(''),
        hsnCode: '',
        itemName: '',
        returnReason: '',
        disabled: false,
        selected: false,
      );

  factory ReturnedItem.fromJson(Map<String, dynamic> json) => ReturnedItem(
        item: CommonKeyValueParam()
          ..resetData(CommonKeyValueModel(id: json['itemCode'] ?? '', value: json['itemName'] ?? '')),
        tax: TextFieldParam()..resetData(json['tax'] ?? ''),
        totalPrice: TextFieldParam()..resetData(json['totalPrice'] ?? ''),
        qty: TextFieldParam()..resetData(json['qty'] ?? ''),
        label: TextFieldParam()..resetData(json['label'] ?? ''),
        returnReason: json['returnReason'] ?? '',
        itemName: json['itemName'] ?? '',
        hsnCode: json['hsnCode'] ?? '',
        disabled: json['isActive'] == false,
        selected: false,
      );

  Map<String, dynamic> toJson() => {
        'itemCode': item.value?.id ?? '',
        'itemName': item.value?.value ?? '',
      };
}
