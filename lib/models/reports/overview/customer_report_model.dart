import 'package:invently/assortment/utils/json_utils.dart';
import 'package:invently/models/common/listing_model.dart';

class OverviewCustomersModel implements ListingModel {
  String customerName;
  String customerCode;
  String customerEmail;
  String mobileNo;
  String createdDate;
  String idNo;
  String idType;
  String dob;
  String gender;
  String bloodGroup;
  String maritalStatus;
  String religion;
  String education;
  String photoUrl;
  String idProofUrl;
  String street;
  String state;
  String country;
  String status;

  OverviewCustomersModel({
    required this.customerName,
    required this.customerCode,
    required this.customerEmail,
    required this.mobileNo,
    required this.idNo,
    required this.createdDate,
    required this.idType,
    required this.dob,
    required this.gender,
    required this.bloodGroup,
    required this.maritalStatus,
    required this.religion,
    required this.education,
    required this.photoUrl,
    required this.idProofUrl,
    required this.street,
    required this.state,
    required this.country,
    required this.status,
    required this.disabled,
    required this.selected,
  });

  factory OverviewCustomersModel.fromJson(Map<String, dynamic> json) => OverviewCustomersModel(
    customerName: json['customerName'] ?? '',
    customerCode: json['customerCode'] ?? '',
    customerEmail: json['customerEmail'] ?? '',
    mobileNo: json['mobileNo'] ?? '',
    createdDate: json['createdDate'] ?? '',
    idNo: json['idNo'] ?? '',
    idType: json['idType'] ?? '',
    dob: json['dob'] ?? '',
    gender: json['gender'] ?? '',
    bloodGroup: json['bloodGroup'] ?? '',
    maritalStatus: json['maritalStatus'] ?? '',
    religion: json['religion'] ?? '',
    education: json['education'] ?? '',
    photoUrl: json['photoUrl'] ?? '',
    idProofUrl: json['idProofUrl'] ?? '',
    street: json['street'] ?? '',
    state: json['state'] ?? '',
    country: json['country'] ?? '',
    status: json['status'] ?? '',
    disabled: json['isActive'] == false,
    selected: false,
  );

  Map<String, dynamic> toJson() => {
    'customer_code': customerCode,
    'customer_name': customerName,
  };

  static List<OverviewCustomersModel> listFromJson(Map<String, dynamic> json) =>
      List<OverviewCustomersModel>.from((Ju.gV(json, 'data') ?? []).map((x) => OverviewCustomersModel.fromJson(x)));

  @override
  bool disabled;

  @override
  bool selected;
}