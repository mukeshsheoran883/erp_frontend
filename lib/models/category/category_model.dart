import 'package:invently/assortment/utils/json_utils.dart';
import 'package:invently/models/common/listing_model.dart';

class CategoryModel implements ListingModel {
  String name;
  String categoryCode;

  CategoryModel({
    required this.name,
    required this.categoryCode,
    required this.disabled,
    required this.selected,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) => CategoryModel(
        name: json['name'] ?? '',
        categoryCode: json['categoryCode'] ?? '',
        disabled: json['isActive'] == false,
        selected: false,
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        'category_code': categoryCode,
      };

  static List<CategoryModel> listFromJson(Map<String, dynamic> json) =>
      List<CategoryModel>.from((Ju.gV(json, 'data') ?? []).map((x) => CategoryModel.fromJson(x)));

  @override
  bool disabled;

  @override
  bool selected;
}
