import 'package:invently/assortment/extensions/context_extensions.dart';
import 'package:invently/assortment/extensions/string_extensions.dart';
import 'package:invently/assortment/future_handler/handle_future_with_alert.dart';
import 'package:invently/assortment/services/navigation_service/navigation_service.dart';
import 'package:invently/assortment/status.dart';
import 'package:invently/models/common/common_id_value_model.dart';
import 'package:invently/models/sales/return_item_model.dart';
import 'package:invently/network/branch_service.dart';
import 'package:invently/network/sales/return_item_service.dart';
import 'package:invently/provider/sales/return_item_provider.dart';
import 'package:invently/ui/purchase/purchase_list/add_purchase/add_purchase_screen.dart';
import 'package:invently/ui/purchase/purchase_list/widgets/filter_section.dart';
import 'package:invently/utils/globals.dart';
import 'package:invently/utils/static_values.dart';
import 'package:invently/utils/theme/colors/colors.dart';
import 'package:invently/utils/theme/text_style/text_styles.dart';
import 'package:invently/widgets/alert_dialog/alert_bottom_buttons.dart';
import 'package:invently/widgets/alert_dialog/alert_title_bar.dart';
import 'package:invently/widgets/alert_dialog/api_search_drop_down.dart';
import 'package:invently/widgets/alert_dialog/popup_menu/show_app_menu.dart';
import 'package:invently/widgets/alert_dialog/show_dialog.dart';
import 'package:invently/widgets/app_snack_bar.dart';
import 'package:invently/widgets/buttons/add_button.dart';
import 'package:invently/widgets/form_widgets/search_text_field.dart';
import 'package:invently/widgets/page_widgets/custom_data_table.dart';
import 'package:invently/widgets/page_widgets/delete_button.dart';
import 'package:invently/widgets/page_widgets/filter_button.dart';
import 'package:invently/widgets/page_widgets/page_body_container.dart';
import 'package:invently/widgets/page_widgets/page_list_title.dart';
import 'package:invently/widgets/page_widgets/page_list_view.dart';
import 'package:invently/widgets/page_widgets/page_shelf.dart';
import 'package:invently/widgets/page_widgets/pagination_number_row.dart';
import 'package:invently/widgets/page_widgets/refresh_button.dart';
import 'package:invently/widgets/show_multi_delete_popup.dart';
import 'package:invently/widgets/view_item_overlay.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

part 'return_item_functions.dart';

part '../return_item/view_return_item/return_item_details.dart';

part '../return_item/widgets/table_elements.dart';

class ReturnItemScreen extends StatefulWidget {
  const ReturnItemScreen({super.key});

  @override
  State<ReturnItemScreen> createState() => _ReturnItemScreenListingState();
}

class _ReturnItemScreenListingState extends State<ReturnItemScreen> {
  late ScrollController scrollController;
  late TextEditingController searchTextController;

  @override
  void initState() {
    searchTextController = TextEditingController();
    scrollController = ScrollController();
    final provider = context.read<ReturnItemProvider>();
    provider.clearProvider();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      AppNavigator.setBreadCrumbs([AppRoutes.sales, AppRoutes.returnItem]);
      provider.getReturnItemList();
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
    return Consumer<ReturnItemProvider>(
      builder: (context, provider, child) {
        return PageBodyContainer(
          bottomWidget: PaginationNumberRow(
            selectedPage: provider.currentPage,
            totalPage: provider.totalPages,
            showingCount: provider.returnItemList.length,
            totalCount: provider.totalCount,
            onPageTap: provider.changePage,
            selectedCount: provider.returnItemList.where((e) => e.selected).length,
          ),
          child: Column(
            children: [
              PageShelf(
                children: [
                  SearchTextField(
                    controller: searchTextController,
                    onTextSubmit: (a) => provider.searchKey == a ? null : provider.search(a),
                    onSearchResultTap: (a) => _viewCustomerDetails(a.id),
                    onSearch: _search,
                  ),
                  FilterButton(
                    onFilterTap: _showFilter,
                    status: provider.returnItemListStatus,
                    filter: provider.filterModel,
                  ),
                  const Spacer(),
                  if (provider.returnItemList.where((e) => e.selected).isNotEmpty)
                    DeleteButton(
                      onDelTap: () => _deletePurchase(provider.returnItemList.where((e) => e.selected).toList()),
                    ),
                  RefreshButton(
                    onRefreshTap: () => provider.getReturnItemList(pageNumber: provider.currentPage),
                    status: provider.returnItemListStatus,
                  ),
                  AddButton(text: 'Create New', onTap: _onAddTap),
                ],
              ),
              Expanded(
                child: PageListView(
                  /// Table Title
                  onSelectAllTap: (a) => provider.selectAll(),
                  isAllSelected: !provider.returnItemList.map((e) => e.selected).contains(false),
                  titles: _titles(),

                  /// Scrollview
                  controller: scrollController,
                  status: provider.returnItemListStatus,
                  list: provider.returnItemList,

                  /// List Tile
                  onMenuTap: (index, params) => _onMenuTap(provider.returnItemList[index], params),
                  onSelectTap: (selected, index) => provider.selectItem(provider.returnItemList[index], selected),
                  tileSections: (index) => _tileSections(provider.returnItemList[index]),

                  /// Error
                  listingError: provider.returnItemListingError,
                  listingName: 'Return Item',
                  onReloadTap: () => provider.getReturnItemList(pageNumber: provider.currentPage),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _onAddTap() => AppNavigator.navigate(AppRoutes.returnItemAdd);
}
