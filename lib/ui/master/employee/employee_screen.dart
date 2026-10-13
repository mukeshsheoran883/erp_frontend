
import 'package:invently/assortment/extensions/string_extensions.dart';
import 'package:invently/assortment/future_handler/handle_future_with_alert.dart';
import 'package:invently/assortment/services/navigation_service/navigation_service.dart';
import 'package:invently/assortment/status.dart';
import 'package:invently/assortment/widgets/cached_image.dart';
import 'package:invently/assortment/widgets/svg_image.dart';
import 'package:invently/gen/assets.gen.dart';
import 'package:invently/models/common/common_id_value_model.dart';
import 'package:invently/models/user/employee_model.dart';
import 'package:invently/network/employee_service.dart';
import 'package:invently/provider/master/employee_provider.dart';
import 'package:invently/ui/master/employee/add_employee/add_employee_screen.dart';
import 'package:invently/ui/master/employee/view_employee/employee_details_wrap_widget.dart';
import 'package:invently/ui/master/employee/widgets/filter_section.dart';
import 'package:invently/utils/globals.dart';
import 'package:invently/utils/static_values.dart';
import 'package:invently/utils/theme/colors/colors.dart';
import 'package:invently/utils/theme/text_style/text_styles.dart';
import 'package:invently/widgets/alert_dialog/api_search_drop_down.dart';
import 'package:invently/widgets/alert_dialog/popup_menu/show_app_menu.dart';
import 'package:invently/widgets/app_snack_bar.dart';
import 'package:invently/widgets/buttons/add_button.dart';
import 'package:invently/widgets/chip_widget.dart';
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
import 'package:invently/widgets/page_widgets/view_details_side_menu/chip_widget.dart';
import 'package:invently/widgets/page_widgets/view_details_side_menu/details_item.dart';
import 'package:invently/widgets/page_widgets/view_details_side_menu/view_details_bottom_buttons.dart';
import 'package:invently/widgets/page_widgets/view_details_side_menu/view_details_skeleton.dart';
import 'package:invently/widgets/show_multi_delete_popup.dart';
import 'package:invently/widgets/view_item_overlay.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

part 'employee_functions.dart';
part 'view_employee/employee_details.dart';
part 'widgets/table_elements.dart';

class EmployeeScreen extends StatefulWidget {
  const EmployeeScreen({super.key});

  @override
  State<EmployeeScreen> createState() => _EmployeeListingState();
}

class _EmployeeListingState extends State<EmployeeScreen> {
  late ScrollController scrollController;

  late TextEditingController searchTextController;

  @override
  void initState() {
    scrollController = ScrollController();
    searchTextController = TextEditingController();
    final provider = context.read<EmployeeProvider>();
    provider.clearProvider();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      AppNavigator.setBreadCrumbs([AppRoutes.master, AppRoutes.employee]);
      provider.getEmployeeList();
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
    return Consumer<EmployeeProvider>(
      builder: (context, provider, child) {
        return PageBodyContainer(
          bottomWidget: PaginationNumberRow(
            selectedPage: provider.currentPage,
            totalPage: provider.totalPages,
            showingCount: provider.employeeList.length,
            totalCount: provider.totalCount,
            onPageTap: provider.changePage,
            selectedCount: provider.employeeList.where((e) => e.selected).length,
          ),
          child: Column(
            children: [
              PageShelf(
                children: [
                  SearchTextField(
                    controller: searchTextController,
                    onTextSubmit: (a) => provider.searchKey == a ? null : provider.search(a),
                    onSearchResultTap: (a) => _viewEmployeeDetails(a.id),
                    onSearch: _search,
                  ),
                  FilterButton(
                    onFilterTap: _showFilter,
                    status: provider.employeeListStatus,
                    filter: provider.filterModel,
                  ),
                  const Spacer(),
                  if (provider.employeeList.where((e) => e.selected && !e.isActive).isNotEmpty)
                    SquareIconButton(model: _getIconButtonModel(provider, true)),
                  if (provider.employeeList.where((e) => e.selected && e.isActive).isNotEmpty)
                    SquareIconButton(model: _getIconButtonModel(provider, false)),
                  if (provider.employeeList.where((e) => e.selected).isNotEmpty)
                    DeleteButton(
                      onDelTap: () => _deleteEmployees(provider.employeeList.where((e) => e.selected).toList()),
                    ),
                  RefreshButton(
                    onRefreshTap: () => provider.getEmployeeList(pageNumber: provider.currentPage),
                    status: provider.employeeListStatus,
                  ),
                  AddButton(text: 'Add Employee', onTap: _onAddTap),
                ],
              ),
              Expanded(
                child: PageListView(
                  /// Table Title
                  onSelectAllTap: (a) => provider.selectAll(),
                  isAllSelected: !provider.employeeList.map((e) => e.selected).contains(false),
                  titles: _titles(),

                  /// Scrollview
                  controller: scrollController,
                  status: provider.employeeListStatus,
                  list: provider.employeeList,

                  /// List Tile
                  onMenuTap: (index, params) => _onMenuTap(provider.employeeList[index], params),
                  onSelectTap: (selected, index) => provider.selectItem(provider.employeeList[index], selected),
                  tileSections: (index) => _tileSections(provider.employeeList[index]),

                  /// Error
                  listingError: provider.employeeListingError,
                  listingName: 'Employees',
                  onReloadTap: () => provider.getEmployeeList(pageNumber: provider.currentPage),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _onAddTap() => AppNavigator.navigate(AppRoutes.employeeAdd);

  SquareIconButtonModel _getIconButtonModel(EmployeeProvider provider, bool isActivateButton) {
    return SquareIconButtonModel(
      buttonIcon: isActivateButton ? Assets.icons.personApprove : Assets.icons.personCancel,
      tooltip: isActivateButton ? 'Activate' : 'Deactivate',
      onTap: () => _updateEmployeeStatus(
        (isActivateButton
                ? provider.employeeList.where((e) => e.selected && !e.isActive)
                : provider.employeeList.where((e) => e.selected && e.isActive))
            .toList(),
        isActivateButton,
      ),
      iconColor: isActivateButton ? Tm.color(Tc.grnActLight) : Tm.color(Tc.redActLight),
      buttonBgColor: isActivateButton ? Tm.color(Tc.iconButtonBgGreen) : Tm.color(Tc.iconButtonBgRed),
    );
  }
}
