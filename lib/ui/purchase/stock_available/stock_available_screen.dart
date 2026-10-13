import 'package:invently/assortment/extensions/string_extensions.dart';
import 'package:invently/assortment/future_handler/handle_future_with_alert.dart';
import 'package:invently/assortment/services/navigation_service/navigation_service.dart';
import 'package:invently/assortment/status.dart';
import 'package:invently/models/common/common_id_value_model.dart';
import 'package:invently/models/purchase/stock_available_model.dart';
import 'package:invently/network/stock_available_service.dart';
import 'package:invently/provider/purchase/stock_available_provider.dart';
import 'package:invently/ui/purchase/purchase_list/widgets/filter_section.dart';
import 'package:invently/ui/purchase/stock_available/add_stock_available/add_stock_available_screen.dart';
import 'package:invently/utils/static_values.dart';
import 'package:invently/utils/theme/colors/colors.dart';
import 'package:invently/utils/theme/text_style/text_styles.dart';
import 'package:invently/widgets/alert_dialog/api_search_drop_down.dart';
import 'package:invently/widgets/alert_dialog/popup_menu/show_app_menu.dart';
import 'package:invently/widgets/buttons/add_button.dart';
import 'package:invently/widgets/form_widgets/search_text_field.dart';
import 'package:invently/widgets/page_widgets/custom_data_table.dart';
import 'package:invently/widgets/page_widgets/delete_button.dart';
import 'package:invently/widgets/page_widgets/filter_button.dart';
import 'package:invently/widgets/page_widgets/page_body_container.dart';
import 'package:invently/widgets/page_widgets/page_list_view.dart';
import 'package:invently/widgets/page_widgets/page_shelf.dart';
import 'package:invently/widgets/page_widgets/pagination_number_row.dart';
import 'package:invently/widgets/page_widgets/refresh_button.dart';
import 'package:invently/widgets/show_multi_delete_popup.dart';
import 'package:invently/widgets/view_item_overlay.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

part 'widgets/table_elements.dart';

part 'stock_available_functions.dart';

class StockAvailableScreen extends StatefulWidget {
  const StockAvailableScreen({super.key});

  @override
  State<StockAvailableScreen> createState() => _StockAvailableScreenListingState();
}

class _StockAvailableScreenListingState extends State<StockAvailableScreen> {
  late ScrollController scrollController;
  late TextEditingController searchTextController;

  @override
  void initState() {
    searchTextController = TextEditingController();
    scrollController = ScrollController();
    final provider = context.read<StockAvailableProvider>();
    provider.clearProvider();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      AppNavigator.setBreadCrumbs([AppRoutes.purchase, AppRoutes.stockAvailableList]);
      provider.getStockAvailableList();
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
    return Consumer<StockAvailableProvider>(
      builder: (context, provider, child) {
        return PageBodyContainer(
          bottomWidget: PaginationNumberRow(
            selectedPage: provider.currentPage,
            totalPage: provider.totalPages,
            showingCount: provider.stockAvailableList.length,
            totalCount: provider.totalCount,
            onPageTap: provider.changePage,
            selectedCount: provider.stockAvailableList.where((e) => e.selected).length,
          ),
          child: Column(
            children: [
              PageShelf(
                children: [
                  SearchTextField(
                    controller: searchTextController,
                    onTextSubmit: (a) => provider.searchKey == a ? null : provider.search(a),
                    onSearchResultTap: (a) => () {},
                    onSearch: _search,
                  ),
                  FilterButton(
                    onFilterTap: () {},
                    status: provider.stockAvailableListStatus,
                    filter: provider.filterModel,
                  ),
                  const Spacer(),
                  if (provider.stockAvailableList.where((e) => e.selected).isNotEmpty)
                    DeleteButton(
                      onDelTap: () => _deletePurchase(provider.stockAvailableList.where((e) => e.selected).toList()),
                    ),
                  RefreshButton(
                    onRefreshTap: () => provider.getStockAvailableList(pageNumber: provider.currentPage),
                    status: provider.stockAvailableListStatus,
                  ),
                  AddButton(text: 'Create New', onTap: _onAddTap),
                ],
              ),
              Expanded(
                child: PageListView(
                  /// Table Title
                  onSelectAllTap: (a) => provider.selectAll(),
                  isAllSelected: !provider.stockAvailableList.map((e) => e.selected).contains(false),
                  titles: _titles(),

                  /// Scrollview
                  controller: scrollController,
                  status: provider.stockAvailableListStatus,
                  list: provider.stockAvailableList,

                  /// List Tile
                  onMenuTap: (index, params) => _onMenuTap(provider.stockAvailableList[index], params),
                  onSelectTap: (selected, index) => provider.selectItem(provider.stockAvailableList[index], selected),
                  tileSections: (index) => _tileSections(provider.stockAvailableList[index]),

                  /// Error
                  listingError: provider.stockAvailableListingError,
                  listingName: 'Purchase',
                  onReloadTap: () => provider.getStockAvailableList(pageNumber: provider.currentPage),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _onAddTap() => AppNavigator.navigate(AppRoutes.stockAvailableAdd);
}
