part of '../quotation_report_screen.dart';

List<DataTableItem> _titles() => [
      const DataTableItem(percentWidth: 8, label: 'Quotation ID'),
      const DataTableItem(percentWidth: 18, label: 'Customer Name & Code'),
      const DataTableItem(percentWidth: 18, label: 'Item Name & Code'),
      const DataTableItem(percentWidth: 8, label: 'HSN Code'),
      const DataTableItem(percentWidth: 8, label: 'Qty'),
      const DataTableItem(percentWidth: 8, label: 'Price'),
      const DataTableItem(percentWidth: 8, label: 'Total Price'),
      const DataTableItem(percentWidth: 12, label: 'Date'),
      const DataTableItem(percentWidth: 12, label: 'Quotation Type'),
    ];

List<DataTableItem> _tileSections(QuotationReportModel quotation) => [
      DataTableItem(percentWidth: 8, label: quotation.quotationId),
      DataTableItem(
        percentWidth: 18,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              quotation.customerName,
              style: Ts.rgRegular(color: Tm.color(Tc.tableConTxt)),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              quotation.customerCode,
              style: Ts.mdRegular(color: Tm.color(Tc.tableConSubTxt)),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
      DataTableItem(
        percentWidth: 18,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              quotation.itemName,
              style: Ts.rgRegular(color: Tm.color(Tc.tableConTxt)),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              quotation.itemCode,
              style: Ts.mdRegular(color: Tm.color(Tc.tableConSubTxt)),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
      DataTableItem(percentWidth: 8, label: quotation.hsnCode),
      DataTableItem(percentWidth: 8, label: quotation.qty),
      DataTableItem(percentWidth: 8, label: StaticValues.currencySymbol(quotation.price)),
      DataTableItem(percentWidth: 8, label: StaticValues.currencySymbol(quotation.totalPrice)),
      DataTableItem(percentWidth: 12, label: quotation.date),
      DataTableItem(percentWidth: 12, label: quotation.quotationType),
    ];
