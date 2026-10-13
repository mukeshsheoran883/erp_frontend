import 'package:invently/assortment/extensions/string_extensions.dart';
import 'package:invently/assortment/services/navigation_service/navigation_service.dart';
import 'package:invently/assortment/status.dart';
import 'package:invently/assortment/widgets/cached_image.dart';
import 'package:invently/assortment/widgets/svg_image.dart';
import 'package:invently/gen/assets.gen.dart';
import 'package:invently/models/administration/organization_model.dart';
import 'package:invently/models/common/common_id_value_model.dart';
import 'package:invently/network/administration_service.dart';
import 'package:invently/provider/administration_provider.dart';
import 'package:invently/ui/administration/add_administration/add_administration_screen.dart';
import 'package:invently/utils/globals.dart';
import 'package:invently/utils/static_values.dart';
import 'package:invently/utils/theme/colors/colors.dart';
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

import '../../assortment/future_handler/handle_future_with_alert.dart';

part 'administration_functions.dart';
part 'view_administration/administration_details.dart';
part 'widgets/table_elements.dart';

class AdministrationScreen extends StatefulWidget {
  const AdministrationScreen({super.key});

  @override
  State<AdministrationScreen> createState() => _AdministrationListingState();
}

class _AdministrationListingState extends State<AdministrationScreen> {
  late ScrollController scrollController;
  late TextEditingController searchTextController;

  @override
  void initState() {
    scrollController = ScrollController();
    searchTextController = TextEditingController();
    final provider = context.read<AdministrationProvider>();
    provider.clearProvider();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      AppNavigator.setBreadCrumbs([AppRoutes.administration]);
      provider.getOrganizationList();
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
    return Consumer<AdministrationProvider>(
      builder: (context, provider, child) {
        return PageBodyContainer(
          bottomWidget: PaginationNumberRow(
            selectedPage: provider.currentPage,
            totalPage: provider.totalPages,
            showingCount: provider.organizationList.length,
            totalCount: provider.totalCount,
            onPageTap: provider.changePage,
            selectedCount: provider.organizationList.where((e) => e.selected).length,
          ),
          child: Column(
            children: [
              PageShelf(
                children: [
                  SearchTextField(
                    controller: searchTextController,
                    onTextSubmit: (a) => provider.searchKey == a ? null : provider.search(a),
                    onSearchResultTap: (a) => _viewOrganizationDetails(a.id),
                    onSearch: _search,
                  ),
                  const Spacer(),
                  if (provider.organizationList.where((e) => e.selected).isNotEmpty)
                    DeleteButton(
                      onDelTap: () =>
                          _deleteAdministration(provider.organizationList.where((e) => e.selected).toList()),
                    ),
                  RefreshButton(
                    onRefreshTap: () => provider.getOrganizationList(pageNumber: provider.currentPage),
                    status: provider.organizationListStatus,
                  ),
                  AddButton(text: 'Add Organization', onTap: _onAddTap),
                ],
              ),
              Expanded(
                child: PageListView(
                  /// Table Title
                  onSelectAllTap: (a) => provider.selectAll(),
                  isAllSelected: !provider.organizationList.map((e) => e.selected).contains(false),
                  titles: _titles(),

                  /// Scrollview
                  controller: scrollController,
                  status: provider.organizationListStatus,
                  list: provider.organizationList,

                  /// List Tile
                  onSelectTap: (selected, index) => provider.selectItem(provider.organizationList[index], selected),
                  tileSections: (index) => _tileSections(provider.organizationList[index]),
                  onMenuTap: (index, params) => _onMenuTap(provider.organizationList[index], params),

                  /// Error
                  listingError: provider.organizationListingError,
                  listingName: 'Administration',
                  onReloadTap: () => provider.getOrganizationList(pageNumber: provider.currentPage),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _onAddTap() => AppNavigator.navigate(AppRoutes.administrationAdd);
}
