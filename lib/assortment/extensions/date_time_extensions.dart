import 'package:invently/utils/globals.dart';
import 'package:intl/intl.dart';

class DateTimeUtils {
  static DateTime? getNullableDateTime(String? dateTime, {DateFormat? dateFormat}) {
    if (dateTime == null) return null;

    try {
      if (dateFormat != null) return dateFormat.parse(dateTime);

      return DateTime.parse(dateTime);
    } catch (e) {
      Globals.logger.log('dateTime to parse $dateTime. $e', logLocation: true);

      return null;
    }
  }
}

extension DateTimeExtensions on DateTime {
  DateTime convertToDateAlone() => DateTime(year, month, day);
}
