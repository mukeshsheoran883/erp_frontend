
import 'package:invently/assortment/services/navigation_service/navigation_service.dart';
import 'package:invently/assortment/status.dart';
import 'package:invently/assortment/widgets/button/hover_button_base.dart';
import 'package:invently/assortment/widgets/button/hover_gesture_detector.dart';
import 'package:invently/assortment/widgets/svg_image.dart';
import 'package:invently/gen/assets.gen.dart';
import 'package:invently/utils/theme/colors/colors.dart';
import 'package:invently/utils/theme/text_style/text_styles.dart';
import 'package:invently/widgets/alert_dialog/alert_bottom_buttons.dart';
import 'package:invently/widgets/page_widgets/view_details_side_menu/view_details_skeleton.dart';
import 'package:flutter/material.dart';

class FilterSection extends StatelessWidget {
  final Widget child;
  final Function()? onApply;
  final Function()? onClear;

  const FilterSection({super.key, required this.child, this.onApply, this.onClear});

  @override
  Widget build(BuildContext context) {
    return ViewDetailsSkeleton(
      title: 'Filter',
      middleWidget: _ClearButton(onTap: () => {AppNavigator.pop(), onClear?.call()}),
      bottomButtons: null,
      bottomWidget: _BottomWidget(onClose: AppNavigator.pop, onApply: () => {AppNavigator.pop(), onApply?.call()}),
      error: '',
      onRetry: null,
      status: Status.success,
      builder: (context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
        child: child,
      ),
    );
  }
}

class _ClearButton extends StatelessWidget {
  final Function()? onTap;

  const _ClearButton({this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 24),
      child: HoverGD(
        onTap: onTap,
        builder: (context, bState) {
          return Text(
            'Clear All',
            style: Ts.rgRegular(
              color: Tm.color(
                onTap == null
                    ? Tc.secAct
                    : bState.isPressing
                        ? Tc.secAct
                        : bState.isHovering
                            ? Tc.secHov
                            : Tc.secDef,
              ),
            ),
          );
        },
      ),
    );
  }
}

class _BottomWidget extends StatelessWidget {
  final Function()? onApply;
  final Function() onClose;

  const _BottomWidget({required this.onApply, required this.onClose});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: Tm.color(Tc.comCardBg),
        border: Border(top: BorderSide(color: Tm.color(Tc.tableDivider), width: 1)),
      ),
      alignment: Alignment.centerRight,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          AlertButton(
            onTap: onClose,
            text: 'Close',
            iconPadding: const EdgeInsets.only(right: 4),
            buttonColor: Tm.color(Tc.neuDef),
            color: Tm.color(Tc.neuNeuBtnTxt),
            icon: SvgImage(Assets.icons.closeSquare, height: 22, width: 22, color: Tm.color(Tc.neuNeuBtnTxt)),
          ),
          const SizedBox(width: 20),
          AlertButton(
            onTap: onApply,
            text: 'Apply',
            color: Tm.color(Tc.comBtnTxt),
            iconPadding: const EdgeInsets.only(right: 4),
            icon: SvgImage(
              Assets.icons.checkSquare,
              height: 22,
              width: 22,
              color: Tm.color(Tc.comBtnTxt),
            ),
          ),
          const SizedBox(width: 20),
        ],
      ),
    );
  }
}
