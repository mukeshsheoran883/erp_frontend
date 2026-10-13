
import 'package:invently/assortment/extensions/date_time_extensions.dart';
import 'package:invently/assortment/network/jwt_decoder.dart';
import 'package:invently/assortment/utils/json_utils.dart';
import 'package:invently/models/common/common_id_value_model.dart';
import 'package:invently/models/common/country_codes.dart';
import 'package:invently/models/common/listing_model.dart';
import 'package:invently/models/user/employee_permissions.dart';
import 'package:intl/intl.dart';

class UserModel implements ListingModel {
  String name;
  String mobileNumber;
  String mobileNumberDailCode;
  String altMobileNumberDailCode;
  String altMobileNumber;
  DateTime dob;
  List<CommonKeyValueModel> shopAccess;
  String emailId;
  String state;
  String country;
  String address;
  String profilePhotoUrl;
  String organisationName;
  bool emailVerified;
  String employeeCode;
  EmployeePermission permissions;
  bool isActive;
  CommonKeyValueModel defaultShop;

  UserModel({
    required this.name,
    required this.mobileNumberDailCode,
    required this.mobileNumber,
    required this.altMobileNumberDailCode,
    required this.altMobileNumber,
    required this.dob,
    required this.shopAccess,
    required this.emailId,
    required this.state,
    required this.country,
    required this.address,
    required this.profilePhotoUrl,
    required this.organisationName,
    required this.emailVerified,
    required this.employeeCode,
    required this.disabled,
    required this.selected,
    required this.permissions,
    required this.isActive,
    required this.defaultShop,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        name: json['name'] ?? '',
        mobileNumber: Countries.getPhoneFromPhoneNumber(phoneNumber: json['mobileNumber'] ?? ''),
        mobileNumberDailCode: Countries.getCodeFromPhoneNumber(phoneNumber: json['mobileNumber'] ?? ''),
        altMobileNumber: Countries.getPhoneFromPhoneNumber(phoneNumber: json['altMobileNumber'] ?? ''),
        altMobileNumberDailCode: Countries.getCodeFromPhoneNumber(phoneNumber: json['altMobileNumber'] ?? ''),
        dob: DateTimeUtils.getNullableDateTime(json['dob']) ?? DateTime.now(),
        shopAccess: _getAccessibleShops(json['shopAccess'] ?? []),
        emailId: json['emailId'] ?? '',
        state: json['state'] ?? '',
        country: json['country'] ?? '',
        address: json['street'] ?? '',
        profilePhotoUrl: json['profilePhotoUrl'] ?? '',
        organisationName: json['organisationName'] ?? '',
        emailVerified: json['emailVerified'] ?? false,
        employeeCode: json['employeeCode'] ?? '',
        permissions: EmployeePermission.fromJson(json['permissions'] ?? {}),
        disabled: json['isActive'] == false,
        isActive: json['isActive'] == true,
        selected: false,
        defaultShop:
            CommonKeyValueModel(id: json['defaultShop']?['shopCode'] ?? '', value: json['defaultShop']?['name'] ?? ''),
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        'mobile_number': Countries.concatCode(countryCode: mobileNumberDailCode, phoneNumber: mobileNumber),
        'alternate_mobile_number': Countries.concatCode(countryCode: altMobileNumberDailCode, phoneNumber: altMobileNumber),
        'dob': DateFormat('yyyy-MM-dd').format(dob),
        'shop_access': List<String>.from(shopAccess.map((x) => x.id)),
        'email_id': emailId,
        'state': state,
        'country': country,
        'street': address,
        'profile_photo_url': profilePhotoUrl,
        'organisation_name': organisationName,
        'email_verified': emailVerified,
        'employee_code': employeeCode,
        'permissions': permissions.toJson(),
        'is_active': isActive,
      };

  Map<String, dynamic> toJsonForDb() => {
        'name': name,
        'mobileNumber': Countries.concatCode(countryCode: mobileNumberDailCode, phoneNumber: mobileNumber),
        'altMobileNumber': Countries.concatCode(countryCode: altMobileNumberDailCode, phoneNumber: altMobileNumber),
        'dob': DateFormat('yyyy-MM-dd').format(dob),
        'shopAccess': [
          for (final i in shopAccess) {'shopCode': i.id, 'name': i.value},
        ],
        'emailId': emailId,
        'state': state,
        'country': country,
        'street': address,
        'profilePhotoUrl': profilePhotoUrl,
        'organisationName': organisationName,
        'emailVerified': emailVerified,
        'employeeCode': employeeCode,
        'permissions': permissions.toJson(),
        'isActive': isActive,
        'defaultShop': {'shopCode': defaultShop.id, 'name': defaultShop.value},
      };

  static List<UserModel> listFromJson(Map<String, dynamic> json) =>
      List<UserModel>.from((Ju.gV(json, 'data') ?? []).map((x) => UserModel.fromJson(x)));

  @override
  bool disabled;

  @override
  bool selected;

  static String? employeeCodeFromAccessToken(String token) {
    final Map<String, dynamic>? json = JwtDecoder.decode(token);
    if (json == null) return null;

    return Ju.gV(json, 'user_specific_data.employeeCode');
  }

  static String? roleFromAccessToken(String token) {
    final Map<String, dynamic>? json = JwtDecoder.decode(token);
    if (json == null) return null;

    return Ju.gV(json, 'role');
  }

  static List<CommonKeyValueModel> _getAccessibleShops(List json) {
    List<CommonKeyValueModel> shops = [];

    for (final i in json) {
      String id = (i['shopCode'] ?? '').trim();
      String value = (i['name'] ?? '').trim();

      if (id.isNotEmpty && value.isNotEmpty) {
        shops.add(CommonKeyValueModel(id: id, value: value));
      }
    }

    return shops;
  }
}
