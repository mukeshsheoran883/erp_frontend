import 'package:invently/assortment/status.dart';
import 'package:invently/assortment/widgets/error_loading_and_empty_widgets/custom_progress_indicator.dart';
import 'package:invently/utils/globals.dart';
import 'package:invently/widgets/alert_dialog/show_notification_alert.dart';
import 'package:flutter/material.dart';

import 'full_screen_overlay.dart';

// ignore_for_file: long-parameter-list

///[handleFutureWithAlert] accepts a future and shows a loader as the future progress and if there was any
///error in completing the future then this function shows an alert with the error in it.
///All properties like [showProgressBar], [showAlert]  can be customised.

Future<Status> handleFutureWithAlert({
  required String Function() errorMessage,
  required Future<Status> Function() function,
  Function()? onSuccess,
  Function()? onError,
  Function()? onComplete,
  Function()? onAlertDismiss,
  bool showProgressBar = true,
  bool showAlert = true,
  bool transparentLoaderBg = true,
  TextAlign textAlign = TextAlign.center,
  Duration progressbarWaitDuration = const Duration(milliseconds: 700),
}) async {
  final FullScreenBanner banner = FullScreenBanner();

  Status apiStatus = Status.loading;

  Future.delayed(progressbarWaitDuration, () {
    if (showProgressBar && apiStatus == Status.loading) {
      banner.show(widget: CustomProgressIndicator(transparentBg: transparentLoaderBg));
    }
  });

  bool isErrorFromTryCatch = false;
  try {
    apiStatus = await function();
  } catch (e, s) {
    apiStatus = Status.error;
    isErrorFromTryCatch = true;
    Globals.logger.log(e.toString());
    Globals.logger.log(s.toString());
  }

  if (showProgressBar) {
    banner.hide();
  }
  if (onComplete != null) {
    onComplete();
  }

  if (apiStatus == Status.success) {
    if (onSuccess != null) {
      onSuccess();
    }
  } else if (apiStatus == Status.error) {
    if (onError != null) {
      onError();
    }
    if (showAlert) {
      showSingleButtonAlert(
        title: 'Error',
        text: (isErrorFromTryCatch || errorMessage().trim().isEmpty) ? 'Something went wrong.' : errorMessage(),
        onDismiss: onAlertDismiss,
      );
    }
  }

  return apiStatus;
}
