import 'package:invently/assortment/extensions/string_extensions.dart';
import 'package:invently/assortment/future_handler/handle_future_with_alert.dart';
import 'package:invently/assortment/services/navigation_service/navigation_service.dart';
import 'package:invently/assortment/status.dart';
import 'package:invently/models/common/common_id_value_model.dart';
import 'package:invently/models/purchase/stock_pending_transfer_model.dart';
import 'package:invently/network/stock_pending_transfer_service.dart';
import 'package:invently/provider/purchase/stock_pending_transfer_provider.dart';
import 'package:invently/ui/purchase/stock_transfer/pending_transfer/add_stock_completed_transfer/add_stock_pending_transfer_screen.dart';
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
import 'package:invently/widgets/page_widgets/refresh_button.dart';
import 'package:invently/widgets/show_multi_delete_popup.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

part 'widgets/table_elements.dart';
part 'stock_pending_transfer_functions.dart';

class StockPendingTransferScreen extends StatefulWidget {
  const StockPendingTransferScreen({super.key});

  @override
  State<StockPendingTransferScreen> createState() => _StockPendingTransferScreenListingState();
}

class _StockPendingTransferScreenListingState extends State<StockPendingTransferScreen> {
  late ScrollController scrollController;
  late TextEditingController searchTextController;

  @override
  void initState() {
    searchTextController = TextEditingController();
    scrollController = ScrollController();
    final provider = context.read<StockPendingTransferProvider>();
    provider.clearProvider();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      provider.getStockPendingTransferList();
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
    return Consumer<StockPendingTransferProvider>(
      builder: (context, provider, child) {
        return PageBodyContainer(
          child: Column(
            children: [
              PageShelf(
                children: [
                  SearchTextField(
                    controller: searchTextController,
                    onTextSubmit: (a) => provider.searchKey == a ? null : provider.search(a),
                    onSearchResultTap: (a) => (){},
                    onSearch: _search,
                  ),
                  FilterButton(
                    onFilterTap: () {},
                    status: provider.stockPendingTransferListStatus,
                    filter: provider.filterModel,
                  ),
                  const Spacer(),
                  if (provider.stockPendingTransferList.where((e) => e.selected).isNotEmpty)
                    DeleteButton(
                      onDelTap: () => _deletePurchase(provider.stockPendingTransferList.where((e) => e.selected).toList()),
                    ),
                  RefreshButton(
                    onRefreshTap: () => provider.getStockPendingTransferList(pageNumber: provider.currentPage),
                    status: provider.stockPendingTransferListStatus,
                  ),
                  AddButton(text: 'Create New', onTap: _onAddTap),
                ],
              ),
              Expanded(
                child: PageListView(
                  /// Table Title
                  onSelectAllTap: (a) => provider.selectAll(),
                  isAllSelected: !provider.stockPendingTransferList.map((e) => e.selected).contains(false),
                  titles: _titles(),

                  /// Scrollview
                  controller: scrollController,
                  status: provider.stockPendingTransferListStatus,
                  list: provider.stockPendingTransferList,

                  /// List Tile
                  onMenuTap: (index, params) => _onMenuTap(provider.stockPendingTransferList[index], params),
                  onSelectTap: (selected, index) => provider.selectItem(provider.stockPendingTransferList[index], selected),
                  tileSections: (index) => _tileSections(provider.stockPendingTransferList[index]),

                  /// Error
                  listingError: provider.stockPendingTransferListingError,
                  listingName: 'Stock Pending Transfer',
                  onReloadTap: () => provider.getStockPendingTransferList(pageNumber: provider.currentPage),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _onAddTap() => AppNavigator.navigate(AppRoutes.stockTransferAdd);
}
