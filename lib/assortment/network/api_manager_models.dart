import 'package:invently/assortment/utils/file_utils.dart';
import 'package:invently/utils/static_values.dart';
import 'package:dio/dio.dart';

import 'api_helper.dart';

class ApiResponseModel<T> {
  List<String> errors;
  Response? rawResponse;
  ApiResponseType responseType;
  String? nextUrl;
  String searchText;
  int currentPage;
  int totalPage;
  int totalCount;
  int showingCount;
  bool needApproval;
  DioHelper request;
  String? fileName;
  T? data;
  FileSize? fileSize;

  ApiResponseModel({
    required this.errors,
    required this.responseType,
    required this.nextUrl,
    required this.request,
    required this.data,
    required this.searchText,
    this.needApproval = false,
    this.currentPage = 1,
    this.totalCount = 0,
    this.showingCount = 0,
    this.totalPage = 0,
    this.rawResponse,
    this.fileName,
    this.fileSize,
  });

  String firstError() => errors.isEmpty
      ? StaticValues.commonErrorMessage
      : errors.length == 1
          ? errors.first
          : _getErrorWithBullet(errors);

  String _getErrorWithBullet(List<String> errors) {
    String error = '';
    for (final i in errors) {
      final String e = i.trim();
      if (e.isNotEmpty) error = '$error\n•$e';
    }

    return error;
  }

  bool isSuccess({bool checkData = true}) {
    if (checkData) {
      return responseType.success && data != null;
    } else {
      return false;
    }
  }
}

class UrlQuery {
  String key;
  String? value;
  UrlQuery({required this.key, required this.value});

  static String getApiWithQueries({required String api, required List<UrlQuery> filters}) {
    filters = filters.where((e) => e.value != null && e.value!.trim().isNotEmpty).toList();

    final List<String> filterStringList = [];

    for (final filter in filters) {
      final String filterString = '${filter.key}=${filter.value}';
      if (api.contains(filterString)) continue;
      filterStringList.add(filterString);
    }

    for (final filter in filterStringList) {
      api = api.contains('?') ? '$api&$filter' : '$api?$filter';
    }

    return api;
  }
}

enum ApiResponseType {
  ok(success: true),
  internalServerError,
  dataTypeError,
  noInternet,
  timeOutError,
  inValidFormat,
  unAuthenticated,
  requestCancelled,
  noFileName,
  unknownError;

  final bool success;
  const ApiResponseType({this.success = false});
}

enum ApiMethods {
  get(value: 'GET', stringName: 'GET'),
  post(value: 'POST', stringName: 'POST'),
  put(value: 'PUT', stringName: 'PUT'),
  patch(value: 'PATCH', stringName: 'PATCH'),
  delete(value: 'DELETE', stringName: 'DELETE'),
  fileUpload(value: 'POST', stringName: 'File Upload'),
  fileDownload(value: 'GET', stringName: 'File Download'),
  ;

  final String value;
  final String stringName;

  const ApiMethods({required this.value, required this.stringName});
}

class ErrorMessages {
  final String formatErrorMsg;
  final String internalServerErrorMsg;
  final String routingMsg;
  final String socketErrorMsg;
  final String dataTypeErrorMsg;
  final String timeoutErrorMsg;
  final String commonErrorMsg;
  final String cancelErrorMsg;
  final String unAuthenticatedErrorMsg;

  const ErrorMessages({
    this.formatErrorMsg = 'Invalid format.',
    this.internalServerErrorMsg = 'Internal server error.',
    this.routingMsg = 'Please login to continue',
    this.socketErrorMsg = 'Failed to connect to internet. Please check your internet connection.',
    this.timeoutErrorMsg = 'Your connection has timeout. Please try again.',
    this.commonErrorMsg = 'Something went wrong',
    this.dataTypeErrorMsg = 'Data-type error',
    this.cancelErrorMsg = 'Request cancelled',
    this.unAuthenticatedErrorMsg = 'Unauthorized action',
  });
}
