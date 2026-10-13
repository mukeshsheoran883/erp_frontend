import 'package:invently/assortment/utils/json_utils.dart';
import 'package:invently/models/common/common_id_value_model.dart';
import 'package:invently/models/common/form_models.dart';
import 'package:invently/models/common/listing_model.dart';

class StockAvailableModel implements ListingModel {
  String returnId;
  String purchaseId;
  String supplierName;
  String date;
  String time;
  String amount;
  String itemName;
  String itemCode;
  String sellingPrice;
  String vendorCost;
  DateTime createdOn;
  DateTime expiryDate;
  String quantity;
  String unit;
  List<StockAvailableItemModel> items;

  StockAvailableModel({
    required this.returnId,
    required this.purchaseId,
    required this.supplierName,
    required this.date,
    required this.time,
    required this.amount,
    required this.itemName,
    required this.itemCode,
    required this.items,
    required this.sellingPrice,
    required this.unit,
    required this.quantity,
    required this.createdOn,
    required this.expiryDate,
    required this.vendorCost,
    required this.disabled,
    required this.selected,
  });

  factory StockAvailableModel.fromJson(Map<String, dynamic> json) => StockAvailableModel(
        returnId: json['returnId'] ?? '',
        purchaseId: json['purchaseId'] ?? '',
        supplierName: json['supplierName'] ?? '',
        date: json['date'] ?? '',
        time: json['time'] ?? '',
        amount: json['amount'] ?? '',
        sellingPrice: json['sellingPrice'] ?? '',
        itemName: json['itemName'] ?? '',
        itemCode: json['itemCode'] ?? '',
        vendorCost: json['vendorCost'] ?? '',
        expiryDate: json['expiryDate'] != null ? DateTime.parse(json['expiryDate']) : DateTime.now(),
        createdOn: json['createdOn'] != null ? DateTime.parse(json['createdOn']) : DateTime.now(),
        quantity: json['quantity'] ?? '',
        unit: json['unit'] ?? '',
        items: (json['items'] as List<dynamic>? ?? []).map((item) => StockAvailableItemModel.fromJson(item)).toList(),
        disabled: json['isActive'] == false,
        selected: false,
      );

  Map<String, dynamic> toJson() => {
        'purchase_id': purchaseId,
        'supplier_name': supplierName,
      };

  static List<StockAvailableModel> listFromJson(Map<String, dynamic> json) =>
      List<StockAvailableModel>.from((Ju.gV(json, 'data') ?? []).map((x) => StockAvailableModel.fromJson(x)));

  @override
  bool disabled;

  @override
  bool selected;
}

class StockAvailableItemModel implements ListingModel {
  CommonKeyValueParam branch;
  TextFieldParam qty;

  @override
  bool disabled;

  @override
  bool selected;

  StockAvailableItemModel({
    required this.branch,
    required this.qty,
    required this.disabled,
    required this.selected,
  });

  factory StockAvailableItemModel.empty() => StockAvailableItemModel(
        branch: CommonKeyValueParam()..resetData(CommonKeyValueModel(id: '', value: '')),
        qty: TextFieldParam()..resetData(''),
        disabled: false,
        selected: false,
      );

  factory StockAvailableItemModel.fromJson(Map<String, dynamic> json) => StockAvailableItemModel(
        branch: CommonKeyValueParam()
          ..resetData(CommonKeyValueModel(id: json['branchCode'] ?? '', value: json['branchName'] ?? '')),
        qty: TextFieldParam()..resetData(json['qty'] ?? ''),
        disabled: json['isActive'] == false,
        selected: false,
      );

  Map<String, dynamic> toJson() => {
        'branchCode': branch.value?.id ?? '',
        'branchName': branch.value?.value ?? '',
      };
}

class UnitModel extends CommonKeyValueModel {
  UnitModel({required super.id, required super.value});

  factory UnitModel.kiloGram() => UnitModel(id: 'kg', value: 'Kilogram');

  factory UnitModel.milliliter() => UnitModel(id: 'ml', value: 'Milliliter');

  factory UnitModel.liter() => UnitModel(id: 'l', value: 'Liter');

  factory UnitModel.gram() => UnitModel(id: 'g', value: 'Gram');

  factory UnitModel.count() => UnitModel(id: 'c', value: 'Count');

  static List<UnitModel> allUnits = [
    UnitModel.count(),
    UnitModel.gram(),
    UnitModel.kiloGram(),
    UnitModel.milliliter(),
    UnitModel.liter(),
  ];
}
