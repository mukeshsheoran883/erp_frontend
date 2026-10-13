part of '../inventory_screen.dart';

List<DataTableItem> _titles() => [
      const DataTableItem(percentWidth: 10, label: 'Inventory Code'),
      const DataTableItem(percentWidth: 20, label: 'Item Name'),
      const DataTableItem(percentWidth: 15, label: 'Shop Name'),
      const DataTableItem(percentWidth: 10, label: 'Price'),
      const DataTableItem(percentWidth: 10, label: 'Expiry Date'),
      const DataTableItem(percentWidth: 25, label: 'description'),
      const DataTableItem(percentWidth: 10, label: 'Balance Qty'),
      // const DataTableItem(percentWidth: 23, label: 'Expiry Date'),
      // const DataTableItem(percentWidth: 20, label: 'Price'),
      // const DataTableItem(percentWidth: 20, label: 'Balance Qty'),
    ];

List<DataTableItem> _tileSections(InventoryModel purchase) => [
  DataTableItem(percentWidth: 10, label: purchase.inventoryCode),
      DataTableItem(percentWidth: 20, label: purchase.itemName),
      DataTableItem(percentWidth: 15, label: purchase.shopName),
      DataTableItem(percentWidth: 10, label: StaticValues.currencySymbol(purchase.price.toString())),
      DataTableItem(percentWidth: 10, label: StaticValues.commonDateFormatSlash.format(purchase.expiryDate)),
      DataTableItem(percentWidth: 25, label: purchase.description),
      DataTableItem(percentWidth: 10, label: purchase.balanceQty.toString()),
  //     DataTableItem(percentWidth: 23, label: StaticValues.commonDateFormatSlash.format(purchase.expiryDate)),
  //     DataTableItem(percentWidth: 20, label: StaticValues.currencySymbol(purchase.balanceQty.toString())),
];
