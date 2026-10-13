part of '../stock_report_screen.dart';

List<DataTableItem> _titles() => [
      const DataTableItem(percentWidth: 12, label: 'Purchase ID'),
      const DataTableItem(percentWidth: 20, label: 'Item Name & Code'),
      const DataTableItem(percentWidth: 12, label: 'Qty'),
      const DataTableItem(percentWidth: 12, label: 'Date'),
      const DataTableItem(percentWidth: 12, label: 'Price'),
      const DataTableItem(percentWidth: 12, label: 'HSN Code'),
      const DataTableItem(percentWidth: 20, label: 'Branch Name & Code'),
    ];

List<DataTableItem> _tileSections(StockReportModel stock) => [
      DataTableItem(percentWidth: 12, label: stock.purchaseId),
      DataTableItem(
        percentWidth: 20,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              stock.itemName,
              style: Ts.rgRegular(color: Tm.color(Tc.tableConTxt)),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              stock.itemCode,
              style: Ts.mdRegular(color: Tm.color(Tc.tableConSubTxt)),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
      DataTableItem(percentWidth: 12, label: stock.qty),
      DataTableItem(percentWidth: 12, label: stock.date),
      DataTableItem(percentWidth: 12, label: StaticValues.currencySymbol(stock.price)),
      DataTableItem(percentWidth: 12, label: stock.hsnCode),
      DataTableItem(
        percentWidth: 20,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              stock.branchName,
              style: Ts.rgRegular(color: Tm.color(Tc.tableConTxt)),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              stock.branchCode,
              style: Ts.mdRegular(color: Tm.color(Tc.tableConSubTxt)),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    ];
