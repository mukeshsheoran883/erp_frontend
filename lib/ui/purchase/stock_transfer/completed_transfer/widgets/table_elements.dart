part of '../stock_completed_transfer_screen.dart';

List<DataTableItem> _titles() => [
      const DataTableItem(percentWidth: 23, label: 'SL. No'),
      const DataTableItem(percentWidth: 23, label: 'Request ID'),
      const DataTableItem(percentWidth: 24, label: 'Raised By'),
      const DataTableItem(percentWidth: 24, label: 'Created On'),
    ];

List<DataTableItem> _tileSections(StockCompletedTransferModel stockCompletedTransfer) => [
      DataTableItem(percentWidth: 23, label: stockCompletedTransfer.slNo),
      DataTableItem(percentWidth: 23, label: stockCompletedTransfer.requestId),
      DataTableItem(percentWidth: 24, label: stockCompletedTransfer.raisedBy),
      DataTableItem(
        percentWidth: 24,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              stockCompletedTransfer.date,
              style: Ts.rgRegular(color: Tm.color(Tc.tableConTxt)),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              stockCompletedTransfer.time,
              style: Ts.mdRegular(color: Tm.color(Tc.tableConSubTxt)),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    ];
