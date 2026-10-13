import 'package:invently/assortment/status.dart';
import 'package:invently/models/reports/overview/supplies_report_model.dart';
import 'package:invently/network/reports/overview_report_sevice.dart';
import 'package:invently/provider/reports/overview_report_provider.dart';
import 'package:invently/ui/reports/overview/overview_report_variables.dart';
import 'package:invently/utils/theme/colors/colors.dart';
import 'package:invently/utils/theme/text_style/text_styles.dart';
import 'package:invently/widgets/page_widgets/custom_data_table.dart';
import 'package:invently/widgets/page_widgets/page_list_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

part 'widgets/table_elements.dart';

part 'supplies_report_functions.dart';

class SuppliesReportScreen extends StatefulWidget {
  const SuppliesReportScreen({super.key});

  @override
  State<SuppliesReportScreen> createState() => _SuppliesReportScreenListingState();
}

class _SuppliesReportScreenListingState extends State<SuppliesReportScreen> {
  late ScrollController scrollController;
  late OverviewReportProvider provider;
  late OverviewReportVariables<OverviewSuppliesModel> param;

  @override
  void initState() {
    provider = context.read<OverviewReportProvider>();
    param = provider.suppliesVariables;
    param.clear();
    param.onSubmit = (a) => _getSuppliesReport(this, pageNumber: a);
    scrollController = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) => _getSuppliesReport(this));
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
    return Consumer<OverviewReportProvider>(
      builder: (context, provider, child) {
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
                listingName: 'Supplies Report',
                onReloadTap: () => _getSuppliesReport(this, pageNumber: param.currentPage),
              ),
            ),
          ],
        );
      },
    );
  }

  void _refresh() => mounted ? setState(() {}) : null;
}
