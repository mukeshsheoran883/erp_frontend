part of '../returned_purchase_screen.dart';

List<DataTableItem> _titles() => [
      const DataTableItem(percentWidth: 16, label: 'Return ID'),
      const DataTableItem(percentWidth: 16, label: 'Purchase ID'),
      const DataTableItem(percentWidth: 30, label: 'Supplier Name'),
      const DataTableItem(percentWidth: 16, label: 'Date & Time'),
      const DataTableItem(percentWidth: 16, label: 'Amount'),
    ];

List<DataTableItem> _tileSections(ReturnedPurchaseModel returnedPurchase) => [
      DataTableItem(percentWidth: 16, label: returnedPurchase.returnId),
      DataTableItem(percentWidth: 16, label: returnedPurchase.purchaseId),
      DataTableItem(percentWidth: 30, label: returnedPurchase.supplierName),
      DataTableItem(
        percentWidth: 16,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              returnedPurchase.date,
              style: Ts.rgRegular(color: Tm.color(Tc.tableConTxt)),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              returnedPurchase.time,
              style: Ts.mdRegular(color: Tm.color(Tc.tableConSubTxt)),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
      DataTableItem(percentWidth: 16, label: StaticValues.currencySymbol(returnedPurchase.amount)),
    ];
