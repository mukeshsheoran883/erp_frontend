
part of '../employee_screen.dart';

List<DataTableItem> _titles() => [
      const DataTableItem(percentWidth: 7, label: 'Emp. ID'),
      const DataTableItem(percentWidth: 33, label: 'Employee Name & Mail ID'),
      const DataTableItem(percentWidth: 33, label: 'Address'),
      const DataTableItem(percentWidth: 18, label: 'Mobile No.'),
      const DataTableItem(percentWidth: 9, label: 'Status'),
    ];

List<DataTableItem> _tileSections(UserModel employee) => [
      DataTableItem(percentWidth: 7, label: employee.employeeCode),
      DataTableItem(
        percentWidth: 33,
        child: Row(
          children: [
            ClipOval(
              child: CachedImage(
                url: employee.profilePhotoUrl,
                height: 40,
                width: 40,
                errorWidget: SvgImage(Assets.icons.personCircle, height: 40, width: 40, color: Tm.color(Tc.txtH4)),
              ),
            ),
            const SizedBox(width: 12),
            Flexible(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    employee.name.toPascalCase(),
                    style: (DataTableProperties.props).style ?? Ts.rgRegular(color: Tm.color(Tc.txtH3)),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  Text(
                    employee.emailId.toFirstLetterUpperCase(),
                    style: (DataTableProperties.props).style ?? Ts.mdRegular(color: Tm.color(Tc.tableConSubTxt)),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      DataTableItem(percentWidth: 33, label: employee.address.toPascalCase()),
      DataTableItem(
        percentWidth: 18,
        label: StaticValues.mobileFormatter(code: employee.mobileNumberDailCode, number: employee.mobileNumber),
      ),
      DataTableItem(
        percentWidth: 9,
        child: ChipWidget(
          chip: ChipModel.fromValue(
            trueText: StaticValues.getStatusText(!employee.disabled),
            falseText: StaticValues.getStatusText(!employee.disabled),
            condition: !employee.disabled,
          ),
        ),
      ),
    ];
