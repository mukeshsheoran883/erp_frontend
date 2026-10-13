import 'package:invently/assortment/utils/json_utils.dart';
import 'package:invently/models/common/country_codes.dart';
import 'package:invently/models/common/listing_model.dart';
import 'package:intl/intl.dart';

class CustomerModel implements ListingModel {
  String name;
  String mobileNumber;
  String mobileNumberDailCode;
  DateTime createdDateTime;
  DateTime dateOfBirth;
  String emailId;
  String gender;
  String martialStatus;
  String religion;
  String bloodGroup;
  String education;
  String state;
  String country;
  String street;
  String photoUrl;
  String idProofUrl;
  String organisationName;
  String customerCode;
  String idNumber;
  String idType;
  String occupation;

  @override
  bool disabled;

  @override
  bool selected;

  CustomerModel({
    required this.name,
    required this.mobileNumber,
    required this.mobileNumberDailCode,
    required this.createdDateTime,
    required this.dateOfBirth,
    required this.emailId,
    required this.gender,
    required this.martialStatus,
    required this.religion,
    required this.bloodGroup,
    required this.education,
    required this.state,
    required this.country,
    required this.street,
    required this.photoUrl,
    required this.idProofUrl,
    required this.organisationName,
    required this.customerCode,
    required this.idNumber,
    required this.idType,
    required this.occupation,
    required this.disabled,
    required this.selected,
  });

  // ============================================================
  // FROM JSON
  // GET / LIST API RESPONSE
  // ============================================================

  factory CustomerModel.fromJson(
    Map<String, dynamic> json,
  ) {
    final mobileNumber = json['mobileNumber']?.toString() ?? '';

    return CustomerModel(
      organisationName: json['organisationName']?.toString() ?? '',
      country: json['country']?.toString() ?? '',
      state: json['state']?.toString() ?? '',
      street: json['street']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      disabled: json['isActive'] == false,
      selected: false,
      mobileNumber: Countries.getPhoneFromPhoneNumber(
        phoneNumber: mobileNumber,
      ),
      mobileNumberDailCode: Countries.getCodeFromPhoneNumber(
        phoneNumber: mobileNumber,
      ),
      emailId: json['emailId']?.toString() ?? '',
      createdDateTime: DateTime.tryParse(
            json['createdDateTime']?.toString() ?? '',
          ) ??
          DateTime.now(),
      customerCode: json['customerCode']?.toString() ?? '',
      idNumber: json['idNumber']?.toString() ?? '',
      idType: json['idType']?.toString() ?? '',
      occupation: json['occupation']?.toString() ?? '',
      photoUrl: json['photoUrl']?.toString() ?? '',
      idProofUrl: json['idProofUrl']?.toString() ?? '',
      dateOfBirth: DateTime.tryParse(
            json['dateOfBirth']?.toString() ?? '',
          ) ??
          DateTime.now(),
      gender: json['gender']?.toString() ?? '',
      martialStatus: json['martial_status']?.toString() ??
          json['martialStatus']?.toString() ??
          '',
      religion: json['religion']?.toString() ?? '',
      bloodGroup: json['bloodGroup']?.toString() ?? '',
      education: json['education']?.toString() ?? '',
    );
  }

  // ============================================================
  // TO JSON
  // CREATE / UPDATE API
  // ============================================================

  Map<String, dynamic> toJson() {
    return {
      'customer_code': customerCode,
      'name': name,
      'state': state,
      'country': country,
      'street': street,
      'mobile_number': Countries.concatCode(
        countryCode: mobileNumberDailCode,
        phoneNumber: mobileNumber,
      ),
      'email_id': emailId,
      'id_number': idNumber,
      'id_type': idType,
      'photo_url': photoUrl,
      'id_proof_url': idProofUrl,
      'occupation': occupation,
      'date_of_birth': DateFormat('yyyy-MM-dd').format(
        dateOfBirth,
      ),
      'gender': gender,
      'martial_status': martialStatus,
      'religion': religion,
      'blood_group': bloodGroup,
      'education': education,
    };
  }

  // ============================================================
  // LIST FROM JSON
  // ============================================================

  static List<CustomerModel> listFromJson(
    Map<String, dynamic> json,
  ) {
    return List<CustomerModel>.from(
      (Ju.gV(json, 'data') ?? []).map(
        (e) => CustomerModel.fromJson(
          Map<String, dynamic>.from(e),
        ),
      ),
    );
  }
}
