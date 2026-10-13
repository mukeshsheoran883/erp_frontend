import 'package:invently/assortment/utils/json_utils.dart';
import 'package:invently/models/common/country_codes.dart';
import 'package:invently/models/common/listing_model.dart';

class SupplierModel implements ListingModel {
  String name;
  String mobileNumber;
  String emailId;
  String state;
  String country;
  String profilePhotoUrl;
  String supplierCode;
  String idProofUrl;
  String gstNumber;
  String idType;
  String idNumber;
  String altMobileNumber;
  String mobileNumberDailCode;
  String altMobileNumberDailCode;
  String address;

  SupplierModel({
    required this.name,
    required this.mobileNumber,
    required this.emailId,
    required this.state,
    required this.country,
    required this.address,
    required this.profilePhotoUrl,
    required this.supplierCode,
    required this.disabled,
    required this.selected,
    required this.idProofUrl,
    required this.gstNumber,
    required this.idType,
    required this.idNumber,
    required this.altMobileNumber,
    required this.altMobileNumberDailCode,
    required this.mobileNumberDailCode,
  });

  factory SupplierModel.fromJson(Map<String, dynamic> json) => SupplierModel(
        name: json['name'] ?? '',
        mobileNumber: Countries.getPhoneFromPhoneNumber(phoneNumber: json['mobileNumber'] ?? ''),
        mobileNumberDailCode: Countries.getCodeFromPhoneNumber(phoneNumber: json['mobileNumber'] ?? ''),
        altMobileNumber: Countries.getPhoneFromPhoneNumber(phoneNumber: json['altMobileNumber'] ?? ''),
        altMobileNumberDailCode: Countries.getCodeFromPhoneNumber(phoneNumber: json['altMobileNumber'] ?? ''),
        emailId: json['emailId'] ?? '',
        state: json['state'] ?? '',
        country: json['country'] ?? '',
        address: json['street'] ?? '',
        profilePhotoUrl: json['photoUrl'] ?? '',
        supplierCode: json['supplierCode'] ?? '',
        idProofUrl: json['idProofUrl'] ?? '',
        gstNumber: json['gstNumber'] ?? '',
        idType: json['idType'] ?? '',
        idNumber: json['idNumber'] ?? '',
        disabled: json['isActive'] == false,
        selected: false,
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        'state': state,
        'country': country,
        'street': address,
        'mobile_number': Countries.concatCode(countryCode: mobileNumberDailCode, phoneNumber: mobileNumber),
        'alt_mobile_number': Countries.concatCode(countryCode: altMobileNumberDailCode, phoneNumber: altMobileNumber),
        'email_id': emailId,
        'id_number': idNumber,
        'id_type': idType,
        'gst_number': gstNumber,
        'photo_url': profilePhotoUrl,
        'id_proof_url': idProofUrl,
        'supplier_code': supplierCode,
      };

  static List<SupplierModel> listFromJson(Map<String, dynamic> json) =>
      List<SupplierModel>.from((Ju.gV(json, 'data') ?? []).map((x) => SupplierModel.fromJson(x)));

  @override
  bool disabled;

  @override
  bool selected;
}
