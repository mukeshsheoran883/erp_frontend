import 'package:invently/assortment/extensions/date_time_extensions.dart';
import 'package:invently/assortment/utils/json_utils.dart';
import 'package:invently/models/common/country_codes.dart';
import 'package:invently/models/common/listing_model.dart';
import 'package:intl/intl.dart';

class BranchModel implements ListingModel {
  String name;
  String mobileNumber;
  String mobileNumberDailCode;
  DateTime createdDateTime;
  String emailId;
  String state;
  String country;
  String street;
  String isActiveChangeTime;
  String organisationName;
  String shopCode;
  String type;
  String website;
  String altMobileNumber;
  String altMobileNumberDailCode;

  BranchModel({
    required this.name,
    required this.mobileNumber,
    required this.mobileNumberDailCode,
    required this.createdDateTime,
    required this.emailId,
    required this.state,
    required this.country,
    required this.street,
    required this.isActiveChangeTime,
    required this.organisationName,
    required this.shopCode,
    required this.disabled,
    required this.selected,
    required this.type,
    required this.website,
    required this.altMobileNumber,
    required this.altMobileNumberDailCode,
  });

  factory BranchModel.fromJson(Map<String, dynamic> json) => BranchModel(
        name: json['name'] ?? '',
        mobileNumber: Countries.getPhoneFromPhoneNumber(phoneNumber: json['mobileNumber'] ?? ''),
        mobileNumberDailCode: Countries.getCodeFromPhoneNumber(phoneNumber: json['mobileNumber'] ?? ''),
        createdDateTime: DateTimeUtils.getNullableDateTime(json['dob']) ?? DateTime.now(),
        emailId: json['emailId'] ?? '',
        state: json['state'] ?? '',
        country: json['country'] ?? '',
        street: json['street'] ?? '',
        isActiveChangeTime: json['isActiveChangeTime'] ?? '',
        organisationName: json['organisationName'] ?? '',
        shopCode: json['shopCode'] ?? '',
        type: json['type'] ?? '',
        website: json['website'] ?? '',
        altMobileNumber: Countries.getPhoneFromPhoneNumber(phoneNumber: json['altMobileNumber'] ?? ''),
        altMobileNumberDailCode: Countries.getCodeFromPhoneNumber(phoneNumber: json['altMobileNumber'] ?? ''),
        disabled: json['isActive'] == false,
        selected: false,
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        'mobile_number': Countries.concatCode(countryCode: mobileNumberDailCode, phoneNumber: mobileNumber),
        'website': website,
        'alt_mobile_number': Countries.concatCode(countryCode: altMobileNumberDailCode, phoneNumber: altMobileNumber),
        'dob': DateFormat('yyyy-MM-dd').format(createdDateTime),
        'email_id': emailId,
        'type': type,
        'state': state,
        'country': country,
        'street': street,
        shopCode.isEmpty ? '' : 'shop_code': shopCode.isEmpty ? null : shopCode,
      };

  static List<BranchModel> listFromJson(Map<String, dynamic> json) =>
      List<BranchModel>.from((Ju.gV(json, 'data') ?? []).map((x) => BranchModel.fromJson(x)));

  @override
  bool disabled;

  @override
  bool selected;
}
