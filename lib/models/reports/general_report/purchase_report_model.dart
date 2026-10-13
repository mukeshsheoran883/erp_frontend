
import 'package:invently/assortment/utils/json_utils.dart';
import 'package:invently/models/common/listing_model.dart';

class PurchaseReportModel implements ListingModel {
  String itemName;
  String itemCode;
  String qty;
  String price;
  String landingCast;
  String retailPrice;
  String totalPrice;
  String supplierName;
  String supplierCode;
  String date;
  String purchaseId;
  String discount;
  String hsnCode;
  String branchName;
  String branchCode;
  String mrpPrice;

  PurchaseReportModel({
    required this.itemName,
    required this.itemCode,
    required this.qty,
    required this.price,
    required this.landingCast,
    required this.retailPrice,
    required this.totalPrice,
    required this.supplierName,
    required this.supplierCode,
    required this.date,
    required this.purchaseId,
    required this.discount,
    required this.hsnCode,
    required this.mrpPrice,
    required this.branchCode,
    required this.branchName,
    required this.disabled,
    required this.selected,
  });

  factory PurchaseReportModel.fromJson(Map<String, dynamic> json) => PurchaseReportModel(
        itemCode: json['itemCode'] ?? '',
        itemName: json['itemName'] ?? '',
        qty: json['qty'] ?? '',
        price: json['price'] ?? '',
        landingCast: json['landingCast'] ?? '',
        retailPrice: json['retailPrice'] ?? '',
        totalPrice: json['totalPrice'] ?? '',
        supplierCode: json['supplierCode'] ?? '',
        mrpPrice: json['mrpPrice'] ?? '',
        supplierName: json['supplierName'] ?? '',
        date: json['date'] ?? '',
        purchaseId: json['purchaseId'] ?? '',
        discount: json['discount'] ?? '',
        hsnCode: json['hsnCode'] ?? '',
        branchName: json['branchName'] ?? '',
        branchCode: json['branchCode'] ?? '',
        disabled: json['isActive'] == false,
        selected: false,
      );

  Map<String, dynamic> toJson() => {
        'date': date,
        'hsn_code': hsnCode,
      };

  static List<PurchaseReportModel> listFromJson(Map<String, dynamic> json) =>
      List<PurchaseReportModel>.from((Ju.gV(json, 'data') ?? []).map((x) => PurchaseReportModel.fromJson(x)));

  @override
  bool disabled;

  @override
  bool selected;
}
