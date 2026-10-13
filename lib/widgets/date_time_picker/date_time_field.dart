
import 'package:invently/assortment/widgets/button/hover_button_base.dart';
import 'package:invently/assortment/widgets/button/hover_gesture_detector.dart';
import 'package:invently/assortment/widgets/svg_image.dart';
import 'package:invently/gen/assets.gen.dart';
import 'package:invently/utils/static_values.dart';
import 'package:invently/utils/theme/colors/colors.dart';
import 'package:invently/widgets/date_time_picker/date_time_picker.dart';
import 'package:invently/widgets/text_widget/text_field.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CustomDateTimeField extends StatefulWidget {
  final DateTime? initialDateTime;
  final DateTime? maxDateTime;
  final DateTime? minDateTime;
  final Function(DateTime?)? onDateSelected;
  final DatePickMode pickMode;
  final DateFormat? format;
  final String? title;
  final String? error;
  final bool required;
  final String? hint;
  final Color? borderColor;
  final Color? fillColor;
  final double borderRadius;
  final bool autoFocus;
  final bool removeAllProps;
  final EdgeInsets errorPadding;
  final bool readOnly;
  final bool? showError;

  const CustomDateTimeField({
    super.key,
    required this.title,
    this.required = false,
    this.error,
    this.hint,
    this.readOnly = false,
    this.autoFocus = false,
    this.removeAllProps = false,
    this.borderColor,
    this.borderRadius = 12,
    this.fillColor,
    this.errorPadding = const EdgeInsets.only(bottom: 8),
    this.initialDateTime,
    this.maxDateTime,
    this.minDateTime,
    this.onDateSelected,
    this.pickMode = DatePickMode.dateOnly,
    this.format,
    this.showError,
  });

  @override
  State<CustomDateTimeField> createState() => _CustomDateTimeFieldState();
}

class _CustomDateTimeFieldState extends State<CustomDateTimeField> {
  late TextEditingController controller;

  @override
  void initState() {
    controller = TextEditingController(text: _getText());
    super.initState();
  }

  @override
  void didUpdateWidget(covariant CustomDateTimeField oldWidget) {
    controller.text = _getText();
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextFieldWithTitle(
      removeAllProps: widget.removeAllProps,
      title: widget.title,
      onTap: _showDateTimePicker,
      error: widget.error,
      required: widget.required,
      hint: widget.hint,
      enableSelection: false,
      showError: widget.showError,
      readOnly: widget.readOnly,
      borderColor: widget.borderColor,
      fillColor: widget.fillColor,
      borderRadius: widget.borderRadius,
      autoFocus: widget.autoFocus,
      errorPadding: widget.errorPadding,
      controller: controller,
      suffixIcon: _getIcon(),
    );
  }

  String _getText() {
    if (widget.initialDateTime == null) return '';

    try {
      if (widget.pickMode == DatePickMode.dateAndTime) {
        return (widget.format ?? StaticValues.commonDateTimeFullFormat).format(widget.initialDateTime!);
      }
      if (widget.pickMode == DatePickMode.dateOnly) {
        return (widget.format ?? StaticValues.commonDateFormat).format(widget.initialDateTime!);
      }
      return (widget.format ?? StaticValues.commonTimeFormat).format(widget.initialDateTime!);
    } catch (_) {
      return '';
    }
  }

  Future<void> _showDateTimePicker() async {
    DateTime? initialDateTime = widget.initialDateTime;
    if (widget.maxDateTime != null && widget.initialDateTime != null && initialDateTime!.isAfter(widget.maxDateTime!)) {
      initialDateTime = widget.maxDateTime!;
    }
    if (widget.minDateTime != null &&
        widget.initialDateTime != null &&
        initialDateTime!.isBefore(widget.minDateTime!)) {
      initialDateTime = widget.minDateTime!;
    }

    DateTime? newDateTime = await showCustomDateTimePicker(
      DateTimePickerModel(
        selectedDate: initialDateTime,
        mode: widget.pickMode,
        maxDate: widget.maxDateTime,
        minDate: widget.minDateTime,
      ),
    );

    widget.onDateSelected?.call(newDateTime);
  }

  Widget _getIcon() {
    String iconPath = Assets.icons.calendar;
    switch (widget.pickMode) {
      case DatePickMode.dateOnly:
        iconPath = Assets.icons.calendar;
      case DatePickMode.timeOnly:
        iconPath = Assets.icons.clock;
      case DatePickMode.dateAndTime:
        iconPath = Assets.icons.calendarClock;
    }

    return HoverGD(
      onTap: widget.initialDateTime == null
          ? null
          : widget.onDateSelected == null
              ? null
              : () => widget.onDateSelected!(null),
      builder: (context, bState) {
        return Container(
          width: 12,
          height: 12,
          alignment: Alignment.center,
          child: SvgImage(
            height: widget.initialDateTime == null ? 21 : null,
            widget.initialDateTime == null ? iconPath : Assets.icons.close,
            color: widget.initialDateTime == null
                ? Tm.color(Tc.tabDefTxt)
                : Tm.color(bState.isHovering ? Tc.closeRed : Tc.tabDefTxt),
          ),
        );
      },
    );
  }
}
