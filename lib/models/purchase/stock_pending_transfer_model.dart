import 'package:invently/assortment/utils/json_utils.dart';
import 'package:invently/models/common/common_id_value_model.dart';
import 'package:invently/models/common/form_models.dart';
import 'package:invently/models/common/listing_model.dart';

class StockPendingTransferModel implements ListingModel {
  String slNo;
  String requestId;
  String raisedBy;
  String date;
  String time;
  List<StockPendingTransferItemModel> items;

  StockPendingTransferModel({
    required this.slNo,
    required this.requestId,
    required this.raisedBy,
    required this.date,
    required this.time,
    required this.items,
    required this.disabled,
    required this.selected,
  });

  factory StockPendingTransferModel.fromJson(Map<String, dynamic> json) => StockPendingTransferModel(
        slNo: json['slNo'] ?? '',
        requestId: json['requestId'] ?? '',
        raisedBy: json['raisedBy'] ?? '',
        date: json['date'] ?? '',
        time: json['time'] ?? '',
        items: (json['items'] as List<dynamic>? ?? [])
            .map((item) => StockPendingTransferItemModel.fromJson(item))
            .toList(),
        disabled: json['isActive'] == false,
        selected: false,
      );

  Map<String, dynamic> toJson() => {
        'purchase_id': requestId,
        'supplier_name': slNo,
      };

  static List<StockPendingTransferModel> listFromJson(Map<String, dynamic> json) =>
      List<StockPendingTransferModel>.from(
          (Ju.gV(json, 'data') ?? []).map((x) => StockPendingTransferModel.fromJson(x)));

  @override
  bool disabled;

  @override
  bool selected;
}

class StockPendingTransferItemModel implements ListingModel {
  CommonKeyValueParam branchFrom;
  CommonKeyValueParam branchTo;
  CommonKeyValueParam item;
  TextFieldParam qty;
  TextFieldParam description;

  @override
  bool disabled;

  @override
  bool selected;

  StockPendingTransferItemModel({
    required this.item,
    required this.branchFrom,
    required this.branchTo,
    required this.description,
    required this.qty,
    required this.disabled,
    required this.selected,
  });

  factory StockPendingTransferItemModel.empty() => StockPendingTransferItemModel(
        item: CommonKeyValueParam(),
        branchFrom: CommonKeyValueParam(),
        branchTo: CommonKeyValueParam(),
        qty: TextFieldParam()..resetData('1'),
        description: TextFieldParam()..resetData(''),
        disabled: false,
        selected: false,
      );

  factory StockPendingTransferItemModel.fromJson(Map<String, dynamic> json) => StockPendingTransferItemModel(
        item: CommonKeyValueParam()
          ..resetData(CommonKeyValueModel(id: json['itemCode'] ?? '', value: json['itemName'] ?? '')),
        branchFrom: CommonKeyValueParam()
          ..resetData(CommonKeyValueModel(id: json['branchCodeFrom'] ?? '', value: json['branchNameFrom'] ?? '')),
        branchTo: CommonKeyValueParam()
          ..resetData(CommonKeyValueModel(id: json['branchCodeTo'] ?? '', value: json['branchNameTo'] ?? '')),
        qty: TextFieldParam()..resetData(json['qty'] ?? ''),
        description: TextFieldParam()..resetData(json['description'] ?? ''),
        disabled: json['isActive'] == false,
        selected: false,
      );

  Map<String, dynamic> toJson() => {
        'branchCode': branchTo.value?.id ?? '',
        'branchName': branchTo.value?.value ?? '',
      };
}
