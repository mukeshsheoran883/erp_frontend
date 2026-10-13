
import 'package:invently/assortment/status.dart';
import 'package:invently/assortment/widgets/button/hover_gesture_detector.dart';
import 'package:invently/assortment/widgets/svg_image.dart';
import 'package:invently/gen/assets.gen.dart';
import 'package:invently/utils/theme/colors/colors.dart';
import 'package:flutter/material.dart';

class RefreshButton extends StatelessWidget {
  final Function()? onRefreshTap;
  final Status status;
  final EdgeInsets padding;

  const RefreshButton({
    super.key,
    required this.onRefreshTap,
    this.padding = const EdgeInsets.only(right: 16),
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: HoverGD(
        onTap: status == Status.loading ? null : onRefreshTap,
        tooltip: 'Refresh',
        borderRadius: const BorderRadius.all(Radius.circular(12)),
        child: Container(
          height: 48,
          width: 48,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(12)),
            color: Tm.color(Tc.priDefLight),
          ),
          child: SvgImage(
            Assets.icons.refresh,
            width: 22,
            height: 22,
            color:
                status == Status.loading ? Tm.color(Tc.priIconLight).withValues(alpha: 0.5) : Tm.color(Tc.priIconLight),
          ),
        ),
      ),
    );
  }
}
