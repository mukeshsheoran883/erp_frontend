import 'package:invently/assortment/extensions/string_extensions.dart';
import 'package:invently/assortment/future_handler/handle_future_with_alert.dart';
import 'package:invently/assortment/services/navigation_service/navigation_service.dart';
import 'package:invently/assortment/status.dart';
import 'package:invently/assortment/widgets/cached_image.dart';
import 'package:invently/assortment/widgets/svg_image.dart';
import 'package:invently/gen/assets.gen.dart';
import 'package:invently/models/common/common_id_value_model.dart';
import 'package:invently/models/items/item_model.dart';
import 'package:invently/network/item_service.dart';
import 'package:invently/provider/master/item_provider.dart';
import 'package:invently/ui/master/items/add_items/add_items_screen.dart';
import 'package:invently/ui/master/items/widgets/filter_section.dart';
import 'package:invently/utils/globals.dart';
import 'package:invently/utils/static_values.dart';
import 'package:invently/utils/theme/colors/colors.dart';
import 'package:invently/utils/theme/text_style/text_styles.dart';
import 'package:invently/widgets/alert_dialog/api_search_drop_down.dart';
import 'package:invently/widgets/alert_dialog/popup_menu/show_app_menu.dart';
import 'package:invently/widgets/app_snack_bar.dart';
import 'package:invently/widgets/buttons/add_button.dart';
import 'package:invently/widgets/form_widgets/search_text_field.dart';
import 'package:invently/widgets/page_widgets/custom_data_table.dart';
import 'package:invently/widgets/page_widgets/custom_scroll_bar.dart';
import 'package:invently/widgets/page_widgets/delete_button.dart';
import 'package:invently/widgets/page_widgets/filter_button.dart';
import 'package:invently/widgets/page_widgets/page_body_container.dart';
import 'package:invently/widgets/page_widgets/page_list_view.dart';
import 'package:invently/widgets/page_widgets/page_shelf.dart';
import 'package:invently/widgets/page_widgets/pagination_number_row.dart';
import 'package:invently/widgets/page_widgets/refresh_button.dart';
import 'package:invently/widgets/page_widgets/view_details_side_menu/details_item.dart';
import 'package:invently/widgets/page_widgets/view_details_side_menu/view_details_bottom_buttons.dart';
import 'package:invently/widgets/page_widgets/view_details_side_menu/view_details_skeleton.dart';
import 'package:invently/widgets/show_multi_delete_popup.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../widgets/view_item_overlay.dart';

part 'items_functions.dart';
part 'view_items/items_details.dart';
part 'widgets/table_elements.dart';

class ItemListing extends StatefulWidget {
  const ItemListing({super.key});

  @override
  State<ItemListing> createState() => _ItemListingState();
}

class _ItemListingState extends State<ItemListing> {
  late ScrollController scrollController;
  late TextEditingController searchTextController;

  @override
  void initState() {
    scrollController = ScrollController();
    searchTextController = TextEditingController();
    final provider = context.read<ItemProvider>();
    provider.clearProvider();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      AppNavigator.setBreadCrumbs([AppRoutes.master, AppRoutes.items]);
      provider.getItemList();
    });

    super.initState();
  }

  @override
  void dispose() {
    searchTextController.dispose();
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ItemProvider>(
      builder: (context, provider, child) {
        return PageBodyContainer(
          bottomWidget: PaginationNumberRow(
            selectedPage: provider.currentPage,
            totalPage: provider.totalPages,
            showingCount: provider.itemList.length,
            totalCount: provider.totalCount,
            onPageTap: provider.changePage,
            selectedCount: provider.itemList.where((e) => e.selected).length,
          ),
          child: Column(
            children: [
              PageShelf(
                children: [
                  SearchTextField(
                    controller: searchTextController,
                    onTextSubmit: (a) => provider.searchKey == a ? null : provider.search(a),
                    onSearchResultTap: (a) => _viewItemsDetails(a.id),
                    onSearch: _search,
                  ),
                  FilterButton(
                    onFilterTap: _showFilter,
                    status: provider.itemListStatus,
                    filter: provider.filterModel,
                  ),
                  const Spacer(),
                  if (provider.itemList.where((e) => e.selected).isNotEmpty)
                    DeleteButton(
                      onDelTap: () => _deleteItems(provider.itemList.where((e) => e.selected).toList()),
                    ),
                  RefreshButton(
                    onRefreshTap: () => provider.getItemList(pageNumber: provider.currentPage),
                    status: provider.itemListStatus,
                  ),
                  AddButton(text: 'Add Item', onTap: _onAddTap),
                ],
              ),
              Expanded(
                child: PageListView(
                  /// Table Title
                  onSelectAllTap: (a) => provider.selectAll(),
                  isAllSelected: !provider.itemList.map((e) => e.selected).contains(false),
                  titles: _titles(),

                  /// Scrollview
                  controller: scrollController,
                  status: provider.itemListStatus,
                  list: provider.itemList,

                  /// List Tile
                  onMenuTap: (index, params) => _onMenuTap(provider.itemList[index], params),
                  onSelectTap: (selected, index) => provider.selectItem(provider.itemList[index], selected),
                  tileSections: (index) => _tileSections(provider.itemList[index]),

                  /// Error
                  listingError: provider.itemListingError,
                  listingName: 'Items',
                  onReloadTap: () => provider.getItemList(pageNumber: provider.currentPage),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _onAddTap() => AppNavigator.navigate(AppRoutes.itemAdd);
}
