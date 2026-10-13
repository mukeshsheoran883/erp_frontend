part of '../category_screen.dart';

List<DataTableItem> _titles() => [
      const DataTableItem(percentWidth: 11, label: 'Code'),
      const DataTableItem(percentWidth: 89, label: 'Category Name'),
    ];

List<DataTableItem> _tileSections(CategoryModel category) => [
      DataTableItem(percentWidth: 11, label: category.categoryCode),
      DataTableItem(
        percentWidth: 89,
        child: Text(
          category.name.toFirstLetterUpperCase(),
          style: (DataTableProperties.props).style ?? Ts.rgRegular(color: Tm.color(Tc.txtH3)),
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
      ),
    ];
