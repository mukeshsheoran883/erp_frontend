import 'package:invently/models/common/form_models.dart';
import 'package:invently/models/reports/administration/attendance_report_model.dart';
import 'package:invently/models/reports/administration/employee_report_model.dart';
import 'package:invently/ui/reports/administration/administration_report_variables.dart';
import 'package:gusto_neumorphic/gusto_neumorphic.dart';

class AdministrationReportProvider extends ChangeNotifier {
  TabController? tabController;
  DateTimeParam startDate = DateTimeParam();
  DateTimeParam endDate = DateTimeParam();
  Function()? validateFn;

  AdministrationReportVariables<EmployeeReportModel> employeeVariables = AdministrationReportVariables();
  AdministrationReportVariables<AttendanceReportModel> attendanceVariables = AdministrationReportVariables();

  AdministrationReportVariables currentVariable() {
    if (tabController?.index == 1) return attendanceVariables;
    return employeeVariables;
  }

  void changePage(int a) {
    currentVariable().onSubmit?.call(a);
  }

  void initDateRange() {
    startDate.reset(DateTime.now());
    endDate.reset(DateTime.now());
  }

  void clearProvider() {
    startDate.dispose();
    endDate.dispose();
    employeeVariables.clear();
    attendanceVariables.clear();
    try {
      tabController?.dispose();
    } catch (_) {}
  }

  void refresh() => notifyListeners();
}
