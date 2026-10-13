
import 'package:invently/utils/theme/colors/colors.dart';
import 'package:invently/utils/theme/text_style/text_styles.dart';
import 'package:invently/widgets/custom_check_box.dart';
import 'package:flutter/material.dart';

import 'custom_data_table.dart';

class PageListTitle extends StatelessWidget {
  final List<DataTableItem> titles;
  final void Function(bool) onSelectAllTap;
  final bool isAllSelected;
  final bool logBalance;
  final DataTableProperties? properties;
  final double height;
  final bool showCheckBox;
  final bool showMenuIcon;

  const PageListTitle({
    super.key,
    required this.titles,
    required this.onSelectAllTap,
    required this.isAllSelected,
    required this.showCheckBox,
    required this.showMenuIcon,
    this.logBalance = false,
    this.properties,
    this.height = 48,
  });

  @override
  Widget build(BuildContext context) {
    return CustomDataTable(
      isHeading: true,
      logBalance: logBalance,
      properties: properties ??
          DataTableProperties(
            color: Tm.color(Tc.tableHeader),
            style: Ts.rgRegular(color: Tm.color(Tc.txtH3)),
            showDivider: true,
          ),
      height: height,
      items: [
        if (showCheckBox)
          DataTableItem(
            percentWidth: 3,
            properties: DataTableProperties(alignment: Alignment.center),
            child: CustomCheckBox(isChecked: isAllSelected, onChange: onSelectAllTap),
          ),
        ...titles,
        if (showMenuIcon) DataTableItem(percentWidth: 3, properties: DataTableProperties(showDivider: false)),
      ],
    );
  }
}
