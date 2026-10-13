import 'package:invently/models/common/listing_model.dart';

class InvoiceItemModel {
  String itemCode;
  String itemName;
  double quantity;
  double price;
  double tax;
  double discount;
  double totalPrice;

  InvoiceItemModel({
    required this.itemCode,
    this.itemName = '',
    required this.quantity,
    this.price = 0,
    this.tax = 0,
    this.discount = 0,
    this.totalPrice = 0,
  });

  factory InvoiceItemModel.fromJson(Map<String, dynamic> json) => InvoiceItemModel(
    itemCode: json['item_code']?.toString() ?? '',
    itemName: json['item_name']?.toString() ?? '',
    quantity: double.tryParse(json['quantity']?.toString() ?? '0') ?? 0,
    price: double.tryParse(json['price']?.toString() ?? '0') ?? 0,
    tax: double.tryParse(json['tax']?.toString() ?? '0') ?? 0,
    discount: double.tryParse(json['discount']?.toString() ?? '0') ?? 0,
    totalPrice: double.tryParse(json['total_price']?.toString() ?? '0') ?? 0,
  );

  Map<String, dynamic> toJson() => {
    'item_code': itemCode,
    'quantity': quantity.toInt(),
    'price': price.toStringAsFixed(2),
    'tax': tax.toStringAsFixed(2),
    'discount': discount.toStringAsFixed(2),
  };
}

class BillHistoryModel implements ListingModel {
  String billNumber;
  String customerName;
  String customerPhone; // NEW
  String posCode;
  DateTime date;
  double totalPrice;
  String itemName;
  int quantity;
  String billedBy;
  String shopCode;
  String itemCode;

  /// Detail-screen only fields (not present in listing API response)
  int customerBillsId;
  double discounts;
  String discountsUnit;
  double waveOff;
  double amount;
  List<InvoiceItemModel> items;

  @override
  bool disabled;

  @override
  bool selected;

  BillHistoryModel({
    required this.billNumber,
    required this.date,
    required this.customerName,
    this.customerPhone = '', // NEW
    required this.posCode,
    required this.totalPrice,
    this.itemName = '',
    this.quantity = 0,
    this.billedBy = '',
    this.shopCode = '',
    this.itemCode = '',
    this.customerBillsId = 0,
    this.discounts = 0,
    this.discountsUnit = '',
    this.waveOff = 0,
    this.amount = 0,
    this.items = const [],
    required this.disabled,
    required this.selected,
  });

  factory BillHistoryModel.fromJson(Map<String, dynamic> json) {
    return BillHistoryModel(
      billNumber: json['billNumber']?.toString() ?? json['bill_number']?.toString() ?? '',
      date: DateTime.tryParse(
        json['createdAt']?.toString() ?? json['created_at']?.toString() ?? '',
      ) ??
          DateTime.now(),
      totalPrice: double.tryParse(
        json['totalPrice']?.toString() ?? json['amount']?.toString() ?? '0',
      ) ??
          0,
      posCode: json['posCode']?.toString() ?? '',
      itemName: json['itemName']?.toString() ?? '',
      customerName: json['customerName']?.toString() ?? json['customer_name']?.toString() ?? '',
      customerPhone: json['customerPhone']?.toString() ?? json['customer_phone']?.toString() ?? '', // NEW
      quantity: int.tryParse(json['quantity']?.toString() ?? '0') ?? 0,
      billedBy: json['billedBy']?.toString() ?? json['billed_by']?.toString() ?? '',
      shopCode: json['shopCode']?.toString() ?? json['shop_code']?.toString() ?? '',
      customerBillsId: int.tryParse(json['customer_bills_id']?.toString() ?? '0') ?? 0,
      discounts: double.tryParse(json['discounts']?.toString() ?? '0') ?? 0,
      discountsUnit: json['discounts_unit']?.toString() ?? '',
      waveOff: double.tryParse(json['wave_off']?.toString() ?? '0') ?? 0,
      amount: double.tryParse(json['amount']?.toString() ?? '0') ?? 0,
      items: (json['items'] as List<dynamic>? ?? [])
          .map((e) => InvoiceItemModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      disabled: json['isActive'] == false,
      selected: false,
    );
  }

  /// Add/Update (request body sent to API)
  Map<String, dynamic> toJson() => {
    'customer_name': customerName,
    'customer_phone': customerPhone,
    'items': items.map((item) => item.toJson()).toList(),
  };

  static List<BillHistoryModel> listFromJson(Map<String, dynamic> json) {
    return (json['data'] as List<dynamic>?)
        ?.map(
          (item) => BillHistoryModel.fromJson(
        item as Map<String, dynamic>,
      ),
    )
        .toList() ??
        [];
  }
}