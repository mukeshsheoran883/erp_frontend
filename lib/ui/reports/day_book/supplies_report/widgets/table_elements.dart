part of '../supplies_report_screen.dart';

List<DataTableItem> _titles() => [
      const DataTableItem(percentWidth: 15, label: 'Supplier Name & Code'),
      const DataTableItem(percentWidth: 10, label: 'Street'),
      const DataTableItem(percentWidth: 10, label: 'State'),
      const DataTableItem(percentWidth: 10, label: 'Country'),
      const DataTableItem(percentWidth: 11, label: 'GST No.'),
      const DataTableItem(percentWidth: 11, label: 'Mobile No.'),
      const DataTableItem(percentWidth: 11, label: 'Alt Mobile No.'),
      const DataTableItem(percentWidth: 11, label: 'ID No.'),
      const DataTableItem(percentWidth: 11, label: 'ID Type'),
    ];

List<DataTableItem> _tileSections(DayBookSuppliesModel supplies) => [
      DataTableItem(
        percentWidth: 15,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              supplies.supplierName,
              style: Ts.rgRegular(color: Tm.color(Tc.tableConTxt)),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              supplies.supplierCode,
              style: Ts.mdRegular(color: Tm.color(Tc.tableConSubTxt)),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
      DataTableItem(percentWidth: 10, label: supplies.street),
      DataTableItem(percentWidth: 10, label: supplies.state),
      DataTableItem(percentWidth: 10, label: supplies.country),
      DataTableItem(percentWidth: 11, label: supplies.gstNo),
      DataTableItem(percentWidth: 11, label: supplies.mobileNo),
      DataTableItem(percentWidth: 11, label: supplies.altMobileNo),
      DataTableItem(percentWidth: 11, label: supplies.idNo),
      DataTableItem(percentWidth: 11, label: supplies.idType),
    ];
