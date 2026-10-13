
import 'package:invently/assortment/extensions/date_time_extensions.dart';
import 'package:invently/assortment/utils/json_utils.dart';
import 'package:invently/models/common/listing_model.dart';

class ShopModel implements ListingModel {
  String name;
  String organisationName;
  DateTime createdDateTime;
  String state;
  String street;
  String country;
  String shopCode;
  String website;
  String emailId;
  String mobileNumber;
  String altMobileNumber;
  String type;

  ShopModel({
    required this.name,
    required this.organisationName,
    required this.createdDateTime,
    required this.state,
    required this.street,
    required this.country,
    required this.shopCode,
    required this.website,
    required this.emailId,
    required this.mobileNumber,
    required this.altMobileNumber,
    required this.type,
    required this.selected,
    required this.disabled,
  });

  factory ShopModel.fromJson(Map<String, dynamic> json) => ShopModel(
        name: json['name'] ?? '',
        organisationName: json['organisationName'] ?? '',
        createdDateTime: DateTimeUtils.getNullableDateTime(json['createdDateTime']) ?? DateTime.now(),
        state: json['state'] ?? '',
        street: json['street'] ?? '',
        country: json['country'] ?? '',
        shopCode: json['shopCode'] ?? '',
        website: json['website'] ?? '',
        emailId: json['emailId'] ?? '',
        mobileNumber: json['mobileNumber'] ?? '',
        altMobileNumber: json['altMobileNumber'] ?? '',
        type: json['type'] ?? '',
        disabled: json['isActive'] == false,
        selected: false,
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        'is_active': !disabled,
        'organisation_name': organisationName,
        'created_date_time': createdDateTime.toIso8601String(),
        'state': state,
        'street': street,
        'country': country,
        'shop_code': shopCode,
        'website': website,
        'email_id': emailId,
        'mobile_number': mobileNumber,
        'alt_mobile_number': altMobileNumber,
        'type': type,
      };

  static List<ShopModel> listFromJson(Map<String, dynamic> json) =>
      List<ShopModel>.from((Ju.gV(json, 'data') ?? []).map((x) => ShopModel.fromJson(x)));

  @override
  bool disabled;

  @override
  bool selected;
}
