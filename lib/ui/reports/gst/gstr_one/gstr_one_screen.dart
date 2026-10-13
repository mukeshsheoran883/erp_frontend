import 'package:invently/assortment/status.dart';
import 'package:invently/models/reports/gst_report/gst_one_model.dart';
import 'package:invently/network/reports/gst_report_service.dart';
import 'package:invently/provider/reports/gst_report_provider.dart';
import 'package:invently/ui/reports/gst/gst_report_variables.dart';
import 'package:invently/utils/static_values.dart';
import 'package:invently/utils/theme/colors/colors.dart';
import 'package:invently/utils/theme/text_style/text_styles.dart';
import 'package:invently/widgets/page_widgets/custom_data_table.dart';
import 'package:invently/widgets/page_widgets/page_list_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

part 'widgets/table_elements.dart';

part 'gst_one_report_functions.dart';

class GstrOneScreen extends StatefulWidget {
  const GstrOneScreen({super.key});

  @override
  State<GstrOneScreen> createState() => _GstrOneScreenListingState();
}

class _GstrOneScreenListingState extends State<GstrOneScreen> {
  late ScrollController scrollController;
  late GstReportProvider provider;
  late GstReportVariables<GstOneModel> param;

  @override
  void initState() {
    provider = context.read<GstReportProvider>();
    param = provider.gstOneVariables;
    param.clear();
    param.onSubmit = (a) => _getGstOneReport(this, pageNumber: a);
    scrollController = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) => _getGstOneReport(this));
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
    return Consumer<GstReportProvider>(
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
                listingName: 'Gstr 1',
                onReloadTap: () => _getGstOneReport(this, pageNumber: param.currentPage),
              ),
            ),
          ],
        );
      },
    );
  }

  void _refresh() => mounted ? setState(() {}) : null;
}
