
import 'package:invently/utils/theme/colors/colors.dart';
import 'package:flutter/material.dart';

class BaseWindowScreen extends StatelessWidget {
  final Widget child;
  const BaseWindowScreen({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Tm.color(Tc.comBg), body: child);
  }
}
