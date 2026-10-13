
import 'package:invently/models/common/form_models.dart';
import 'package:invently/models/reports/general_report/purchase_report_model.dart';
import 'package:invently/models/reports/general_report/quotation_report_model.dart';
import 'package:invently/models/reports/general_report/sales_report_model.dart';
import 'package:invently/models/reports/general_report/stock_report_model.dart';
import 'package:invently/ui/reports/general_report/general_report_variables.dart';
import 'package:flutter/material.dart';

class GeneralReportsProvider extends ChangeNotifier {
  TabController? tabController;
  DateTimeParam startDate = DateTimeParam();
  DateTimeParam endDate = DateTimeParam();
  Function()? validateFn;

  GeneralReportVariables<PurchaseReportModel> purchaseVariables = GeneralReportVariables();
  GeneralReportVariables<StockReportModel> stockVariables = GeneralReportVariables();
  GeneralReportVariables<SalesReportModel> salesVariables = GeneralReportVariables();
  GeneralReportVariables<QuotationReportModel> quotationVariables = GeneralReportVariables();

  GeneralReportVariables currentVariable() {
    if (tabController?.index == 1) return stockVariables;
    if (tabController?.index == 2) return salesVariables;
    if (tabController?.index == 3) return quotationVariables;

    return purchaseVariables;
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
    purchaseVariables.clear();
    stockVariables.clear();
    salesVariables.clear();
    quotationVariables.clear();
    try {
      tabController?.dispose();
    } catch (_) {}
  }

  void refresh() => notifyListeners();
}
