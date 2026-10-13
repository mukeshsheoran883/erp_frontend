part of '../bill_history_screen.dart';

List<DataTableItem> _titles() => [
  const DataTableItem(
    percentWidth: 18,
    label: 'Bill Number',
  ),
  const DataTableItem(
    percentWidth: 18,
    label: 'Customer Name',
  ),const DataTableItem(
    percentWidth: 17,
    label: 'Date & Time',
  ),
  const DataTableItem(
    percentWidth: 15,
    label: 'Shop Code',
  ),
  const DataTableItem(
    percentWidth: 17,
    label: 'Perform Invoice Code',
  ),
  const DataTableItem(
    percentWidth: 15,
    label: 'Total',
  ),
];

List<DataTableItem> _tileSections(
    BillHistoryModel billHistory,
    ) =>
    [
      DataTableItem(
        percentWidth: 18,
        label: billHistory.billNumber,
      ),
      DataTableItem(
        percentWidth: 18,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              StaticValues.commonDateMonthFormat.format(
                billHistory.date,
              ),
              style: Ts.rgRegular(
                color: Tm.color(Tc.tableConTxt),
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              StaticValues.commonTimeFormat.format(
                billHistory.date,
              ),
              style: Ts.mdRegular(
                color: Tm.color(Tc.tableConSubTxt),
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
      DataTableItem(
        percentWidth: 17,
        label:
          billHistory.customerName.toString(),
      ),
      DataTableItem(
        percentWidth: 15,
        label:
          billHistory.shopCode.toString(),
      ),
      DataTableItem(
        percentWidth: 17,
        label:
          billHistory.posCode.toString(),
      ),
      DataTableItem(
        percentWidth: 15,
        label: StaticValues.currencySymbol(
          billHistory.totalPrice.toString(),
        ),
      ),
    ];