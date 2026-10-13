import 'package:invently/assortment/utils/json_utils.dart';
import 'package:invently/models/common/listing_model.dart';

class BrandModel implements ListingModel {
  String name;
  String brandCode;

  BrandModel({
    required this.name,
    required this.brandCode,
    required this.disabled,
    required this.selected,
  });

  factory BrandModel.fromJson(Map<String, dynamic> json) => BrandModel(
        name: json['name'] ?? '',
        brandCode: json['brandCode'] ?? '',
        disabled: json['isActive'] == false,
        selected: false,
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        'brand_code': brandCode,
      };

  static List<BrandModel> listFromJson(Map<String, dynamic> json) =>
      List<BrandModel>.from((Ju.gV(json, 'data') ?? []).map((x) => BrandModel.fromJson(x)));

  @override
  bool disabled;

  @override
  bool selected;
}
