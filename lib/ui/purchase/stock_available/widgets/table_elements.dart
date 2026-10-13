part of '../stock_available_screen.dart';

List<DataTableItem> _titles() => [
  const DataTableItem(percentWidth: 16, label: 'Return ID'),
  const DataTableItem(percentWidth: 16, label: 'Purchase ID'),
  const DataTableItem(percentWidth: 30, label: 'Supplier Name'),
  const DataTableItem(percentWidth: 16, label: 'Date & Time'),
  const DataTableItem(percentWidth: 16, label: 'Amount'),
];

List<DataTableItem> _tileSections(StockAvailableModel stockAvailable) => [
  DataTableItem(percentWidth: 16, label: stockAvailable.returnId),
  DataTableItem(percentWidth: 16, label: stockAvailable.purchaseId),
  DataTableItem(percentWidth: 30, label: stockAvailable.supplierName),
  DataTableItem(
    percentWidth: 16,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          stockAvailable.date,
          style: Ts.rgRegular(color: Tm.color(Tc.tableConTxt)),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        Text(
          stockAvailable.time,
          style: Ts.mdRegular(color: Tm.color(Tc.tableConSubTxt)),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    ),
  ),
  DataTableItem(percentWidth: 16, label: StaticValues.currencySymbol(stockAvailable.amount)),
];
