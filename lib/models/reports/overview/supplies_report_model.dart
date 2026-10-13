import 'package:invently/assortment/utils/json_utils.dart';
import 'package:invently/models/common/listing_model.dart';

class OverviewSuppliesModel implements ListingModel {
  String supplierName;
  String supplierCode;
  String street;
  String state;
  String country;
  String gstNo;
  String mobileNo;
  String altMobileNo;
  String idNo;
  String idType;

  OverviewSuppliesModel({
    required this.supplierName,
    required this.supplierCode,
    required this.street,
    required this.state,
    required this.country,
    required this.gstNo,
    required this.mobileNo,
    required this.altMobileNo,
    required this.idNo,
    required this.idType,
    required this.selected,
    required this.disabled,
  });

  factory OverviewSuppliesModel.fromJson(Map<String, dynamic> json) => OverviewSuppliesModel(
    supplierName: json['supplierName'] ?? '',
    supplierCode: json['supplierCode'] ?? '',
    street: json['street'] ?? '',
    state: json['state'] ?? '',
    gstNo: json['gstNo'] ?? '',
    country: json['country'] ?? '',
    mobileNo: json['mobileNo'] ?? '',
    altMobileNo: json['altMobileNo'] ?? '',
    idNo: json['idNo'] ?? '',
    idType: json['idType'] ?? '',
    disabled: json['isActive'] == false,
    selected: false,
  );

  Map<String, dynamic> toJson() => {
    'supplier_name': supplierName,
    'supplier_code': supplierCode,
  };

  static List<OverviewSuppliesModel> listFromJson(Map<String, dynamic> json) =>
      List<OverviewSuppliesModel>.from((Ju.gV(json, 'data') ?? []).map((x) => OverviewSuppliesModel.fromJson(x)));

  @override
  bool disabled;

  @override
  bool selected;
}
