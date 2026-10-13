import 'package:invently/assortment/extensions/string_extensions.dart';
import 'package:invently/assortment/future_handler/handle_future_with_alert.dart';
import 'package:invently/assortment/services/navigation_service/navigation_service.dart';
import 'package:invently/assortment/status.dart';
import 'package:invently/gen/assets.gen.dart';
import 'package:invently/models/common/common_id_value_model.dart';
import 'package:invently/models/inventory/inventory_model.dart';
import 'package:invently/models/user/employee_model.dart';
import 'package:invently/network/branch_service.dart';
import 'package:invently/network/inventory/inventory_service.dart';
import 'package:invently/network/purchase_service.dart';
import 'package:invently/provider/inventory/inventory_provider.dart';
import 'package:invently/provider/master/employee_provider.dart';
import 'package:invently/ui/inventory/add_inventory/add_inventory_screen.dart';
import 'package:invently/ui/purchase/purchase_list/add_purchase/add_purchase_screen.dart';
import 'package:invently/ui/purchase/purchase_list/widgets/filter_section.dart';
import 'package:invently/utils/globals.dart';
import 'package:invently/utils/static_values.dart';
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
import 'package:invently/widgets/page_widgets/page_header_container.dart';
import 'package:invently/widgets/page_widgets/page_list_view.dart';
import 'package:invently/widgets/page_widgets/page_shelf.dart';
import 'package:invently/widgets/page_widgets/pagination_number_row.dart';
import 'package:invently/widgets/page_widgets/refresh_button.dart';
import 'package:invently/widgets/page_widgets/view_details_side_menu/details_item.dart';
import 'package:invently/widgets/page_widgets/view_details_side_menu/view_details_bottom_buttons.dart';
import 'package:invently/widgets/page_widgets/view_details_side_menu/view_details_skeleton.dart';
import 'package:invently/widgets/show_multi_delete_popup.dart';
import 'package:invently/widgets/view_item_overlay.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

part 'inventory_functions.dart';
part 'widgets/table_elements.dart';
part 'view_inventory/inventory_details.dart';

class InventoryScreen extends StatefulWidget {
  const InventoryScreen({super.key});

  @override
  State<InventoryScreen> createState() => _InventoryScreenListingState();
}

class _InventoryScreenListingState extends State<InventoryScreen> {
  late ScrollController scrollController;
  late TextEditingController searchTextController;

  @override
  void initState() {
    searchTextController = TextEditingController();
    scrollController = ScrollController();
    final provider = context.read<InventoryProvider>();
    provider.clearProvider();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      AppNavigator.setBreadCrumbs([AppRoutes.inventory]);
      provider.getInventoryList();
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
    return Consumer<InventoryProvider>(
      builder: (context, provider, child) {
        return PageBodyContainer(
          bottomWidget: PaginationNumberRow(
            selectedPage: provider.currentPage,
            totalPage: provider.totalPages,
            showingCount: provider.inventoryList.length,
            totalCount: provider.totalCount,
            onPageTap: provider.changePage,
            selectedCount: provider.inventoryList.where((e) => e.selected).length,
          ),
          child: Column(
            children: [
              PageShelf(
                children: [
                  SearchTextField(
                    controller: searchTextController,
                    onTextSubmit: (a) => provider.searchKey == a ? null : provider.search(a),
                    onSearchResultTap: (a) => {},
                    onSearch: _search,
                  ),
                  FilterButton(
                    onFilterTap: _showFilter,
                    status: provider.inventoryListStatus,
                    filter: provider.filterModel,
                  ),
                  const Spacer(),
                  if (provider.inventoryList.where((e) => e.selected).isNotEmpty)
                    DeleteButton(
                      onDelTap: () => _deletePurchase(provider.inventoryList.where((e) => e.selected).toList()),
                    ),
                  RefreshButton(
                    onRefreshTap: () => provider.getInventoryList(pageNumber: provider.currentPage),
                    status: provider.inventoryListStatus,
                  ),
                  PageHeaderButton(
                    label: 'Inventory Log',
                    onTap: _onInventoryLog,
                    icon: Assets.icons.inventoryLog,
                  ),
                  SizedBox(width: 24,),
                  AddButton(text: 'Add Inventory', onTap: _onAddTap),
                ],
              ),
              Expanded(
                child: PageListView(
                  /// Table Title
                  onSelectAllTap: (a) => provider.selectAll(),
                  isAllSelected: !provider.inventoryList.map((e) => e.selected).contains(false),
                  titles: _titles(),

                  /// Scrollview
                  controller: scrollController,
                  status: provider.inventoryListStatus,
                  list: provider.inventoryList,

                  /// List Tile
                  onMenuTap: (index, params) => _onMenuTap(provider.inventoryList[index], params),
                  onSelectTap: (selected, index) => provider.selectItem(provider.inventoryList[index], selected),
                  tileSections: (index) => _tileSections(provider.inventoryList[index]),

                  /// Error
                  listingError: provider.inventoryListingError,
                  listingName: 'Inventory',
                  onReloadTap: provider.getInventoryList,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
  void _onAddTap() => AppNavigator.navigate(AppRoutes.inventoryAdd);
  void _onInventoryLog() => AppNavigator.navigate(AppRoutes.inventoryLogList);
}
