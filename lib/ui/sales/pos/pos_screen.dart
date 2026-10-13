import 'package:invently/assortment/extensions/string_extensions.dart';
import 'package:invently/assortment/future_handler/handle_future_with_alert.dart';
import 'package:invently/assortment/network/api_manager_models.dart';
import 'package:invently/assortment/services/navigation_service/navigation_service.dart';
import 'package:invently/assortment/status.dart';
import 'package:invently/gen/assets.gen.dart';
import 'package:invently/models/common/common_id_value_model.dart';
import 'package:invently/models/inventory/inventory_model.dart';
import 'package:invently/models/pos/pos_model.dart';
import 'package:invently/models/user/employee_model.dart';
import 'package:invently/network/branch_service.dart';
import 'package:invently/network/inventory/inventory_service.dart';
import 'package:invently/network/pos/pos_service.dart';
import 'package:invently/network/purchase_service.dart';
import 'package:invently/provider/authentication_provider.dart';
import 'package:invently/provider/inventory/inventory_provider.dart';
import 'package:invently/provider/master/employee_provider.dart';
import 'package:invently/provider/ops/pos_provider.dart';
import 'package:invently/ui/inventory/add_inventory/add_inventory_screen.dart';
import 'package:invently/ui/purchase/purchase_list/add_purchase/add_purchase_screen.dart';
import 'package:invently/ui/purchase/purchase_list/widgets/filter_section.dart';
import 'package:invently/utils/globals.dart';
import 'package:invently/utils/static_values.dart';
import 'package:invently/utils/theme/colors/colors.dart';
import 'package:invently/widgets/alert_dialog/api_search_drop_down.dart';
import 'package:invently/widgets/alert_dialog/double_button_alert.dart';
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

part 'pos_functions.dart';
part 'widgets/table_elements.dart';
part 'view_pos/pos_details.dart';

class PosScreen extends StatefulWidget {
  const PosScreen({super.key});

  @override
  State<PosScreen> createState() => _PosScreenListingState();
}

class _PosScreenListingState extends State<PosScreen> {
  late ScrollController scrollController;
  late TextEditingController searchTextController;

  @override
  void initState() {
    searchTextController = TextEditingController();
    scrollController = ScrollController();
    final provider = context.read<PosProvider>();
    provider.clearProvider();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      AppNavigator.setBreadCrumbs([AppRoutes.pos]);
      provider.getPosList();
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
    return Consumer<PosProvider>(
      builder: (context, provider, child) {
        return PageBodyContainer(
          bottomWidget: PaginationNumberRow(
            selectedPage: provider.currentPage,
            totalPage: provider.totalPages,
            showingCount: provider.posList.length,
            totalCount: provider.totalCount,
            onPageTap: provider.changePage,
            selectedCount: provider.posList.where((e) => e.selected).length,
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
                  // FilterButton(
                  //   onFilterTap: _showFilter,
                  //   status: provider.posListStatus,
                  //   filter: provider.filterModel,
                  // ),
                  const Spacer(),
                  // if (provider.posList.where((e) => e.selected).isNotEmpty)
                  //   DeleteButton(
                  //     onDelTap: () => _deletePurchase(provider.posList.where((e) => e.selected).toList()),
                  //   ),
                  RefreshButton(
                    onRefreshTap: () => provider.getPosList(pageNumber: provider.currentPage),
                    status: provider.posListStatus,
                  ),
                  // PageHeaderButton(
                  //   label: 'Pos',
                  //   onTap: _onInventoryLog,
                  //   icon: Assets.icons.inventoryLog,
                  // ),
                  SizedBox(width: 24,),
                  AddButton(text: 'Add Performa I...', onTap: _onAddTap),
                ],
              ),
              Expanded(
                child: PageListView(
                  /// Table Title
                  onSelectAllTap: (a) => provider.selectAll(),
                  isAllSelected: !provider.posList.map((e) => e.selected).contains(false),
                  titles: _titles(),

                  /// Scrollview
                  controller: scrollController,
                  status: provider.posListStatus,
                  list: provider.posList,

                  /// List Tile
                  onMenuTap: (index, params) => _onMenuTap(provider.posList[index], params),
                  onSelectTap: (selected, index) => provider.selectItem(provider.posList[index], selected),
                  tileSections: (index) => _tileSections(provider.posList[index]),

                  /// Error
                  listingError: provider.posListingError,
                  listingName: 'Performa Invoice',
                  onReloadTap: provider.getPosList,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
  void _onAddTap() => AppNavigator.navigate(AppRoutes.posAdd);
  // void _onInventoryLog() => AppNavigator.navigate(AppRoutes.inventoryLogList);
}
