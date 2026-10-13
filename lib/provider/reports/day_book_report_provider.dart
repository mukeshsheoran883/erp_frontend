import 'package:invently/models/common/form_models.dart';
import 'package:invently/models/reports/day_book/day_book_customer_model.dart';
import 'package:invently/models/reports/day_book/day_book_inventory_balance_model.dart';
import 'package:invently/models/reports/day_book/day_book_item_model.dart';
import 'package:invently/models/reports/day_book/day_book_supplies_model.dart';
import 'package:gusto_neumorphic/gusto_neumorphic.dart';
import 'package:invently/ui/reports/day_book/day_book_report_variables.dart';

class DayBookReportProvider extends ChangeNotifier {
  TabController? tabController;
  DateTimeParam startDate = DateTimeParam();
  DateTimeParam endDate = DateTimeParam();
  Function()? validateFn;

  DayBookReportVariables<DayBookItemModel> itemVariables = DayBookReportVariables();
  DayBookReportVariables<DayBookCustomersModel> customersVariables = DayBookReportVariables();
  DayBookReportVariables<DayBookInventoryBalanceModel> inventoryBalanceVariables = DayBookReportVariables();
  DayBookReportVariables<DayBookSuppliesModel> suppliesVariables = DayBookReportVariables();

  DayBookReportVariables currentVariable() {
    if (tabController?.index == 1) return customersVariables;
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
    customersVariables.clear();
    inventoryBalanceVariables.clear();
    suppliesVariables.clear();
    try {
      tabController?.dispose();
    } catch (_) {}
  }

  void refresh() => notifyListeners();
}
