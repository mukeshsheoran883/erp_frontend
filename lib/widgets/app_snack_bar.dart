import 'package:invently/assortment/extensions/string_extensions.dart';
import 'package:invently/assortment/utils/message_time_calculator.dart';
import 'package:invently/assortment/widgets/button/hover_button_base.dart';
import 'package:invently/assortment/widgets/button/hover_gesture_detector.dart';
import 'package:invently/assortment/widgets/svg_image.dart';
import 'package:invently/gen/assets.gen.dart';
import 'package:invently/utils/globals.dart';
import 'package:invently/utils/theme/colors/colors.dart';
import 'package:invently/utils/theme/text_style/text_styles.dart';
import 'package:invently/widgets/alert_dialog/show_notification_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';

class AppSnackBar {
  static ToastFuture? _future;
  static Future<void> _onClose() async => _future?.dismiss(showAnim: true);
  static bool _popupShowing = false;

  static Future<void> showSnackBarWithText({
    String? text,
    String? title,
    Duration? duration,
    Color? backgroundColor,
    Color? borderColor,
    Color? textColor,
    bool clickToOpen = true,
  }) async {
    duration ??= text == null ? const Duration(seconds: 3) : calculateMessageDuration(text);
    backgroundColor ??= Tm.color(Tc.comCardBg);
    borderColor ??= Tm.color(Tc.grnIconLight);
    textColor ??= Tm.color(Tc.grnIconLight);
    if (text?.trim().isEmpty ?? true) clickToOpen = false;

    _future = showToastWidget(
      Padding(
        padding: const EdgeInsets.all(12),
        child: HoverGD(
          hoverColor: Colors.transparent,
          clickColor: Colors.transparent,
          onTap: clickToOpen
              ? () {
                  if (_popupShowing) return;
                  _popupShowing = true;
                  _onClose().then(
                    (value) => {showSingleButtonAlert(text: text, title: title), _popupShowing = false},
                  );
                }
              : null,
          child: Container(
            width: 400,
            decoration: ShapeDecoration(
              shape: RoundedRectangleBorder(
                borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                side: BorderSide(color: borderColor, width: 1),
              ),
              color: backgroundColor,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 18, top: 18, bottom: 8),
                        child: (title != null)
                            ? Text(
                                title.toFirstLetterUpperCase(),
                                style: TsDefined.ts16W500(color: Tm.color(Tc.txtH2)),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                              )
                            : const SizedBox(),
                      ),
                    ),
                    HoverGD(
                      onTap: _onClose,
                      builder: (context, state) {
                        return Container(
                          color: Colors.transparent,
                          alignment: Alignment.center,
                          width: 32,
                          height: 32,
                          child: SvgImage(
                            Assets.icons.closeCircle,
                            width: 24,
                            height: 24,
                            color: state.isHovering ? Tm.color(Tc.closeRed) : Tm.color(Tc.txtH4),
                          ),
                        );
                      },
                      child: Container(
                        color: Colors.transparent,
                        alignment: Alignment.center,
                        width: 32,
                        height: 32,
                        child: SvgImage(Assets.icons.closeCircle, width: 24, height: 24, color: Tm.color(Tc.redDef)),
                      ),
                    ),
                  ],
                ),
                if (text != null)
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 18, right: 18, bottom: 18),
                      child: Text(
                        text,
                        style: TsDefined.ts15W400(color: textColor),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 3,
                      ),
                    ),
                  )
                else
                  const SizedBox(height: 8),
              ],
            ),
          ),
        ),
      ),
      context: Globals.context(),
      isIgnoring: false,
      duration: duration,
      animation: StyledToastAnimation.slideFromLeftFade,
      reverseAnimation: StyledToastAnimation.slideToLeftFade,
      animDuration: const Duration(milliseconds: 250),
      position: StyledToastPosition.left,
      overlayPosition: const OverlayPosition(bottom: 12),
    );
  }
}
