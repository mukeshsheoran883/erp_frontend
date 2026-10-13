
import 'package:invently/assortment/utils/json_utils.dart';
import 'package:invently/models/common/listing_model.dart';

class QuotationReportModel implements ListingModel {
  String quotationId;
  String customerName;
  String customerCode;
  String itemName;
  String itemCode;
  String hsnCode;
  String qty;
  String price;
  String totalPrice;
  String date;
  String quotationType;

  QuotationReportModel({
    required this.date,
    required this.totalPrice,
    required this.itemName,
    required this.itemCode,
    required this.qty,
    required this.customerCode,
    required this.quotationId,
    required this.hsnCode,
    required this.quotationType,
    required this.customerName,
    required this.price,
    required this.disabled,
    required this.selected,
  });

  factory QuotationReportModel.fromJson(Map<String, dynamic> json) => QuotationReportModel(
        date: json['date'] ?? '',
        quotationType: json['quotationType'] ?? '',
        itemName: json['itemName'] ?? '',
        itemCode: json['itemCode'] ?? '',
        quotationId: json['quotationId'] ?? '',
        customerCode: json['customerCode'] ?? '',
        hsnCode: json['hsnCode'] ?? '',
        qty: json['qty'] ?? '',
        totalPrice: json['totalPrice'] ?? '',
        customerName: json['customerName'] ?? '',
        price: json['price'] ?? '',
        disabled: json['isActive'] == false,
        selected: false,
      );

  Map<String, dynamic> toJson() => {
        'date': customerCode,
        'hsn_code': customerName,
      };

  static List<QuotationReportModel> listFromJson(Map<String, dynamic> json) =>
      List<QuotationReportModel>.from((Ju.gV(json, 'data') ?? []).map((x) => QuotationReportModel.fromJson(x)));

  @override
  bool disabled;

  @override
  bool selected;
}
