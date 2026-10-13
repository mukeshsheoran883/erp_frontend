import 'package:invently/assortment/status.dart';
import 'package:invently/models/reports/general_report/sales_report_model.dart';
import 'package:invently/network/reports/general_report_service.dart';
import 'package:invently/provider/reports/general_reports_provider.dart';
import 'package:invently/ui/reports/general_report/general_report_variables.dart';
import 'package:invently/utils/static_values.dart';
import 'package:invently/utils/theme/colors/colors.dart';
import 'package:invently/utils/theme/text_style/text_styles.dart';
import 'package:invently/widgets/page_widgets/custom_data_table.dart';
import 'package:invently/widgets/page_widgets/page_list_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

part 'sales_report_functions.dart';
part 'widgets/table_elements.dart';

class SalesReportScreen extends StatefulWidget {
  const SalesReportScreen({super.key});

  @override
  State<SalesReportScreen> createState() => _SalesReportScreenListingState();
}

class _SalesReportScreenListingState extends State<SalesReportScreen> {
  late ScrollController scrollController;

  late GeneralReportsProvider provider;
  late GeneralReportVariables<SalesReportModel> param;

  @override
  void initState() {
    provider = context.read<GeneralReportsProvider>();
    param = provider.salesVariables;
    scrollController = ScrollController();
    param.clear();
    param.onSubmit = (a) => _getSalesReport(this, pageNumber: a);

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) => _getSalesReport(this));

    super.initState();
  }

  @override
  void dispose() {
    param.clear();
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: PageListView(
            showCheckBox: false,
            showMenuIcon: false,

            /// Table Title
            onSelectAllTap: (a) => () {},
            isAllSelected: false,
            titles: _titles(),

            /// Scrollview
            controller: scrollController,
            status: param.listingStatus,
            list: param.reportsList,

            /// List Tile
            onMenuTap: (index, params) => () {},
            onSelectTap: (p0, p1) {},
            tileSections: (index) => _tileSections(param.reportsList[index]),

            /// Error
            listingError: param.listingError,
            listingName: 'Sales Report',
            onReloadTap: () => _getSalesReport(this, pageNumber: param.currentPage),
          ),
        ),
      ],
    );
  }

  void _refresh() => mounted ? setState(() {}) : null;
}
