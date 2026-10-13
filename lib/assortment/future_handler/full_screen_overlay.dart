import 'package:invently/ui/splash/widgets/responsive_framework_builder.dart';
import 'package:invently/utils/globals.dart';
import 'package:invently/utils/theme/colors/colors.dart';
import 'package:flutter/material.dart';

class FullScreenBanner {
  DialogRoute? _dialogRoute;
  final BuildContext _context = Globals.context();

  Future<dynamic>? show({Widget? widget, bool dismissible = false, Color? barrierColor}) {
    barrierColor ??= Tm.isDarkTheme.value ? Colors.black26 : Colors.black12;

    _dialogRoute = DialogRoute(
      context: _context,
      barrierDismissible: dismissible,
      builder: (context) => ResponsiveFrameworkBuilder(
        child: DefaultTextStyle(
          style: const TextStyle(),
          child: PopScope(
            canPop: dismissible,
            child: widget ?? const Center(child: _FullScreenWidget()),
          ),
        ),
      ),
      barrierColor: barrierColor,
    );

    if (_dialogRoute == null) return null;

    return Navigator.push(_context, _dialogRoute!);
  }

  void hide() {
    if (_dialogRoute != null && _dialogRoute!.canPop) Navigator.removeRoute(_context, _dialogRoute!);
  }
}

class _FullScreenWidget extends StatelessWidget {
  const _FullScreenWidget();

  @override
  Widget build(BuildContext context) => Container(color: Colors.transparent);
}
