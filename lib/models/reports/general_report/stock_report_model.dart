
import 'package:invently/assortment/utils/json_utils.dart';
import 'package:invently/models/common/listing_model.dart';

class StockReportModel implements ListingModel {
  String purchaseId;
  String itemName;
  String itemCode;
  String qty;
  String date;
  String price;
  String hsnCode;
  String branchName;
  String branchCode;

  StockReportModel({
    required this.itemName,
    required this.itemCode,
    required this.qty,
    required this.price,
    required this.date,
    required this.purchaseId,
    required this.hsnCode,
    required this.branchCode,
    required this.branchName,
    required this.disabled,
    required this.selected,
  });

  factory StockReportModel.fromJson(Map<String, dynamic> json) => StockReportModel(
        itemCode: json['itemCode'] ?? '',
        itemName: json['itemName'] ?? '',
        qty: json['qty'] ?? '',
        price: json['price'] ?? '',
        date: json['date'] ?? '',
        purchaseId: json['purchaseId'] ?? '',
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

  static List<StockReportModel> listFromJson(Map<String, dynamic> json) =>
      List<StockReportModel>.from((Ju.gV(json, 'data') ?? []).map((x) => StockReportModel.fromJson(x)));

  @override
  bool disabled;

  @override
  bool selected;
}
