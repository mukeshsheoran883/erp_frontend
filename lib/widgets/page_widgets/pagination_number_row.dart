
import 'package:invently/assortment/extensions/text_formatters.dart';
import 'package:invently/assortment/widgets/button/hover_gesture_detector.dart';
import 'package:invently/assortment/widgets/svg_image.dart';
import 'package:invently/gen/assets.gen.dart';
import 'package:invently/utils/common_functions.dart';
import 'package:invently/utils/static_values.dart';
import 'package:invently/utils/theme/colors/colors.dart';
import 'package:invently/utils/theme/text_style/text_styles.dart';
import 'package:invently/widgets/alert_dialog/show_notification_alert.dart';
import 'package:flutter/material.dart';

class PaginationNumberRow extends StatelessWidget {
  final int selectedPage;
  final int totalPage;
  final int showingCount;
  final int totalCount;
  final Function(int) onPageTap;
  final int selectedCount;

  const PaginationNumberRow({
    super.key,
    required this.selectedPage,
    required this.totalPage,
    required this.showingCount,
    required this.totalCount,
    required this.onPageTap,
    required this.selectedCount,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 6),
      child: SizedBox(
        height: 44,
        child: totalCount < 1
            ? null
            : Row(
                children: [
                  if (showingCount != 0)
                    Text(
                      'Showing ${_rangeCount()} of $totalCount results${selectedCount > 0 ? ' (Selected $selectedCount)' : ''}',
                      style: Ts.mdRegular(color: Tm.color(Tc.ipfTxt)),
                    ),
                  const Spacer(),
                  Container(
                    decoration: BoxDecoration(
                      color: Tm.color(Tc.comCardBg),
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                    ),
                    padding: const EdgeInsets.all(2),
                    child: Row(
                      children: [
                        _ArrowWidget(
                          icon: Assets.icons.arrowLeftLong,
                          onTap: selectedPage <= 1 ? null : () => onPageTap(selectedPage - 1),
                        ),
                        const SizedBox(width: 14),
                        _ArrowWidget(
                          icon: Assets.icons.arrowRightLong,
                          onTap: selectedPage >= totalPage ? null : () => onPageTap(selectedPage + 1),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 24),
                  _PageNumberWidget(selectedPage: selectedPage, totalPage: totalPage, onPageChanged: onPageTap),
                  const SizedBox(width: 12),
                ],
              ),
      ),
    );
  }

  String _rangeCount() {
    int itemsPerPage = Query.defaultCount();
    int itemsTillPreviousPage = (selectedPage - 1) * itemsPerPage;
    int itemsShowingTillNow = itemsTillPreviousPage + showingCount;

    return '${itemsTillPreviousPage + 1}-$itemsShowingTillNow';
  }
}

class _DecorationContainer extends StatelessWidget {
  final Widget child;
  final double? width;

  const _DecorationContainer({required this.child, this.width});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 32,
      width: width ?? 32,
      decoration: BoxDecoration(
        color: Tm.color(Tc.comCardBg),
        borderRadius: const BorderRadius.all(Radius.circular(8)),
        border: Border.all(color: Tm.color(Tc.neuDef), width: 2),
      ),
      child: child,
    );
  }
}

class _ArrowWidget extends StatelessWidget {
  final String icon;
  final Function()? onTap;

  const _ArrowWidget({required this.icon, this.onTap});

  @override
  Widget build(BuildContext context) {
    return HoverGD(
      onTap: onTap,
      borderRadius: const BorderRadius.all(Radius.circular(8)),
      child: _DecorationContainer(
        child: SizedBox(
          width: 32,
          height: 32,
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: SvgImage(icon, width: 16, height: 16, color: Tm.color(onTap == null ? Tc.neuHov : Tc.neuNeuBtnTxt)),
          ),
        ),
      ),
    );
  }
}

class _PageNumberWidget extends StatefulWidget {
  final int selectedPage;
  final int totalPage;
  final Function(int) onPageChanged;

  const _PageNumberWidget({
    required this.selectedPage,
    required this.totalPage,
    required this.onPageChanged,
  });

  @override
  State<_PageNumberWidget> createState() => _PageNumberWidgetState();
}

class _PageNumberWidgetState extends State<_PageNumberWidget> {
  late TextEditingController controller;

  double _containerWidth = 28;
  double defaultWidth = 28;
  double calculatedWidth = 28;
  late FocusNode node;

  void _updateWidth() {
    final TextPainter textPainter = TextPainter(
      text: TextSpan(text: controller.text, style: Ts.rgRegular(color: Tm.color(Tc.ipfTxt))),
      maxLines: 1,
      textDirection: TextDirection.ltr,
    )..layout();

    if (textPainter.size.width > defaultWidth) {
      calculatedWidth = textPainter.size.width;
    } else {
      calculatedWidth = defaultWidth;
    }

    setState(() => _containerWidth = calculatedWidth + 30);
  }

  @override
  void initState() {
    super.initState();
    controller = TextEditingController(text: widget.selectedPage.toString());
    node = FocusNode();
    node.addListener(_focusListener);
    _updateWidth();
    controller.addListener(_updateWidth);
  }

  @override
  void dispose() {
    controller.removeListener(_updateWidth);
    controller.dispose();
    node.removeListener(_focusListener);
    node.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant _PageNumberWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    controller.text = widget.selectedPage.toString();
  }

  void _focusListener() {
    int? typedPage;
    CommonFunctions.removeTextSelection(controller);
    try {
      typedPage = int.parse(controller.text.trim());
    } catch (_) {}

    if (!node.hasFocus) {
      if (typedPage == null) {
        controller.text = widget.selectedPage.toString();
        return;
      }

      String? text;

      if (typedPage > widget.totalPage) text = 'Entered page number exceeds the total pages';
      if (typedPage < 1) text = 'Page number cannot be less than 1';

      if (text != null) {
        showSingleButtonAlert(text: text);
        controller.text = widget.selectedPage.toString();
        return;
      }

      widget.onPageChanged(typedPage);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('Page', style: Ts.rgRegular(color: Tm.color(Tc.ipfTxt))),
        const SizedBox(width: 12),
        Flexible(
          child: _DecorationContainer(
            width: _containerWidth,
            child: Focus(
              focusNode: node,
              child: TextField(
                controller: controller,
                maxLines: 1,
                maxLength: 10,
                inputFormatters: [NumbersOnlyFormatter()],
                decoration: const InputDecoration(
                  counterText: '',
                  isDense: true,
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 8),
                ),
                cursorHeight: 18,
                textAlignVertical: TextAlignVertical.center,
                textAlign: TextAlign.center,
                style: Ts.rgRegular(color: Tm.color(Tc.ipfTxt)),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Text('of ${widget.totalPage}', style: Ts.rgRegular(color: Tm.color(Tc.ipfTxt))),
      ],
    );
  }
}

class PaginationDetailsModel {
  final int selectedPage;
  final int totalPage;
  final int showingCount;
  final int totalCount;
  final Function(int) onPageTap;
  final int selectedCount;

  PaginationDetailsModel({
    required this.totalPage,
    required this.showingCount,
    required this.totalCount,
    required this.onPageTap,
    required this.selectedCount,
    required this.selectedPage,
  });
}
