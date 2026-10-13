import 'package:invently/assortment/widgets/button/hover_gesture_detector.dart';
import 'package:invently/utils/theme/colors/colors.dart';
import 'package:invently/utils/theme/text_style/text_styles.dart';
import 'package:flutter/material.dart';

class ErrorRetryButtonSmall extends StatelessWidget {
  final String? error;
  final Function() onRetry;
  final bool useWrap;
  const ErrorRetryButtonSmall({super.key, this.error, required this.onRetry, this.useWrap = false});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onRetry,
      child: useWrap
          ? Wrap(
              children: [
                Icon(Icons.refresh, color: Tm.color(Tc.redDef), size: 18),
                const SizedBox(width: 5, height: 5),
                Text(
                  error ?? 'Refresh',
                  textAlign: TextAlign.center,
                  style: TsDefined.ts14W400(
                    color: Tm.color(Tc.txtSection),
                  ),
                ),
              ],
            )
          : Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                HoverGD(
                  onTap: onRetry,
                  child: ColoredBox(
                    color: Colors.transparent,
                    child: Icon(Icons.refresh, color: Tm.color(Tc.redDef), size: 18),
                  ),
                ),
                Flexible(
                  child: Text(
                    error ?? 'Refresh',
                    textAlign: TextAlign.center,
                    style: TsDefined.ts14W400(color: Tm.color(Tc.txtSection)),
                  ),
                ),
              ],
            ),
    );
  }
}
