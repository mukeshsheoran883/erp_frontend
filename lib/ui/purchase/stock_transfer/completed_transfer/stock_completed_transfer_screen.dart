import 'package:invently/assortment/extensions/string_extensions.dart';
import 'package:invently/assortment/future_handler/handle_future_with_alert.dart';
import 'package:invently/assortment/services/navigation_service/navigation_service.dart';
import 'package:invently/assortment/status.dart';
import 'package:invently/models/common/common_id_value_model.dart';
import 'package:invently/models/purchase/stock_completed_transfer_model.dart';
import 'package:invently/network/stock_completed_transfer_service.dart';
import 'package:invently/provider/purchase/stock_completed_transfer_service.dart';
import 'package:invently/ui/purchase/purchase_list/add_purchase/add_purchase_screen.dart';
import 'package:invently/utils/theme/colors/colors.dart';
import 'package:invently/utils/theme/text_style/text_styles.dart';
import 'package:invently/widgets/alert_dialog/api_search_drop_down.dart';
import 'package:invently/widgets/alert_dialog/popup_menu/show_app_menu.dart';
import 'package:invently/widgets/form_widgets/search_text_field.dart';
import 'package:invently/widgets/page_widgets/custom_data_table.dart';
import 'package:invently/widgets/page_widgets/delete_button.dart';
import 'package:invently/widgets/page_widgets/page_body_container.dart';
import 'package:invently/widgets/page_widgets/page_list_view.dart';
import 'package:invently/widgets/page_widgets/page_shelf.dart';
import 'package:invently/widgets/page_widgets/refresh_button.dart';
import 'package:invently/widgets/show_multi_delete_popup.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

part 'widgets/table_elements.dart';

part 'stock_completed_transfer_functions.dart';

class StockCompletedTransferScreen extends StatefulWidget {
  const StockCompletedTransferScreen({super.key});

  @override
  State<StockCompletedTransferScreen> createState() => _StockCompletedTransferScreenListingState();
}

class _StockCompletedTransferScreenListingState extends State<StockCompletedTransferScreen> {
  late ScrollController scrollController;
  late TextEditingController searchTextController;

  @override
  void initState() {
    searchTextController = TextEditingController();
    scrollController = ScrollController();
    final provider = context.read<StockCompletedTransferProvider>();
    provider.clearProvider();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      provider.getStockCompletedTransferList();
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
    return Consumer<StockCompletedTransferProvider>(
      builder: (context, provider, child) {
        return PageBodyContainer(
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
                  // FilterButton(
                  //   onFilterTap: () {},
                  //   status: provider.stockCompletedTransferListStatus,
                  //   filter: provider.filterModel,
                  // ),
                  const Spacer(),
                  if (provider.stockCompletedTransferList.where((e) => e.selected).isNotEmpty)
                    DeleteButton(
                      onDelTap: () =>
                          _deletePurchase(provider.stockCompletedTransferList.where((e) => e.selected).toList()),
                    ),
                  RefreshButton(
                    onRefreshTap: () => provider.getStockCompletedTransferList(pageNumber: provider.currentPage),
                    status: provider.stockCompletedTransferListStatus,
                  ),
                  // AddButton(text: 'Create New', onTap: _onAddTap),
                ],
              ),
              Expanded(
                child: PageListView(
                  /// Table Title
                  onSelectAllTap: (a) => provider.selectAll(),
                  isAllSelected: !provider.stockCompletedTransferList.map((e) => e.selected).contains(false),
                  titles: _titles(),

                  /// Scrollview
                  controller: scrollController,
                  status: provider.stockCompletedTransferListStatus,
                  list: provider.stockCompletedTransferList,

                  /// List Tile
                  onMenuTap: (index, params) => _onMenuTap(provider.stockCompletedTransferList[index], params),
                  onSelectTap: (selected, index) =>
                      provider.selectItem(provider.stockCompletedTransferList[index], selected),
                  tileSections: (index) => _tileSections(provider.stockCompletedTransferList[index]),

                  /// Error
                  listingError: provider.stockCompletedTransferListingError,
                  listingName: 'Stock Completed Transfer',
                  onReloadTap: () => provider.getStockCompletedTransferList(pageNumber: provider.currentPage),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // void _onAddTap() => AppNavigator.navigate(AppRoutes.purchaseAdd);
}
