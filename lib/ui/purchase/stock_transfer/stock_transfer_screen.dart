import 'package:invently/assortment/services/navigation_service/navigation_service.dart';
import 'package:invently/ui/purchase/stock_transfer/completed_transfer/stock_completed_transfer_screen.dart';
import 'package:invently/ui/purchase/stock_transfer/pending_transfer/stock_pending_transfer_screen.dart';
import 'package:invently/ui/purchase/stock_transfer/rejected_transfer/stock_rejected_transfer_screen.dart';
import 'package:invently/widgets/custom_tab_bar/custom_tab_bar.dart';
import 'package:invently/widgets/page_widgets/page_body_container.dart';
import 'package:invently/widgets/page_widgets/pagination_number_row.dart';
import 'package:flutter/material.dart';

class StockTransferScreen extends StatefulWidget {
  const StockTransferScreen({super.key});

  @override
  State<StockTransferScreen> createState() => _StockTransferScreenState();
}

class _StockTransferScreenState extends State<StockTransferScreen> {
  TabController? tabController;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      AppNavigator.setBreadCrumbs([AppRoutes.purchase, AppRoutes.stockTransfer]);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: PageBodyContainer(
            bottomWidget: PaginationNumberRow(
              selectedPage: 1,
              totalPage: 2,
              showingCount: 3,
              totalCount: 3,
              onPageTap: (p0) {},
              selectedCount: 1,
            ),
            child: PageBodyContainer(
              child: CustomTabBar(
                onControllerCreated: (a) => tabController = a,
                titles: const [
                  'Pending Transfer',
                  'Completed',
                  'Rejected',
                ],
                tabs: const [
                  StockPendingTransferScreen(),
                  StockCompletedTransferScreen(),
                  StockRejectedTransferScreen(),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
