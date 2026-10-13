
import 'dart:convert';
import 'dart:io';

import 'package:invently/assortment/helpers/db.dart';
import 'package:invently/provider/authentication_provider.dart';
import 'package:invently/utils/static_values.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:universal_html/html.dart' as html;

import 'api_helper.dart';
import 'api_manager_models.dart';
import 'endpoints.dart';

class SaveNetworkLog {
  static final List<Endpoint> _excluded = [Endpoint.login(), Endpoint.getNewToken()];
  static const String _pattern = '―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――';
  static const String _openPattern = '⬐$_pattern⬎\r\n';
  static const String _closePattern = '\r\n⬑$_pattern⬏';

  static Future<void> addLog(ApiResponseModel response) async {
    int length = await clearDb();

    DioHelper request = response.request;
    final Duration time = request.endTime.difference(request.startTime);

    String endpoint = request.endpoint.replaceFirst(request.url.baseUrl, '{{baseUrl}}/');

    final urlLog = 'URL: ${request.method.value} $endpoint (${time.inMilliseconds} ms)';

    Map<String, dynamic> headers = request.dio.options.headers;

    String auth = headers[request.authorizationKey] ?? '';

    if (auth.contains(AuthenticationProvider.getAccessToken())) {
      headers[request.authorizationKey] = 'ACCESS TOKEN';
    } else if (auth.contains(AuthenticationProvider.getRefreshToken())) {
      headers[request.authorizationKey] = 'REFRESH TOKEN';
    }

    final stringHeaders = '\nHEADERS: ${jsonEncode(headers)}';

    String? responseBody;
    try {
      responseBody = jsonEncode(response.rawResponse?.data);
    } catch (_) {}

    bool hideResponse = false;
    for (final i in _excluded) {
      if (request.url.privateUrl == i.privateUrl) hideResponse = true;
    }

    final String sentData =
        '\nSENT DATA: ${request.body == null ? null : hideResponse ? 'SENT DATA HIDDEN' : jsonEncode(request.getUpdatedBody(request.body!, request.method))}';
    final responseData = '\nRESPONSE DATA: ${hideResponse ? 'RESPONSE HIDDEN' : responseBody ?? 'NULL'}';
    final String? responseError = response.responseType.success ? null : '\nERROR: ${response.errors.firstOrNull}';
    final responseStatusCode = '\nSTATUS CODE: ${response.rawResponse?.statusCode ?? ''}';
    final String logData =
        '\r\nREQUEST NO:${length + 1}\r\n$_openPattern$urlLog$stringHeaders$sentData$responseStatusCode${responseError ?? ''}$responseData$_closePattern\r\n\r\n';

    await LogDB().addValue(value: logData);
  }

  static Future<bool> saveToFileAndDownload({required String content, required String fileName}) async {
    if (kIsWeb) {
      final blob = html.Blob([content]);
      final url = html.Url.createObjectUrlFromBlob(blob);
      html.AnchorElement(href: url)
        ..setAttribute('download', fileName)
        ..click();

      html.Url.revokeObjectUrl(url);
      return true;
    } else {
      final Directory? downloadsDir = await getDownloadsDirectory();
      if (downloadsDir == null) return false;

      final file = File('${downloadsDir.path}\\$fileName');
      if (file.existsSync()) file.deleteSync(recursive: true);
      file.createSync(recursive: true);
      file.writeAsStringSync(content);

      return true;
    }
  }

  static Future<String> saveLog() async {
    List logs = await LogDB().getAllValue();
    String logText = '';
    if (logs.isEmpty) return 'No logs to save';

    for (final i in logs) {
      logText = logText + i;
    }

    String date = StaticValues.commonDateTimeFullFormat
        .format(DateTime.now())
        .replaceAll(' ', '-')
        .replaceAll(',', '-')
        .replaceAll(':', '-');
    bool success = await SaveNetworkLog.saveToFileAndDownload(content: logText, fileName: 'logs($date).txt');
    if (success) return 'Log saved to downloads';
    return 'Failed to save log';
  }

  static Future<int> clearDb() async {
    final length = (await LogDB().getAllValue()).length;
    if (length > 100) await LogDB().deleteFromDisk();

    return length;
  }
}
