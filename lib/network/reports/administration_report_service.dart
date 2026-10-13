import 'package:invently/assortment/network/api_helper.dart';
import 'package:invently/assortment/network/api_manager_models.dart';
import 'package:invently/assortment/network/endpoints.dart';
import 'package:invently/models/reports/administration/attendance_report_model.dart';
import 'package:invently/models/reports/administration/employee_report_model.dart';
import 'package:invently/utils/static_values.dart';

class AdministrationReportService {
  static Future<ApiResponseModel<List<EmployeeReportModel>>> getEmployeeReportList({
    required int pageNumber,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    return await DioHelper(
      method: ApiMethods.get,
      url: Endpoint.employeeReport(),
      queries: [Query.pageNumber(pageNumber), Query.countLimit(), Query.startDate(startDate), Query.endDate(endDate)],
      fromJson: EmployeeReportModel.listFromJson,
    ).call();
  }

  static Future<ApiResponseModel<List<AttendanceReportModel>>> getAttendanceReportList({
    required int pageNumber,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    return await DioHelper(
      method: ApiMethods.get,
      url: Endpoint.attendanceReport(),
      queries: [Query.pageNumber(pageNumber), Query.countLimit(), Query.startDate(startDate), Query.endDate(endDate)],
      fromJson: AttendanceReportModel.listFromJson,
    ).call();
  }
}
