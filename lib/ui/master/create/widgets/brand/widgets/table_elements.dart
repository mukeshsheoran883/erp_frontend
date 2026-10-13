part of '../brand_screen.dart';

List<DataTableItem> _titles() => [
      const DataTableItem(percentWidth: 11, label: 'Code'),
      const DataTableItem(percentWidth: 89, label: 'Branch Name'),
    ];

List<DataTableItem> _tileSections(BrandModel brand) => [
      DataTableItem(percentWidth: 11, label: brand.brandCode),
      DataTableItem(
        percentWidth: 89,
        child: Text(
          brand.name.toFirstLetterUpperCase(),
          style: (DataTableProperties.props).style ?? Ts.rgRegular(color: Tm.color(Tc.txtH3)),
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
      ),
    ];
