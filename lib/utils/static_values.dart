
import 'package:invently/assortment/extensions/context_extensions.dart';
import 'package:invently/assortment/network/api_manager_models.dart';
import 'package:invently/gen/env.dart';
import 'package:invently/provider/authentication_provider.dart';
import 'package:invently/utils/globals.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

class StaticValues {
  static bool isProduction = kDebugMode ? false : Env.isRelease;
  static bool? needApproval = isProduction ? null : false;
  static bool saveApiRequest = Env.logRequest;
  static const String companyName = 'GEM';
  static const String appName = 'Biller';
  static const String commonErrorMessage = 'Something went wrong';
  static const String sampleImage = 'https://images.inc.com/uploaded_files/image/1920x1080/getty_481292845_77896.jpg';
  static String longString = isProduction
      ? ''
      : 'Software fuels our digital world, weaving code into seamless solutions from robust applications to intricate algorithms, it shapes our tech-driven future.';
  static String veryLongString = isProduction
      ? ''
      : 'Software, the intangible engine propelling our digital age, encompasses a vast realm of programs and applications that breathe life into our devices. From operating systems orchestrating hardware interactions to intricate applications streamlining daily tasks, software is the silent architect of our technological ecosystem.In the realm of business, enterprise software manages operations, enhances productivity, and facilitates communication. Customer relationship management (CRM) software builds bridges between companies and clients, fostering lasting connections. Enterprise resource planning (ERP) software integrates various business processes, offering a holistic view for efficient decision-making.The world of creativity is fueled by graphic design software, 3D modeling tools, and video editing suites, empowering artists and creators to manifest their visions. Meanwhile, gaming software transforms pixels into immersive virtual worlds, captivating audiences and pushing the boundaries of entertainment.In the cybersecurity domain, antivirus software, firewalls, and encryption tools stand as digital guardians, shielding systems from malicious threats. As data proliferates, database management systems organize and retrieve information, forming the backbone of data-driven applications.The open-source movement exemplifies collaborative software development, where communities converge to create, refine, and share code freely. Operating systems like Linux thrive on this ethos, underpinning servers, embedded systems, and even mobile devices.';
  static String approvalString(String text) => 'Your request to $text has sent for approval.';

  static Map<String, String> defaultHeaders({bool isRefreshToken = false, String? token, bool sendToken = true}) => {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        if ((AuthenticationProvider.isLoggedIn || token != null) && sendToken)
          'Authorization':
              'Bearer ${token ?? (isRefreshToken ? AuthenticationProvider.getRefreshToken() : AuthenticationProvider.getAccessToken())}',
      };

  static final commonDateFormat = DateFormat('dd-MM-yyyy');
  static final commonDateFormatSlash = DateFormat('dd/MM/yyyy');
  static final commonDateMonthFormat = DateFormat('dd MMM, yyyy');
  static final commonDateTimeFormat = DateFormat('dd-MM-yyyy, hh:mm a');
  static final commonDateTimeFullFormat = DateFormat('dd-MM-yyyy, hh:mm:ss a');
  static final commonTimeFullFormat = DateFormat('hh:mm:ss a');
  static final commonTimeFormat = DateFormat('hh:mm a');
  static const autoLogOutDuration = Duration(minutes: 30);

  static String getStatusText(bool a) => a ? 'Active' : 'Inactive';

  static String mobileFormatter({required String code, required String number}) {
    if (code.trim().isEmpty) return number;

    return '(+${code.trim()}) $number';
  }

  static double formWidth() => 900;

  static String currencySymbol(String amount) => '₹ $amount';
}

class Query {
  static UrlQuery employeeCode() =>
      UrlQuery(key: 'employee_code', value: AuthenticationProvider.getUserDetailsStatic().employeeCode.trim());

  static UrlQuery countLimit({int? count, bool? pagination}) =>
      UrlQuery(key: 'limit', value: (pagination ?? true) ? (count ?? defaultCount()).toString() : '10000000');
  static UrlQuery pageNumber(int count) => UrlQuery(key: 'page_num', value: count.toString());
  static UrlQuery search(String key) => UrlQuery(key: 'key', value: key);

  static UrlQuery startDate(DateTime date) =>
      UrlQuery(key: 'start_date', value: StaticValues.commonDateFormat.format(date));

  static UrlQuery endDate(DateTime date) =>
      UrlQuery(key: 'end_date', value: StaticValues.commonDateFormat.format(date));

  static int defaultCount() {
    try {
      if (Globals.context().screenHeight < 1050) return 10;
    } catch (_) {}

    return 11;
  }
}
