import 'package:invently/assortment/extensions/string_extensions.dart';
import 'package:invently/assortment/future_handler/handle_future_with_alert.dart';
import 'package:invently/assortment/services/navigation_service/navigation_service.dart';
import 'package:invently/assortment/status.dart';
import 'package:invently/models/category/category_model.dart';
import 'package:invently/models/common/common_id_value_model.dart';
import 'package:invently/network/category_service.dart';
import 'package:invently/provider/master/create/category_provider.dart';
import 'package:invently/ui/master/create/widgets/category/add_category/add_category_screen.dart';
import 'package:invently/utils/globals.dart';
import 'package:invently/utils/theme/colors/colors.dart';
import 'package:invently/utils/theme/text_style/text_styles.dart';
import 'package:invently/widgets/alert_dialog/api_search_drop_down.dart';
import 'package:invently/widgets/alert_dialog/popup_menu/show_app_menu.dart';
import 'package:invently/widgets/app_snack_bar.dart';
import 'package:invently/widgets/buttons/add_button.dart';
import 'package:invently/widgets/form_widgets/search_text_field.dart';
import 'package:invently/widgets/page_widgets/custom_data_table.dart';
import 'package:invently/widgets/page_widgets/delete_button.dart';
import 'package:invently/widgets/page_widgets/page_body_container.dart';
import 'package:invently/widgets/page_widgets/page_list_view.dart';
import 'package:invently/widgets/page_widgets/page_shelf.dart';
import 'package:invently/widgets/page_widgets/pagination_number_row.dart';
import 'package:invently/widgets/page_widgets/refresh_button.dart';
import 'package:invently/widgets/show_multi_delete_popup.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

part 'category_functions.dart';
part 'widgets/table_elements.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryListingState();
}

class _CategoryListingState extends State<CategoryScreen> {
  late ScrollController scrollController;
  late TextEditingController searchTextController;

  @override
  void initState() {
    scrollController = ScrollController();
    searchTextController = TextEditingController();
    final provider = context.read<CategoryProvider>();
    provider.clear();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      AppNavigator.setBreadCrumbs([AppRoutes.master, AppRoutes.create]);
      provider.getCategoryList();
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
    return Consumer<CategoryProvider>(
      builder: (context, provider, child) {
        return PageBodyContainer(
          bottomWidget: PaginationNumberRow(
            selectedPage: provider.currentPage,
            totalPage: provider.totalPages,
            showingCount: provider.categoryList.length,
            totalCount: provider.totalCount,
            onPageTap: provider.changePage,
            selectedCount: provider.categoryList.where((e) => e.selected).length,
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
                  if (provider.categoryList.where((e) => e.selected).isNotEmpty)
                    DeleteButton(
                      onDelTap: () => _deleteCategory(provider.categoryList.where((e) => e.selected).toList()),
                    ),
                  RefreshButton(
                    onRefreshTap: () => provider.getCategoryList(pageNumber: provider.currentPage),
                    status: provider.categoryListStatus,
                  ),
                  AddButton(text: 'Add Category', onTap: _onAddTap),
                ],
              ),
              Expanded(
                child: PageListView(
                  /// Table Title
                  onSelectAllTap: (a) => provider.selectAll(),
                  isAllSelected: !provider.categoryList.map((e) => e.selected).contains(false),
                  titles: _titles(),

                  /// Scrollview
                  controller: scrollController,
                  status: provider.categoryListStatus,
                  list: provider.categoryList,

                  /// List Tile
                  onMenuTap: (index, params) => _onMenuTap(provider.categoryList[index], params),
                  onSelectTap: (selected, index) => provider.selectItem(provider.categoryList[index], selected),
                  tileSections: (index) => _tileSections(provider.categoryList[index]),

                  /// Error
                  listingError: provider.categoryListingError,
                  listingName: 'Category',
                  onReloadTap: () => provider.getCategoryList(pageNumber: provider.currentPage),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _onAddTap() => showCustomCategoryScreen(title: 'Add Category', buttonName: 'Save');
}
