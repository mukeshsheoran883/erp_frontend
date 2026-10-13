import 'package:invently/assortment/utils/json_utils.dart';
import 'package:invently/models/common/listing_model.dart';

class AttendanceReportModel implements ListingModel {
  String employeeName;
  String employeeCode;
  String employeeEmail;
  String date;
  String startTime;
  String endTime;
  String totalHours;
  String totalActives;

  AttendanceReportModel({
    required this.employeeName,
    required this.employeeCode,
    required this.employeeEmail,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.totalHours,
    required this.totalActives,
    required this.disabled,
    required this.selected,
  });

  factory AttendanceReportModel.fromJson(Map<String, dynamic> json) => AttendanceReportModel(
        employeeName: json['employeeName'] ?? '',
        employeeCode: json['employeeCode'] ?? '',
        employeeEmail: json['employeeEmail'] ?? '',
        date: json['date'] ?? '',
        startTime: json['startTime'] ?? '',
        endTime: json['endTime'] ?? '',
        totalHours: json['totalHours'] ?? '',
        totalActives: json['totalActives'] ?? '',
        disabled: json['isActive'] == false,
        selected: false,
      );

  Map<String, dynamic> toJson() => {
        'employee_name': employeeName,
        'employee_code': employeeCode,
      };

  static List<AttendanceReportModel> listFromJson(Map<String, dynamic> json) =>
      List<AttendanceReportModel>.from((Ju.gV(json, 'data') ?? []).map((x) => AttendanceReportModel.fromJson(x)));

  @override
  bool disabled;

  @override
  bool selected;
}
