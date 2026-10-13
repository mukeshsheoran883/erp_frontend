
import 'package:invently/assortment/status.dart';
import 'package:invently/assortment/widgets/error_loading_and_empty_widgets/custom_progress_indicator.dart';
import 'package:invently/assortment/widgets/error_loading_and_empty_widgets/error_retry_button.dart';
import 'package:invently/utils/static_values.dart';
import 'package:flutter/material.dart';

class PageWidget extends StatelessWidget {
  final Widget child;
  final String errorMessage;
  final Status status;
  final Function() onRetry;

  const PageWidget({
    super.key,
    required this.child,
    required this.errorMessage,
    required this.status,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    switch (status) {
      case Status.success:
        return child;
      case Status.loading:
        return const Center(child: CustomProgressIndicator());
      default:
        return ErrorWidgetWithButton(
          error: errorMessage.isEmpty ? StaticValues.commonErrorMessage : errorMessage,
          onPressed: onRetry,
        );
    }
  }
}
