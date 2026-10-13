import 'package:invently/assortment/extensions/date_time_extensions.dart';
import 'package:invently/assortment/utils/json_utils.dart';
import 'package:invently/models/common/country_codes.dart';
import 'package:invently/models/common/listing_model.dart';
import 'package:intl/intl.dart';

class AdministrationModel implements ListingModel {
  String name;
  String organisationId;
  DateTime createdDateTime;
  String state;
  String street;
  String country;
  int shopCount;
  int employeeCount;
  String imageUrl;
  String contactPersonName;
  String email;
  String mobileNumber;
  String mobileNumberDailCode;
  String altMobileNumberDailCode;
  String altMobileNumber;
  DateTime planExpiry;
  bool paymentGateway;
  bool approval;
  String plan;

  AdministrationModel({
    required this.organisationId,
    required this.name,
    required this.createdDateTime,
    required this.state,
    required this.country,
    required this.street,
    required this.disabled,
    required this.selected,
    required this.employeeCount,
    required this.shopCount,
    required this.imageUrl,
    required this.contactPersonName,
    required this.email,
    required this.mobileNumberDailCode,
    required this.mobileNumber,
    required this.altMobileNumberDailCode,
    required this.altMobileNumber,
    required this.planExpiry,
    required this.paymentGateway,
    required this.approval,
    required this.plan,
  });

  factory AdministrationModel.fromJson(Map<String, dynamic> json) =>
      AdministrationModel(
        name: json['companyName'] ?? '',
        organisationId: json['organisation_id']?.toString() ?? '',
        createdDateTime:
        DateTimeUtils.getNullableDateTime(json['createdDateTime']) ??
            DateTime.now(),
        state: json['state'] ?? '',
        country: json['country'] ?? '',
        street: json['street'] ?? '',
        disabled: json['is_active'] == false,
        shopCount: json['shopCount'] ?? 0,
        employeeCount: json['employeeCount'] ?? 0,
        selected: false,
        imageUrl: json['imageUrl'] ?? '',
        contactPersonName: json['ownerName'] ?? '',
        email: json['email'] ?? '',
        plan: json['plan'] ?? '',
        paymentGateway: json['paymentGateway'] ?? false,
        approval: json['approval'] ?? false,
        mobileNumber: Countries.getPhoneFromPhoneNumber(
            phoneNumber: json['ownerMobile'] ?? ''),
        mobileNumberDailCode: Countries.getCodeFromPhoneNumber(
            phoneNumber: json['ownerMobile'] ?? ''),
        altMobileNumber: Countries.getPhoneFromPhoneNumber(
            phoneNumber: json['ownerAlternateMobile'] ?? ''),
        altMobileNumberDailCode: Countries.getCodeFromPhoneNumber(
            phoneNumber: json['ownerAlternateMobile'] ?? ''),
        planExpiry: json['planExpiry'] != null
            ? DateTime.parse(json['planExpiry'])
            : DateTime.now(),
      );
  Map<String, dynamic> toJson() => {
        'shop_count': shopCount,
        'employee_count': employeeCount,
        'name': name,
        'state': state,
        'country': country,
        'street': street,
        'image_url': imageUrl,
        'owner_name': contactPersonName,
        'owner_email': email,
        'payment_gateway': paymentGateway,
        'approval': approval,
        'plan': plan,
        'owner_mobile': Countries.concatCode(
            countryCode: mobileNumberDailCode, phoneNumber: mobileNumber),
        'owner_alternate_mobile': Countries.concatCode(
            countryCode: altMobileNumberDailCode, phoneNumber: altMobileNumber),
        'plan_expiry': DateFormat('yyyy-MM-dd').format(planExpiry),
      };

  static List<AdministrationModel> listFromJson(Map<String, dynamic> json) =>
      List<AdministrationModel>.from((Ju.gV(json, 'data') ?? [])
          .map((x) => AdministrationModel.fromJson(x)));

  @override
  bool disabled;

  @override
  bool selected;
}
