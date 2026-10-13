import 'package:invently/assortment/status.dart';
import 'package:invently/models/reports/administration/employee_report_model.dart';
import 'package:invently/network/reports/administration_report_service.dart';
import 'package:invently/provider/reports/administration_report_provider.dart';
import 'package:invently/ui/reports/administration/administration_report_variables.dart';
import 'package:invently/utils/theme/colors/colors.dart';
import 'package:invently/utils/theme/text_style/text_styles.dart';
import 'package:invently/widgets/page_widgets/custom_data_table.dart';
import 'package:invently/widgets/page_widgets/page_list_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

part 'widgets/table_elements.dart';

part 'employee_report_functions.dart';

class EmployeeReportScreen extends StatefulWidget {
  const EmployeeReportScreen({super.key});

  @override
  State<EmployeeReportScreen> createState() => _EmployeeReportScreenListingState();
}

class _EmployeeReportScreenListingState extends State<EmployeeReportScreen> {
  late ScrollController scrollController;
  late AdministrationReportProvider provider;
  late AdministrationReportVariables<EmployeeReportModel> param;

  @override
  void initState() {
    provider = context.read<AdministrationReportProvider>();
    param = provider.employeeVariables;
    param.clear();
    param.onSubmit = (a) => _getEmployeeReport(this, pageNumber: a);
    scrollController = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) => _getEmployeeReport(this));
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
    return Consumer<AdministrationReportProvider>(
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
                listingName: 'Customer Report',
                onReloadTap: () => _getEmployeeReport(this, pageNumber: param.currentPage),
              ),
            ),
          ],
        );
      },
    );
  }

  void _refresh() => mounted ? setState(() {}) : null;
}
