import 'package:invently/assortment/extensions/string_extensions.dart';
import 'package:invently/utils/globals.dart';
import 'package:invently/utils/theme/colors/colors.dart';
import 'package:invently/utils/theme/text_style/text_styles.dart';
import 'package:flutter/material.dart';

class CustomDataTable extends StatelessWidget {
  final List<DataTableItem> items;
  final DataTableProperties? properties;
  final bool logBalance;
  final double? height;
  final bool isHeading;

  const CustomDataTable({
    super.key,
    required this.items,
    this.properties,
    this.logBalance = false,
    this.height,
    this.isHeading = false,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constrains) {
        if (logBalance) {
          Globals.logger.log(
            'Remaining %(${isHeading ? 'Heading' : 'Tile'}): ${100 - (items.map((e) => e.percentWidth).reduce((a, e) => a + e))}',
          );
        }

        return Container(
          height: height,
          color: properties?.color,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (int i = 0; i < items.length; i++)
                _DataTableItemWidget(
                  properties: _getProperties(items[i], i),
                  percentWidth: (constrains.maxWidth * items[i].percentWidth) / 106,
                  label: items[i].label,
                  overflow: items[i].overflow,
                  maxLines: items[i].maxLines,
                  child: items[i].child,
                ),
            ],
          ),
        );
      },
    );
  }

  DataTableProperties? _getProperties(DataTableItem item, int index) {
    DataTableProperties? props = item.properties ?? properties;

    // Change container color when logging
    if (logBalance) {
      props ??= DataTableProperties();

      props.color = index % 2 == 0 ? Colors.yellow : Colors.green;
    }

    return props;
  }
}

class _DataTableItemWidget extends StatelessWidget {
  final String? label;
  final int maxLines;
  final Widget? child;
  final DataTableProperties? properties;
  final double percentWidth;
  final TextOverflow? overflow;

  const _DataTableItemWidget({
    required this.properties,
    required this.maxLines,
    this.child,
    this.label,
    this.overflow,
    required this.percentWidth,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: (properties ?? DataTableProperties.props).innerPadding,
          margin: (properties ?? DataTableProperties.props).outerPadding,
          decoration: BoxDecoration(
            color: (properties ?? DataTableProperties.props).color,
            border: (properties ?? DataTableProperties.props).showDivider
                ? Border(
                    right: BorderSide(
                      color: Tm.colorSeparate(
                        PC.colorPrimary200.withValues(alpha: 0.6),
                        PC.colorPrimary200.withValues(alpha: 0.3),
                      ),
                      width: 0.3,
                    ),
                  )
                : null,
          ),
          width: percentWidth,
          alignment: (properties ?? DataTableProperties.props).alignment,
          child: child ??
              Text(
                ((label ?? '').trim().isEmpty ? '-' : label!.trim()).toFirstLetterUpperCase(),
                style:
                    (properties ?? DataTableProperties.props).style ?? TsDefined.ts17W400(color: Tm.color(Tc.priDef)),
                overflow: overflow,
                maxLines: maxLines,
              ),
        ),
      ],
    );
  }
}

class DataTableProperties {
  final EdgeInsets innerPadding;
  final EdgeInsets outerPadding;
  Color? color;
  final Alignment alignment;
  final TextStyle? style;
  bool showDivider;

  DataTableProperties({
    this.innerPadding = const EdgeInsets.symmetric(horizontal: 12),
    this.outerPadding = const EdgeInsets.all(0),
    this.color,
    this.alignment = Alignment.centerLeft,
    this.style,
    this.showDivider = true,
  });

  static DataTableProperties props = DataTableProperties();

  DataTableProperties copyWith({
    EdgeInsets? innerPadding,
    EdgeInsets? outerPadding,
    Color? color,
    Alignment? alignment,
    TextStyle? style,
    bool? showDivider,
  }) {
    return DataTableProperties(
      innerPadding: innerPadding ?? this.innerPadding,
      outerPadding: outerPadding ?? this.outerPadding,
      color: color ?? this.color,
      alignment: alignment ?? this.alignment,
      style: style ?? this.style,
      showDivider: showDivider ?? this.showDivider,
    );
  }
}

class DataTableItem {
  final String? label;
  final Widget? child;
  final double percentWidth;
  final TextOverflow? overflow;
  final int maxLines;
  final DataTableProperties? properties;

  const DataTableItem({
    required this.percentWidth,
    this.label,
    this.child,
    this.overflow = TextOverflow.ellipsis,
    this.properties,
    this.maxLines = 1,
  });
}
