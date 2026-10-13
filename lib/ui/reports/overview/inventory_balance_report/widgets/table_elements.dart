part of '../inventory_balance_report_screen.dart';

List<DataTableItem> _titles() => [
      const DataTableItem(percentWidth: 25, label: 'Item Name & Code'),
      const DataTableItem(percentWidth: 25, label: 'Brand Name & Code'),
      const DataTableItem(percentWidth: 20, label: 'Price'),
      const DataTableItem(percentWidth: 15, label: 'Qty Left'),
      const DataTableItem(percentWidth: 15, label: 'Item Description'),
    ];

List<DataTableItem> _tileSections(OverviewInventoryBalanceModel inventoryBalance) => [
      DataTableItem(
        percentWidth: 25,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              inventoryBalance.itemName,
              style: Ts.rgRegular(color: Tm.color(Tc.tableConTxt)),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              inventoryBalance.itemCode,
              style: Ts.mdRegular(color: Tm.color(Tc.tableConSubTxt)),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
      DataTableItem(
        percentWidth: 25,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              inventoryBalance.brandName,
              style: Ts.rgRegular(color: Tm.color(Tc.tableConTxt)),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              inventoryBalance.brandCode,
              style: Ts.mdRegular(color: Tm.color(Tc.tableConSubTxt)),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
      DataTableItem(percentWidth: 20, label: StaticValues.currencySymbol(inventoryBalance.price)),
      DataTableItem(percentWidth: 15, label: inventoryBalance.qtyLeft),
      DataTableItem(percentWidth: 15, label: inventoryBalance.itemDescription),
    ];
