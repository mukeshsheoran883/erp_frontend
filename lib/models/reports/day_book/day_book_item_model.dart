import 'package:invently/assortment/utils/json_utils.dart';
import 'package:invently/models/common/listing_model.dart';

class DayBookItemModel implements ListingModel {
  String itemName;
  String itemCode;
  String itemDescription;
  String brandName;
  String brandCode;
  String categoryName;
  String categoryCode;
  String barCode;
  String qrCode;
  String suppliesCode;
  String suppliesName;
  String createdAt;
  String hsnCode;

  DayBookItemModel({
    required this.itemName,
    required this.itemCode,
    required this.itemDescription,
    required this.brandName,
    required this.brandCode,
    required this.categoryName,
    required this.categoryCode,
    required this.barCode,
    required this.qrCode,
    required this.suppliesCode,
    required this.suppliesName,
    required this.createdAt,
    required this.hsnCode,
    required this.disabled,
    required this.selected,
  });

  factory DayBookItemModel.fromJson(Map<String, dynamic> json) => DayBookItemModel(
    itemName: json['itemName'] ?? '',
    itemCode: json['itemCode'] ?? '',
    itemDescription: json['itemDescription'] ?? '',
    brandName: json['brandName'] ?? '',
    brandCode: json['brandCode'] ?? '',
    categoryName: json['categoryName'] ?? '',
    categoryCode: json['categoryCode'] ?? '',
    barCode: json['barCode'] ?? '',
    qrCode: json['qrCode'] ?? '',
    suppliesCode: json['suppliesCode'] ?? '',
    suppliesName: json['suppliesName'] ?? '',
    createdAt: json['createdAt'] ?? '',
    hsnCode: json['hsnCode'] ?? '',
    disabled: json['isActive'] == false,
    selected: false,
  );

  Map<String, dynamic> toJson() => {
    'hsn_code': hsnCode,
    'employee_code': itemCode,
  };

  static List<DayBookItemModel> listFromJson(Map<String, dynamic> json) =>
      List<DayBookItemModel>.from((Ju.gV(json, 'data') ?? []).map((x) => DayBookItemModel.fromJson(x)));

  @override
  bool disabled;

  @override
  bool selected;
}
