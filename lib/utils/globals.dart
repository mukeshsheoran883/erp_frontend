import 'package:invently/assortment/logger.dart';
import 'package:invently/utils/static_values.dart';
import 'package:flutter/cupertino.dart';

class Globals {
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  static const String dummyProfileImage =
      'https://thumbs.dreamstime.com/b/happy-person-portrait-smiling-woman-tanned-skin-curly-hair-happy-person-portrait-smiling-young-friendly-woman-197501184.jpg';

  static BuildContext context() => navigatorKey.currentState!.context;

  //ignore:avoid_redundant_argument_values
  static Logger logger = Logger(enable: !StaticValues.isProduction);
}
