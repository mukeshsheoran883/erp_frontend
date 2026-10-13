import 'package:invently/assortment/utils/json_utils.dart';
import 'package:invently/models/common/listing_model.dart';

class CustomerQuotationModel implements ListingModel {
  int customerQuotationId;
  String customerQuotationCode;
  String customerName;
  String customerPhone;
  String customerEmail;
  String status;
  DateTime createdAt;
  String shopCode;
  List<CustomerQuotationItemModel> items;

  @override
  bool disabled;

  @override
  bool selected;

  CustomerQuotationModel({
    required this.customerQuotationId,
    required this.customerQuotationCode,
    required this.customerName,
    required this.customerPhone,
    required this.customerEmail,
    required this.status,
    required this.createdAt,
    required this.shopCode,
    required this.items,
    required this.disabled,
    required this.selected,
  });

  /// GET (list + single) response
  factory CustomerQuotationModel.fromJson(Map<String, dynamic> json) => CustomerQuotationModel(
    customerQuotationId: (json['customer_quotation_id'] ?? 0).toInt(),
    customerQuotationCode: json['customer_quotation_code'] ?? '',
    customerName: json['customer_name'] ?? '',
    customerPhone: json['customer_phone'] ?? '',
    customerEmail: json['customer_email'] ?? '',
    status: json['status'] ?? '',
    createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : DateTime.now(),
    shopCode: json['shop_code'] ?? '',
    items: (json['items'] as List<dynamic>?)
        ?.map((item) => CustomerQuotationItemModel.fromJson(item))
        .toList() ??
        [],
    disabled: json['isActive'] == false,
    selected: false,
  );

  /// Add/Update (request body sent to API)
  Map<String, dynamic> toJson() => {
    'customer_name': customerName,
    'customer_phone': customerPhone,
    'customer_email': customerEmail,
    'shop_code': shopCode,
    'items': items.map((item) => item.toJson()).toList(),
  };

  static List<CustomerQuotationModel> listFromJson(Map<String, dynamic> json) =>
      List<CustomerQuotationModel>.from((Ju.gV(json, 'data') ?? []).map((x) => CustomerQuotationModel.fromJson(x)));
}

class CustomerQuotationItemModel {
  int customerQuotationItemId;
  String itemCode;
  String itemName;
  int quantity;

  CustomerQuotationItemModel({
    this.customerQuotationItemId = 0,
    required this.itemCode,
    this.itemName = '',
    required this.quantity,
  });

  factory CustomerQuotationItemModel.fromJson(Map<String, dynamic> json) => CustomerQuotationItemModel(
    customerQuotationItemId: (json['customer_quotation_item_id'] ?? 0).toInt(),
    itemCode: json['item_code'] ?? json['item_id__item_code'] ?? '',

    itemName: json['item_id__name'] ?? json['itemName'] ?? '',

    quantity: (json['quantity'] ?? 0).toInt(),
  );

  Map<String, dynamic> toJson() => {
    'item_code': itemCode,
    'quantity': quantity,
  };
}