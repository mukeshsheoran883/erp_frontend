part of '../attendance_report_screen.dart';

List<DataTableItem> _titles() => [
      const DataTableItem(percentWidth: 16, label: 'Employee Name & Code'),
      const DataTableItem(percentWidth: 17, label: 'Employee Email'),
      const DataTableItem(percentWidth: 11, label: 'Date'),
      const DataTableItem(percentWidth: 14, label: 'Start Time'),
      const DataTableItem(percentWidth: 10, label: 'End Time'),
      const DataTableItem(percentWidth: 16, label: 'Total Hours'),
      const DataTableItem(percentWidth: 16, label: 'Total Actives'),
    ];

List<DataTableItem> _tileSections(AttendanceReportModel attendance) => [
      DataTableItem(
        percentWidth: 16,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              attendance.employeeName,
              style: Ts.rgRegular(color: Tm.color(Tc.tableConTxt)),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              attendance.employeeCode,
              style: Ts.mdRegular(color: Tm.color(Tc.tableConSubTxt)),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
      DataTableItem(percentWidth: 17, label: attendance.employeeEmail),
      DataTableItem(percentWidth: 11, label: attendance.date),
      DataTableItem(percentWidth: 14, label: attendance.startTime),
      DataTableItem(percentWidth: 10, label: attendance.endTime),
      DataTableItem(percentWidth: 16, label: attendance.totalHours),
      DataTableItem(percentWidth: 16, label: attendance.totalActives),
    ];
