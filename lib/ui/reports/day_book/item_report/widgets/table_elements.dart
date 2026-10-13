part of '../item_report_screen.dart';

List<DataTableItem> _titles() => [
      const DataTableItem(percentWidth: 14, label: 'Item Name & Code'),
      const DataTableItem(percentWidth: 14, label: 'Item Description'),
      const DataTableItem(percentWidth: 12, label: 'Brand Name & Code'),
      const DataTableItem(percentWidth: 14, label: 'Category Name & Code'),
      const DataTableItem(percentWidth: 8, label: 'Bar Code'),
      const DataTableItem(percentWidth: 8, label: 'QR Code'),
      const DataTableItem(percentWidth: 14, label: 'Supplier Name & Code'),
      const DataTableItem(percentWidth: 8, label: 'Created At'),
      const DataTableItem(percentWidth: 8, label: 'HSN Code'),
    ];

List<DataTableItem> _tileSections(DayBookItemModel item) => [
      DataTableItem(
        percentWidth: 14,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              item.itemName,
              style: Ts.rgRegular(color: Tm.color(Tc.tableConTxt)),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              item.itemCode,
              style: Ts.mdRegular(color: Tm.color(Tc.tableConSubTxt)),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
      DataTableItem(percentWidth: 14, label: item.itemDescription),
      DataTableItem(
        percentWidth: 12,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              item.brandName,
              style: Ts.rgRegular(color: Tm.color(Tc.tableConTxt)),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              item.brandCode,
              style: Ts.mdRegular(color: Tm.color(Tc.tableConSubTxt)),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
      DataTableItem(
        percentWidth: 14,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              item.categoryName,
              style: Ts.rgRegular(color: Tm.color(Tc.tableConTxt)),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              item.categoryCode,
              style: Ts.mdRegular(color: Tm.color(Tc.tableConSubTxt)),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
      DataTableItem(percentWidth: 8, label: item.barCode),
      DataTableItem(percentWidth: 8, label: item.qrCode),
      DataTableItem(
        percentWidth: 14,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              item.suppliesName,
              style: Ts.rgRegular(color: Tm.color(Tc.tableConTxt)),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              item.suppliesCode,
              style: Ts.mdRegular(color: Tm.color(Tc.tableConSubTxt)),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
      DataTableItem(percentWidth: 8, label: item.createdAt),
      DataTableItem(percentWidth: 8, label: item.hsnCode),
    ];
