part of '../employee_report_screen.dart';

List<DataTableItem> _titles() => [
      const DataTableItem(percentWidth: 16, label: 'Employee Name & Code'),
      const DataTableItem(percentWidth: 18, label: 'Employee Email'),
      const DataTableItem(percentWidth: 9, label: 'DOB'),
      const DataTableItem(percentWidth: 14, label: 'Street'),
      const DataTableItem(percentWidth: 15, label: 'State'),
      const DataTableItem(percentWidth: 14, label: 'Country'),
      const DataTableItem(percentWidth: 14, label: 'BranchAccess'),
    ];

List<DataTableItem> _tileSections(EmployeeReportModel employee) => [
      DataTableItem(
        percentWidth: 16,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              employee.employeeName,
              style: Ts.rgRegular(color: Tm.color(Tc.tableConTxt)),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              employee.employeeCode,
              style: Ts.mdRegular(color: Tm.color(Tc.tableConSubTxt)),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
      DataTableItem(percentWidth: 18, label: employee.employeeEmail),
      DataTableItem(percentWidth: 9, label: employee.dob),
      DataTableItem(percentWidth: 14, label: employee.street),
      DataTableItem(percentWidth: 15, label: employee.state),
      DataTableItem(percentWidth: 14, label: employee.country),
      DataTableItem(percentWidth: 14, label: employee.branchAccess),
    ];
