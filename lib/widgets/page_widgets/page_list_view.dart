
import 'package:invently/assortment/status.dart';
import 'package:invently/assortment/widgets/error_loading_and_empty_widgets/custom_progress_indicator.dart';
import 'package:invently/assortment/widgets/error_loading_and_empty_widgets/empty_screen_widgets.dart';
import 'package:invently/assortment/widgets/error_loading_and_empty_widgets/error_retry_button.dart';
import 'package:invently/models/common/listing_model.dart';
import 'package:invently/utils/static_values.dart';
import 'package:invently/widgets/alert_dialog/popup_menu/show_app_menu.dart';
import 'package:invently/widgets/page_widgets/custom_scroll_bar.dart';
import 'package:invently/widgets/page_widgets/page_list_tile.dart';
import 'package:invently/widgets/page_widgets/page_list_title.dart';
import 'package:flutter/material.dart';

import 'custom_data_table.dart';

class PageListView extends StatelessWidget {
  final Status status;
  final List<ListingModel> list;
  final ScrollController controller;
  final void Function() onReloadTap;
  final String listingError;
  final String listingName;
  final List<DataTableItem> titles;
  final List<DataTableItem> Function(int) tileSections;
  final bool isAllSelected;
  final bool logBalanceForTitle;
  final bool logBalanceForTile;
  final Function(bool) onSelectAllTap;
  final Function(bool, int) onSelectTap;
  final Function(int, AppMenuParams) onMenuTap;
  final DataTableProperties? titleProperties;
  final DataTableProperties? tileProperties;
  final bool showCheckBox;
  final bool showMenuIcon;

  const PageListView({
    super.key,
    required this.status,
    required this.list,
    required this.controller,
    required this.listingError,
    required this.listingName,
    required this.onReloadTap,
    required this.titles,
    required this.onSelectAllTap,
    required this.isAllSelected,
    required this.onMenuTap,
    required this.onSelectTap,
    required this.tileSections,
    this.logBalanceForTitle = false,
    this.logBalanceForTile = false,
    this.tileProperties,
    this.titleProperties,
    this.showMenuIcon = true,
    this.showCheckBox = true,
  });

  @override
  Widget build(BuildContext context) {
    return status == Status.loading
        ? const Center(child: CustomProgressIndicator())
        : status == Status.success && list.isNotEmpty
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  PageListTitle(
                    isAllSelected: isAllSelected,
                    onSelectAllTap: onSelectAllTap,
                    titles: titles,
                    logBalance: logBalanceForTitle,
                    properties: titleProperties,
                    showCheckBox: showCheckBox,
                    showMenuIcon: showMenuIcon,
                  ),
                  Expanded(
                    child: LayoutBuilder(
                      builder: (context, c) {
                        return CustomScrollBar(
                          controller: controller,
                          child: ListView.builder(
                            controller: controller,
                            itemCount: list.length,
                            padding: EdgeInsets.zero,
                            itemBuilder: (context, index) => PageListTile(
                              properties: tileProperties,
                              index: index,
                              height: c.maxHeight / (list.length < 10 ? Query.defaultCount() : list.length),
                              logBalance: logBalanceForTile,
                              items: tileSections(index),
                              onSelectTap: (a) => onSelectTap(a, index),
                              onMenuTap: (a) => onMenuTap(index, a),
                              selected: list[index].selected,
                              disabled: list[index].disabled,
                              showCheckBox: showCheckBox,
                              showMenuIcon: showMenuIcon,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              )
            : status == Status.success
                ? ListEmptyWidget(text: 'No $listingName Found')
                : ErrorWidgetWithButton(error: listingError, onPressed: () => onReloadTap());
  }
}
