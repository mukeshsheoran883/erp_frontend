part of '../customer_report_screen.dart';

List<DataTableItem> _titles() => [
      const DataTableItem(percentWidth: 14, label: 'Customer Name & Email'),
      const DataTableItem(percentWidth: 10, label: 'Customer Code'),
      const DataTableItem(percentWidth: 8, label: 'Mobile No.'),
      const DataTableItem(percentWidth: 9, label: 'Created Date'),
      const DataTableItem(percentWidth: 6, label: 'ID No.'),
      const DataTableItem(percentWidth: 9, label: 'ID Type'),
      const DataTableItem(percentWidth: 8, label: 'DOB'),
      const DataTableItem(percentWidth: 6, label: 'Gender'),
      const DataTableItem(percentWidth: 8, label: 'Blood Group'),
      const DataTableItem(percentWidth: 9, label: 'Marital Status'),
      const DataTableItem(percentWidth: 6, label: 'Religion'),
      const DataTableItem(percentWidth: 6, label: 'Education'),
    ];

List<DataTableItem> _tileSections(DayBookCustomersModel customer) => [
      DataTableItem(
        percentWidth: 14,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              customer.customerName,
              style: Ts.rgRegular(color: Tm.color(Tc.tableConTxt)),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              customer.customerEmail,
              style: Ts.mdRegular(color: Tm.color(Tc.tableConSubTxt)),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
      DataTableItem(percentWidth: 10, label: customer.customerCode),
      DataTableItem(percentWidth: 8, label: customer.mobileNo),
      DataTableItem(percentWidth: 9, label: customer.createdDate),
      DataTableItem(percentWidth: 6, label: customer.idNo),
      DataTableItem(percentWidth: 9, label: customer.idType),
      DataTableItem(percentWidth: 8, label: customer.dob),
      DataTableItem(percentWidth: 6, label: customer.gender),
      DataTableItem(percentWidth: 8, label: customer.bloodGroup),
      DataTableItem(percentWidth: 9, label: customer.maritalStatus),
      DataTableItem(percentWidth: 6, label: customer.religion),
      DataTableItem(percentWidth: 6, label: customer.education),
    ];
