import 'package:invently/assortment/utils/json_utils.dart';
import 'package:invently/models/common/listing_model.dart';

class DayBookInventoryBalanceModel implements ListingModel {
  String itemName;
  String itemCode;
  String brandName;
  String brandCode;
  String price;
  String qtyLeft;
  String itemDescription;

  DayBookInventoryBalanceModel({
    required this.itemName,
    required this.itemCode,
    required this.brandName,
    required this.brandCode,
    required this.price,
    required this.qtyLeft,
    required this.itemDescription,
    required this.selected,
    required this.disabled,
  });

  factory DayBookInventoryBalanceModel.fromJson(Map<String, dynamic> json) => DayBookInventoryBalanceModel(
    itemName: json['itemName'] ?? '',
    itemCode: json['itemCode'] ?? '',
    brandName: json['brandName'] ?? '',
    brandCode: json['brandCode'] ?? '',
    price: json['price'] ?? '',
    qtyLeft: json['qtyLeft'] ?? '',
    itemDescription: json['itemDescription'] ?? '',
    disabled: json['isActive'] == false,
    selected: false,
  );

  Map<String, dynamic> toJson() => {
    'item_name': itemName,
    'item_code': itemCode,
  };

  static List<DayBookInventoryBalanceModel> listFromJson(Map<String, dynamic> json) =>
      List<DayBookInventoryBalanceModel>.from(
        (Ju.gV(json, 'data') ?? []).map((x) => DayBookInventoryBalanceModel.fromJson(x)),
      );

  @override
  bool disabled;

  @override
  bool selected;
}
