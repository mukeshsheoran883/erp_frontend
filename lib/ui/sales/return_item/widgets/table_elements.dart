part of '../return_item_screen.dart';

List<DataTableItem> _titles() => [
      const DataTableItem(percentWidth: 20, label: 'Bill Number'),
      const DataTableItem(percentWidth: 25, label: 'Customer Name'),
      const DataTableItem(percentWidth: 25, label: 'Return Reason'),
      const DataTableItem(percentWidth: 14, label: 'Date & Time'),
      const DataTableItem(percentWidth: 10, label: 'Total'),
    ];

List<DataTableItem> _tileSections(ReturnItemModel returnItem) => [
      DataTableItem(percentWidth: 20, label: returnItem.billNumber),
      DataTableItem(percentWidth: 25, label: returnItem.customerName),
      DataTableItem(percentWidth: 25, label: returnItem.returnReason),
      DataTableItem(
        percentWidth: 14,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              // StaticValues.commonDateMonthFormat.format(returnItem.date),
              returnItem.date,
              style: Ts.rgRegular(color: Tm.color(Tc.tableConTxt)),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              returnItem.time,
              // StaticValues.commonTimeFormat.format(purchase.createdTime),
              style: Ts.mdRegular(color: Tm.color(Tc.tableConSubTxt)),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
      DataTableItem(percentWidth: 10, label: StaticValues.currencySymbol(returnItem.totalPrice.toString())),
    ];
