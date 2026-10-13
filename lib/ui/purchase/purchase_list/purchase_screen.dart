import 'package:invently/assortment/extensions/context_extensions.dart';
import 'package:invently/assortment/extensions/string_extensions.dart';
import 'package:invently/assortment/future_handler/handle_future_with_alert.dart';
import 'package:invently/assortment/services/navigation_service/navigation_service.dart';
import 'package:invently/assortment/status.dart';
import 'package:invently/assortment/widgets/cached_image.dart';
import 'package:invently/assortment/widgets/svg_image.dart';
import 'package:invently/gen/assets.gen.dart';
import 'package:invently/models/common/common_id_value_model.dart';
import 'package:invently/models/purchase/purchase_model.dart';
import 'package:invently/network/branch_service.dart';
import 'package:invently/network/purchase_service.dart';
import 'package:invently/provider/purchase/purchase_provider.dart';
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

part 'purchase_functions.dart';
part 'view_purchase/purchase_details.dart';
part 'widgets/table_elements.dart';

class PurchaseScreen extends StatefulWidget {
  const PurchaseScreen({super.key});

  @override
  State<PurchaseScreen> createState() => _PurchaseListingState();
}

class _PurchaseListingState extends State<PurchaseScreen> {
  late ScrollController scrollController;
  late TextEditingController searchTextController;

  @override
  void initState() {
    searchTextController = TextEditingController();
    scrollController = ScrollController();
    final provider = context.read<PurchaseProvider>();
    provider.clearProvider();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      AppNavigator.setBreadCrumbs([AppRoutes.purchase, AppRoutes.purchase]);
      provider.getPurchaseList();
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
    return Consumer<PurchaseProvider>(
      builder: (context, provider, child) {
        return PageBodyContainer(
          bottomWidget: PaginationNumberRow(
            selectedPage: provider.currentPage,
            totalPage: provider.totalPages,
            showingCount: provider.purchaseList.length,
            totalCount: provider.totalCount,
            onPageTap: provider.changePage,
            selectedCount: provider.purchaseList.where((e) => e.selected).length,
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
                    status: provider.purchaseListStatus,
                    filter: provider.filterModel,
                  ),
                  const Spacer(),
                  if (provider.purchaseList.where((e) => e.selected).isNotEmpty)
                    DeleteButton(
                      onDelTap: () => _deletePurchase(provider.purchaseList.where((e) => e.selected).toList()),
                    ),
                  RefreshButton(
                    onRefreshTap: () => provider.getPurchaseList(pageNumber: provider.currentPage),
                    status: provider.purchaseListStatus,
                  ),
                  AddButton(text: 'Create New', onTap: _onAddTap),
                ],
              ),
              Expanded(
                child: PageListView(
                  /// Table Title
                  onSelectAllTap: (a) => provider.selectAll(),
                  isAllSelected: !provider.purchaseList.map((e) => e.selected).contains(false),
                  titles: _titles(),

                  /// Scrollview
                  controller: scrollController,
                  status: provider.purchaseListStatus,
                  list: provider.purchaseList,

                  /// List Tile
                  onMenuTap: (index, params) => _onMenuTap(provider.purchaseList[index], params),
                  onSelectTap: (selected, index) => provider.selectItem(provider.purchaseList[index], selected),
                  tileSections: (index) => _tileSections(provider.purchaseList[index]),

                  /// Error
                  listingError: provider.purchaseListingError,
                  listingName: 'Purchase',
                  onReloadTap: () => provider.getPurchaseList(pageNumber: provider.currentPage),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _onAddTap() => AppNavigator.navigate(AppRoutes.purchaseAdd);
}
