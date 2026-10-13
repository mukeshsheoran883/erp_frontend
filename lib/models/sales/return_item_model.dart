import 'package:invently/models/common/listing_model.dart';

class ReturnItemModel implements ListingModel {
  String billNumber;
  String customerName;
  String returnReason;
  String time;
  String date;
  String totalPrice;
  List<ItemModel> items;

  @override
  bool disabled;

  @override
  bool selected;

  ReturnItemModel({
    required this.customerName,
    required this.returnReason,
    required this.date,
    required this.time,
    required this.billNumber,
    required this.items,
    required this.totalPrice,
    required this.disabled,
    required this.selected,
  });

  factory ReturnItemModel.fromJson(Map<String, dynamic> json) => ReturnItemModel(
    billNumber: json['billNumber'] ?? '',
    returnReason: json['returnReason'] ?? '',
    date: json['date'] ?? '',
    time: json['time'] ?? '',
    totalPrice: json['totalPrice'] ?? '',
    customerName: json['customerName'] ?? '',
    items: (json['items'] as List<dynamic>?)?.map((item) => ItemModel.fromJson(item)).toList() ?? [],
    disabled: json['isActive'] == false,
    selected: false,
  );

  Map<String, dynamic> toJson() => {
    'customerName': customerName,
    'items': items.map((item) => item.toJson()).toList(),
  };

  static List<ReturnItemModel> listFromJson(Map<String, dynamic> json) =>
      (json['data'] as List<dynamic>?)?.map((item) => ReturnItemModel.fromJson(item)).toList() ?? [];
}

class ItemModel implements ListingModel {
  String itemName;
  String returnReason;
  int qty;
  int tax;
  double price;
  double totalPrice;
  @override
  bool disabled;

  @override
  bool selected;

  ItemModel({
    required this.itemName,
    required this.returnReason,
    required this.qty,
    required this.tax,
    required this.price,
    required this.totalPrice,
    required this.disabled,
    required this.selected,
  });

  factory ItemModel.fromJson(Map<String, dynamic> json) => ItemModel(
    itemName: json['itemName'] ?? '',
    returnReason: json['returnReason'] ?? '',
    qty: int.tryParse(json['qty'].toString()) ?? 0,
    tax: int.tryParse(json['tax'].toString()) ?? 0,
    price: double.tryParse(json['price'].toString()) ?? 0.0,
    totalPrice: double.tryParse(json['totalPrice'].toString()) ?? 0.0,
    disabled: json['isActive'] == false,
    selected: false,
  );

  Map<String, dynamic> toJson() => {
    'itemName': itemName,
    'qty': qty,
    'tax': tax,
    'price': price,
    'totalPrice': totalPrice,
  };
}

// ---------- Add/Update (request body sent to API) ----------

class ReturnCreateModel {
  String purchaseBillNumber;
  String supplierCode;
  String itemCode;
  String returnReason;
  double quantity;
  double price;
  double tax;

  ReturnCreateModel({
    required this.purchaseBillNumber,
    required this.supplierCode,
    required this.itemCode,
    required this.returnReason,
    required this.quantity,
    required this.price,
    required this.tax,
  });

  Map<String, dynamic> toJson() => {
    'purchase_bill_number': purchaseBillNumber,
    'supplier_code': supplierCode,
    'item_code': itemCode,
    'return_reason': returnReason,
    'quantity': quantity,
    'price': price,
    'tax': tax,
  };
}