part of '../sales_report_screen.dart';

List<DataTableItem> _titles() => [
      const DataTableItem(percentWidth: 9, label: 'Bill Number'),
      const DataTableItem(percentWidth: 9, label: 'Bill Date'),
      const DataTableItem(percentWidth: 16, label: 'Item Name & Code'),
      const DataTableItem(percentWidth: 9, label: 'HSN Code'),
      const DataTableItem(percentWidth: 9, label: 'Qty'),
      const DataTableItem(percentWidth: 8, label: 'Price'),
      const DataTableItem(percentWidth: 8, label: 'Total Price'),
      const DataTableItem(percentWidth: 16, label: 'Customer Name & Code'),
      const DataTableItem(percentWidth: 16, label: 'Branch Name & Code'),
    ];

List<DataTableItem> _tileSections(SalesReportModel sales) => [
      DataTableItem(percentWidth: 9, label: sales.billNumber),
      DataTableItem(percentWidth: 9, label: sales.billDate),
      DataTableItem(
        percentWidth: 16,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              sales.itemName,
              style: Ts.rgRegular(color: Tm.color(Tc.tableConTxt)),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              sales.itemCode,
              style: Ts.mdRegular(color: Tm.color(Tc.tableConSubTxt)),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
      DataTableItem(percentWidth: 9, label: sales.hsnCode),
      DataTableItem(percentWidth: 9, label: sales.qty),
      DataTableItem(percentWidth: 8, label: StaticValues.currencySymbol(sales.price)),
      DataTableItem(percentWidth: 8, label: StaticValues.currencySymbol(sales.totalPrice)),
      DataTableItem(
        percentWidth: 16,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              sales.customerName,
              style: Ts.rgRegular(color: Tm.color(Tc.tableConTxt)),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              sales.customerCode,
              style: Ts.mdRegular(color: Tm.color(Tc.tableConSubTxt)),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
      DataTableItem(
        percentWidth: 16,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              sales.branchName,
              style: Ts.rgRegular(color: Tm.color(Tc.tableConTxt)),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              sales.branchCode,
              style: Ts.mdRegular(color: Tm.color(Tc.tableConSubTxt)),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    ];
