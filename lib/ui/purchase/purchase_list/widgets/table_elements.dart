part of '../purchase_screen.dart';

List<DataTableItem> _titles() => [
      const DataTableItem(percentWidth: 12, label: 'Purchase Code'),
      const DataTableItem(percentWidth: 18, label: 'Purchase Number'),
      const DataTableItem(percentWidth: 27, label: 'Date & Time'),
      const DataTableItem(percentWidth: 29, label: 'Supplier Name'),
      const DataTableItem(percentWidth: 14, label: 'Bill Amount'),
    ];

List<DataTableItem> _tileSections(PurchaseModel purchase) => [
      DataTableItem(percentWidth: 12, label: purchase.purchaseCode),
      DataTableItem(percentWidth: 18, label: purchase.purchaseBillNumber),
      DataTableItem(
        percentWidth: 27,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              StaticValues.commonDateMonthFormat.format(purchase.createdTime),
              style: Ts.rgRegular(color: Tm.color(Tc.tableConTxt)),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              StaticValues.commonTimeFormat.format(purchase.createdTime),
              style: Ts.mdRegular(color: Tm.color(Tc.tableConSubTxt)),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
      DataTableItem(percentWidth: 29, label: purchase.supplierName),
      DataTableItem(percentWidth: 14, label: StaticValues.currencySymbol(purchase.billAmount.toString())),
    ];
