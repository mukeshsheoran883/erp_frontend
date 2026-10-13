part of '../gstr_two_screen.dart';

List<DataTableItem> _titles() => [
      const DataTableItem(percentWidth: 10, label: 'Supplier GST No'),
      const DataTableItem(percentWidth: 9, label: 'Purchase ID'),
      const DataTableItem(percentWidth: 10, label: 'HSN Code'),
      const DataTableItem(percentWidth: 11, label: 'Reseller GST No'),
      const DataTableItem(percentWidth: 5, label: 'QTY'),
      const DataTableItem(percentWidth: 10, label: 'Price'),
      const DataTableItem(percentWidth: 10, label: 'Total Price'),
      const DataTableItem(percentWidth: 10, label: 'Tax'),
      const DataTableItem(percentWidth: 10, label: 'Tax Amount'),
      const DataTableItem(percentWidth: 15, label: 'Branch Name & Code'),
    ];

List<DataTableItem> _tileSections(GstTwoModel gst) => [
      DataTableItem(percentWidth: 10, label: gst.supplierGSTNo),
      DataTableItem(percentWidth: 9, label: gst.purchaseID),
      DataTableItem(percentWidth: 10, label: gst.hsnCode),
      DataTableItem(percentWidth: 11, label: gst.resellerGSTNo),
      DataTableItem(percentWidth: 5, label: gst.qty),
      DataTableItem(percentWidth: 10, label: StaticValues.currencySymbol(gst.price)),
      DataTableItem(percentWidth: 10, label: StaticValues.currencySymbol(gst.totalPrice)),
      DataTableItem(percentWidth: 10, label: gst.tax),
      DataTableItem(percentWidth: 10, label: StaticValues.currencySymbol(gst.taxAmount)),
      DataTableItem(
        percentWidth: 15,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              gst.branchName,
              style: Ts.rgRegular(color: Tm.color(Tc.tableConTxt)),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              gst.branchCode,
              style: Ts.mdRegular(color: Tm.color(Tc.tableConSubTxt)),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    ];
