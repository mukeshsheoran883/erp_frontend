
import 'package:invently/provider/administration_provider.dart';
import 'package:invently/provider/dispatch/dispatch_provider.dart';
import 'package:invently/provider/godown/godown_provider.dart';
import 'package:invently/provider/inventory/inventory_log_provider.dart';
import 'package:invently/provider/inventory/inventory_provider.dart' show InventoryProvider;
import 'package:invently/provider/ops/pos_provider.dart';
import 'package:invently/provider/reports/administration_report_provider.dart';
import 'package:invently/provider/authentication_provider.dart';
import 'package:invently/provider/common_functions_provider.dart';
import 'package:invently/provider/reports/day_book_report_provider.dart';
import 'package:invently/provider/reports/gst_report_provider.dart';
import 'package:invently/provider/master/branch_provider.dart';
import 'package:invently/provider/master/create/brand_provider.dart';
import 'package:invently/provider/master/create/category_provider.dart';
import 'package:invently/provider/master/create/tax_provider.dart';
import 'package:invently/provider/master/customer_provider.dart';
import 'package:invently/provider/master/employee_provider.dart';
import 'package:invently/provider/master/item_provider.dart';
import 'package:invently/provider/master/supplier_provider.dart';
import 'package:invently/provider/reports/overview_report_provider.dart';
import 'package:invently/provider/printer_template_provider.dart';
import 'package:invently/provider/purchase/purchase_provider.dart';
import 'package:invently/provider/purchase/returned_purchases_provider.dart';
import 'package:invently/provider/quotations_provider.dart';
import 'package:invently/provider/reports/general_reports_provider.dart';
import 'package:invently/provider/sales/bill_history_provider.dart';
import 'package:invently/provider/sales/customer_quotation_provider.dart';
import 'package:invently/provider/sales/return_item_provider.dart';
import 'package:invently/provider/purchase/stock_available_provider.dart';
import 'package:invently/provider/purchase/stock_completed_transfer_service.dart';
import 'package:invently/provider/purchase/stock_pending_transfer_provider.dart';
import 'package:invently/provider/purchase/stock_rejected_transfer_provider.dart';
import 'package:invently/utils/globals.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

class ProviderRegister {
  static final List<SingleChildWidget> providers = [
    ChangeNotifierProvider(create: (_) => AuthenticationProvider()),
    ChangeNotifierProvider(create: (_) => CommonFunctionsProvider()),
    ChangeNotifierProvider(create: (_) => EmployeeProvider()),
    ChangeNotifierProvider(create: (_) => SupplierProvider()),
    ChangeNotifierProvider(create: (_) => BranchProvider()),
    ChangeNotifierProvider(create: (_) => ItemProvider()),
    ChangeNotifierProvider(create: (_) => BrandProvider()),
    ChangeNotifierProvider(create: (_) => CategoryProvider()),
    ChangeNotifierProvider(create: (_) => TaxProvider()),
    ChangeNotifierProvider(create: (_) => CustomerProvider()),
    ChangeNotifierProvider(create: (_) => AdministrationProvider()),
    ChangeNotifierProvider(create: (_) => InventoryProvider()),
    ChangeNotifierProvider(create: (_) => PurchaseProvider()),
    ChangeNotifierProvider(create: (_) => GstReportProvider()),
    ChangeNotifierProvider(create: (_) => AdministrationReportProvider()),
    ChangeNotifierProvider(create: (_) => DayBookReportProvider()),
    ChangeNotifierProvider(create: (_) => OverviewReportProvider()),
    ChangeNotifierProvider(create: (_) => ReturnedPurchasesProvider()),
    ChangeNotifierProvider(create: (_) => PrinterTemplateProvider()),
    ChangeNotifierProvider(create: (_) => GeneralReportsProvider()),
    ChangeNotifierProvider(create: (_) => StockAvailableProvider()),
    ChangeNotifierProvider(create: (_) => StockPendingTransferProvider()),
    ChangeNotifierProvider(create: (_) => StockCompletedTransferProvider()),
    ChangeNotifierProvider(create: (_) => StockRejectedTransferProvider()),
    ChangeNotifierProvider(create: (_) => QuotationsProvider()),
    ChangeNotifierProvider(create: (_) => ReturnItemProvider()),
    ChangeNotifierProvider(create: (_) => ReturnItemProvider()),
    ChangeNotifierProvider(create: (_) => BillHistoryProvider()),
    ChangeNotifierProvider(create: (_) => InventoryLogProvider()),
    ChangeNotifierProvider(create: (_) => CustomerQuotationProvider()),
    ChangeNotifierProvider(create: (_) => PosProvider()),
    ChangeNotifierProvider(create: (_) => GodownProvider()),
    ChangeNotifierProvider(create: (_) => DispatchProvider()),
  ];

  static void clearProviders() {
    final BuildContext context = Globals.context();

    context.read<AuthenticationProvider>().clearProvider();
    context.read<CommonFunctionsProvider>().clearProvider();
    context.read<EmployeeProvider>().clearProvider();
    context.read<SupplierProvider>().clearProvider();
    context.read<BranchProvider>().clearProvider();
    context.read<ItemProvider>().clearProvider();
    context.read<BrandProvider>().clearProvider();
    context.read<CategoryProvider>().clearProvider();
    context.read<TaxProvider>().clearProvider();
    context.read<CustomerProvider>().clearProvider();
    context.read<AdministrationProvider>().clearProvider();
    context.read<PurchaseProvider>().clearProvider();
    context.read<GstReportProvider>().clearProvider();
    context.read<AdministrationReportProvider>().clearProvider();
    context.read<DayBookReportProvider>().clearProvider();
    context.read<OverviewReportProvider>().clearProvider();
    context.read<ReturnedPurchasesProvider>().clearProvider();
    context.read<PrinterTemplateProvider>().clearProvider();
    context.read<GeneralReportsProvider>().clearProvider();
    context.read<StockAvailableProvider>().clearProvider();
    context.read<StockPendingTransferProvider>().clearProvider();
    context.read<StockCompletedTransferProvider>().clearProvider();
    context.read<StockRejectedTransferProvider>().clearProvider();
    context.read<QuotationsProvider>().clearProvider();
    context.read<ReturnItemProvider>().clearProvider();
    context.read<BillHistoryProvider>().clearProvider();
    context.read<InventoryProvider>().clearProvider();
    context.read<InventoryLogProvider>().clearProvider();
    context.read<CustomerQuotationProvider>().clearProvider();
    context.read<PosProvider>().clearProvider();
    context.read<GodownProvider>().clearProvider();
    context.read<DispatchProvider>().clearProvider();
  }
}
