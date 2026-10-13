part of '../customer_screen.dart';

List<DataTableItem> _titles() => [
      const DataTableItem(percentWidth: 7, label: 'Code'),
      const DataTableItem(percentWidth: 24, label: 'Customer Name'),
      const DataTableItem(percentWidth: 18, label: 'Mobile No'),
      const DataTableItem(percentWidth: 18, label: 'Country'),
      const DataTableItem(percentWidth: 18, label: 'State'),
      const DataTableItem(percentWidth: 15, label: 'Street'),
    ];

List<DataTableItem> _tileSections(CustomerModel customer) => [
      DataTableItem(percentWidth: 7, label: customer.customerCode),
      DataTableItem(
        percentWidth: 24,
        label: customer.name.toFirstLetterUpperCase(),
      ),
      DataTableItem(
        percentWidth: 18,
        label: StaticValues.mobileFormatter(
          code: customer.mobileNumberDailCode,
          number: customer.mobileNumber,
        ),
      ),
      DataTableItem(percentWidth: 18, label: customer.country),
      DataTableItem(percentWidth: 18, label: customer.state),
      DataTableItem(percentWidth: 15, label: customer.street),
    ];
