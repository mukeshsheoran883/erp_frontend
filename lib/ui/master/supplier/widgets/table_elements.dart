part of '../supplier_screen.dart';

List<DataTableItem> _titles() => [
      const DataTableItem(percentWidth: 7, label: 'Code'),
      const DataTableItem(percentWidth: 33, label: 'Name'),
      const DataTableItem(percentWidth: 16, label: 'Country'),
      const DataTableItem(percentWidth: 15, label: 'State'),
      const DataTableItem(percentWidth: 16, label: 'Address'),
      const DataTableItem(percentWidth: 13, label: 'Mobile'),
    ];

List<DataTableItem> _tileSections(SupplierModel supplier) => [
      DataTableItem(percentWidth: 7, label: supplier.supplierCode),
      DataTableItem(
        percentWidth: 33,
        child: Row(
          children: [
            ClipOval(
              child: CachedImage(
                url: supplier.profilePhotoUrl,
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
                    supplier.name.toFirstLetterUpperCase(),
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
      DataTableItem(percentWidth: 16, label: supplier.country),
      DataTableItem(percentWidth: 15, label: supplier.address),
      DataTableItem(percentWidth: 16, label: StaticValues.getStatusText(supplier.disabled)),
      DataTableItem(
        percentWidth: 13,
        label: StaticValues.mobileFormatter(code: supplier.mobileNumberDailCode, number: supplier.mobileNumber),
      ),
    ];
