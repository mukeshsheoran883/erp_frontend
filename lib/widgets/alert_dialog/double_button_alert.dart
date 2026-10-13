import 'package:invently/assortment/extensions/context_extensions.dart';
import 'package:invently/assortment/extensions/string_extensions.dart';
import 'package:invently/assortment/services/navigation_service/navigation_service.dart';
import 'package:invently/utils/theme/colors/colors.dart';
import 'package:invently/utils/theme/text_style/text_styles.dart';
import 'package:invently/widgets/alert_dialog/alert_bottom_buttons.dart';
import 'package:invently/widgets/alert_dialog/alert_title_bar.dart';
import 'package:invently/widgets/alert_dialog/show_dialog.dart';
import 'package:invently/widgets/page_widgets/custom_scroll_bar.dart';
import 'package:flutter/material.dart';

Future<void> showDoubleButtonAlert(
  DoubleButtonAlertModel model, {
  bool canClose = false,
  bool transparentBg = false,
}) async {
  await showPopup(child: _DoubleButtonAlert(model: model), canClose: canClose);
}

class _DoubleButtonAlert extends StatefulWidget {
  final DoubleButtonAlertModel model;
  const _DoubleButtonAlert({required this.model});

  @override
  State<_DoubleButtonAlert> createState() => _DoubleButtonAlertState();
}

class _DoubleButtonAlertState extends State<_DoubleButtonAlert> {
  late ScrollController controller;

  @override
  void initState() {
    controller = ScrollController();
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: context.percentWidth * 30,
      constraints: BoxConstraints(maxHeight: context.percentHeight * 70),
      color: Tm.color(Tc.comCardBg),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AlertDialogTitleBar(title: (widget.model.title ?? 'Alert').toPascalCase()),
          Flexible(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: (widget.model.multiListingWidget != null || widget.model.multiContent != null)
                    ? CrossAxisAlignment.start
                    : CrossAxisAlignment.center,
                children: [
                  if (widget.model.content != null)
                    Text(widget.model.content!, style: TsDefined.ts18W400(), textAlign: TextAlign.center),
                  if (widget.model.content != null) const SizedBox(height: 24),
                  if (widget.model.multiListingWidget != null) Flexible(child: widget.model.multiListingWidget!),
                  if (widget.model.multiContent != null)
                    Flexible(
                      child: CustomScrollBar(
                        controller: controller,
                        child: ListView(
                          controller: controller,
                          shrinkWrap: true,
                          children: [
                            for (final i in widget.model.multiContent!)
                              Text(
                                '• $i',
                                style: TsDefined.ts18W500(
                                  color: widget.model.multiContentColor ?? Tm.color(Tc.redIconLight),
                                ),
                                textAlign: TextAlign.start,
                              ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          AlertBottomButton(
            leftText: widget.model.leftText,
            rightText: widget.model.rightText,
            onLeftTap: widget.model.onLeftTap ?? AppNavigator.pop,
            onRightTap: widget.model.onRightTap,
            rightIcon: widget.model.rightIcon,
            rightBtnColor: widget.model.rightButtonBg,
          ),
        ],
      ),
    );
  }
}

class DoubleButtonAlertModel {
  String leftText;
  String rightText;
  String? content;
  String? title;
  Color? multiContentColor;
  List<String>? multiContent;
  Widget? multiListingWidget;
  IconData icon;
  Function()? onLeftTap;
  Function() onRightTap;
  Widget? rightIcon;
  Color? rightButtonBg;

  DoubleButtonAlertModel({
    this.leftText = 'No',
    this.onLeftTap,
    this.rightText = 'Yes',
    this.title,
    this.icon = Icons.info,
    this.multiContentColor,
    required this.onRightTap,
    required this.content,
    this.multiListingWidget,
    this.multiContent,
    this.rightIcon,
    this.rightButtonBg,
  });
}
