import 'package:invently/assortment/extensions/string_extensions.dart';
import 'package:invently/assortment/future_handler/handle_future_with_alert.dart';
import 'package:invently/assortment/services/navigation_service/navigation_service.dart';
import 'package:invently/assortment/status.dart';
import 'package:invently/gen/assets.gen.dart';
import 'package:invently/models/common/common_id_value_model.dart';
import 'package:invently/models/common/form_models.dart';
import 'package:invently/models/sales/bill_history_model.dart';
import 'package:invently/network/branch_service.dart';
import 'package:invently/network/sales/bill_history_service.dart';
import 'package:invently/network/supplier_service.dart';
import 'package:invently/provider/sales/bill_history_provider.dart';
import 'package:invently/ui/purchase/purchase_list/widgets/filter_section.dart';
import 'package:invently/utils/globals.dart';
import 'package:invently/utils/static_values.dart';
import 'package:invently/utils/theme/colors/colors.dart';
import 'package:invently/utils/theme/text_style/text_styles.dart';
import 'package:invently/widgets/alert_dialog/api_search_drop_down.dart';
import 'package:invently/widgets/alert_dialog/popup_menu/show_app_menu.dart';
import 'package:invently/widgets/app_snack_bar.dart';
import 'package:invently/widgets/buttons/add_button.dart';
import 'package:invently/widgets/form_widgets/search_selection_popup/search_popup_text_field.dart';
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
import 'package:invently/widgets/page_widgets/view_details_side_menu/details_item.dart' show DetailsValueName;
import 'package:invently/widgets/page_widgets/view_details_side_menu/view_details_bottom_buttons.dart';
import 'package:invently/widgets/page_widgets/view_details_side_menu/view_details_skeleton.dart';
import 'package:invently/widgets/show_multi_delete_popup.dart';
import 'package:invently/widgets/view_item_overlay.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

part 'bill_history_functions.dart';

part '../bill_history/view_invoice/invoice_details.dart';

part '../bill_history/widgets/table_elements.dart';

class BillHistoryScreen extends StatefulWidget {
  const BillHistoryScreen({super.key});

  @override
  State<BillHistoryScreen> createState() => _BillHistoryScreenListingState();
}

class _BillHistoryScreenListingState extends State<BillHistoryScreen> {
  late ScrollController scrollController;
  late TextEditingController searchTextController;
  DropDownParam<CommonKeyValueModel> supplier = DropDownParam(options: []);

  @override
  void initState() {
    searchTextController = TextEditingController();
    scrollController = ScrollController();
    final provider = context.read<BillHistoryProvider>();
    provider.clearProvider();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      AppNavigator.setBreadCrumbs([AppRoutes.sales, AppRoutes.billHistory]);
      provider.getBillHistoryList();
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
    return Consumer<BillHistoryProvider>(
      builder: (context, provider, child) {
        return PageBodyContainer(
          bottomWidget: PaginationNumberRow(
            selectedPage: provider.currentPage,
            totalPage: provider.totalPages,
            showingCount: provider.billHistoryList.length,
            totalCount: provider.totalCount,
            onPageTap: provider.changePage,
            selectedCount: provider.billHistoryList.where((e) => e.selected).length,
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
                    status: provider.billHistoryListStatus,
                    filter: provider.filterModel,
                  ),
                  const Spacer(),
                  if (provider.billHistoryList.where((e) => e.selected).isNotEmpty)
                    DeleteButton(
                      onDelTap: () => _deletePurchase(provider.billHistoryList.where((e) => e.selected).toList()),
                    ),
                  RefreshButton(
                    onRefreshTap: () => provider.getBillHistoryList(pageNumber: provider.currentPage),
                    status: provider.billHistoryListStatus,
                  ),
                  // SizedBox(
                  //   width: 300,
                  //   child: SearchPopupTextField(
                  //     removeAllProps: true,
                  //     selected: supplier.selected,
                  //     hint: 'Select Supplier',
                  //     popupSubject: 'supplier',
                  //     onSelected: _onSupplierSelected,
                  //     onSearch: _onSupplierSearch,
                  //     error: supplier.error.errorMessage,
                  //   ),
                  // ),
                  SizedBox(width: 8,),
                  AddButton(text: 'Add Invoice', onTap: _onAddTap),
                  // SquareIconButton(
                  //   model: SquareIconButtonModel(
                  //     buttonIcon: Assets.icons.arrowRightLong,
                  //     tooltip: 'Add item',
                  //     onTap: _onAddTap,
                  //     buttonBgColor: Tm.color(Tc.priIconLight),
                  //     iconColor: Tm.color(Tc.priIconLight),
                  //     iconSize: 18,
                  //   ),
                  // ),
                  // AddButton(text: 'Create New', onTap: _onAddTap),
                ],
              ),
              Expanded(
                child: PageListView(
                  /// Table Title
                  onSelectAllTap: (a) => provider.selectAll(),
                  isAllSelected: !provider.billHistoryList.map((e) => e.selected).contains(false),
                  titles: _titles(),

                  /// Scrollview
                  controller: scrollController,
                  status: provider.billHistoryListStatus,
                  list: provider.billHistoryList,

                  /// List Tile
                  onMenuTap: (index, params) => _onMenuTap(provider.billHistoryList[index], params),
                  onSelectTap: (selected, index) => provider.selectItem(provider.billHistoryList[index], selected),
                  tileSections: (index) => _tileSections(provider.billHistoryList[index]),

                  /// Error
                  listingError: provider.billHistoryListingError,
                  listingName: 'Invoice',
                  onReloadTap: () => provider.getBillHistoryList(pageNumber: provider.currentPage),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _onSupplierSelected(CommonKeyValueModel? st) {
    supplier.reset(st);
    _refresh();
  }

  Future<SearchApiResponseModel> _onSupplierSearch(SearchModel search) async {
    final response =
        await SupplierService.getSupplierList(searchKey: search.text, pageNumber: search.pageNumber, filter: null);

    return SearchApiResponseModel(
      response: response,
      items: response.data?.map((e) => CommonKeyValueModel(id: e.supplierCode, value: e.name)).toList() ?? [],
      searchResultsFor: search.text,
    );
  }

  void _refresh() => mounted ? setState(() {}) : null;

  void _onAddTap() => AppNavigator.navigate(AppRoutes.billAdd);
}
