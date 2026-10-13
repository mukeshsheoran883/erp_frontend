import 'package:invently/assortment/utils/json_utils.dart';
import 'package:invently/models/common/listing_model.dart';

class EmployeeReportModel implements ListingModel {
  String employeeName;
  String employeeCode;
  String employeeEmail;
  String state;
  String dob;
  String street;
  String country;
  String branchAccess;

  EmployeeReportModel({
    required this.employeeName,
    required this.employeeCode,
    required this.employeeEmail,
    required this.street,
    required this.state,
    required this.dob,
    required this.branchAccess,
    required this.country,
    required this.disabled,
    required this.selected,
  });

  factory EmployeeReportModel.fromJson(Map<String, dynamic> json) => EmployeeReportModel(
        employeeName: json['employeeName'] ?? '',
        employeeCode: json['employeeCode'] ?? '',
        employeeEmail: json['employeeEmail'] ?? '',
        state: json['state'] ?? '',
        street: json['street'] ?? '',
        dob: json['dob'] ?? '',
        branchAccess: json['branchAccess'] ?? '',
        country: json['country'] ?? '',
        disabled: json['isActive'] == false,
        selected: false,
      );

  Map<String, dynamic> toJson() => {
        'employee_name': employeeName,
        'employee_code': employeeCode,
      };

  static List<EmployeeReportModel> listFromJson(Map<String, dynamic> json) =>
      List<EmployeeReportModel>.from((Ju.gV(json, 'data') ?? []).map((x) => EmployeeReportModel.fromJson(x)));

  @override
  bool disabled;

  @override
  bool selected;
}
