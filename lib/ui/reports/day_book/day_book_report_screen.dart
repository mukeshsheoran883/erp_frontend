import 'package:invently/assortment/services/navigation_service/navigation_service.dart';
import 'package:invently/gen/assets.gen.dart';
import 'package:invently/provider/reports/day_book_report_provider.dart';
import 'package:invently/ui/reports/day_book/customer_report/customer_report_screen.dart';
import 'package:invently/ui/reports/day_book/inventory_balance_report/inventory_balance_report_screen.dart';
import 'package:invently/ui/reports/day_book/item_report/item_report_screen.dart';
import 'package:invently/ui/reports/day_book/supplies_report/supplies_report_screen.dart';
import 'package:invently/utils/theme/colors/colors.dart';
import 'package:invently/utils/validation/validator.dart';
import 'package:invently/utils/validation/validators.dart';
import 'package:invently/widgets/custom_tab_bar/custom_tab_bar.dart';
import 'package:invently/widgets/date_time_picker/date_time_field.dart';
import 'package:invently/widgets/date_time_picker/date_time_picker.dart';
import 'package:invently/widgets/page_widgets/page_body_container.dart';
import 'package:invently/widgets/page_widgets/page_header_container.dart';
import 'package:invently/widgets/page_widgets/pagination_number_row.dart';
import 'package:invently/widgets/page_widgets/refresh_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

part 'day_book_report_functions.dart';

class DayBookReportScreen extends StatefulWidget {
  const DayBookReportScreen({super.key});

  @override
  State<DayBookReportScreen> createState() => _DayBookReportScreenState();
}

class _DayBookReportScreenState extends State<DayBookReportScreen> {
  late DayBookReportProvider reportsProvider;

  @override
  void initState() {
    reportsProvider = context.read<DayBookReportProvider>();
    reportsProvider.clearProvider();
    reportsProvider.initDateRange();
    reportsProvider.validateFn = () => _validate(this);

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      AppNavigator.setBreadCrumbs([AppRoutes.reports, AppRoutes.dayBookReport]);
    });
    super.initState();
  }

  @override
  void dispose() {
    reportsProvider.clearProvider();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DayBookReportProvider>(
      builder: (context, provider, child) {
        return Column(
          children: [
            PageHeaderContainer(
              bottomSpacing: 0,
              widgets: [
                Flexible(
                  child: CustomDateTimeField(
                    title: null,
                    hint: 'Start Date',
                    pickMode: DatePickMode.dateOnly,
                    maxDateTime: DateTime.now(),
                    error: provider.startDate.error.errorMessage,
                    initialDateTime: provider.startDate.dateTime,
                    removeAllProps: true,
                    showError: true,
                    onDateSelected: (a) => {provider.startDate.reset(a), _refresh()},
                  ),
                ),
                Flexible(
                  child: CustomDateTimeField(
                    title: null,
                    hint: 'End Date',
                    pickMode: DatePickMode.dateOnly,
                    maxDateTime: DateTime.now(),
                    error: provider.endDate.error.errorMessage,
                    initialDateTime: provider.endDate.dateTime,
                    removeAllProps: true,
                    showError: true,
                    onDateSelected: (a) => {provider.endDate.reset(a), _refresh()},
                  ),
                ),
                Spacer(),
                Spacer(),
                RefreshButton(
                  onRefreshTap: () => provider.currentVariable().onSubmit?.call(provider.currentVariable().currentPage),
                  status: provider.currentVariable().listingStatus,
                  padding: EdgeInsets.zero,
                ),
                PageHeaderButton(
                  label: 'Submit',
                  onTap: () => _onSubmitTap(this, 1),
                  icon: Assets.icons.checkSquare,
                  status: provider.currentVariable().listingStatus,
                ),
                PageHeaderButton(
                  label: 'Download',
                  onTap: () => () {},
                  icon: Assets.icons.download,
                  buttonColor: Tm.color(Tc.neuDef),
                  textColor: Tm.color(Tc.neuNeuBtnTxt),
                  status: provider.currentVariable().listingStatus,
                ),
              ],
            ),
            SizedBox(height: 24),
            Expanded(
              child: PageBodyContainer(
                bottomWidget: PaginationNumberRow(
                  selectedPage: provider.currentVariable().currentPage,
                  totalPage: provider.currentVariable().totalPages,
                  showingCount: provider.currentVariable().showingCount,
                  totalCount: provider.currentVariable().totalCount,
                  onPageTap: provider.changePage,
                  selectedCount: 0,
                ),
                child: PageBodyContainer(
                  child: CustomTabBar(
                    onControllerCreated: (a) => provider.tabController = a,
                    onPageChanged: (a) => _refresh(),
                    titles: const ['Items', 'Customers', 'Inventory Balance', 'Supplies'],
                    tabs: const [
                      ItemReportScreen(),
                      CustomerReportScreen(),
                      InventoryBalanceReportScreen(),
                      SuppliesReportScreen(),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _refresh() => mounted ? setState(() {}) : null;
}
