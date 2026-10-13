import 'package:invently/assortment/status.dart';
import 'package:invently/models/reports/administration/attendance_report_model.dart';
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

part 'attendance_report_functions.dart';

class AttendanceReportScreen extends StatefulWidget {
  const AttendanceReportScreen({super.key});

  @override
  State<AttendanceReportScreen> createState() => _AttendanceReportScreenListingState();
}

class _AttendanceReportScreenListingState extends State<AttendanceReportScreen> {
  late ScrollController scrollController;
  late AdministrationReportProvider provider;
  late AdministrationReportVariables<AttendanceReportModel> param;

  @override
  void initState() {
    provider = context.read<AdministrationReportProvider>();
    param = provider.attendanceVariables;
    param.clear();
    param.onSubmit = (a) => _getAttendanceReport(this, pageNumber: a);
    scrollController = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) => _getAttendanceReport(this));
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
                onReloadTap: () => _getAttendanceReport(this, pageNumber: param.currentPage),
              ),
            ),
          ],
        );
      },
    );
  }

  void _refresh() => mounted ? setState(() {}) : null;
}
