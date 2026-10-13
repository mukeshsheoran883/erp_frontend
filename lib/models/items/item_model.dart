import 'package:invently/assortment/utils/json_utils.dart';
import 'package:invently/models/common/listing_model.dart';

// ---------- GET (list/edit prefill) ----------
class ItemModel implements ListingModel {
  int itemId;
  String name;
  String description;
  String itemCode;
  String brandCode;
  String brandName;
  String hsnCode;
  String categoryName;
  String categoryCode;
  String supplierName;
  String supplierCode;
  String barQrCode;
  DateTime createdTime;
  String taxCode;
  String taxName;
  String imageUrl;
  int noOfPackets;
  String skuCode;
  double plainPrice;
  double printedPrice;
  double moq;
  List<ItemAttributeGetModel> attributes;
  List<ItemOtherImagemodel> otherImages;

  @override
  bool disabled;

  @override
  bool selected;

  ItemModel({
    required this.itemId,
    required this.name,
    required this.description,
    required this.itemCode,
    required this.brandCode,
    required this.brandName,
    required this.hsnCode,
    required this.categoryName,
    required this.categoryCode,
    required this.supplierName,
    required this.supplierCode,
    required this.barQrCode,
    required this.createdTime,
    required this.taxCode,
    required this.taxName,
    required this.imageUrl,
    required this.noOfPackets,
    required this.skuCode,
    required this.plainPrice,
    required this.printedPrice,
    required this.moq,
    required this.attributes,
    required this.otherImages,
    required this.disabled,
    required this.selected,
  });

  factory ItemModel.fromJson(Map<String, dynamic> json) => ItemModel(
    itemId: (json['item_id'] ?? 0).toInt(),
    name: json['name'] ?? '',
    description: json['description'] ?? '',
    itemCode: json['itemCode'] ?? '',
    brandCode: json['brandCode'] ?? '',
    brandName: json['brandName'] ?? '',
    hsnCode: json['hsnCode'] ?? '',
    categoryName: json['categoryName'] ?? '',
    categoryCode: json['categoryCode'] ?? '',
    supplierName: json['supplierName'] ?? '',
    supplierCode: json['supplierCode'] ?? '',
    barQrCode: json['code'] ?? '',
    createdTime: json['createdTime'] != null ? DateTime.parse(json['createdTime']) : DateTime.now(),
    taxCode: json['taxCode'] ?? '',
    taxName: json['taxName'] ?? '',
    imageUrl: json['imageUrl'] ?? '',
    noOfPackets: (json['no_of_packets'] ?? 0).toInt(),
    skuCode: json['sku_code'] ?? '',
    plainPrice: double.tryParse(json['plain_price'].toString()) ?? 0.0,
    printedPrice: double.tryParse(json['printed_price'].toString()) ?? 0.0,
    moq: double.tryParse(json['moq'].toString()) ?? 0.0,
    attributes: (json['attributes'] as List<dynamic>?)
        ?.map((a) => ItemAttributeGetModel.fromJson(a))
        .toList() ??
        [],
    otherImages: (json['other_images'] as List<dynamic>?)
        ?.map((i) => ItemOtherImagemodel.fromJson(i))
        .toList() ??
        [],
    disabled: json['isActive'] == false,
    selected: false,
  );

  static List<ItemModel> listFromJson(Map<String, dynamic> json) =>
      List<ItemModel>.from((Ju.gV(json, 'data') ?? []).map((x) => ItemModel.fromJson(x)));
}

class ItemAttributeGetModel {
  int attributeId;
  String attributeKey;
  String attributeValue;
  String attributeUnit;

  ItemAttributeGetModel({
    required this.attributeId,
    required this.attributeKey,
    required this.attributeValue,
    required this.attributeUnit,
  });

  factory ItemAttributeGetModel.fromJson(Map<String, dynamic> json) => ItemAttributeGetModel(
    attributeId: (json['attribute_id'] ?? 0).toInt(),
    attributeKey: json['attribute_key'] ?? '',
    attributeValue: json['attribute_value'] ?? '',
    attributeUnit: json['attribute_unit'] ?? '',
  );
}

class ItemOtherImagemodel {
  int imageId;
  String imageUrl;

  ItemOtherImagemodel({required this.imageId, required this.imageUrl});

  factory ItemOtherImagemodel.fromJson(Map<String, dynamic> json) => ItemOtherImagemodel(
    imageId: (json['image_id'] ?? 0).toInt(),
    imageUrl: json['image_url'] ?? '',
  );
}


// ---------- Add/Update (request body sent to API) ----------
class ItemCreateModel {
  String name;
  String itemCode;
  String description;
  String barQrCode;
  String brandCode;
  String categoryCode;
  String supplierCode;
  String imageUrl;
  String taxCode;
  String hsnCode;
  int noOfPackets;
  String skuCode;
  String plainPrice;
  String printedPrice;
  String moq;
  List<ItemAttributeModel> attributes;
  List<String> otherImages;

  ItemCreateModel({
    required this.itemCode,
    required this.name,
    required this.description,
    required this.barQrCode,
    required this.brandCode,
    required this.categoryCode,
    required this.supplierCode,
    required this.imageUrl,
    required this.taxCode,
    required this.hsnCode,
    required this.noOfPackets,
    required this.skuCode,
    required this.plainPrice,
    required this.printedPrice,
    required this.moq,
    required this.attributes,
    required this.otherImages,
  });

  Map<String, dynamic> toJson() => {
    'item_code' : itemCode,
    'name': name,
    'description': description,
    'bar_qr_code': barQrCode,
    'brand_code': brandCode,
    'category_code': categoryCode,
    'supplier_code': supplierCode,
    'image_url': imageUrl,
    'tax_code': taxCode,
    'hsn_code': hsnCode,
    'no_of_packets': noOfPackets,
    'sku_code': skuCode,
    'plain_price': plainPrice,
    'printed_price': printedPrice,
    'moq': moq,
    'attributes': attributes.map((a) => a.toJson()).toList(),
    'other_images': otherImages,
  };
}

class ItemAttributeModel {
  String attributeKey;
  String attributeValue;
  String attributeUnit;

  ItemAttributeModel({
    required this.attributeKey,
    required this.attributeValue,
    required this.attributeUnit,
  });

  Map<String, dynamic> toJson() => {
    'attribute_key': attributeKey,
    'attribute_value': attributeValue,
    'attribute_unit': attributeUnit,
  };
}