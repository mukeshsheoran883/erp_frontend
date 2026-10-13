
import 'package:invently/assortment/utils/json_utils.dart';
import 'package:invently/models/common/listing_model.dart';

class SalesReportModel implements ListingModel {
  String billNumber;
  String billDate;
  String itemName;
  String hsnCode;
  String itemCode;
  String qty;
  String price;
  String totalPrice;
  String customerName;
  String customerCode;
  String branchName;
  String branchCode;

  SalesReportModel({
    required this.billDate,
    required this.branchCode,
    required this.itemName,
    required this.itemCode,
    required this.branchName,
    required this.hsnCode,
    required this.totalPrice,
    required this.billNumber,
    required this.customerName,
    required this.qty,
    required this.customerCode,
    required this.price,
    required this.disabled,
    required this.selected,
  });

  factory SalesReportModel.fromJson(Map<String, dynamic> json) => SalesReportModel(
        customerCode: json['customerCode'] ?? '',
        qty: json['qty'] ?? '',
        itemName: json['itemName'] ?? '',
        itemCode: json['itemCode'] ?? '',
        totalPrice: json['totalPrice'] ?? '',
        branchName: json['branchName'] ?? '',
        branchCode: json['branchCode'] ?? '',
        hsnCode: json['hsnCode'] ?? '',
        billDate: json['billDate'] ?? '',
        billNumber: json['billNumber'] ?? '',
        customerName: json['customerName'] ?? '',
        price: json['price'] ?? '',
        disabled: json['isActive'] == false,
        selected: false,
      );

  Map<String, dynamic> toJson() => {
        'date': itemName,
        'hsn_code': itemCode,
      };

  static List<SalesReportModel> listFromJson(Map<String, dynamic> json) =>
      List<SalesReportModel>.from((Ju.gV(json, 'data') ?? []).map((x) => SalesReportModel.fromJson(x)));

  @override
  bool disabled;

  @override
  bool selected;
}
