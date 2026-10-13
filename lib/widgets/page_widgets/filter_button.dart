
import 'package:invently/assortment/status.dart';
import 'package:invently/assortment/widgets/button/hover_gesture_detector.dart';
import 'package:invently/assortment/widgets/svg_image.dart';
import 'package:invently/gen/assets.gen.dart';
import 'package:invently/models/common/filter_model.dart';
import 'package:invently/utils/theme/colors/colors.dart';
import 'package:flutter/material.dart';

class FilterButton extends StatelessWidget {
  final Function()? onFilterTap;
  final FilterModel? filter;
  final Status status;
  final EdgeInsets padding;

  const FilterButton({
    super.key,
    required this.onFilterTap,
    this.padding = const EdgeInsets.only(right: 16),
    required this.status,
    required this.filter,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: HoverGD(
        onTap: status == Status.loading ? null : onFilterTap,
        tooltip: (filter?.isAnyFilterApplied() ?? false) ? 'Filter applied' : 'Filter',
        borderRadius: const BorderRadius.all(Radius.circular(12)),
        child: Container(
          height: 48,
          width: 48,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(12)),
            color: status == Status.loading
                ? Tm.color(Tc.priDefLight)
                : (filter?.isAnyFilterApplied() ?? false)
                    ? Tm.color(Tc.priDef)
                    : Tm.color(Tc.priDefLight),
          ),
          child: SvgImage(
            Assets.icons.filter,
            width: 22,
            height: 22,
            color: status == Status.loading
                ? Tm.color(Tc.priIconLight).withValues(alpha: 0.5)
                : (filter?.isAnyFilterApplied() ?? false)
                    ? Tm.color(Tc.comBtnTxt)
                    : Tm.color(Tc.priIconLight),
          ),
        ),
      ),
    );
  }
}
