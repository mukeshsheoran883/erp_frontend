import 'package:invently/assortment/utils/json_utils.dart';
import 'package:invently/models/common/listing_model.dart';

class QuotationsModel implements ListingModel {
  int quotationId;
  String quotationCode;
  bool purchase;
  bool sales;
  int quantity;
  String supplierName;
  String organisationId;
  DateTime createdDate;
  double totalAmount;
  String itemName;
  String description;
  String brand;
  double price;
  double tax;
  double total;


  @override
  bool disabled;

  @override
  bool selected;

  QuotationsModel({
    required this.quotationId,
    required this.quotationCode,
    required this.supplierName,
    required this.organisationId,
    required this.createdDate,
    required this.totalAmount,
    required this.itemName,
    required this.description,
    required this.brand,
    required this.quantity,
    required this.price,
    required this.tax,
    required this.total,
    required this.purchase,
    required this.sales,
    required this.disabled,
    required this.selected,
  });

  factory QuotationsModel.fromJson(Map<String, dynamic> json) => QuotationsModel(
    quotationId: (json['quotationId'] ?? 0),
    quotationCode: json['quotationCode'] ?? '',
    supplierName: json['supplierName'] ?? '',
    organisationId: (json['organisationId'] ?? ''),
    createdDate: json['createdDate'] != null ? DateTime.parse(json['createdDate']) : DateTime.now(),
    totalAmount: double.tryParse(json['totalAmount'].toString()) ?? 0.0,
    itemName: json['itemName'] ?? '',
    description: json['description'] ?? '',
    brand: json['brand'] ?? '',
    quantity: (json['quantity'] ?? 0).toInt(),
    price: double.tryParse(json['price'].toString()) ?? 0.0,
    tax: double.tryParse(json['tax'].toString()) ?? 0.0,
    total: double.tryParse(json['total'].toString()) ?? 0.0,
    purchase: json['purchase'] ?? false,
    sales: json['sales'] ?? false,
    disabled: json['isActive'] == false,
    selected: false,
  );

  static List<QuotationsModel> listFromJson(Map<String, dynamic> json) =>
      List<QuotationsModel>.from((Ju.gV(json, 'data') ?? []).map((x) => QuotationsModel.fromJson(x)));
}



class QuotationCreateModel {
  String supplierId;
  String organisationId;
  String itemId;
  String description;
  String brand;
  int quantity;
  double price;
  double tax;
  double total;
  bool purchase;
  bool sales;

  QuotationCreateModel({
    required this.supplierId,
    required this.organisationId,
    required this.itemId,
    required this.description,
    required this.brand,
    required this.quantity,
    required this.price,
    required this.tax,
    required this.total,
    required this.purchase,
    required this.sales,
  });

  Map<String, dynamic> toJson() => {
    'supplier_id': supplierId,
    'organisation_id': organisationId,
    'item_id': itemId,
    'description': description,
    'brand': brand,
    'quantity': quantity,
    'price': price,
    'tax': tax,
    'total': total,
    'purchase': purchase,
    'sales': sales,
  };
}