import 'package:invently/gen/env.dart';
import 'package:invently/utils/static_values.dart';

class Endpoint {
  final String _privateUrl;
  late String _baseUrl;
  late String url;
  Endpoint(this._privateUrl, {String? baseUrl}) {
    _baseUrl = baseUrl ?? (StaticValues.isProduction ? Env.baseUrlLive : Env.baseUrlDev);
    url = _baseUrl + _privateUrl;
  }

  String get baseUrl => _baseUrl;
  String get privateUrl => _privateUrl;

  /// ------------------------------------------ Privacy & Terms -------------------------------------------------
  static Endpoint privacyPolicy() =>
      Endpoint(baseUrl: 'https://drive.google.com/', 'file/d/1VTdE0yk32dqUT2sgNG8yI9xQm6-mzTGw/view');

  /// ------------------------------------------ User Auth -------------------------------------------------
  static Endpoint login() => Endpoint('auth/login/');
  static Endpoint getNewToken() => Endpoint('auth/token/');
  static Endpoint forgotPasswordSendEmail() => Endpoint('auth/email_verify/');
  static Endpoint forgotPasswordChange() => Endpoint('auth/forgot_password/');
  static Endpoint activateAccount() => Endpoint('auth/register/');

  /// ------------------------------------------ User Details -------------------------------------------------
  static Endpoint getEmployee() => Endpoint('employees/get/');
  static Endpoint passwordChange() => Endpoint('auth/password_change/');

  /// ------------------------------------------ Storage -------------------------------------------------
  static Endpoint fileUpload() => Endpoint('storage/upload/');

  static Endpoint fileDownload() => Endpoint('storage/get/');

  /// ------------------------------------------ Supplier -----------------------------------------------------
  static Endpoint supplierList({bool search = false}) => Endpoint(search ? 'supplier/search/' : 'supplier/get_all/');
  static Endpoint addSupplier() => Endpoint('supplier/create/');
  static Endpoint getSupplier() => Endpoint('supplier/get/');
  static Endpoint multiDeleteSuppliers() => Endpoint('supplier/delete_many/');
  static Endpoint updateSupplier() => Endpoint('supplier/update/');

  /// ------------------------------------------ Item -----------------------------------------------------
  static Endpoint itemList({bool search = false}) => Endpoint(search ? 'item/search/' : 'item/get_all/');
  static Endpoint addItem() => Endpoint('item/create/');
  static Endpoint getItem() => Endpoint('item/get/');
  static Endpoint multiDeleteItem() => Endpoint('item/delete_many/');
  static Endpoint updateItem() => Endpoint('item/update/');
  static Endpoint updateItemBulkCreate() => Endpoint('item/bulk_create/');

  /// ------------------------------------------ Brand -----------------------------------------------------
  static Endpoint brandList({bool search = false}) => Endpoint(search ? 'brand/search/' : 'brand/get_all/');
  static Endpoint addBrand() => Endpoint('brand/create/');
  static Endpoint deleteBrands() => Endpoint('brand/delete_many/');
  static Endpoint updateBrand() => Endpoint('brand/update/');

  /// ------------------------------------------ Tax -----------------------------------------------------
  static Endpoint taxList({bool search = false}) => Endpoint(search ? 'taxes/search/' : 'taxes/get_all/');
  static Endpoint getTex() => Endpoint('taxes/get/');
  static Endpoint addTax() => Endpoint('taxes/create/');
  static Endpoint deleteTaxes() => Endpoint('taxes/delete_many/');
  static Endpoint updateTax() => Endpoint('taxes/update/');

  /// ------------------------------------------ Category -----------------------------------------------------
  static Endpoint categoryList({bool search = false}) => Endpoint(search ? 'category/search/' : 'category/get_all/');
  static Endpoint addCategory() => Endpoint('category/create/');
  static Endpoint deleteCategories() => Endpoint('category/delete_many/');
  static Endpoint updateCategory() => Endpoint('category/update/');

  /// ------------------------------------------ Stock -----------------------------------------------------
  static Endpoint stockList() => Endpoint('stock/get_all/');

  /// ------------------------------------------ Products -----------------------------------------------------
  static Endpoint productList({bool search = false}) => Endpoint(search ? 'inventory/search/' : 'inventory/get_all/');
  static Endpoint getProduct() => Endpoint('inventory/get/');
  static Endpoint addProduct() => Endpoint('inventory/create/');
  static Endpoint updateProduct() => Endpoint('inventory/update/');
  static Endpoint deleteProducts() => Endpoint('inventory/delete_many/');

  ///-----------------------------------------------Branch/Shops-----------------------------------------------------
  static Endpoint branchList({bool search = false}) => Endpoint(search ? 'shops/search/' : 'shops/get_all/');
  static Endpoint getBranch() => Endpoint('shops/get/');
  static Endpoint addBranch() => Endpoint('shops/create/');
  static Endpoint deleteBranches() => Endpoint('shops/delete_many/');
  static Endpoint updateBranch() => Endpoint('shops/update/');

  /// ------------------------------------------ Customer -----------------------------------------------------
  static Endpoint customerList({bool search = false}) => Endpoint(search ? 'customer/search/' : 'customer/get_all/');
  static Endpoint addCustomer() => Endpoint('customer/create/');
  static Endpoint getCustomer() => Endpoint('customer/get/');
  static Endpoint deleteCustomer() => Endpoint('customer/delete_many/');
  static Endpoint updateCustomer() => Endpoint('customer/update/');

  /// ------------------------------------------ Customer -----------------------------------------------------
  static Endpoint customerQuotationList({bool search = false}) => Endpoint(search ? 'customer/search/' : 'customer-quotation/get-all');
  static Endpoint addCustomerQuotation() => Endpoint('customer-quotation/create');
  static Endpoint getCustomerQuotation() => Endpoint('customer-quotation/get');
  static Endpoint reviewCustomerQuotation() => Endpoint('customer-quotation/review');
  // static Endpoint deleteCustomer() => Endpoint('customer/delete_many/');
  // static Endpoint updateCustomer() => Endpoint('customer/update/');

  /// ------------------------------------------ Employee -----------------------------------------------------
  static Endpoint employeeList({bool search = false}) => Endpoint(search ? 'employees/search/' : 'employees/get_all/');
  static Endpoint addEmployee() => Endpoint('employees/create/');
  static Endpoint multiDeleteEmployee() => Endpoint('employees/delete_many/');
  static Endpoint updateEmployee() => Endpoint('employees/update/');
  static Endpoint employeeStatusChange() => Endpoint('employees/bulk_status_change/');

  /// ------------------------------------------ administration -----------------------------------------------------
  static Endpoint organizationList({bool search = false}) =>
      Endpoint(search ? 'organisation/search/' : 'organisation/get_all/');
  static Endpoint addOrganization() => Endpoint('organisation/create/');
  static Endpoint getOrganization() => Endpoint('organisation/get/');
  static Endpoint deleteOrganization() => Endpoint('organisation/delete_many/');
  static Endpoint updateOrganization() => Endpoint('organisation/update/');

  /// ------------------------------------------ inventory -----------------------------------------------------
  static Endpoint inventory({bool search = false}) =>
      Endpoint(search ? 'inventory/search/' : 'inventory/get_all/');
  static Endpoint addInventory() => Endpoint('inventory/create/');
  static Endpoint inventoryLogs() => Endpoint('inventory/inventory-logs-get-all/');
  static Endpoint getInventory() => Endpoint('inventory/get/');
  static Endpoint deleteInventory() => Endpoint('inventory/delete_many/');
  static Endpoint updateInventory() => Endpoint('inventory/update/');

 static Endpoint pos({bool search = false}) =>
      Endpoint(search ? 'pos/search/' : 'pos/get-all');
  static Endpoint addPos() => Endpoint('pos/create');
  static Endpoint posExecute() => Endpoint('pos/execute');
  static Endpoint getPos() => Endpoint('pos/get');
  static Endpoint posConfirm() => Endpoint('pos/confirm');
  static Endpoint posCancel() => Endpoint('pos/cancel');
  static Endpoint posSend() => Endpoint('pos/send');
  static Endpoint posInventoryConfirm() => Endpoint('pos/inventory-confirm');
  static Endpoint posDelete() => Endpoint('pos/delete');
  static Endpoint posDispatchConfirm() => Endpoint('pos/dispatch-confirm');
  static Endpoint posDispatchAddDetails() => Endpoint('pos/dispatch-add-details');

  /// ------------------------------------------ sales -----------------------------------------------------
  static Endpoint returnItemList({bool search = false}) => Endpoint(search ? 'return-item/search/' : 'return-item/get_all/');
  static Endpoint addReturnItem() => Endpoint('return_item/create/');
  static Endpoint getReturnItem() => Endpoint('return_item/get/');
  static Endpoint deleteReturnItem() => Endpoint('return_item/delete_many/');
  static Endpoint updateReturnItem() => Endpoint('return_item/update/');
  static Endpoint billHistoryList({bool search = false}) => Endpoint(search ? 'billing/get_all/' : 'billing/get_all/');
  static Endpoint addBillHistory() => Endpoint('billing/create/');
  static Endpoint getBillHistory() => Endpoint('billing/get/');
  static Endpoint deleteBillHistory() => Endpoint('billing/delete_many/');
  static Endpoint updateBillHistory() => Endpoint('billing/update/');


  /// ------------------------------------------ purchase -----------------------------------------------------
  static Endpoint purchaseList({bool search = false}) => Endpoint(search ? 'purchase/search/' : 'purchase/get_all/');
  static Endpoint addPurchase() => Endpoint('purchase/create/');
  static Endpoint getPurchase() => Endpoint('purchase/get/');
  static Endpoint deletePurchase() => Endpoint('purchase/delete_many/');
  static Endpoint updatePurchase() => Endpoint('purchase/update/');

  /// ------------------------------------------returned purchase -----------------------------------------------------
  static Endpoint returnedPurchaseList({bool search = false}) =>
      Endpoint(search ? 'return-purchase/search/' : 'return-purchase/get_all/');
  static Endpoint addReturnedPurchase() => Endpoint('return-purchase/create/');
  static Endpoint getReturnedPurchase() => Endpoint('return-purchase/get/');
  static Endpoint getReturnedPurchaseDummy() => Endpoint('return-purchase/get/test/');
  static Endpoint deleteReturnedPurchase() => Endpoint('return-purchase/delete_many/');
  static Endpoint updateReturnedPurchase() => Endpoint('return-purchase/update/');

  /// ------------------------------------------Stock Available-----------------------------------------------------
  static Endpoint stockAvailableList({bool search = false}) =>
      Endpoint(search ? 'stock_available/search/' : 'stock_available/get_all/');
  static Endpoint addStockAvailable() => Endpoint('stock_available/create/');
  static Endpoint getStockAvailable() => Endpoint('stock_available/get/');
  static Endpoint deleteStockAvailable() => Endpoint('stock_available/delete_many/');
  static Endpoint updateStockAvailable() => Endpoint('stock_available/update/');

  /// ------------------------------------------Quotations-----------------------------------------------------
  static Endpoint quotationsList({bool search = false}) =>
      Endpoint(search ? 'quotations/search/' : 'quotations/get_all/');
  static Endpoint addQuotations() => Endpoint('quotations/create/');
  static Endpoint getQuotations() => Endpoint('quotations/get/');
  static Endpoint deleteQuotations() => Endpoint('quotations/delete_many/');
  static Endpoint updateQuotations() => Endpoint('quotations/update/');

  /// ------------------------------------------Stock Transfer-----------------------------------------------------
  static Endpoint stockPendingTransferList({bool search = false}) =>
      Endpoint(search ? 'stock-transfer/search/' : 'stock-transfer/get_pending_transfers/');
  static Endpoint addStockPendingTransfer() => Endpoint('stock-transfer/create/');
  static Endpoint getStockPendingTransfer() => Endpoint('stock-transfer/get_pending_transfers/');
  static Endpoint deleteStockPendingTransfer() => Endpoint('stock-transfer/delete_many/');
  static Endpoint updateStockPendingTransfer() => Endpoint('stock-transfer/update/');

  static Endpoint stockCompletedTransferList({bool search = false}) =>
      Endpoint(search ? 'stock-transfer/search/' : 'stock-transfer/get_completed_transfers/');
  static Endpoint addStockCompletedTransfer() => Endpoint('stock-transfer/create/');
  static Endpoint getStockCompletedTransfer() => Endpoint('stock-transfer/get_completed_transfers/');
  static Endpoint deleteStockCompletedTransfer() => Endpoint('stock-transfer/delete_many/');
  static Endpoint updateStockCompletedTransfer() => Endpoint('stock-transfer/update/');

  static Endpoint stockRejectedTransferList({bool search = false}) =>
      Endpoint(search ? 'stock-transfer/search/' : 'stock-transfer/get_rejected_transfers/');
  static Endpoint addStockRejectedTransfer() => Endpoint('stock-transfer/create/');
  static Endpoint getStockRejectedTransfer() => Endpoint('stock-transfer/get_rejected_transfers/');
  static Endpoint deleteStockRejectedTransfer() => Endpoint('stock-transfer/delete_many/');
  static Endpoint updateStockRejectedTransfer() => Endpoint('stock-transfer/update/');

  /// ------------------------------------------ REPORTS -----------------------------------------------------
  static Endpoint gst1Report() => Endpoint('reports/gst_1/');
  static Endpoint gst2Report() => Endpoint('reports/gst_2/');
  static Endpoint dayBookInventoryBalance() => Endpoint('reports/day_book/inventory_balance/');
  static Endpoint dayBookSupplies() => Endpoint('reports/day_book/supplies/');
  static Endpoint dayBookCustomers() => Endpoint('reports/day_book/customers/');
  static Endpoint dayBookItem() => Endpoint('reports/day_book/item/');
  static Endpoint employeeReport() => Endpoint('reports/administration/employee/');
  static Endpoint attendanceReport() => Endpoint('reports/administration/attendance/');
  static Endpoint overviewInventoryBalance() => Endpoint('reports/overview/inventory_balance/');
  static Endpoint overviewSupplies() => Endpoint('reports/overview/supplies/');
  static Endpoint overviewCustomers() => Endpoint('reports/overview/customers/');
  static Endpoint overviewItem() => Endpoint('reports/overview/item/');
  static Endpoint purchaseReport() => Endpoint('general-report/get_purchase_report/');

  static Endpoint stockReport() => Endpoint('general-report/stock_report/');
  static Endpoint salesReport() => Endpoint('general-report/sales_report/');
  static Endpoint quotationReport() => Endpoint('general-report/get_quotation_report/');

  /// ------------------------------------------ METHODS --------------------------------------------------------
  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is Endpoint && runtimeType == other.runtimeType && url == other.url;

  @override
  int get hashCode => url.hashCode;
}
