import 'package:invently/assortment/future_handler/handle_future_with_alert.dart';
import 'package:invently/assortment/network/api_manager_models.dart';
import 'package:invently/assortment/services/navigation_service/navigation_service.dart';
import 'package:invently/assortment/status.dart';
import 'package:invently/models/common/common_id_value_model.dart';
import 'package:invently/models/pos/pos_model.dart';
import 'package:invently/network/pos/pos_service.dart';
import 'package:invently/network/purchase_service.dart';
import 'package:invently/provider/dispatch/dispatch_provider.dart';
import 'package:invently/ui/godown/add_dispatch-details/add_dispatch_details_screen.dart';
import 'package:invently/utils/globals.dart';
import 'package:invently/utils/static_values.dart';
import 'package:invently/utils/theme/colors/colors.dart';
import 'package:invently/widgets/alert_dialog/api_search_drop_down.dart';
import 'package:invently/widgets/alert_dialog/double_button_alert.dart';
import 'package:invently/widgets/alert_dialog/popup_menu/show_app_menu.dart';
import 'package:invently/widgets/app_snack_bar.dart';
import 'package:invently/widgets/form_widgets/search_text_field.dart';
import 'package:invently/widgets/page_widgets/custom_data_table.dart';
import 'package:invently/widgets/page_widgets/page_body_container.dart';
import 'package:invently/widgets/page_widgets/page_list_view.dart';
import 'package:invently/widgets/page_widgets/page_shelf.dart';
import 'package:invently/widgets/page_widgets/pagination_number_row.dart';
import 'package:invently/widgets/page_widgets/refresh_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

part 'dispatch_functions.dart';
part 'widgets/table_elements.dart';

class DispatchScreen extends StatefulWidget {
  const DispatchScreen({super.key});

  @override
  State<DispatchScreen> createState() => _DispatchScreenListingState();
}

class _DispatchScreenListingState extends State<DispatchScreen> {
  late ScrollController scrollController;
  late TextEditingController searchTextController;

  @override
  void initState() {
    searchTextController = TextEditingController();
    scrollController = ScrollController();
    final provider = context.read<DispatchProvider>();
    provider.clearProvider();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      AppNavigator.setBreadCrumbs([AppRoutes.godown]);
      provider.getDispatchList();
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
    return Consumer<DispatchProvider>(
      builder: (context, provider, child) {
        return PageBodyContainer(
          bottomWidget: PaginationNumberRow(
            selectedPage: provider.currentPage,
            totalPage: provider.totalPages,
            showingCount: provider.posList.length,
            totalCount: provider.totalCount,
            onPageTap: provider.changePage,
            selectedCount: provider.posList.where((e) => e.selected).length,
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
                  RefreshButton(
                    onRefreshTap: () => provider.getDispatchList(pageNumber: provider.currentPage),
                    status: provider.posListStatus,
                  ),
                ],
              ),
              Expanded(
                child: PageListView(
                  /// Table Title
                  onSelectAllTap: (a) => provider.selectAll(),
                  isAllSelected: !provider.posList.map((e) => e.selected).contains(false),
                  titles: _titles(),

                  /// Scrollview
                  controller: scrollController,
                  status: provider.posListStatus,
                  list: provider.posList,
                  showCheckBox: false,

                  /// List Tile
                  onMenuTap: (index, params) => _onMenuTap(provider.posList[index], params),
                  onSelectTap: (selected, index) => provider.selectItem(provider.posList[index], selected),
                  tileSections: (index) => _tileSections(provider.posList[index]),

                  /// Error
                  listingError: provider.posListingError,
                  listingName: 'Dispatch',
                  onReloadTap: provider.getDispatchList,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
