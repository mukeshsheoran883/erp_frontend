import 'package:invently/assortment/utils/json_utils.dart';
import 'package:invently/models/common/listing_model.dart';

class GstTwoModel implements ListingModel {
  String supplierGSTNo;
  String purchaseID;
  String hsnCode;
  String resellerGSTNo;
  String qty;
  String price;
  String totalPrice;
  String tax;
  String taxAmount;
  String branchName;
  String branchCode;

  GstTwoModel({
    required this.supplierGSTNo,
    required this.purchaseID,
    required this.hsnCode,
    required this.resellerGSTNo,
    required this.qty,
    required this.price,
    required this.totalPrice,
    required this.tax,
    required this.taxAmount,
    required this.branchName,
    required this.branchCode,
    required this.disabled,
    required this.selected,
  });

  factory GstTwoModel.fromJson(Map<String, dynamic> json) => GstTwoModel(
        supplierGSTNo: json['supplierGSTNo'] ?? '',
        purchaseID: json['purchaseID'] ?? '',
        hsnCode: json['hsnCode'] ?? '',
        resellerGSTNo: json['resellerGSTNo'] ?? '',
        qty: json['qty'] ?? '',
        price: json['price'] ?? '',
        totalPrice: json['totalPrice'] ?? '',
        tax: json['tax'] ?? '',
        branchName: json['branchName'] ?? '',
        taxAmount: json['taxAmount'] ?? '',
        branchCode: json['branchCode'] ?? '',
        disabled: json['isActive'] == false,
        selected: false,
      );

  Map<String, dynamic> toJson() => {
        'branch_code': branchCode,
        'hsn_code': hsnCode,
      };

  static List<GstTwoModel> listFromJson(Map<String, dynamic> json) =>
      List<GstTwoModel>.from((Ju.gV(json, 'data') ?? []).map((x) => GstTwoModel.fromJson(x)));

  @override
  bool disabled;

  @override
  bool selected;
}
