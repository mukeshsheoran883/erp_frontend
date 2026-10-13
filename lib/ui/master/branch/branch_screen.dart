import 'package:invently/assortment/extensions/string_extensions.dart';
import 'package:invently/assortment/future_handler/handle_future_with_alert.dart';
import 'package:invently/assortment/services/navigation_service/navigation_service.dart';
import 'package:invently/assortment/status.dart';
import 'package:invently/models/branch/branch_model.dart';
import 'package:invently/models/common/common_id_value_model.dart';
import 'package:invently/network/branch_service.dart';
import 'package:invently/provider/master/branch_provider.dart';
import 'package:invently/ui/master/branch/add_branch/add_branch_screen.dart';
import 'package:invently/ui/master/branch/widgets/filter_section.dart';
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

part 'branch_functions.dart';
part 'view_branch/branch_details.dart';
part 'widgets/table_elements.dart';

class BranchScreen extends StatefulWidget {
  const BranchScreen({super.key});

  @override
  State<BranchScreen> createState() => _BranchListingState();
}

class _BranchListingState extends State<BranchScreen> {
  late ScrollController scrollController;
  late TextEditingController searchTextController;

  @override
  void initState() {
    searchTextController = TextEditingController();
    scrollController = ScrollController();
    final provider = context.read<BranchProvider>();
    provider.clearProvider();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      AppNavigator.setBreadCrumbs([AppRoutes.master, AppRoutes.branch]);
      provider.getBranchList();
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
    return Consumer<BranchProvider>(
      builder: (context, provider, child) {
        return PageBodyContainer(
          bottomWidget: PaginationNumberRow(
            selectedPage: provider.currentPage,
            totalPage: provider.totalPages,
            showingCount: provider.branchList.length,
            totalCount: provider.totalCount,
            onPageTap: provider.changePage,
            selectedCount: provider.branchList.where((e) => e.selected).length,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch, 
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
                    status: provider.branchListStatus,
                    filter: provider.filterModel,
                  ),
                  const Spacer(),
                  if (provider.branchList.where((e) => e.selected).isNotEmpty)
                    DeleteButton(
                      onDelTap: () => _deleteBranches(provider.branchList.where((e) => e.selected).toList()),
                    ),
                  RefreshButton(
                    onRefreshTap: () => provider.getBranchList(pageNumber: provider.currentPage),
                    status: provider.branchListStatus,
                  ),
                  AddButton(text: 'Add Branch', onTap: _onAddTap),
                ],
              ),
              Expanded(
                child: PageListView(
                  /// Table Title
                  onSelectAllTap: (a) => provider.selectAll(),
                  isAllSelected: !provider.branchList.map((e) => e.selected).contains(false),
                  titles: _titles(),

                  /// Scrollview
                  controller: scrollController,
                  status: provider.branchListStatus,
                  list: provider.branchList,

                  /// List Tile
                  onMenuTap: (index, params) => _onMenuTap(provider.branchList[index], params),
                  onSelectTap: (selected, index) => provider.selectItem(provider.branchList[index], selected),
                  tileSections: (index) => _tileSections(provider.branchList[index]),

                  /// Error
                  listingError: provider.branchListingError,
                  listingName: 'Branch',
                  onReloadTap: () => provider.getBranchList(pageNumber: provider.currentPage),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _onAddTap() => AppNavigator.navigate(AppRoutes.branchAdd);
}
