part of '../branch_screen.dart';

List<DataTableItem> _titles() => [
      const DataTableItem(percentWidth: 7, label: 'Code'),
      const DataTableItem(percentWidth: 25, label: 'Branch Name'),
      const DataTableItem(percentWidth: 13, label: 'Country'),
      const DataTableItem(percentWidth: 13, label: 'State'),
      const DataTableItem(percentWidth: 14, label: 'Street'),
      const DataTableItem(percentWidth: 14, label: 'Type'),
      const DataTableItem(percentWidth: 14, label: 'Mobile'),
    ];

List<DataTableItem> _tileSections(BranchModel branch) => [
      DataTableItem(percentWidth: 7, label: branch.shopCode),
      DataTableItem(
        percentWidth: 25,
        label: branch.name.toFirstLetterUpperCase(),
      ),
      DataTableItem(percentWidth: 13, label: branch.country),
      DataTableItem(percentWidth: 13, label: branch.state),
      DataTableItem(percentWidth: 14, label: branch.street),
      DataTableItem(percentWidth: 14, label: branch.type),
      DataTableItem(
        percentWidth: 14,
        label: StaticValues.mobileFormatter(
          code: branch.mobileNumberDailCode,
          number: branch.mobileNumber,
        ),
      ),
    ];
