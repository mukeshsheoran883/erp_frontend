import 'package:invently/assortment/extensions/context_extensions.dart';
import 'package:invently/utils/static_values.dart';
import 'package:invently/utils/theme/colors/colors.dart';
import 'package:invently/utils/theme/text_style/text_styles.dart';
import 'package:invently/widgets/alert_dialog/alert_bottom_buttons.dart';
import 'package:invently/widgets/alert_dialog/alert_title_bar.dart';
import 'package:invently/widgets/alert_dialog/show_dialog.dart';
import 'package:invently/widgets/date_time_picker/time_widget.dart';
import 'package:invently/widgets/tab_bar_title.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'date_picker_props.dart';
import 'date_widget.dart';

Future<DateTime?> showCustomDateTimePicker(DateTimePickerModel model) async {
  return await showPopup(canClose: true, child: _DatePicker(model: model));
}

class _DatePicker extends StatefulWidget {
  final DateTimePickerModel model;

  const _DatePicker({required this.model});

  @override
  State<_DatePicker> createState() => _DatePickerState();
}

class _DatePickerState extends State<_DatePicker> with SingleTickerProviderStateMixin {
  late DateTime selectedDateTime;
  late TabController _tabController;
  int index = 0;

  @override
  void initState() {
    _tabController = TabController(length: widget.model.mode == DatePickMode.dateAndTime ? 2 : 1, vsync: this);
    _tabController.addListener(_onTabChange);

    selectedDateTime = widget.model.selectedDate ?? DateTime.now();
    super.initState();
  }

  void _onTabChange() => setState(() {});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (a, b) => a ? null : _close(widget.model.selectedDate),
      child: Container(
        width: context.percentWidth * 35,
        decoration: BoxDecoration(color: Tm.color(Tc.comCardBg)),
        height: 600,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AlertDialogTitleBar(
              title:
                  'Select ${widget.model.mode == DatePickMode.dateAndTime ? 'Date & Time' : widget.model.mode == DatePickMode.dateOnly ? 'Date' : 'Time'}',
              onCloseTap: () => _close(widget.model.selectedDate),
            ),
            Flexible(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 24),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            if (widget.model.mode == DatePickMode.dateAndTime)
                              SizedBox(
                                width: 150,
                                height: 47,
                                child: CustomTabBarTitleRounded(
                                  titles: const ['Date', 'Time'],
                                  selectedIndex: _tabController.index,
                                  onTap: (a) => _tabController.animateTo(a),
                                ),
                              ),
                            Container(
                              decoration: BoxDecoration(
                                color: Tm.color(Tc.ipfDef),
                                borderRadius: const BorderRadius.all(Radius.circular(12)),
                              ),
                              padding: const EdgeInsets.all(12),
                              child: Text(
                                widget.model.mode == DatePickMode.dateOnly
                                    ? StaticValues.commonDateFormat.format(selectedDateTime)
                                    : widget.model.mode == DatePickMode.timeOnly
                                        ? StaticValues.commonTimeFullFormat.format(selectedDateTime)
                                        : StaticValues.commonDateTimeFullFormat.format(selectedDateTime),
                                style: TsDefined.ts16W600(
                                  color: Tm.color(Tc.tabDefTxt),
                                  fontFamily: FontFamily.roboto,
                                ).copyWith(wordSpacing: 8, letterSpacing: 1.5),
                              ),
                            ),
                            if (widget.model.mode == DatePickMode.dateAndTime) const SizedBox(width: 150),
                          ],
                        ),
                      ),
                    ),
                    Flexible(
                      child: TabBarView(
                        controller: _tabController,
                        children: [
                          if (widget.model.mode == DatePickMode.dateOnly ||
                              widget.model.mode == DatePickMode.dateAndTime)
                            CustomCalendarDatePicker(
                              initialDate: selectedDateTime,
                              firstDate: widget.model.minDate!,
                              lastDate: widget.model.maxDate!,
                              onDateChanged: (a) => setState(() => selectedDateTime = a),
                              props: DatePickerProps(),
                            ),
                          if (widget.model.mode == DatePickMode.timeOnly ||
                              widget.model.mode == DatePickMode.dateAndTime)
                            Center(
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 32),
                                child: CustomTimeWidget(
                                  initialTime: selectedDateTime,
                                  onTimeChange: (a) => setState(() => selectedDateTime = a),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            AlertBottomButton(
              leftText: 'Close',
              onLeftTap: () => _close(widget.model.selectedDate),
              onRightTap: () => _close(selectedDateTime),
              rightText: 'Select',
            ),
          ],
        ),
      ),
    );
  }

  void _close(DateTime? date) => mounted ? context.pop(date) : null;
}

class DateTimePickerModel {
  DateTime? selectedDate;
  DateTime? minDate;
  DateTime? maxDate;
  DateTime? todayDate;
  DatePickMode? mode;

  DateTimePickerModel({required this.selectedDate, this.maxDate, this.minDate, this.todayDate, this.mode}) {
    minDate ??= DateTime.now().subtract(const Duration(days: 365 * 100));
    maxDate ??= DateTime.now().add(const Duration(days: 365 * 100));
    mode ??= DatePickMode.dateAndTime;
  }
}

enum DatePickMode {
  dateOnly,
  timeOnly,
  dateAndTime;
}
