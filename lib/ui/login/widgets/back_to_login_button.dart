
import 'package:invently/assortment/services/navigation_service/navigation_service.dart';
import 'package:invently/assortment/widgets/button/hover_gesture_detector.dart';
import 'package:invently/utils/theme/colors/colors.dart';
import 'package:invently/utils/theme/text_style/text_styles.dart';
import 'package:flutter/material.dart';

class BackToLoginButton extends StatelessWidget {
  const BackToLoginButton({super.key});

  @override
  Widget build(BuildContext context) {
    return HoverGD(
      child: Text('Back to login', style: Ts.rgMedium(color: Tm.color(Tc.txtH4))),
      onTap: () => AppNavigator.navigate(AppRoutes.login),
    );
  }
}

class LoginTextOnlyButton extends StatelessWidget {
  final String text;
  final Function()? onTap;

  const LoginTextOnlyButton({super.key, this.onTap, required this.text});

  @override
  Widget build(BuildContext context) {
    return HoverGD(
      onTap: onTap,
      child: Text(text, style: Ts.rgMedium(color: Tm.color(Tc.txtH4))),
    );
  }
}
