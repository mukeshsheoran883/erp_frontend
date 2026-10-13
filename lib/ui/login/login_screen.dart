
import 'package:invently/assortment/widgets/svg_image.dart';
import 'package:invently/gen/assets.gen.dart';
import 'package:invently/ui/login/widgets/bottom_text.dart';
import 'package:invently/ui/login/widgets/company_name.dart';
import 'package:invently/ui/side_menu/widgets/theme_switch.dart';
import 'package:invently/utils/theme/colors/colors.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  final Widget child;
  const LoginScreen({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [const Expanded(child: _LeftContainer()), Expanded(child: _RightContainer(child: child))],
    );
  }
}

class _LeftContainer extends StatelessWidget {
  const _LeftContainer();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [PC.colorPrimary900, PC.colorPrimary500],
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
        ),
      ),
      alignment: Alignment.center,
      child: SizedBox(height: 150, child: SvgImage(Assets.images.logo)),
    );
  }
}

class _RightContainer extends StatefulWidget {
  final Widget child;
  const _RightContainer({required this.child});

  @override
  State<_RightContainer> createState() => _RightContainerState();
}

class _RightContainerState extends State<_RightContainer> {
  late ScrollController scrollController;

  @override
  void initState() {
    scrollController = ScrollController();
    super.initState();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Tm.color(Tc.loginWhite),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            alignment: Alignment.center,
            child: Stack(
              alignment: Alignment.center,
              children: [
                const CompanyName(),
                Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 16, top: 8),
                    child: ThemeSwitch(
                      expanded: false,
                      bgColor: Colors.transparent,
                      buttonInsideColor: Tm.color(Tc.comHigh),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 392 + 64,
            constraints: const BoxConstraints(minHeight: 400),
            decoration: BoxDecoration(
              color: Tm.isDarkTheme.value ? Tm.color(Tc.comHigh).withValues(alpha: 0.3) : null,
              borderRadius: const BorderRadius.all(Radius.circular(24)),
            ),
            padding: const EdgeInsets.all(32),
            child: widget.child,
          ),
          const Padding(padding: EdgeInsets.only(top: 12), child: BottomText()),
        ],
      ),
    );
  }
}
