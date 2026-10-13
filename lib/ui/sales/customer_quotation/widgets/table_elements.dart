part of '../customer_quotation_screen.dart';

List<DataTableItem> _titles() => [
      const DataTableItem(percentWidth: 22, label: 'Customer Quotation Code'),
      const DataTableItem(percentWidth: 22, label: 'Customer Name'),
      const DataTableItem(percentWidth: 22, label: 'Email'),
      const DataTableItem(percentWidth: 20, label: 'Customer Phone'),
      const DataTableItem(percentWidth: 17, label: 'Created At'),
    ];

List<DataTableItem> _tileSections(CustomerQuotationModel customerQuotation) => [
      DataTableItem(
          percentWidth: 22, label: customerQuotation.customerQuotationCode),
      DataTableItem(percentWidth: 22, label: customerQuotation.customerName),
      DataTableItem(percentWidth: 22, label: customerQuotation.customerEmail),
      DataTableItem(percentWidth: 20, label: customerQuotation.customerPhone),
      DataTableItem(
        percentWidth: 17,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              StaticValues.commonDateMonthFormat
                  .format(customerQuotation.createdAt),
              style: Ts.rgRegular(color: Tm.color(Tc.tableConTxt)),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              StaticValues.commonTimeFormat.format(customerQuotation.createdAt),
              style: Ts.mdRegular(color: Tm.color(Tc.tableConSubTxt)),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
      // DataTableItem(percentWidth: 20, label: billHistory.billNumber),
      // DataTableItem(percentWidth: 20, label: billHistory.billNumber),
      // DataTableItem(percentWidth: 14, label: StaticValues.currencySymbol(billHistory.totalPrice.toString())),
    ];
