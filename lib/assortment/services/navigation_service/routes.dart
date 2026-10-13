part of 'navigation_service.dart';

abstract class AppRoutes {
  static final AppRoute splash = AppRoute(
      path: '/splash',
      name: 'splash',
      goBuilder: (c, s) => const SplashScreen(),);
  static final AppRoute testScreen = AppRoute(
      path: '/test', name: 'test', goBuilder: (c, s) => const TestScreen(),);

  static final AppRoute baseWindow = AppRoute(
    shellBuilder: (c, s, d) => BaseWindowScreen(child: d),
    routes: [home, _login, _forgotPassword, _accountActivation, error],
    name: '',
    path: '',
  );

  static final AppRoute _forgotPassword = AppRoute(
    path: '/forgot-password',
    name: 'forgot password',
    shellBuilder: (c, s, d) => LoginScreen(child: d),
    routes: [
      forgotPasswordEmailSection,
      forgotPasswordResetSection(data: null)
    ,],
  );
  static final AppRoute forgotPasswordEmailSection = AppRoute(
      path: '/forgot-password',
      name: 'forgot password',
      goBuilder: (c, s) => const ForgotPasswordSection(),);

  static AppRoute forgotPasswordResetSection(
          {required ForgotPasswordResetSection? data,}) =>
      AppRoute(
        path: '/forgot-password-reset',
        name: 'forgot password email',
        data: data,
        goBuilder: (c, s) {
          ForgotPasswordResetSection a = s.extra as ForgotPasswordResetSection;
          return ForgotPasswordResetSection(email: a.email);
        },
      );

  static final AppRoute _accountActivation = AppRoute(
    path: '/activate-account',
    name: 'activate account',
    shellBuilder: (c, s, d) => LoginScreen(child: d),
    routes: [activateAccount, createAccountPassword(data: null)],
  );

  static final AppRoute activateAccount = AppRoute(
    path: '/activate-account',
    name: 'activate account',
    goBuilder: (c, s) => const ActivateAccountOtpRequest(),
  );

  static AppRoute createAccountPassword(
          {required CreateAccountPassword? data,}) =>
      AppRoute(
        path: '/create-password',
        name: 'create password',
        data: data,
        goBuilder: (c, s) {
          CreateAccountPassword a = s.extra as CreateAccountPassword;
          return CreateAccountPassword(email: a.email);
        },
      );

  static final AppRoute login = AppRoute(
      path: '/login', name: 'login', goBuilder: (c, s) => const LoginSection(),);

  static final AppRoute _login = AppRoute(
    path: '/login',
    name: 'login',
    shellBuilder: (c, s, d) => LoginScreen(child: d),
    routes: [login, loginBranchSelection(data: null)],
  );

  static AppRoute loginBranchSelection({required SelectBranchSection? data}) =>
      AppRoute(
        path: '/branch-select',
        name: 'Select Branch',
        data: data,
        goBuilder: (c, s) {
          SelectBranchSection a = s.extra as SelectBranchSection;
          return SelectBranchSection(
            employeeCode: a.employeeCode,
            rememberMe: a.rememberMe,
            loginResponse: a.loginResponse, role: a.role,
          );
        },
      );

  static final AppRoute error = AppRoute(
      path: '/error',
      name: 'error',
      goBuilder: (c, s) => ErrorScreen(state: s),);
  static final AppRoute home = AppRoute(
    shellBuilder: (BuildContext context, GoRouterState state, Widget child) =>
        MainHomeScreen(child: child),
    name: '',
    path: '',
    routes: [
      dashBoard,
      master,
      administration,
      inventory,
      godown,
      posInventory,
      sales,
      quotations,
      printerTemplates,
      purchase,
      reports,
    ],
  );

  static final AppRoute dashBoard = AppRoute(
    path: '/dashboard',
    name: 'dashboard',
    iconPath: Assets.icons.dashboard,
    goBuilder: (c, s) => const DashboardScreen(),
  );

  static final AppRoute administration = AppRoute(
    path: '/administration',
    name: 'administration',
    iconPath: Assets.icons.administration,
    routes: [
      administrationListing,
      administrationAdd,
      administrationEdit(
          data: const AddEditAdministrationScreen(administrationCode: null),),
    ],
    shellBuilder: (ctx, s, c) => c,
  );

  static final AppRoute administrationListing = AppRoute(
    path: '/organization-list',
    name: 'organization list',
    iconPath: Assets.icons.administration,
    goBuilder: (c, s) => const AdministrationScreen(),
  );

  static final AppRoute administrationAdd = AppRoute(
    path: '/organization-add',
    name: 'add organization',
    iconPath: Assets.icons.administration,
    goBuilder: (c, s) =>
        const AddEditAdministrationScreen(administrationCode: null),
  );

  static AppRoute administrationEdit(
          {required AddEditAdministrationScreen data,}) =>
      AppRoute(
        path: '/organization-edit',
        name: 'edit organization',
        iconPath: Assets.icons.administration,
        data: data,
        goBuilder: (c, s) {
          AddEditAdministrationScreen a =
              s.extra as AddEditAdministrationScreen;
          return AddEditAdministrationScreen(
              administrationCode: a.administrationCode,);
        },
      );

  /// ------------------------------------- Sub-routes in  [inventory] --------------------------------------------

  static final AppRoute godown = AppRoute(
    path: '/dispatch',
    name: 'dispatch',
    iconPath: Assets.icons.godown,
    goBuilder: (c, s) => const DispatchScreen(),
  );

  static final AppRoute inventory = AppRoute(
    path: '/inventory',
    name: 'inventory',
    iconPath: Assets.icons.inventory,
    routes: [
      inventoryList,
      inventoryLogList,
      inventoryAdd,
      inventoryEdit(
          data: const AddEditInventoryScreen(
        inventoryCode: null,
        inventoryName: null,
      ),),
    ],
    shellBuilder: (ctx, s, c) => c,
  );

  static final AppRoute inventoryList = AppRoute(
    path: '/inventory-listing',
    name: 'inventory list',
    iconPath: Assets.icons.inventory,
    goBuilder: (c, s) => const InventoryScreen(),
  );

  static final AppRoute inventoryLogList = AppRoute(
    path: '/inventory-log-listing',
    name: 'inventory log list',
    iconPath: Assets.icons.inventory,
    goBuilder: (c, s) => const InventoryLogScreen(),
  );

  static final AppRoute inventoryAdd = AppRoute(
    path: '/inventory-add',
    name: 'add inventory',
    iconPath: Assets.icons.inventory,
    goBuilder: (c, s) => const AddEditInventoryScreen(
      inventoryCode: null,
      inventoryName: null,
    ),
  );

  static AppRoute inventoryEdit({required AddEditInventoryScreen data}) =>
      AppRoute(
        path: '/inventory-edit',
        name: 'edit inventory',
        iconPath: Assets.icons.inventory,
        data: data,
        goBuilder: (c, s) {
          AddEditInventoryScreen a = s.extra as AddEditInventoryScreen;
          return AddEditInventoryScreen(
            inventoryCode: a.inventoryCode,
            inventoryName: a.inventoryName,
          );
        },
      );

  static final AppRoute sales = AppRoute(
    path: '/sales',
    name: 'sales',
    iconPath: Assets.icons.sales,
    shellBuilder: (context, state, c) => c,
    routes: [
      pos,
      customerQuotation,
      returnItem,
      billHistory,
    ],
  );

  static final AppRoute posInventory = AppRoute(
    path: '/pos_inventory',
    name: 'inventory',
    iconPath: Assets.icons.inventory,
    goBuilder: (c, s) => const PosInventory(),
  );



  static final AppRoute pos = AppRoute(
    path: '/perform-invoice',
    name: 'Perform Invoice',
    iconPath: Assets.icons.receipt,
    routes: [
      posList,
      posAdd,
      posEdit(
        data: const AddEditPosScreen(
          posCode: null,
        ),
      ),
    ],
    shellBuilder: (ctx, s, c) => c,
  );

  static final AppRoute posList = AppRoute(
    path: '/perform-invoice-listing',
    name: 'perform invoice list',
    iconPath: Assets.icons.receipt,
    goBuilder: (c, s) => const PosScreen(),
  );

  static final AppRoute posAdd = AppRoute(
    path: '/perform-invoice-add',
    name: 'add perform invoice',
    iconPath: Assets.icons.receipt,
    goBuilder: (c, s) => const AddEditPosScreen(
      posCode: null,
    ),
  );

  static AppRoute posEdit({required AddEditPosScreen data}) => AppRoute(
        path: '/perform-invoice-edit',
        name: 'edit perform invoice',
        iconPath: Assets.icons.receipt,
        data: data,
        goBuilder: (c, s) {
          AddEditPosScreen a = s.extra as AddEditPosScreen;
          return AddEditPosScreen(
            posCode: a.posCode,
          );
        },
      );

  static final AppRoute returnItem = AppRoute(
    path: '/return-item',
    name: 'return item',
    iconPath: Assets.icons.returnItem,
    routes: [
      returnItemList,
      returnItemAdd,
      returnItemEdit(data: const AddEditReturnItemScreen(returnItemCode: null)),
    ],
    shellBuilder: (ctx, s, c) => c,
  );

  static final AppRoute returnItemList = AppRoute(
    path: '/return-item-listing',
    name: 'return item list',
    iconPath: Assets.icons.returnItem,
    goBuilder: (c, s) => const ReturnItemScreen(),
  );

  static final AppRoute returnItemAdd = AppRoute(
    path: '/return-item-add',
    name: 'add return item',
    iconPath: Assets.icons.returnItem,
    goBuilder: (c, s) => const AddEditReturnItemScreen(
      returnItemCode: null,
    ),
  );

  static AppRoute returnItemEdit({required AddEditReturnItemScreen data}) =>
      AppRoute(
        path: '/return-item-edit',
        name: 'edit return item',
        iconPath: Assets.icons.returnItem,
        data: data,
        goBuilder: (c, s) {
          AddEditReturnItemScreen a = s.extra as AddEditReturnItemScreen;
          return AddEditReturnItemScreen(returnItemCode: a.returnItemCode);
        },
      );

  static final AppRoute billHistory = AppRoute(
    path: '/invoice',
    name: 'invoice',
    iconPath: Assets.icons.invoice,
    routes: [
      billHistoryList,
      billAdd,
      invoiceEdit(data: const AddEditInvoiceScreen(invoiceCode: null))
    ,],
    shellBuilder: (ctx, s, c) => c,
  );

  static final AppRoute billHistoryList = AppRoute(
    path: '/invoice-list',
    name: 'invoice list',
    iconPath: Assets.icons.invoice,
    goBuilder: (c, s) => const BillHistoryScreen(),
  );

  static final AppRoute billAdd = AppRoute(
    path: '/invoice-add',
    name: 'add Invoice',
    iconPath: Assets.icons.invoice,
    goBuilder: (c, s) => const AddEditInvoiceScreen(
      invoiceCode: null,
    ),
  );

  static AppRoute invoiceEdit({required AddEditInvoiceScreen data}) => AppRoute(
        path: '/invoice-edit',
        name: 'edit invoice',
        iconPath: Assets.icons.invoice,
        data: data,
        goBuilder: (c, s) {
          AddEditInvoiceScreen a = s.extra as AddEditInvoiceScreen;
          return AddEditInvoiceScreen(invoiceCode: a.invoiceCode);
        },
      );

  // static final AppRoute billHistoryDetail = AppRoute(
  //   path: '/bill-history-detail',
  //   name: 'bill history detail',
  //   iconPath: Assets.icons.billHistory,
  //   goBuilder: (c, s) => const BillHistoryDetails(),
  // );

  static final AppRoute customerQuotation = AppRoute(
    path: '/customer-quotation',
    name: 'customer quotation',
    iconPath: Assets.icons.quotations,
    routes: [
      customerQuotationsList,
      customerQuotationsAdd,
      customerQuotationsEdit(
          data: const AddEditCustomerQuotationsScreen(
              customerQuotationCode: null,),),
    ],
    shellBuilder: (ctx, s, c) => c,
  );

  static final AppRoute customerQuotationsList = AppRoute(
    path: '/customer-quotation-listing',
    name: 'customer quotation list',
    iconPath: Assets.icons.quotations,
    goBuilder: (c, s) => const CustomerQuotationScreen(),
  );

  static final AppRoute customerQuotationsAdd = AppRoute(
    path: '/customer-quotation-add',
    name: 'add customer quotation',
    iconPath: Assets.icons.quotations,
    goBuilder: (c, s) => const AddEditCustomerQuotationsScreen(
      customerQuotationCode: null,
    ),
  );

  static AppRoute customerQuotationsEdit(
          {required AddEditCustomerQuotationsScreen data,}) =>
      AppRoute(
        path: '/customer-quotations-edit',
        name: 'edit customer quotation',
        iconPath: Assets.icons.quotations,
        data: data,
        goBuilder: (c, s) {
          AddEditCustomerQuotationsScreen a =
              s.extra as AddEditCustomerQuotationsScreen;
          return AddEditCustomerQuotationsScreen(
              customerQuotationCode: a.customerQuotationCode,);
        },
      );

  static final AppRoute quotations = AppRoute(
    path: '/new supply',
    name: 'new supply',
    iconPath: Assets.icons.quotations,
    routes: [
      quotationsList,
      quotationsAdd,
      quotationsEdit(data: const AddEditQuotationsScreen(quotationsCode: null)),
    ],
    shellBuilder: (ctx, s, c) => c,
  );

  static final AppRoute quotationsList = AppRoute(
    path: '/new-supply-listing',
    name: 'new supply list',
    iconPath: Assets.icons.quotations,
    goBuilder: (c, s) => const QuotationsScreen(),
  );

  static final AppRoute quotationsAdd = AppRoute(
    path: '/new-supply-add',
    name: 'add new supply',
    iconPath: Assets.icons.quotations,
    goBuilder: (c, s) => const AddEditQuotationsScreen(
      quotationsCode: null,
    ),
  );

  static AppRoute quotationsEdit({required AddEditQuotationsScreen data}) =>
      AppRoute(
        path: '/new-supply-edit',
        name: 'edit new supply',
        iconPath: Assets.icons.quotations,
        data: data,
        goBuilder: (c, s) {
          AddEditQuotationsScreen a = s.extra as AddEditQuotationsScreen;
          return AddEditQuotationsScreen(quotationsCode: a.quotationsCode);
        },
      );

  static final AppRoute printerTemplates = AppRoute(
    path: '/printer-templates',
    name: 'printer templates',
    iconPath: Assets.icons.printerTemplates,
    goBuilder: (c, s) => const PrinterTemplatesScreen(),
  );

  static final AppRoute purchase = AppRoute(
    path: '/purchase',
    name: 'purchase',
    iconPath: Assets.icons.purchase,
    shellBuilder: (context, state, c) => c,
    routes: [
      purchaseList,
      returnedPurchaseList,
      stockAvailableList,
      stockTransferList
    ,],
  );

  static final AppRoute purchaseList = AppRoute(
    path: '/purchase-list',
    name: 'purchase list',
    iconPath: Assets.icons.taskSquare,
    routes: [
      purchaseListing,
      purchaseAdd,
      purchaseEdit(data: const AddEditPurchaseScreen(purchaseCode: null))
    ,],
    shellBuilder: (ctx, s, c) => c,
  );

  static final AppRoute purchaseListing = AppRoute(
    path: '/purchase-listing',
    name: 'purchase list',
    iconPath: Assets.icons.taskSquare,
    goBuilder: (c, s) => const PurchaseScreen(),
  );

  static final AppRoute purchaseAdd = AppRoute(
    path: '/purchase-add',
    name: 'add purchase',
    iconPath: Assets.icons.taskSquare,
    goBuilder: (c, s) => const AddEditPurchaseScreen(
      purchaseCode: null,
    ),
  );

  static AppRoute purchaseEdit({required AddEditPurchaseScreen data}) =>
      AppRoute(
        path: '/purchase-edit',
        name: 'edit purchase',
        iconPath: Assets.icons.taskSquare,
        data: data,
        goBuilder: (c, s) {
          AddEditPurchaseScreen a = s.extra as AddEditPurchaseScreen;
          return AddEditPurchaseScreen(purchaseCode: a.purchaseCode);
        },
      );

  static final AppRoute returnedPurchaseList = AppRoute(
    path: '/returned-purchase-list',
    name: 'returned purchase list',
    iconPath: Assets.icons.reports,
    routes: [
      returnedPurchaseListing,
      returnedPurchaseAdd,
      returnedPurchaseEdit(
          data:
              const AddEditReturnedPurchaseScreen(returnedPurchaseCode: null),),
    ],
    shellBuilder: (ctx, s, c) => c,
  );

  static final AppRoute returnedPurchaseListing = AppRoute(
    path: '/returned_purchase-listing',
    name: 'returned purchase list',
    iconPath: Assets.icons.reports,
    goBuilder: (c, s) => const ReturnedPurchaseScreen(),
  );

  static final AppRoute returnedPurchaseAdd = AppRoute(
    path: '/returned-purchase-add',
    name: 'add returned purchase',
    iconPath: Assets.icons.reports,
    goBuilder: (c, s) => const AddEditReturnedPurchaseScreen(
      returnedPurchaseCode: null,
    ),
  );

  static AppRoute returnedPurchaseEdit(
          {required AddEditReturnedPurchaseScreen data,}) =>
      AppRoute(
        path: '/returned-purchase-edit',
        name: 'edit returned purchase',
        iconPath: Assets.icons.reports,
        data: data,
        goBuilder: (c, s) {
          AddEditReturnedPurchaseScreen a =
              s.extra as AddEditReturnedPurchaseScreen;
          return AddEditReturnedPurchaseScreen(
              returnedPurchaseCode: a.returnedPurchaseCode,);
        },
      );

  /// ------------------------------------- Sub-routes in  [stockAvailableList] --------------------------------------------
  static final AppRoute stockAvailableList = AppRoute(
    path: '/stock_available-list',
    name: 'stock available list',
    iconPath: Assets.icons.stock,
    routes: [
      stockAvailableListing,
      stockAvailableAdd,
      stockAvailableEdit(
          data: const AddEditStockAvailableScreen(stockAvailableCode: null),),
    ],
    shellBuilder: (ctx, s, c) => c,
  );

  static final AppRoute stockAvailableListing = AppRoute(
    path: '/stock_available-listing',
    name: 'stock available listing',
    iconPath: Assets.icons.stock,
    goBuilder: (c, s) => const StockAvailableScreen(),
  );

  static final AppRoute stockAvailableAdd = AppRoute(
    path: '/stock-available-add',
    name: 'add stock available',
    iconPath: Assets.icons.stock,
    goBuilder: (c, s) => const AddEditStockAvailableScreen(
      stockAvailableCode: null,
    ),
  );

  static AppRoute stockAvailableEdit(
          {required AddEditStockAvailableScreen data,}) =>
      AppRoute(
        path: '/stock-available-edit',
        name: 'edit stock available',
        iconPath: Assets.icons.stock,
        data: data,
        goBuilder: (c, s) {
          AddEditStockAvailableScreen a =
              s.extra as AddEditStockAvailableScreen;
          return AddEditStockAvailableScreen(
              stockAvailableCode: a.stockAvailableCode,);
        },
      );

  static final AppRoute stockTransferList = AppRoute(
    path: '/stock-transfer-list',
    name: 'stock transfer',
    iconPath: Assets.icons.stockTransfer,
    routes: [
      stockTransfer,
      stockTransferAdd,
      stockTransferEdit(
          data: const AddEditStockPendingTransferScreen(
              stockPendingTransferCode: null,),),
    ],
    shellBuilder: (ctx, s, c) => c,
  );

  static final AppRoute stockTransfer = AppRoute(
    path: '/stock_transfer',
    name: 'stock transfer',
    iconPath: Assets.icons.stockTransfer,
    goBuilder: (c, s) => const StockTransferScreen(),
  );

  static final AppRoute stockTransferAdd = AppRoute(
    path: '/stock-transfer-add',
    name: 'add stock transfer',
    iconPath: Assets.icons.stockTransfer,
    goBuilder: (c, s) => const AddEditStockPendingTransferScreen(
      stockPendingTransferCode: null,
    ),
  );

  static AppRoute stockTransferEdit(
          {required AddEditStockPendingTransferScreen data,}) =>
      AppRoute(
        path: '/stock-transfer-edit',
        name: 'edit stock transfer',
        iconPath: Assets.icons.stockTransfer,
        data: data,
        goBuilder: (c, s) {
          AddEditStockPendingTransferScreen a =
              s.extra as AddEditStockPendingTransferScreen;
          return AddEditStockPendingTransferScreen(
              stockPendingTransferCode: a.stockPendingTransferCode,);
        },
      );

  static final AppRoute reports = AppRoute(
    path: '/reports',
    name: 'reports',
    iconPath: Assets.icons.reports,
    shellBuilder: (context, state, c) => c,
    routes: [
      generalReport,
      overviewReport,
      administrationReport,
      dayBookReport,
      gstReport,
    ],
  );

  static final AppRoute generalReport = AppRoute(
    path: '/general_report',
    name: 'general report',
    iconPath: Assets.icons.graph,
    goBuilder: (c, s) => const GeneralReportScreen(),
  );

  static final AppRoute overviewReport = AppRoute(
    path: '/overview_report',
    name: 'overview',
    iconPath: Assets.icons.receipt2,
    goBuilder: (c, s) => const OverviewReportScreen(),
  );

  static final AppRoute administrationReport = AppRoute(
    path: '/administration_report',
    name: 'administration',
    iconPath: Assets.icons.chart,
    goBuilder: (c, s) => const AdministrationReportScreen(),
  );

  static final AppRoute dayBookReport = AppRoute(
    path: '/day_book_report',
    name: 'day book',
    iconPath: Assets.icons.archive,
    goBuilder: (c, s) => const DayBookReportScreen(),
  );

  static final AppRoute gstReport = AppRoute(
    path: '/gst_report',
    name: 'gst',
    iconPath: Assets.icons.discountShape,
    goBuilder: (c, s) => const GstScreen(),
  );

  static final AppRoute master = AppRoute(
    path: '/master',
    name: 'master data',
    iconPath: Assets.icons.masterData,
    shellBuilder: (context, state, c) => c,
    routes: [items, suppliers, branch, employee, create, customers],
  );

  static final AppRoute items = AppRoute(
    path: '/items',
    name: 'items',
    iconPath: Assets.icons.items,
    routes: [
      itemListing,
      itemAdd,
      itemsEdit(data: const AddEditItemScreens(itemCode: null))
    ,],
    shellBuilder: (ctx, s, c) => c,
  );

  static final AppRoute itemListing = AppRoute(
    path: '/item-list',
    name: 'item list',
    iconPath: Assets.icons.items,
    goBuilder: (c, s) => const ItemListing(),
  );

  static final AppRoute itemAdd = AppRoute(
    path: '/item-add',
    name: 'add item',
    iconPath: Assets.icons.items,
    goBuilder: (c, s) => const AddEditItemScreens(
      itemCode: null,
    ),
  );

  static AppRoute itemsEdit({required AddEditItemScreens data}) => AppRoute(
        path: '/item-edit',
        name: 'edit item',
        iconPath: Assets.icons.employee,
        data: data,
        goBuilder: (c, s) {
          AddEditItemScreens a = s.extra as AddEditItemScreens;
          return AddEditItemScreens(itemCode: a.itemCode);
        },
      );

  static final AppRoute branch = AppRoute(
    path: '/branch',
    name: 'branch',
    iconPath: Assets.icons.branch,
    routes: [
      branchListing,
      branchAdd,
      branchEdit(data: const AddEditBranchScreen(shopCode: null))
    ,],
    shellBuilder: (ctx, s, c) => c,
  );

  static final AppRoute branchListing = AppRoute(
    path: '/branch-list',
    name: 'branch list',
    iconPath: Assets.icons.branch,
    goBuilder: (c, s) => const BranchScreen(),
  );

  static final AppRoute branchAdd = AppRoute(
    path: '/branch-add',
    name: 'add branch',
    iconPath: Assets.icons.branch,
    goBuilder: (c, s) => const AddEditBranchScreen(shopCode: null),
  );

  static AppRoute branchEdit({required AddEditBranchScreen data}) => AppRoute(
        path: '/branch-edit',
        name: 'edit branch',
        iconPath: Assets.icons.branch,
        data: data,
        goBuilder: (c, s) {
          AddEditBranchScreen a = s.extra as AddEditBranchScreen;
          return AddEditBranchScreen(shopCode: a.shopCode);
        },
      );

  static final AppRoute customers = AppRoute(
    path: '/customers',
    name: 'customers',
    iconPath: Assets.icons.people,
    routes: [
      customersListing,
      customersAdd,
      customersEdit(data: const AddEditCustomerScreen(customerCode: null)),
    ],
    shellBuilder: (ctx, s, c) => c,
  );

  static final AppRoute customersListing = AppRoute(
    path: '/customers-list',
    name: 'customers list',
    iconPath: Assets.icons.people,
    goBuilder: (c, s) => const CustomerScreen(),
  );

  static final AppRoute customersAdd = AppRoute(
    path: '/customers-add',
    name: 'add customers',
    iconPath: Assets.icons.people,
    goBuilder: (c, s) => const AddEditCustomerScreen(
      customerCode: null,
    ),
  );

  static AppRoute customersEdit({required AddEditCustomerScreen data}) =>
      AppRoute(
        path: '/customers-edit',
        name: 'edit customers',
        iconPath: Assets.icons.people,
        data: data,
        goBuilder: (c, s) {
          AddEditCustomerScreen a = s.extra as AddEditCustomerScreen;
          return AddEditCustomerScreen(customerCode: a.customerCode);
        },
      );

  static final AppRoute employee = AppRoute(
    path: '/employees',
    name: 'employees',
    iconPath: Assets.icons.employee,
    routes: [
      employeeListing,
      employeeAdd,
      employeeEdit(data: const AddEditEmployeeScreen(employeeCode: null))
    ,],
    shellBuilder: (ctx, s, c) => c,
  );

  static final AppRoute employeeListing = AppRoute(
    path: '/employee-list',
    name: 'employee list',
    iconPath: Assets.icons.employee,
    goBuilder: (c, s) => const EmployeeScreen(),
  );

  static final AppRoute employeeAdd = AppRoute(
    path: '/employee-add',
    name: 'add employee',
    iconPath: Assets.icons.employee,
    goBuilder: (c, s) => const AddEditEmployeeScreen(employeeCode: null),
  );

  static AppRoute employeeEdit({required AddEditEmployeeScreen data}) =>
      AppRoute(
        path: '/employee-edit',
        name: 'edit employee',
        iconPath: Assets.icons.employee,
        data: data,
        goBuilder: (c, s) {
          AddEditEmployeeScreen a = s.extra as AddEditEmployeeScreen;
          return AddEditEmployeeScreen(employeeCode: a.employeeCode);
        },
      );

  static final AppRoute create = AppRoute(
    path: '/create',
    name: 'create',
    iconPath: Assets.icons.create,
    goBuilder: (c, s) => const CreateScreen(),
  );

  static final AppRoute suppliers = AppRoute(
    path: '/suppliers',
    name: 'suppliers',
    iconPath: Assets.icons.suppliers,
    routes: [
      suppliersListing,
      supplierAdd,
      suppliersEdit(data: const AddEditSupplierScreen(supplierCode: null))
    ,],
    shellBuilder: (ctx, s, c) => c,
  );

  static final AppRoute suppliersListing = AppRoute(
    path: '/suppliers-list',
    name: 'supplier list',
    iconPath: Assets.icons.suppliers,
    goBuilder: (c, s) => const SupplierScreen(),
  );

  static final AppRoute supplierAdd = AppRoute(
    path: '/suppliers-add',
    name: 'add supplier',
    iconPath: Assets.icons.suppliers,
    goBuilder: (c, s) => const AddEditSupplierScreen(
      supplierCode: null,
    ),
  );

  static AppRoute suppliersEdit({required AddEditSupplierScreen data}) =>
      AppRoute(
        path: '/suppliers-edit',
        name: 'edit suppliers',
        iconPath: Assets.icons.employee,
        data: data,
        goBuilder: (c, s) {
          AddEditSupplierScreen a = s.extra as AddEditSupplierScreen;
          return AddEditSupplierScreen(supplierCode: a.supplierCode);
        },
      );
}
