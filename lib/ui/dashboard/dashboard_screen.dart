
import 'package:invently/assortment/services/navigation_service/navigation_service.dart';
import 'package:invently/provider/authentication_provider.dart';
import 'package:invently/utils/theme/colors/colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((a) => AppNavigator.setBreadCrumbs([AppRoutes.dashBoard]));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      decoration:
          BoxDecoration(color: Tm.color(Tc.comCardBg), borderRadius: const BorderRadius.all(Radius.circular(24))),
      child: Column(
        children: [
          MaterialButton(
            onPressed: () => {
              context.read<AuthenticationProvider>().logout(closeAllPopup: true),
              AppNavigator.navigate(AppRoutes.splash),
            },
            child: const Text('Logout'),
          ),
          const Text('Dashboard'),
        ],
      ),
    );
  }
}
