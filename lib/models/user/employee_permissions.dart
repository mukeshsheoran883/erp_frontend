
import 'package:invently/models/user/employee_permission_model.dart';

class EmployeePermission {
  ///ToDo:Check - must update this list if any of the sub permission is added or removed
  EmployeePermission() {
    dashboardGroup.subModules = [dashboard];
    masterGroup.subModules = [items, shop, suppliers, customers, create, employees];
    inventoryGroup.subModules = [inventory];
    salesGroup.subModules = [pos, returnItem, billHistory];
    quotationsGroup.subModules = [quotations];
    printerTemplatesGroup.subModules = [printerTemplates];
    purchaseGroup.subModules = [stock, purchaseList, returnedPurchase];
    reportsGroup.subModules = [general, overview, administrationReport, dayBook, gst];
  }

  ///ToDo:Check - must update this list if any of the permission group is added or removed
  List<EmployeePermissionGroupModel> permissionList() => [
        dashboardGroup,
        masterGroup,
        inventoryGroup,
        salesGroup,
        quotationsGroup,
        printerTemplatesGroup,
        purchaseGroup,
        reportsGroup,
      ];

  bool isAnyOnePermissionGranted() {
    bool hasPermission = false;
    for (final i in permissionList()) {
      if (i.hasPermission()) hasPermission = true;
    }

    return hasPermission;
  }

  factory EmployeePermission.fromJson(Map<String, dynamic> json) {
    EmployeePermission newPermissions = EmployeePermission();

    for (final i in newPermissions.permissionList()) {
      i.setPermissionFromJson(json);
    }

    return newPermissions;
  }

  Map<String, dynamic> toJson() => Map.fromEntries(permissionList().map((e) => e.toJsonEntry()));

  /// ----------------------------------------------- Dashboard Module -------------------------------------------------
  EmployeePermissionGroupModel dashboardGroup = EmployeePermissionGroupModel(
    moduleName: 'Dashboard',
    jsonKey: 'dashboard',
    description:
        'View and analyze sales, purchases, stock levels, profit margins, expiry reminders, and more — all in one centralized dashboard',
  );

  EmployeePermissionModel dashboard = EmployeePermissionModel(
    moduleName: 'Dashboard',
    jsonKey: 'dashboard',
    description:
        'View and analyze sales, purchases, stock levels, profit margins, expiry reminders, and more — all in one centralized dashboard',
    hasPermission: false,
  );

  /// ----------------------------------------------- Master Module -------------------------------------------------
  EmployeePermissionGroupModel masterGroup = EmployeePermissionGroupModel(
    moduleName: 'Master',
    jsonKey: 'master',
    description:
        'Efficiently manage items, suppliers, branches, customers, create modules, and employees all in one place.',
  );
  EmployeePermissionModel items = EmployeePermissionModel(
    moduleName: 'Items',
    jsonKey: 'item',
    description: 'Add, organize, and manage item listings with bulk insertion and detailed categorization.',
    hasPermission: false,
  );
  EmployeePermissionModel shop = EmployeePermissionModel(
    moduleName: 'Shop',
    jsonKey: 'shop',
    description: 'Add, view, and manage shop/branch details.',
    hasPermission: false,
  );
  EmployeePermissionModel suppliers = EmployeePermissionModel(
    moduleName: 'Suppliers',
    jsonKey: 'supplier',
    description: 'Add, filter, and manage supplier information with detailed contact records.',
    hasPermission: false,
  );

  EmployeePermissionModel customers = EmployeePermissionModel(
    moduleName: 'Customers',
    jsonKey: 'customer',
    description: 'Manage customer details with contact information and location data for streamlined service.',
    hasPermission: false,
  );
  EmployeePermissionModel create = EmployeePermissionModel(
    moduleName: 'Create',
    jsonKey: 'create',
    description:
        'Create, organize, and manage brand, tax, category and other common listings for streamlined product categorization.',
    hasPermission: false,
  );
  EmployeePermissionModel employees = EmployeePermissionModel(
    moduleName: 'Employees',
    jsonKey: 'employee',
    description: 'Add, view, and manage employee details, including contact information and status.',
    hasPermission: false,
  );

  /// ----------------------------------------------- Inventory Module -------------------------------------------------
  EmployeePermissionGroupModel inventoryGroup = EmployeePermissionGroupModel(
    moduleName: 'Inventory',
    jsonKey: 'inventory',
    description:
        'Access comprehensive inventory insights: view items, track stock levels, monitor prices, and manage all item details in one place.',
  );
  EmployeePermissionModel inventory = EmployeePermissionModel(
    moduleName: 'Inventory',
    jsonKey: 'inventory',
    description:
        'Access comprehensive inventory insights: view items, track stock levels, monitor prices, and manage all item details in one place.',
    hasPermission: false,
  );

  /// ----------------------------------------------- Sales Module -------------------------------------------------
  EmployeePermissionGroupModel salesGroup = EmployeePermissionGroupModel(
    moduleName: 'Sales',
    jsonKey: 'billing',
    description: 'Manage point of sales, item returns and bill history easily.',
  );

  EmployeePermissionModel pos = EmployeePermissionModel(
    moduleName: 'POS',
    jsonKey: 'pos',
    description:
        'Generate bills, manage inventory, apply discounts, and process multiple payment methods effortlessly.',
    hasPermission: false,
  );
  EmployeePermissionModel returnItem = EmployeePermissionModel(
    moduleName: 'Return Item',
    jsonKey: 'return_item',
    description: 'Track and process item returns with customer details, return reasons, and total amounts.',
    hasPermission: false,
  );
  EmployeePermissionModel billHistory = EmployeePermissionModel(
    moduleName: 'Bill History',
    jsonKey: 'bill_history',
    description: 'View and filter bill history with details on date, branch, customer, and total amount.',
    hasPermission: false,
  );

  /// ----------------------------------------------- Quotations Module -------------------------------------------------

  EmployeePermissionGroupModel quotationsGroup = EmployeePermissionGroupModel(
    moduleName: 'Quotations',
    jsonKey: 'quotations',
    description: 'Create, manage, and track sales quotations for streamlined client interactions.',
  );

  EmployeePermissionModel quotations = EmployeePermissionModel(
    moduleName: 'Quotations',
    jsonKey: 'quotations',
    description: 'Create, manage, and track sales quotations for streamlined client interactions.',
    hasPermission: false,
  );

  /// ----------------------------------------------- Printer Templates Module -------------------------------------------------
  EmployeePermissionGroupModel printerTemplatesGroup = EmployeePermissionGroupModel(
    moduleName: 'Printer Templates',
    jsonKey: 'printer_templates',
    description: 'Customize, preview, and print templates for professional document formatting.',
  );
  EmployeePermissionModel printerTemplates = EmployeePermissionModel(
    moduleName: 'Printer Templates',
    jsonKey: 'printer_templates',
    description: 'Customize, preview, and print templates for professional document formatting.',
    hasPermission: false,
  );

  /// ----------------------------------------------- Purchase Module -------------------------------------------------
  EmployeePermissionGroupModel purchaseGroup = EmployeePermissionGroupModel(
    moduleName: 'Purchase',
    jsonKey: 'stock',
    description: 'Manage Purchases, returned purchases, stock and stock transfers effortlessly.',
  );

  EmployeePermissionModel purchaseList = EmployeePermissionModel(
    moduleName: 'Purchase List',
    jsonKey: 'purchase_list',
    description: 'Track, filter, and manage purchase records efficiently in one place.',
    hasPermission: false,
  );
  EmployeePermissionModel returnedPurchase = EmployeePermissionModel(
    moduleName: 'Returned Purchase',
    jsonKey: 'return_purchase',
    description: 'Record and track returned purchases with supplier details, date, and amount.',
    hasPermission: false,
  );
  EmployeePermissionModel stock = EmployeePermissionModel(
    moduleName: 'Stock',
    jsonKey: 'stock',
    description: 'Monitor and update stock availability with supplier details, purchase information, and amounts.',
    hasPermission: false,
  );

  /// ----------------------------------------------- Reports Module -------------------------------------------------

  EmployeePermissionGroupModel reportsGroup = EmployeePermissionGroupModel(
    moduleName: 'Reports',
    jsonKey: 'reports',
    description:
        'Generate, view, and download comprehensive reports across general, overview, administration, day book and GST.',
  );

  EmployeePermissionModel general = EmployeePermissionModel(
    moduleName: 'General',
    jsonKey: 'general',
    description:
        'Generate and download detailed purchase, stock, sales, and quotation reports with pricing and supplier information.',
    hasPermission: false,
  );
  EmployeePermissionModel overview = EmployeePermissionModel(
    moduleName: 'Overview',
    jsonKey: 'overview',
    description:
        'Access and download an overview of items, customers, inventory balance, and supplier data with detailed codes and descriptions.',
    hasPermission: false,
  );
  EmployeePermissionModel administrationReport = EmployeePermissionModel(
    moduleName: 'Administration',
    jsonKey: 'administration',
    description: 'Manage and download employee and attendance records with detailed personal and contact information.',
    hasPermission: false,
  );
  EmployeePermissionModel dayBook = EmployeePermissionModel(
    moduleName: 'Day Book',
    jsonKey: 'day_book',
    description: 'Generate, view, and download comprehensive reports across purchases, sales, and stock of the day.',
    hasPermission: false,
  );
  EmployeePermissionModel gst = EmployeePermissionModel(
    moduleName: 'GST',
    jsonKey: 'gst',
    description: 'Generate, view, and download GST reports with item, brand, customer details, and tax data.',
    hasPermission: false,
  );

  /// ---------------------------------------------------------------------------------------------------------------
}
