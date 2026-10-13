import 'package:invently/assortment/utils/json_utils.dart';
import 'package:invently/models/common/listing_model.dart';

class PosModel implements ListingModel {
  int posId;
  String posCode;
  String customerName;
  String customerCode;
  String shopCode;
  String paymentType;
  String paymentStatus;
  double amount;
  double discounts;
  String discountsUnit;
  double waveOff;
  String status;
  int customerQuotationId;
  // String customerQuotationCode;
  DateTime createdDate;
  List<PosItemModel> items;
  Dispatch dispatch;

  @override
  bool disabled;

  @override
  bool selected;

  PosModel({
    required this.posId,
    required this.posCode,
    required this.customerName,
    required this.customerCode,
    required this.shopCode,
    required this.paymentType,
    required this.paymentStatus,
    required this.amount,
    required this.discounts,
    required this.discountsUnit,
    required this.waveOff,
    required this.status,
    required this.customerQuotationId,
    // required this.customerQuotationCode,
    required this.createdDate,
    required this.items,
    required this.dispatch,
    required this.disabled,
    required this.selected,
  });

  /// GET (list + single) response
  factory PosModel.fromJson(Map<String, dynamic> json) => PosModel(
    posId: (json['pos_id'] ?? 0).toInt(),
    posCode: json['pos_code'] ?? '',
    customerName: json['customer__name'] ?? '',
    customerCode: json['customer_code'] ?? '',
    shopCode: json['shop_id__shop_code'] ?? json['shop_code'] ?? '',
    paymentType: json['payment_type'] ?? '',
    paymentStatus: json['payment_status'] ?? '',
    amount: double.tryParse(json['amount'].toString()) ?? 0.0,
    discounts: double.tryParse(json['discounts'].toString()) ?? 0.0,
    discountsUnit: json['discounts_unit'] ?? '',
    waveOff: double.tryParse(json['wave_off'].toString()) ?? 0.0,
    status: json['status'] ?? '',
    customerQuotationId: (json['customer_quotation_id'] ?? 0).toInt(),
    // customerQuotationCode: json['customer_quotation_code'] ?? '',
      dispatch: json['dispatch'] != null
          ? Dispatch.fromJson(json['dispatch']): Dispatch(logisticsCharges: '', logisticsCompany: ''),
    createdDate: json['created_date'] != null ? DateTime.parse(json['created_date']) : DateTime.now(),
    items: (json['items'] as List<dynamic>?)?.map((item) => PosItemModel.fromJson(item)).toList() ?? [],
    disabled: json['isActive'] == false,
    selected: false,
  );

  /// Add/Update (request body sent to API)
  Map<String, dynamic> toJson() => {
    'customer_code': customerCode,
    'shop_code': shopCode,
    // 'customer_quotation_code': customerQuotationCode,
    'items': items.map((item) => item.toJson()).toList(),
  };

  static List<PosModel> listFromJson(Map<String, dynamic> json) =>
      List<PosModel>.from((Ju.gV(json, 'data') ?? []).map((x) => PosModel.fromJson(x)));
}

class PosItemModel {
  int posItemId;
  String itemCode;
  String itemName;
  int quantity;
  double price;
  double tax;
  double discount;
  double total;

  PosItemModel({
    required this.posItemId,
    required this.itemCode,
    required this.itemName,
    required this.quantity,
    required this.price,
    required this.tax,
    required this.discount,
    required this.total,
  });

  factory PosItemModel.fromJson(Map<String, dynamic> json) => PosItemModel(
    posItemId: (json['pos_item_id'] ?? 0).toInt(),
    itemCode: json['item_id__item_code'] ?? json['item_code'] ?? '',
    itemName: json['item_id__name'] ?? '',
    quantity: (json['quantity'] ?? 0).toInt(),
    price: double.tryParse(json['price'].toString()) ?? 0.0,
    tax: double.tryParse(json['tax'].toString()) ?? 0.0,
    discount: double.tryParse(json['discount'].toString()) ?? 0.0,
    total: double.tryParse(json['total'].toString()) ?? 0.0,
  );

  Map<String, dynamic> toJson() => {
    'item_code': itemCode,
    'quantity': quantity,
    'price': price.toString(),
    'tax': tax.toString(),
    'discount': discount.toString(),
  };
}

class Dispatch {
  String logisticsCompany;
  String logisticsCharges;

  Dispatch({
    required this.logisticsCharges,
    required this.logisticsCompany,
  });

  factory Dispatch.fromJson(Map<String, dynamic> json) => Dispatch(
    logisticsCharges: json['logistics_charges'] ?? '',
    logisticsCompany: json['logistics_company'] ?? '',
  );

  Map<String, dynamic> toJson() => {
    'logistics_company': logisticsCompany,
    'logistics_charges': logisticsCharges,
  };
}