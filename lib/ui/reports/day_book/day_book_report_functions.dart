part of 'day_book_report_screen.dart';

Future<void> _onSubmitTap(_DayBookReportScreenState state, int page) async {
  if (!_validate(state)) return;
  state.reportsProvider.currentVariable().onSubmit?.call(page);
}

bool _validate(_DayBookReportScreenState state) {
  bool isValid = Validator.validate([
    CustomValidators.dateValidator(
      field: 'Start date',
      date: state.reportsProvider.startDate.dateTime,
      maxDate: state.reportsProvider.endDate.dateTime?.add(Duration(days: 1)),
      error: state.reportsProvider.startDate.error,
    ),
    CustomValidators.dateValidator(
      field: 'End date',
      date: state.reportsProvider.endDate.dateTime,
      maxDate: DateTime.now().add(Duration(days: 1)),
      error: state.reportsProvider.endDate.error,
    ),
  ]);
  state._refresh();
  return isValid;
}
