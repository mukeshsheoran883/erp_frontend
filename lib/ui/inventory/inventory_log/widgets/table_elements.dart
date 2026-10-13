part of '../inventory_log_screen.dart';

List<DataTableItem> _titles() => [
  const DataTableItem(percentWidth: 12, label: 'Inventory Code'),
  const DataTableItem(percentWidth: 18, label: 'Change Date'),
  const DataTableItem(percentWidth: 18, label: 'Event Type'),
  const DataTableItem(percentWidth: 20, label: 'Batch Id'),
  const DataTableItem(percentWidth: 13, label: 'Status'),
  const DataTableItem(percentWidth: 25, label: 'Error Message'),
];

List<DataTableItem> _tileSections(InventoryLogModel log) => [
  DataTableItem(percentWidth: 12, label: log.inventoryCode),
  DataTableItem(percentWidth: 18, label: StaticValues.commonDateTimeFormat.format(log.changeDate)),
  DataTableItem(percentWidth: 18, label: log.eventType),
  DataTableItem(percentWidth: 20, label: log.batchId),
  DataTableItem(percentWidth: 13, label: log.status),
  DataTableItem(percentWidth: 25, label: log.errorMessage.isEmpty ? '-' : log.errorMessage),
];