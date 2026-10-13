import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_wrapper.dart';
import 'package:responsive_framework/utils/responsive_utils.dart';

class ResponsiveFrameworkBuilder extends StatelessWidget {
  final Widget child;
  const ResponsiveFrameworkBuilder({required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveWrapper.builder(
      child,
      minWidth: 200,
      backgroundColor: Colors.transparent,
      landscapePlatforms: [ResponsiveTargetPlatform.web],
      breakpoints: [
        const ResponsiveBreakpoint.autoScale(500, scaleFactor: 0.3),
        if (MediaQuery.of(context).devicePixelRatio <= 1) ..._points,
      ],
    );
  }
}

List<ResponsiveBreakpoint> _points = const [
  ResponsiveBreakpoint.resize(300, scaleFactor: 0.525),
  ResponsiveBreakpoint.resize(425, scaleFactor: 0.550),
  ResponsiveBreakpoint.resize(450, scaleFactor: 0.575),
  ResponsiveBreakpoint.resize(475, scaleFactor: 0.600),
  ResponsiveBreakpoint.resize(500, scaleFactor: 0.625),
  ResponsiveBreakpoint.resize(525, scaleFactor: 0.650),
  ResponsiveBreakpoint.resize(550, scaleFactor: 0.675),
  ResponsiveBreakpoint.resize(575, scaleFactor: 0.700),
  ResponsiveBreakpoint.resize(600, scaleFactor: 0.710),
  ResponsiveBreakpoint.resize(650, scaleFactor: 0.720),
  ResponsiveBreakpoint.resize(700, scaleFactor: 0.730),
  ResponsiveBreakpoint.resize(750, scaleFactor: 0.740),
  ResponsiveBreakpoint.resize(800, scaleFactor: 0.750),
  ResponsiveBreakpoint.resize(850, scaleFactor: 0.760),
  ResponsiveBreakpoint.resize(900, scaleFactor: 0.770),
  ResponsiveBreakpoint.resize(950, scaleFactor: 0.790),
  ResponsiveBreakpoint.resize(1000, scaleFactor: 0.800),
  ResponsiveBreakpoint.resize(1050, scaleFactor: 0.825),
  ResponsiveBreakpoint.resize(1100, scaleFactor: 0.850),
  ResponsiveBreakpoint.resize(1150, scaleFactor: 0.875),
  ResponsiveBreakpoint.resize(1200, scaleFactor: 0.900),
  ResponsiveBreakpoint.resize(1250, scaleFactor: 0.925),
  ResponsiveBreakpoint.resize(1300, scaleFactor: 0.950),
  ResponsiveBreakpoint.resize(1350, scaleFactor: 0.975),
  ResponsiveBreakpoint.resize(1400),
];
