import 'package:invently/assortment/extensions/string_extensions.dart';
import 'package:invently/assortment/future_handler/handle_future_with_alert.dart';
import 'package:invently/assortment/services/navigation_service/navigation_service.dart';
import 'package:invently/assortment/status.dart';
import 'package:invently/models/common/common_id_value_model.dart';
import 'package:invently/models/quotations/quotations_model.dart';
import 'package:invently/network/quotations/quotations_service.dart';
import 'package:invently/provider/quotations_provider.dart';
import 'package:invently/ui/purchase/purchase_list/add_purchase/add_purchase_screen.dart';
import 'package:invently/ui/purchase/purchase_list/widgets/filter_section.dart';
import 'package:invently/utils/static_values.dart';
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

part 'quotations_functions.dart';

class QuotationsScreen extends StatefulWidget {
  const QuotationsScreen({super.key});

  @override
  State<QuotationsScreen> createState() => _QuotationsScreenListingState();
}

class _QuotationsScreenListingState extends State<QuotationsScreen> {
  late ScrollController scrollController;
  late TextEditingController searchTextController;

  @override
  void initState() {
    searchTextController = TextEditingController();
    scrollController = ScrollController();
    final provider = context.read<QuotationsProvider>();
    provider.clearProvider();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      provider.getQuotationsList();
      AppNavigator.setBreadCrumbs([AppRoutes.quotations]);
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
    return Consumer<QuotationsProvider>(
      builder: (context, provider, child) {
        return PageBodyContainer(
          bottomWidget: PaginationNumberRow(
            selectedPage: 1,
            totalPage: 2,
            showingCount: 3,
            totalCount: 3,
            onPageTap: (p0) {},
            selectedCount: 1,
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
                    status: provider.quotationsListStatus,
                    filter: provider.filterModel,
                  ),
                  const Spacer(),
                  if (provider.quotationsList.where((e) => e.selected).isNotEmpty)
                    DeleteButton(
                      onDelTap: () => _deletePurchase(provider.quotationsList.where((e) => e.selected).toList()),
                    ),
                  RefreshButton(
                    onRefreshTap: () => provider.getQuotationsList(pageNumber: provider.currentPage),
                    status: provider.quotationsListStatus,
                  ),
                  AddButton(text: 'Create New', onTap: _onAddTap),
                ],
              ),
              Expanded(
                child: PageListView(
                  /// Table Title
                  onSelectAllTap: (a) => provider.selectAll(),
                  isAllSelected: !provider.quotationsList.map((e) => e.selected).contains(false),
                  titles: _titles(),

                  /// Scrollview
                  controller: scrollController,
                  status: provider.quotationsListStatus,
                  list: provider.quotationsList,

                  /// List Tile
                  onMenuTap: (index, params) => _onMenuTap(provider.quotationsList[index], params),
                  onSelectTap: (selected, index) => provider.selectItem(provider.quotationsList[index], selected),
                  tileSections: (index) => _tileSections(provider.quotationsList[index]),

                  /// Error
                  listingError: provider.quotationsListingError,
                  listingName: 'new supply',
                  onReloadTap: () => provider.getQuotationsList(pageNumber: provider.currentPage),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _onAddTap() => AppNavigator.navigate(AppRoutes.quotationsAdd);
}
