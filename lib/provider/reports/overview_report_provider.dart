import 'package:invently/models/common/form_models.dart';
import 'package:invently/models/reports/overview/customer_report_model.dart';
import 'package:invently/models/reports/overview/inventory_balance_report_model.dart';
import 'package:invently/models/reports/overview/item_report_model.dart';
import 'package:invently/models/reports/overview/supplies_report_model.dart';
import 'package:invently/ui/reports/overview/overview_report_variables.dart';
import 'package:gusto_neumorphic/gusto_neumorphic.dart';

class OverviewReportProvider extends ChangeNotifier {
  TabController? tabController;
  DateTimeParam startDate = DateTimeParam();
  DateTimeParam endDate = DateTimeParam();
  Function()? validateFn;

  OverviewReportVariables<OverviewItemModel> itemVariables = OverviewReportVariables();
  OverviewReportVariables<OverviewCustomersModel> customerVariables = OverviewReportVariables();
  OverviewReportVariables<OverviewInventoryBalanceModel> inventoryBalanceVariables = OverviewReportVariables();
  OverviewReportVariables<OverviewSuppliesModel> suppliesVariables = OverviewReportVariables();

  OverviewReportVariables currentVariable() {
    if (tabController?.index == 1) return customerVariables;
    if (tabController?.index == 2) return inventoryBalanceVariables;
    if (tabController?.index == 3) return suppliesVariables;

    return itemVariables;
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
    itemVariables.clear();
    customerVariables.clear();
    inventoryBalanceVariables.clear();
    suppliesVariables.clear();
    try {
      tabController?.dispose();
    } catch (_) {}
  }

  void refresh() => notifyListeners();
}
