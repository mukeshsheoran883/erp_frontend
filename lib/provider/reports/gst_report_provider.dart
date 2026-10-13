import 'package:invently/models/common/form_models.dart';
import 'package:invently/models/reports/gst_report/gst_one_model.dart';
import 'package:invently/models/reports/gst_report/gst_two_model.dart';
import 'package:invently/ui/reports/gst/gst_report_variables.dart';
import 'package:gusto_neumorphic/gusto_neumorphic.dart';

class GstReportProvider extends ChangeNotifier {
  TabController? tabController;
  DateTimeParam startDate = DateTimeParam();
  DateTimeParam endDate = DateTimeParam();
  Function()? validateFn;

  GstReportVariables<GstOneModel> gstOneVariables = GstReportVariables();
  GstReportVariables<GstTwoModel> gstTwoVariables = GstReportVariables();


  GstReportVariables currentVariable() {
    if (tabController?.index == 1) return gstTwoVariables;
    return gstOneVariables;
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
    gstOneVariables.clear();
    gstTwoVariables.clear();
    try {
      tabController?.dispose();
    } catch (_) {}
  }

  void refresh() => notifyListeners();
}
