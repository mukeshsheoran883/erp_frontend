import 'package:invently/assortment/status.dart';
import 'package:invently/models/reports/general_report/purchase_report_model.dart';
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

part 'purchase_report_functions.dart';
part 'widgets/table_elements.dart';

class PurchaseReportScreen extends StatefulWidget {
  const PurchaseReportScreen({super.key});

  @override
  State<PurchaseReportScreen> createState() => _PurchaseReportScreenListingState();
}

class _PurchaseReportScreenListingState extends State<PurchaseReportScreen> {
  late ScrollController scrollController;

  late GeneralReportsProvider provider;
  late GeneralReportVariables<PurchaseReportModel> param;

  @override
  void initState() {
    provider = context.read<GeneralReportsProvider>();
    param = provider.purchaseVariables;
    param.clear();
    param.onSubmit = (a) => _getPurchaseReport(this, pageNumber: a);
    scrollController = ScrollController();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) => _getPurchaseReport(this));

    super.initState();
  }

  @override
  void dispose() {
    scrollController.dispose();
    param.clear();
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
            listingName: 'Purchase Report',
            onReloadTap: () => _getPurchaseReport(this, pageNumber: param.currentPage),
          ),
        ),
      ],
    );
  }

  void _refresh() => mounted ? setState(() {}) : null;
}
