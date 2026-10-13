
import 'dart:ui';

import 'package:invently/assortment/helpers/hive_helper.dart';
import 'package:invently/assortment/network/save_network_request.dart';
import 'package:invently/assortment/services/navigation_service/navigation_service.dart';
import 'package:invently/provider/authentication_provider.dart';
import 'package:invently/provider/provider_register.dart';
import 'package:invently/ui/splash/widgets/responsive_framework_builder.dart';
import 'package:invently/utils/app_version.dart';
import 'package:invently/utils/static_values.dart';
import 'package:invently/utils/theme/colors/colors.dart';
import 'package:invently/utils/theme/theme_data.dart';
import 'package:fast_cached_network_image/fast_cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  await initApp();
  runApp(MultiProvider(providers: ProviderRegister.providers, child: const GemBiller()));
}

Future<void> initApp() async {
  WidgetsFlutterBinding.ensureInitialized();
  SemanticsBinding.instance.ensureSemantics();
  await AppVersionUtils.loadAppVersion();
  HiveHelper.init(kIsWeb ? null : 'C:/Users/Public/Downloads');
  SaveNetworkLog.clearDb();
  await AuthenticationProvider.retrieveUserData();
  await Tm.retrieveTheme();
  await FastCachedImageConfig.init();
}

class GemBiller extends StatefulWidget {
  const GemBiller({super.key});

  @override
  State<GemBiller> createState() => _GemBillerState();
}

class _GemBillerState extends State<GemBiller> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: Tm.isDarkTheme,
      builder: (context, theme, child) {
        return MaterialApp.router(
          title: '${StaticValues.companyName} ${StaticValues.appName}',
          debugShowCheckedModeBanner: false,
          theme: commonThemeData,
          routerConfig: AppNavigator.router,
          key: Key(theme.toString()),
          builder: (context, child) => Overlay(
            initialEntries: [OverlayEntry(builder: (context) => ResponsiveFrameworkBuilder(child: child!))],
          ),
          scrollBehavior: _NoThumbScrollBehavior().copyWith(scrollbars: false),
        );
      },
    );
  }
}

class _NoThumbScrollBehavior extends ScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
    PointerDeviceKind.touch,
    PointerDeviceKind.mouse,
    PointerDeviceKind.stylus,
    PointerDeviceKind.trackpad,
  };
}