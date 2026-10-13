
import 'package:invently/assortment/widgets/button/hover_gesture_detector.dart';
import 'package:invently/assortment/widgets/svg_image.dart';
import 'package:invently/gen/assets.gen.dart';
import 'package:invently/utils/theme/colors/colors.dart';
import 'package:invently/utils/theme/text_style/text_styles.dart';
import 'package:invently/widgets/alert_dialog/popup_menu/popup_menu_button.dart';
import 'package:invently/widgets/alert_dialog/popup_menu/show_app_menu.dart';
import 'package:invently/widgets/custom_check_box.dart';
import 'package:invently/widgets/page_widgets/custom_data_table.dart';
import 'package:flutter/material.dart';

import 'list_tile_skeleton.dart';

class PageListTile extends StatefulWidget {
  final List<DataTableItem> items;
  final void Function(bool) onSelectTap;
  final void Function(AppMenuParams) onMenuTap;
  final bool selected;
  final bool disabled;
  final bool logBalance;
  final DataTableProperties? properties;
  final double height;
  final int index;
  final bool showCheckBox;
  final bool showMenuIcon;

  const PageListTile({
    super.key,
    required this.items,
    required this.onSelectTap,
    required this.onMenuTap,
    required this.selected,
    required this.disabled,
    required this.index,
    required this.showCheckBox,
    required this.showMenuIcon,
    this.logBalance = false,
    this.properties,
    this.height = 68,
  });

  @override
  State<PageListTile> createState() => _PageListTileState();
}

class _PageListTileState extends State<PageListTile> {
  LayerLink layerLink = LayerLink();

  @override
  Widget build(BuildContext context) {
    return ListTileSkeleton(
      selected: widget.selected,
      disabled: widget.disabled,
      child: CustomDataTable(
        logBalance: widget.logBalance,
        properties: (widget.properties ??
                DataTableProperties(
                  color: Tm.color(Tc.tableHeader),
                  style: Ts.rgRegular(color: Tm.color(Tc.txtH3)),
                  showDivider: true,
                ))
            .copyWith(color: widget.index % 2 == 0 ? Tm.color(Tc.comCardBg) : Tm.color(Tc.tableLine2)),
        height: widget.height,
        items: [
          if (widget.showCheckBox)
            DataTableItem(
              percentWidth: 3,
              properties: DataTableProperties(alignment: Alignment.center),
              child: CustomCheckBox(isChecked: widget.selected, onChange: widget.onSelectTap),
            ),
          ...widget.items,
          if (widget.showMenuIcon)
            DataTableItem(
              percentWidth: 3,
              properties: DataTableProperties(alignment: Alignment.center),
              child: CustomPopupMenuButton(
                buttonBuilder: (params) {
                  return HoverGD(
                    onTap: () => widget.onMenuTap(params),
                    child: Container(
                      width: 42,
                      height: 42,
                      color: Colors.transparent,
                      alignment: Alignment.center,
                      child: SvgImage(Assets.icons.more, height: 25, color: Tm.color(Tc.txtH4)),
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}
