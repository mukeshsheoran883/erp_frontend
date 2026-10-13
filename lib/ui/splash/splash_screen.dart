
import 'package:invently/assortment/services/navigation_service/navigation_service.dart';
import 'package:invently/provider/authentication_provider.dart';
import 'package:invently/provider/common_functions_provider.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Future.delayed(const Duration(seconds: 0), () {
      CommonFunctionsProvider.setSplashCompleted(true);

      final role = AuthenticationProvider.getRole();
      switch (role) {
        case 'INVENTORY':
          AppNavigator.navigate(AppRoutes.posInventory);
          break;
        case 'DISPATCH':
          AppNavigator.navigate(AppRoutes.godown);
          break;
        default:
          AppNavigator.navigate(AppRoutes.dashBoard);
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: SizedBox()));
  }
}