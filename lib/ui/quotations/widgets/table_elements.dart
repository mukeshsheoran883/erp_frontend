part of '../quotations_screen.dart';

List<DataTableItem> _titles() => [
      const DataTableItem(percentWidth: 10, label: 'Quotation Code'),
      const DataTableItem(percentWidth: 12, label: 'Supplier Name'),
      const DataTableItem(percentWidth: 12, label: 'Item Name'),
      const DataTableItem(percentWidth: 12, label: 'Brand Name'),
      const DataTableItem(percentWidth: 12, label: 'Description'),
      const DataTableItem(percentWidth: 12, label: 'Quantity'),
      const DataTableItem(percentWidth: 8, label: 'Tax %'),
      const DataTableItem(percentWidth: 8, label: 'Price'),
      const DataTableItem(percentWidth: 12, label: 'Total Price'),
      // const DataTableItem(percentWidth: 16, label: 'Item Count'),
      // const DataTableItem(percentWidth: 16, label: 'Total Price'),
    ];

List<DataTableItem> _tileSections(QuotationsModel quotations) => [
      DataTableItem(percentWidth: 10, label: quotations.quotationCode),
      DataTableItem(percentWidth: 12, label: quotations.supplierName),
      DataTableItem(percentWidth: 12, label: quotations.itemName),
      DataTableItem(percentWidth: 12, label: quotations.description),
      DataTableItem(percentWidth: 12, label: quotations.brand),
      DataTableItem(percentWidth: 12, label: quotations.quantity.toString()),
      DataTableItem(percentWidth: 8, label: quotations.tax.toString()),
      DataTableItem(percentWidth: 8, label: StaticValues.currencySymbol(quotations.price.toString())),
      DataTableItem(percentWidth: 12, label: StaticValues.currencySymbol(quotations.total.toString())),
      // DataTableItem(percentWidth: 16, label: quotations.itemName),
      // DataTableItem(percentWidth: 16, label: quotations.itemName),
    ];
