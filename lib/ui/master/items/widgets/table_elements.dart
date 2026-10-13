part of '../items_screen.dart';

List<DataTableItem> _titles() => [
      const DataTableItem(percentWidth: 7, label: 'Code'),
      const DataTableItem(percentWidth: 35, label: 'Item Name'),
      const DataTableItem(percentWidth: 20, label: 'Supplier'),
      const DataTableItem(percentWidth: 20, label: 'Brand'),
      const DataTableItem(percentWidth: 18, label: 'Category'),
    ];

List<DataTableItem> _tileSections(ItemModel item) => [
      DataTableItem(percentWidth: 7, label: item.itemCode),
      DataTableItem(
        percentWidth: 35,
        child: Row(
          children: [
            ClipOval(
              child: CachedImage(
                url: item.imageUrl,
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
                    item.name.toFirstLetterUpperCase(),
                    style: (DataTableProperties.props).style ?? Ts.rgRegular(color: Tm.color(Tc.txtH3)),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      DataTableItem(percentWidth: 20, label: item.supplierName),
      DataTableItem(percentWidth: 20, label: item.brandName),
      DataTableItem(percentWidth: 18, label: item.categoryName),
    ];
