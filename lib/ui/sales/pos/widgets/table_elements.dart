part of '../pos_screen.dart';

List<DataTableItem> _titles() => [
      const DataTableItem(percentWidth: 12, label: 'Pos Code'),
      const DataTableItem(percentWidth: 22, label: 'Customer Name'),
      const DataTableItem(percentWidth: 17, label: 'Shop Code'),
      const DataTableItem(percentWidth: 12, label: 'Amount'),
      const DataTableItem(percentWidth: 12, label: 'Created Date'),
      const DataTableItem(percentWidth: 25, label: 'Status'),
      // const DataTableItem(percentWidth: 10, label: 'Balance Qty'),
      // const DataTableItem(percentWidth: 23, label: 'Expiry Date'),
      // const DataTableItem(percentWidth: 20, label: 'Price'),
      // const DataTableItem(percentWidth: 20, label: 'Balance Qty'),
    ];

List<DataTableItem> _tileSections(PosModel pos) => [
  DataTableItem(percentWidth: 12, label: pos.posCode),
      DataTableItem(percentWidth: 22, label: pos.customerName),
      DataTableItem(percentWidth: 17, label: pos.shopCode),
      DataTableItem(percentWidth: 12, label: StaticValues.currencySymbol(pos.amount.toString())),
      DataTableItem(percentWidth: 12, label: StaticValues.commonDateFormatSlash.format(pos.createdDate)),
      DataTableItem(percentWidth: 25, label: pos.status),
      // DataTableItem(percentWidth: 10, label: StaticValues.currencySymbol(purchase.balanceQty.toString())),
  //     DataTableItem(percentWidth: 23, label: StaticValues.commonDateFormatSlash.format(purchase.expiryDate)),
  //     DataTableItem(percentWidth: 20, label: StaticValues.currencySymbol(purchase.balanceQty.toString())),
];
