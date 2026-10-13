import 'package:invently/assortment/extensions/string_extensions.dart';
import 'package:invently/assortment/future_handler/handle_future_with_alert.dart';
import 'package:invently/assortment/services/navigation_service/navigation_service.dart';
import 'package:invently/assortment/status.dart';
import 'package:invently/models/common/common_id_value_model.dart';
import 'package:invently/models/tax/tax_model.dart';
import 'package:invently/network/tax_service.dart';
import 'package:invently/provider/master/create/tax_provider.dart';
import 'package:invently/ui/master/create/widgets/tax/add_tax/add_tax_screen.dart';
import 'package:invently/utils/globals.dart';
import 'package:invently/widgets/alert_dialog/api_search_drop_down.dart';
import 'package:invently/widgets/alert_dialog/popup_menu/show_app_menu.dart';
import 'package:invently/widgets/app_snack_bar.dart';
import 'package:invently/widgets/buttons/add_button.dart';
import 'package:invently/widgets/form_widgets/search_text_field.dart';
import 'package:invently/widgets/page_widgets/custom_data_table.dart';
import 'package:invently/widgets/page_widgets/custom_scroll_bar.dart';
import 'package:invently/widgets/page_widgets/delete_button.dart';
import 'package:invently/widgets/page_widgets/page_body_container.dart';
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

part 'tax_functions.dart';
part 'view_tax/tax_details.dart';
part 'widgets/table_elements.dart';

class TaxScreen extends StatefulWidget {
  const TaxScreen({super.key});

  @override
  State<TaxScreen> createState() => _TaxListingState();
}

class _TaxListingState extends State<TaxScreen> {
  late ScrollController scrollController;
  late TextEditingController searchTextController;

  @override
  void initState() {
    scrollController = ScrollController();
    searchTextController = TextEditingController();
    final provider = context.read<TaxProvider>();
    provider.clearProvider();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      AppNavigator.setBreadCrumbs([AppRoutes.master, AppRoutes.create]);
      provider.getTaxList();
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
    return Consumer<TaxProvider>(
      builder: (context, provider, child) {
        return PageBodyContainer(
          bottomWidget: PaginationNumberRow(
            selectedPage: provider.currentPage,
            totalPage: provider.totalPages,
            showingCount: provider.taxList.length,
            totalCount: provider.totalCount,
            onPageTap: provider.changePage,
            selectedCount: provider.taxList.where((e) => e.selected).length,
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
                  const Spacer(),
                  if (provider.taxList.where((e) => e.selected).isNotEmpty)
                    DeleteButton(
                      onDelTap: () => _deleteTax(provider.taxList.where((e) => e.selected).toList()),
                    ),
                  RefreshButton(
                    onRefreshTap: () => provider.getTaxList(pageNumber: provider.currentPage),
                    status: provider.taxListStatus,
                  ),
                  AddButton(text: 'Add Tax', onTap: _onAddTap),
                ],
              ),
              Expanded(
                child: PageListView(
                  /// Table Title
                  onSelectAllTap: (a) => provider.selectAll(),
                  isAllSelected: !provider.taxList.map((e) => e.selected).contains(false),
                  titles: _titles(),

                  /// Scrollview
                  controller: scrollController,
                  status: provider.taxListStatus,
                  list: provider.taxList,

                  /// List Tile
                  onMenuTap: (index, params) => _onMenuTap(provider.taxList[index], params),
                  onSelectTap: (selected, index) => provider.selectItem(provider.taxList[index], selected),
                  tileSections: (index) => _tileSections(provider.taxList[index]),

                  /// Error
                  listingError: provider.taxListingError,
                  listingName: 'Tax',
                  onReloadTap: () => provider.getTaxList(pageNumber: provider.currentPage),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _onAddTap() => showAddTaxPopup(title: 'Add Tax', buttonName: 'Save');
}
