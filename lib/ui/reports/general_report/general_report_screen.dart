import 'package:invently/assortment/services/navigation_service/navigation_service.dart';
import 'package:invently/gen/assets.gen.dart';
import 'package:invently/provider/reports/general_reports_provider.dart';
import 'package:invently/ui/reports/general_report/purchase_report/purchase_report_screen.dart';
import 'package:invently/ui/reports/general_report/quotation_report/quotation_report_screen.dart';
import 'package:invently/ui/reports/general_report/sales_report/sales_report_screen.dart';
import 'package:invently/ui/reports/general_report/stock_report/stock_report_screen.dart';
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

import '../../../utils/theme/colors/colors.dart';

part 'general_report_functions.dart';

class GeneralReportScreen extends StatefulWidget {
  const GeneralReportScreen({super.key});

  @override
  State<GeneralReportScreen> createState() => _GeneralReportScreenState();
}

class _GeneralReportScreenState extends State<GeneralReportScreen> {
  late GeneralReportsProvider reportsProvider;

  @override
  void initState() {
    reportsProvider = context.read<GeneralReportsProvider>();
    reportsProvider.clearProvider();
    reportsProvider.initDateRange();
    reportsProvider.validateFn = () => _validate(this);

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      AppNavigator.setBreadCrumbs([AppRoutes.reports, AppRoutes.generalReport]);
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
    return Consumer<GeneralReportsProvider>(
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
                    titles: const ['Purchase Report', 'Stock Report', 'Sales Report', 'Quotation Report'],
                    tabs: [
                      PurchaseReportScreen(),
                      StockReportScreen(),
                      SalesReportScreen(),
                      QuotationReportScreen(),
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
