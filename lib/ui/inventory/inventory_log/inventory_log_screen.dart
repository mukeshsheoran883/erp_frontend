import 'package:invently/assortment/services/navigation_service/navigation_service.dart';
import 'package:invently/models/inventory/inventory_model.dart';
import 'package:invently/provider/inventory/inventory_log_provider.dart';
import 'package:invently/utils/static_values.dart';
import 'package:invently/widgets/page_widgets/custom_data_table.dart';
import 'package:invently/widgets/page_widgets/page_body_container.dart';
import 'package:invently/widgets/page_widgets/page_list_view.dart';
import 'package:invently/widgets/page_widgets/pagination_number_row.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// part 'inventory_functions.dart';
part 'widgets/table_elements.dart';
// part 'view_inventory/inventory_details.dart';

class InventoryLogScreen extends StatefulWidget {
  const InventoryLogScreen({super.key});

  @override
  State<InventoryLogScreen> createState() => _InventoryLogScreenListingState();
}

class _InventoryLogScreenListingState extends State<InventoryLogScreen> {
  late ScrollController scrollController;
  late TextEditingController searchTextController;

  @override
  void initState() {
    searchTextController = TextEditingController();
    scrollController = ScrollController();
    final provider = context.read<InventoryLogProvider>();
    provider.clearProvider();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      AppNavigator.setBreadCrumbs([
        AppRoutes.inventory,
        AppRoutes.inventoryList,
        AppRoutes.inventoryLogList,
      ]);
      provider.getInventoryLogList();
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
    return Consumer<InventoryLogProvider>(
      builder: (context, provider, child) {
        return PageBodyContainer(
          bottomWidget: PaginationNumberRow(
            selectedPage: provider.currentPage,
            totalPage: provider.totalPages,
            showingCount: provider.inventoryLogList.length,
            totalCount: provider.totalCount,
            onPageTap: provider.changePage,
            selectedCount:
                provider.inventoryLogList.where((e) => e.selected).length,
          ),
          child: Column(
            children: [
              // PageShelf(
              //   children: [
              //     SearchTextField(
              //       controller: searchTextController,
              //       onTextSubmit: (a) => provider.searchKey == a ? null : provider.search(a),
              //       onSearchResultTap: (a) => {},
              //       onSearch: _search,
              //     ),
              //     FilterButton(
              //       onFilterTap: _showFilter,
              //       status: provider.inventoryListStatus,
              //       filter: provider.filterModel,
              //     ),
              //     const Spacer(),
              //     if (provider.inventoryList.where((e) => e.selected).isNotEmpty)
              //       DeleteButton(
              //         onDelTap: () => _deletePurchase(provider.inventoryList.where((e) => e.selected).toList()),
              //       ),
              //     RefreshButton(
              //       onRefreshTap: () => provider.getInventoryList(pageNumber: provider.currentPage),
              //       status: provider.inventoryListStatus,
              //     ),
              //     AddButton(text: 'Add Inventory', onTap: _onAddTap),
              //   ],
              // ),
              Expanded(
                child: PageListView(
                  /// Table Title
                  onSelectAllTap: (a) => provider.selectAll(),
                  isAllSelected: !provider.inventoryLogList
                      .map((e) => e.selected)
                      .contains(false),
                  titles: _titles(),

                  /// Scrollview
                  controller: scrollController,
                  status: provider.inventoryLogListStatus,
                  list: provider.inventoryLogList,

                  /// List Tile
                  onMenuTap: (index, params) => () {},
                  onSelectTap: (selected, index) => () {},
                  tileSections: (index) =>
                      _tileSections(provider.inventoryLogList[index]),
                  showCheckBox: false,
                  showMenuIcon: false,

                  /// Error
                  listingError: provider.inventoryLogListingError,
                  listingName: 'Inventory',
                  onReloadTap: provider.getInventoryLogList,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _onAddTap() => AppNavigator.navigate(AppRoutes.inventoryAdd);
}
