part of '../gstr_one_screen.dart';

List<DataTableItem> _titles() => [
      const DataTableItem(percentWidth: 12, label: 'Date'),
      const DataTableItem(percentWidth: 12, label: 'HSN Code'),
      const DataTableItem(percentWidth: 16, label: 'Item Name & Code'),
      const DataTableItem(percentWidth: 15, label: 'Brand Name & Code'),
      const DataTableItem(percentWidth: 15, label: 'Bill Number'),
      const DataTableItem(percentWidth: 15, label: 'Customer Name'),
      const DataTableItem(percentWidth: 15, label: 'Price'),
    ];

List<DataTableItem> _tileSections(GstOneModel gst) => [
      DataTableItem(percentWidth: 12, label: gst.date),
      DataTableItem(percentWidth: 12, label: gst.hsnCode),
      DataTableItem(
        percentWidth: 16,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              gst.itemName,
              style: Ts.rgRegular(color: Tm.color(Tc.tableConTxt)),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              gst.itemCode,
              style: Ts.mdRegular(color: Tm.color(Tc.tableConSubTxt)),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
      DataTableItem(
        percentWidth: 15,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              gst.brandName,
              style: Ts.rgRegular(color: Tm.color(Tc.tableConTxt)),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              gst.brandCode,
              style: Ts.mdRegular(color: Tm.color(Tc.tableConSubTxt)),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
      DataTableItem(percentWidth: 15, label: gst.billNumber),
      DataTableItem(percentWidth: 15, label: gst.customerName),
      DataTableItem(percentWidth: 15, label: StaticValues.currencySymbol(gst.price.toString())),
    ];
