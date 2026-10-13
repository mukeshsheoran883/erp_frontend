import 'package:invently/assortment/utils/json_utils.dart';
import 'package:invently/models/common/listing_model.dart';

class GstOneModel implements ListingModel {
  String date;
  String hsnCode;
  String itemName;
  String itemCode;
  String brandName;
  String brandCode;
  String billNumber;
  String customerName;
  String price;

  GstOneModel({
    required this.date,
    required this.hsnCode,
    required this.itemName,
    required this.itemCode,
    required this.brandName,
    required this.brandCode,
    required this.billNumber,
    required this.customerName,
    required this.price,
    required this.disabled,
    required this.selected,
  });

  factory GstOneModel.fromJson(Map<String, dynamic> json) => GstOneModel(
        date: json['date'] ?? '',
        hsnCode: json['hsnCode'] ?? '',
        itemName: json['itemName'] ?? '',
        itemCode: json['itemCode'] ?? '',
        brandName: json['brandName'] ?? '',
        brandCode: json['brandCode'] ?? '',
        billNumber: json['billNumber'] ?? '',
        customerName: json['customerName'] ?? '',
        price: json['price'] ?? '',
        disabled: json['isActive'] == false,
        selected: false,
      );

  Map<String, dynamic> toJson() => {
        'date': date,
        'hsn_code': hsnCode,
      };

  static List<GstOneModel> listFromJson(Map<String, dynamic> json) =>
      List<GstOneModel>.from((Ju.gV(json, 'data') ?? []).map((x) => GstOneModel.fromJson(x)));

  @override
  bool disabled;

  @override
  bool selected;
}
