
import 'package:invently/assortment/extensions/context_extensions.dart';
import 'package:invently/assortment/status.dart';
import 'package:invently/assortment/widgets/error_loading_and_empty_widgets/custom_progress_indicator.dart';
import 'package:invently/assortment/widgets/error_loading_and_empty_widgets/error_retry_button.dart';
import 'package:invently/utils/theme/colors/colors.dart';
import 'package:invently/widgets/page_widgets/view_details_side_menu/view_details_bottom_buttons.dart';
import 'package:invently/widgets/page_widgets/view_details_side_menu/view_details_title.dart';
import 'package:flutter/material.dart';

class ViewDetailsSkeleton extends StatelessWidget {
  final String title;
  final Widget Function(BuildContext) builder;
  final Widget? middleWidget;
  final Status status;
  final String? error;
  final Function()? onRetry;
  final List<ViewDetailsButtonModel>? bottomButtons;
  final Widget? bottomWidget;

  const ViewDetailsSkeleton({
    super.key,
    required this.title,
    required this.builder,
    required this.status,
    required this.error,
    required this.onRetry,
    required this.bottomButtons,
    this.middleWidget,
    this.bottomWidget,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: context.percentWidth * 22,
      decoration: Tm.isDarkTheme.value
          ? BoxDecoration(border: Border(left: BorderSide(color: Tm.color(Tc.tableDivider), width: 1)))
          : null,
      child: Column(
        children: [
          ViewDetailsTitle(title: title, middleWidget: middleWidget),
          Expanded(
            child: status == Status.loading
                ? const CustomProgressIndicator()
                : status == Status.success
                    ? builder(context)
                    : ErrorWidgetWithButton(onPressed: onRetry, error: error),
          ),
          if (bottomWidget != null) bottomWidget!,
          if (bottomButtons != null && bottomButtons!.isNotEmpty) ViewDetailsBottomButtons(buttons: bottomButtons!),
        ],
      ),
    );
  }
}
