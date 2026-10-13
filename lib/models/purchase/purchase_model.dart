import 'package:invently/assortment/utils/json_utils.dart';
import 'package:invently/models/common/common_id_value_model.dart';
import 'package:invently/models/common/form_models.dart';
import 'package:invently/models/common/listing_model.dart';
import 'package:gusto_neumorphic/gusto_neumorphic.dart';

// ---------- Used by the LIST screen (getPurchaseList) ----------

class PurchaseModel implements ListingModel {
  String purchaseCode;
  String purchaseBillNumber;
  String supplierName;
  String supplierCode;
  String itemName;
  String itemCode;
  int buyingPrice;
  int landingCost;
  int sellingPrice;
  int quantity;
  int tax;
  int billAmount;
  DateTime createdTime;
  List<AddEditPurchaseModel> items;

  PurchaseModel({
    required this.purchaseCode,
    required this.purchaseBillNumber,
    required this.supplierName,
    required this.supplierCode,
    required this.itemName,
    required this.itemCode,
    required this.createdTime,
    required this.buyingPrice,
    required this.landingCost,
    required this.sellingPrice,
    required this.quantity,
    required this.tax,
    required this.billAmount,
    required this.disabled,
    required this.selected,
    required this.items,
  });

  factory PurchaseModel.fromJson(Map<String, dynamic> json) => PurchaseModel(
    purchaseCode: json['purchaseCode'] ?? '',
    purchaseBillNumber: json['purchaseBillNumber'] ?? '',
    supplierName: json['supplierName'] ?? '',
    supplierCode: json['supplierCode'] ?? '',
    itemName: json['itemName'] ?? '',
    itemCode: json['itemCode'] ?? '',
    createdTime: json['createdTime'] != null ? DateTime.parse(json['createdTime']) : DateTime.now(),
    buyingPrice: (json['buyingPrice'] ?? 0).toInt(),
    landingCost: (json['landingCost'] ?? 0).toInt(),
    sellingPrice: (json['sellingPrice'] ?? 0).toInt(),
    tax: (json['tax'] ?? 0).toInt(),
    quantity: (json['quantity'] ?? 0).toInt(),
    billAmount: (json['billAmount'] ?? 0).toInt(),
    disabled: json['isActive'] == false,
    items: [],
    selected: false,
  );

  Map<String, dynamic> toJson() => {
    'purchase_bill_number': purchaseBillNumber,
    'supplier_code': supplierCode,
    'item_code': itemCode,
    'buying_price': buyingPrice,
    'landing_cost': landingCost,
    'selling_price': sellingPrice,
    'tax': tax,
    'quantity': quantity,
    'bill_amount': billAmount,
  };

  static List<PurchaseModel> listFromJson(Map<String, dynamic> json) =>
      List<PurchaseModel>.from((Ju.gV(json, 'data') ?? []).map((x) => PurchaseModel.fromJson(x)));

  @override
  bool disabled;

  @override
  bool selected;
}

// ---------- Used by the EDIT screen (getPurchase — single, flat response) ----------

class PurchaseEditModel {
  String purchaseBillNumber;
  String supplierName;
  String itemName;
  int buyingPrice;
  int landingCost;
  int sellingPrice;
  int tax;
  int quantity;
  int billAmount;
  DateTime createdDateTime;

  PurchaseEditModel({
    required this.purchaseBillNumber,
    required this.supplierName,
    required this.itemName,
    required this.buyingPrice,
    required this.landingCost,
    required this.sellingPrice,
    required this.tax,
    required this.quantity,
    required this.billAmount,
    required this.createdDateTime,
  });

  factory PurchaseEditModel.fromJson(Map<String, dynamic> json) => PurchaseEditModel(
    purchaseBillNumber: json['purchaseBillNumber'] ?? '',
    supplierName: json['supplierName'] ?? '',
    itemName: json['itemName'] ?? '',
    buyingPrice: (json['buyingPrice'] ?? 0).toInt(),
    landingCost: (json['landingCost'] ?? 0).toInt(),
    sellingPrice: (json['sellingPrice'] ?? 0).toInt(),
    tax: (json['tax'] ?? 0).toInt(),
    quantity: (json['quantity'] ?? 0).toInt(),
    billAmount: (json['billAmount'] ?? 0).toInt(),
    createdDateTime:
    json['createdDateTime'] != null ? DateTime.parse(json['createdDateTime']) : DateTime.now(),
  );
}

// ---------- Form state (used in the add/edit screen UI) ----------

class AddEditPurchaseModel {
  CommonKeyValueParam item;
  TextFieldParam buyingPrice;
  TextFieldParam tax;
  TextFieldParam landingCost;
  TextFieldParam sellingPrice;
  TextFieldParam quantity;
  DropDownListenableParam<CommonKeyValueModel> units;
  DateTimeParam expiry;
  List<BranchSplitEntry> branchSplits;

  AddEditPurchaseModel({
    required this.item,
    required this.buyingPrice,
    required this.landingCost,
    required this.sellingPrice,
    required this.units,
    required this.quantity,
    required this.tax,
    required this.expiry,
    required this.branchSplits,
  });

  factory AddEditPurchaseModel.empty() => AddEditPurchaseModel(
    item: CommonKeyValueParam(),
    buyingPrice: TextFieldParam(),
    landingCost: TextFieldParam(),
    tax: TextFieldParam(),
    quantity: TextFieldParam()..reset('1'),
    sellingPrice: TextFieldParam(),
    units: DropDownListenableParam<CommonKeyValueModel>(options: ValueNotifier(UnitModel.allUnits)),
    expiry: DateTimeParam(),
    branchSplits: [BranchSplitEntry.empty()],
  );

  factory AddEditPurchaseModel.fromExisting(PurchaseEditModel purchase) {
    final model = AddEditPurchaseModel.empty();
    model.item.reset(CommonKeyValueModel(id: purchase.itemName, value: purchase.itemName));
    model.buyingPrice.controller.text = purchase.buyingPrice.toString();
    model.landingCost.controller.text = purchase.landingCost.toString();
    model.tax.controller.text = purchase.tax.toString();
    model.sellingPrice.controller.text = purchase.sellingPrice.toString();
    model.quantity.reset(purchase.quantity.toString());
    return model;
  }
}

class BranchSplitEntry {
  CommonKeyValueParam branch;
  TextFieldParam quantity;

  BranchSplitEntry({required this.branch, required this.quantity});

  factory BranchSplitEntry.empty() =>
      BranchSplitEntry(branch: CommonKeyValueParam(), quantity: TextFieldParam()..reset('0'));
}

class UnitModel extends CommonKeyValueModel {
  UnitModel({required super.id, required super.value});

  factory UnitModel.litre() => UnitModel(id: 'Litre', value: 'Litre');

  factory UnitModel.count() => UnitModel(id: 'Count', value: 'Count');

  factory UnitModel.packet() => UnitModel(id: 'Packet', value: 'Packet');

  factory UnitModel.box() => UnitModel(id: 'Box', value: 'Box');

  factory UnitModel.dozen() => UnitModel(id: 'Dozen', value: 'Dozen');

  factory UnitModel.pair() => UnitModel(id: 'Pair', value: 'Pair');

  factory UnitModel.set() => UnitModel(id: 'Set', value: 'Set');

  factory UnitModel.meter() => UnitModel(id: 'Meter', value: 'Meter');

  factory UnitModel.roll() => UnitModel(id: 'Roll', value: 'Roll');

  factory UnitModel.piece() => UnitModel(id: 'Piece', value: 'Piece');

  factory UnitModel.bag() => UnitModel(id: 'Bag', value: 'Bag');

  factory UnitModel.unit() => UnitModel(id: 'Unit', value: 'Unit');

  factory UnitModel.gram() => UnitModel(id: 'Gram', value: 'Gram');

  factory UnitModel.kiloGram() => UnitModel(id: 'Kilogram', value: 'Kilogram');

  factory UnitModel.milligram() => UnitModel(id: 'Milligram', value: 'Milligram');

  factory UnitModel.ton() => UnitModel(id: 'Ton', value: 'Ton');

  static List<UnitModel> allUnits = [
    UnitModel.litre(),
    UnitModel.count(),
    UnitModel.packet(),
    UnitModel.box(),
    UnitModel.dozen(),
    UnitModel.pair(),
    UnitModel.set(),
    UnitModel.meter(),
    UnitModel.roll(),
    UnitModel.piece(),
    UnitModel.bag(),
    UnitModel.unit(),
    UnitModel.gram(),
    UnitModel.kiloGram(),
    UnitModel.milligram(),
    UnitModel.ton(),
  ];
}

// ---------- Add/Update (request body sent to API) ----------

class PurchaseCreateModel {
  String purchaseBillNumber;
  String supplierCode;
  List<PurchaseItemRequestModel> items;
  double billAmount;

  PurchaseCreateModel({
    required this.purchaseBillNumber,
    required this.supplierCode,
    required this.items,
    required this.billAmount,
  });

  Map<String, dynamic> toJson() => {
    'purchase_bill_number': purchaseBillNumber,
    'supplier_code': supplierCode,
    'items': items.map((item) => item.toJson()).toList(),
    'bill_amount': billAmount,
  };
}

class PurchaseItemRequestModel {
  String itemCode;
  int buyingPrice;
  int landingCost;
  int sellingPrice;
  int tax;
  int quantity;
  String unit;
  DateTime expiry;
  List<BranchSplitModel> branchSplit;

  PurchaseItemRequestModel({
    required this.itemCode,
    required this.buyingPrice,
    required this.landingCost,
    required this.sellingPrice,
    required this.tax,
    required this.quantity,
    required this.unit,
    required this.expiry,
    required this.branchSplit,
  });

  Map<String, dynamic> toJson() => {
    'item_code': itemCode,
    'buying_price': buyingPrice,
    'landing_cost': landingCost,
    'selling_price': sellingPrice,
    'tax': tax,
    'quantity': quantity,
    'unit': unit,
    'expiry': expiry.toIso8601String(),
    'branch_split': branchSplit.map((split) => split.toJson()).toList(),
  };
}

class BranchSplitModel {
  String branchCode;
  double quantity;

  BranchSplitModel({
    required this.branchCode,
    required this.quantity,
  });

  Map<String, dynamic> toJson() => {
    'branch_code': branchCode,
    'quantity': quantity,
  };
}

// ---------- Kept as-is from your original file (unused by this flow but preserved) ----------

class PurchaseDetailModel implements ListingModel {
  String supplier;
  String purchaseNumber;
  String date;
  String time;
  String photoUrl;
  List<PurchaseItemModel> items;

  @override
  bool disabled;

  @override
  bool selected;

  PurchaseDetailModel({
    required this.supplier,
    required this.purchaseNumber,
    required this.date,
    required this.time,
    required this.photoUrl,
    required this.items,
    required this.disabled,
    required this.selected,
  });

  factory PurchaseDetailModel.fromJson(Map<String, dynamic> json) => PurchaseDetailModel(
    supplier: json['supplierName'] ?? '',
    purchaseNumber: json['purchaseNumber'] ?? '',
    date: json['date'] ?? '',
    time: json['time'] ?? '',
    photoUrl: json['photoUrl'] ?? '',
    items: (json['items'] as List<dynamic>?)?.map((item) => PurchaseItemModel.fromJson(item)).toList() ?? [],
    disabled: json['isActive'] == false,
    selected: false,
  );

  Map<String, dynamic> toJson() => {
    'supplier': supplier,
    'purchaseNumber': purchaseNumber,
    'date': date,
    'time': time,
    'photoUrl': photoUrl,
    'items': items.map((item) => item.toJson()).toList(),
  };

  static List<PurchaseDetailModel> listFromJson(Map<String, dynamic> json) =>
      (json['data'] as List<dynamic>?)?.map((item) => PurchaseDetailModel.fromJson(item)).toList() ?? [];
}

class PurchaseItemModel implements ListingModel {
  String itemName;
  int qty;
  double tax;
  double buyingPrice;
  double landingCost;
  double sellingPrice;
  double totalPrice;
  DateTime createdDateTime;

  @override
  bool disabled;

  @override
  bool selected;

  PurchaseItemModel({
    required this.itemName,
    required this.qty,
    required this.tax,
    required this.buyingPrice,
    required this.landingCost,
    required this.sellingPrice,
    required this.totalPrice,
    required this.createdDateTime,
    required this.disabled,
    required this.selected,
  });

  factory PurchaseItemModel.fromJson(Map<String, dynamic> json) {
    final qty = double.tryParse(json['quantity'].toString()) ?? 0.0;
    final selling = double.tryParse(json['sellingPrice'].toString()) ?? 0.0;
    return PurchaseItemModel(
      itemName: json['itemName'] ?? '',
      qty: qty.toInt(),
      tax: double.tryParse(json['tax'].toString()) ?? 0.0,
      buyingPrice: double.tryParse(json['buyingPrice'].toString()) ?? 0.0,
      landingCost: double.tryParse(json['landingCost'].toString()) ?? 0.0,
      sellingPrice: selling,
      totalPrice: selling * qty,
      createdDateTime: DateTime.tryParse(json['createdDateTime']?.toString() ?? '') ?? DateTime.now(),
      disabled: json['isActive'] == false,
      selected: false,
    );
  }

  Map<String, dynamic> toJson() => {
    'itemName': itemName,
    'quantity': qty,
    'tax': tax,
    'buyingPrice': buyingPrice,
    'landingCost': landingCost,
    'sellingPrice': sellingPrice,
  };
}