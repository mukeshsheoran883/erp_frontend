import 'package:invently/assortment/status.dart';
import 'package:invently/models/reports/day_book/day_book_item_model.dart';
import 'package:invently/network/reports/day_book_report_service.dart';
import 'package:invently/provider/reports/day_book_report_provider.dart';
import 'package:invently/ui/reports/day_book/day_book_report_variables.dart';
import 'package:invently/utils/theme/colors/colors.dart';
import 'package:invently/utils/theme/text_style/text_styles.dart';
import 'package:invently/widgets/page_widgets/custom_data_table.dart';
import 'package:invently/widgets/page_widgets/page_list_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

part 'widgets/table_elements.dart';

part 'item_report_functions.dart';

class ItemReportScreen extends StatefulWidget {
  const ItemReportScreen({super.key});

  @override
  State<ItemReportScreen> createState() => _ItemReportScreenListingState();
}

class _ItemReportScreenListingState extends State<ItemReportScreen> {
  late ScrollController scrollController;
  late DayBookReportProvider provider;
  late DayBookReportVariables<DayBookItemModel> param;

  @override
  void initState() {
    provider = context.read<DayBookReportProvider>();
    param = provider.itemVariables;
    param.clear();
    param.onSubmit = (a) => _getItemReport(this, pageNumber: a);
    scrollController = ScrollController();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) => _getItemReport(this));

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
    return Consumer<DayBookReportProvider>(
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
                listingName: 'Item Report',
                onReloadTap: () => _getItemReport(this, pageNumber: param.currentPage),
              ),
            ),
          ],
        );
      },
    );
  }

  void _refresh() => mounted ? setState(() {}) : null;
}
