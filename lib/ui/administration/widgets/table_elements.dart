part of '../administration_screen.dart';

List<DataTableItem> _titles() => [
      const DataTableItem(percentWidth: 15, label: 'Organization'),
      const DataTableItem(percentWidth: 15, label: 'Contact Person'),
      const DataTableItem(percentWidth: 15, label: 'Plan'),
      const DataTableItem(percentWidth: 20, label: 'Plan Expiry'),
      const DataTableItem(percentWidth: 20, label: 'Branch Count'),
      const DataTableItem(percentWidth: 15, label: 'User Count'),
    ];

List<DataTableItem> _tileSections(AdministrationModel administration) => [
      DataTableItem(percentWidth: 15, label: administration.name),
      DataTableItem(percentWidth: 15, label: administration.contactPersonName),
      DataTableItem(percentWidth: 15, label: administration.plan),
      DataTableItem(percentWidth: 20, label: StaticValues.commonDateFormatSlash.format(administration.planExpiry)),
      DataTableItem(percentWidth: 20, label: administration.shopCount.toString()),
      DataTableItem(percentWidth: 15, label: administration.employeeCount.toString()),
    ];
