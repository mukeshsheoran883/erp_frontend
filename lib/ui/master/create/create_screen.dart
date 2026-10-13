import 'package:invently/ui/master/create/widgets/brand/brand_screen.dart';
import 'package:invently/ui/master/create/widgets/category/category_screen.dart';
import 'package:invently/ui/master/create/widgets/tax/tax_screen.dart';
import 'package:invently/widgets/custom_tab_bar/custom_tab_bar.dart';
import 'package:invently/widgets/page_widgets/page_body_container.dart';
import 'package:flutter/material.dart';

class CreateScreen extends StatefulWidget {
  const CreateScreen({super.key});

  @override
  State<CreateScreen> createState() => _CreateScreenState();
}

class _CreateScreenState extends State<CreateScreen> {
  TabController? tabController;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PageBodyContainer(
      child: CustomTabBar(
        onControllerCreated: (a) => tabController = a,
        titles: const ['Brand', 'Category', 'Tax'],
        tabs: const [BrandScreen(), CategoryScreen(), TaxScreen()],
      ),
    );
  }
}
