part of '../purchase_report_screen.dart';

List<DataTableItem> _titles() => [
      const DataTableItem(percentWidth: 11, label: 'Item Name & Code'),
      const DataTableItem(percentWidth: 4, label: 'Qty'),
      const DataTableItem(percentWidth: 5, label: 'Price'),
      const DataTableItem(percentWidth: 9, label: 'Landing Cost'),
      const DataTableItem(percentWidth: 8, label: 'Retail Price'),
      const DataTableItem(percentWidth: 7, label: 'MRP Price'),
      const DataTableItem(percentWidth: 13, label: 'Supplier Name & Code'),
      const DataTableItem(percentWidth: 8, label: 'Date'),
      const DataTableItem(percentWidth: 8, label: 'Purchase Id'),
      const DataTableItem(percentWidth: 7, label: 'Discount'),
      const DataTableItem(percentWidth: 7, label: 'HSN Code'),
      const DataTableItem(percentWidth: 13, label: 'Branch Name & Code'),
    ];

List<DataTableItem> _tileSections(PurchaseReportModel purchase) => [
      DataTableItem(
        percentWidth: 11,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              purchase.itemName,
              style: Ts.rgRegular(color: Tm.color(Tc.tableConTxt)),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              purchase.itemCode,
              style: Ts.mdRegular(color: Tm.color(Tc.tableConSubTxt)),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
      DataTableItem(percentWidth: 4, label: purchase.qty),
      DataTableItem(percentWidth: 5, label: StaticValues.currencySymbol(purchase.price)),
      DataTableItem(percentWidth: 9, label: StaticValues.currencySymbol(purchase.landingCast)),
      DataTableItem(percentWidth: 8, label: StaticValues.currencySymbol(purchase.retailPrice)),
      DataTableItem(percentWidth: 7, label: StaticValues.currencySymbol(purchase.mrpPrice)),
      DataTableItem(
        percentWidth: 13,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              purchase.supplierName,
              style: Ts.rgRegular(color: Tm.color(Tc.tableConTxt)),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              purchase.supplierCode,
              style: Ts.mdRegular(color: Tm.color(Tc.tableConSubTxt)),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
      DataTableItem(percentWidth: 8, label: purchase.date),
      DataTableItem(percentWidth: 8, label: purchase.purchaseId),
      DataTableItem(percentWidth: 7, label: purchase.discount),
      DataTableItem(percentWidth: 7, label: purchase.hsnCode),
      DataTableItem(
        percentWidth: 13,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              purchase.branchName,
              style: Ts.rgRegular(color: Tm.color(Tc.tableConTxt)),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              purchase.branchCode,
              style: Ts.mdRegular(color: Tm.color(Tc.tableConSubTxt)),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    ];
