part of '../tax_screen.dart';

List<DataTableItem> _titles() => [
  const DataTableItem(percentWidth: 9, label: 'Code'),
  const DataTableItem(percentWidth: 34, label: 'Tax Name'),
  const DataTableItem(percentWidth: 34, label: 'Tax %'),
  const DataTableItem(percentWidth: 23, label: 'Total Tax %'),
];

List<DataTableItem> _tileSections(TaxModel tax) => [
  DataTableItem(percentWidth: 9, label: tax.taxCode),
  DataTableItem(percentWidth: 34, label: tax.name),
  DataTableItem(percentWidth: 34, label: tax.taxSplitsLabel),
  DataTableItem(percentWidth: 23, label: tax.totalTaxLabel),
];