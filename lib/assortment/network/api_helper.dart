import 'dart:convert';

import 'package:invently/assortment/logger.dart';
import 'package:invently/assortment/network/api_manager_models.dart';
import 'package:invently/assortment/network/endpoints.dart';
import 'package:invently/assortment/network/save_network_request.dart';
import 'package:invently/assortment/services/navigation_service/navigation_service.dart';
import 'package:invently/assortment/utils/file_utils.dart';
import 'package:invently/assortment/utils/json_utils.dart';
import 'package:invently/models/user/login_model.dart';
import 'package:invently/network/common_api_services.dart';
import 'package:invently/provider/authentication_provider.dart';
import 'package:invently/utils/globals.dart';
import 'package:invently/utils/static_values.dart';
import 'package:invently/widgets/app_snack_bar.dart';
import 'package:collection/collection.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'jwt_decoder.dart';

class DioHelper<T> {
  Endpoint url;
  ApiMethods method;
  Duration timeout;
  CancelToken? cancelToken;
  T? Function(Map<String, dynamic>)? fromJson;
  Map<String, dynamic>? headers;
  List<UrlQuery> queries;
  ErrorMessages errorMessages;
  Map<String, dynamic>? body;
  Function(int, int)? onSendProgress;
  Function(int, int)? onReceiveProgress;
  ValueNotifier<double>? sendProgress;
  ValueNotifier<double>? receiveProgress;
  bool validateToken;
  bool logRequest;
  bool logHeader;
  bool isDummy;
  String? customFileName;

  DioHelper({
    required this.url,
    required this.method,
    this.fromJson,
    this.body,
    this.logRequest = true,
    this.logHeader = false,
    this.cancelToken,
    this.onReceiveProgress,
    this.onSendProgress,
    this.sendProgress,
    this.receiveProgress,
    this.errorMessages = defaultMessages,
    this.timeout = const Duration(seconds: 30),
    this.headers,
    this.validateToken = true,
    this.isDummy = false,
    this.customFileName,
    this.queries = const [],
  });

  late Dio dio;
  late String endpoint;
  final String authorizationKey = 'Authorization';
  DateTime startTime = DateTime.now();
  DateTime endTime = DateTime.now();

  String searchKey = '';

  String actualAPI = '';

  /// --------------------------------------------- INIT REQUEST ------------------------------------------------------
  void _initDio() {
    /// --------------------------------------------- SETUP DUMMY REQUEST------------------------------------------
    _setupDummyRequest();

    /// --------------------------------------------- DUMMY REQUEST END------------------------------------------

    /// --------------------------------------------- ADD COMMON QUERIES (applies to ALL API calls) -----------------
    final String shopCode =
        AuthenticationProvider.getUserDetailsStatic().defaultShop.id;
    if(shopCode != '') {
      queries = queries
          .where((q) => q.key != 'filter_key' && q.key != 'filter_value')
          .toList();
      queries.addAll([
        UrlQuery(key: 'filter_key', value: 'shop_code'),
        UrlQuery(key: 'filter_value', value: shopCode),
      ]);
    }

    /// ---------------------------------------------------------------------------------------------------------

    searchKey =
        queries.firstWhereOrNull((e) => e.key == Query.search('').key)?.value ??
            '';
    endpoint = UrlQuery.getApiWithQueries(api: url.url, filters: queries);
    dio = Dio(
      BaseOptions(
        method: method.value,
        connectTimeout: timeout,
        headers: headers ?? StaticValues.defaultHeaders(),
      ),
    );
  }

  /// --------------------------------------------- PROCESS REQUEST ------------------------------------------------------
  Future<ApiResponseModel<T>> call({bool isIteratedCall = false}) async {
    _initDio();

    /// Validate the token
    if (validateToken) {
      final ApiResponseModel? tokenResponse =
          await _handleTokenExpiry(forced: isIteratedCall);

      /// Calling get new token api was failed.
      if (!(tokenResponse?.responseType.success ?? true)) {
        return ApiResponseModel<T>(
          errors: tokenResponse!.errors,
          responseType: tokenResponse.responseType,
          nextUrl: null,
          request: this,
          data: null,
          searchText: searchKey,
        );
      }
    }

    final responseObject = await _sendRequest();
    ApiResponseModel<T> handledResponse = _handleResponse(
        exception: responseObject.exception, response: responseObject.response);
    if (logRequest) _logRequest(handledResponse);
    if (StaticValues.saveApiRequest) SaveNetworkLog.addLog(handledResponse);

    if (validateToken &&
        !isIteratedCall &&
        handledResponse.responseType == ApiResponseType.unAuthenticated) {
      handledResponse = await call(isIteratedCall: true);
    }

    return handledResponse;
  }

  /// --------------------------------------------- HANDLE TOKEN EXPIRY ----------------------------------------------
  Future<ApiResponseModel?> _handleTokenExpiry({bool forced = false}) async {
    final BuildContext context = Globals.context();

    final authProvider = context.read<AuthenticationProvider>();

    final isExpired =
        JwtDecoder.isExpired(dio.options.headers[authorizationKey] ?? '');
    if (isExpired || forced) {
      final ApiResponseModel<LoginResponseModel> tokenResponse =
          await CommonApiServices.getNewAccessToken();

      /// --------------------------------------- NEW ACCESS TOKEN OBTAINED-------------------------------------
      if (tokenResponse.responseType.success) {
        await authProvider.saveNewAccessToken(
            accessToken: tokenResponse.data!.accessToken);
        dio.options.headers[authorizationKey] =
            'Bearer ${tokenResponse.data!.accessToken}';
      }

      /// --------------------------------------- UNAUTHENTICATED REFRESH TOKEN -------------------------------------
      else if (tokenResponse.responseType == ApiResponseType.unAuthenticated) {
        try {
          bool loggedOut = await authProvider.logout();
          if (loggedOut) {
            AppNavigator.navigate(AppRoutes.login);
            Future.delayed(
              const Duration(seconds: 2),
              () => AppSnackBar.showSnackBarWithText(
                  title: errorMessages.routingMsg, clickToOpen: false),
            );
          }
        } catch (e) {
          Globals.logger
              .log('Failed to navigate to logout.', logLocation: true);
        }
      }
      return tokenResponse;
    } else {
      return null;
    }
  }

  /// --------------------------------------------- SEND REQUEST ------------------------------------------------------
  Future<({Object? exception, Response? response})> _sendRequest() async {
    Response? response;
    startTime = DateTime.now();
    try {
      response = await dio.request(
        endpoint,
        data: body,
        cancelToken: cancelToken,
        options: method == ApiMethods.fileDownload
            ? Options(responseType: ResponseType.bytes)
            : null,
        onSendProgress: (body?.isEmpty ?? true)
            ? null
            : (send, total) {
                if (sendProgress != null) sendProgress?.value = send / total;
                if (onSendProgress != null) onSendProgress?.call(send, total);
              },
        onReceiveProgress: (received, total) {
          if (receiveProgress != null)
            receiveProgress?.value = received / total;
          if (onReceiveProgress != null)
            onReceiveProgress?.call(received, total);
        },
      );
      endTime = DateTime.now();
      return (exception: null, response: response);
    } catch (exception) {
      endTime = DateTime.now();
      return (exception: exception, response: null);
    }
  }

  /// --------------------------------------------- HANDLE RESPONSE ------------------------------------------------------
  ApiResponseModel<T> _handleResponse(
      {required Object? exception, required Response? response}) {
    if (exception != null) {
      final ApiResponseModel<T> errorModel = ApiResponseModel(
        data: null,
        responseType: ApiResponseType.noInternet,
        request: this,
        rawResponse: response,
        errors: [],
        nextUrl: null,
        searchText: searchKey,
      );

      if (exception is DioException) {
        errorModel.rawResponse = exception.response;

        if (exception.response?.statusCode == 500) {
          errorModel.responseType = ApiResponseType.internalServerError;
          errorModel.errors = [errorMessages.internalServerErrorMsg];
          return errorModel;
        }

        if (exception.type == DioExceptionType.badResponse &&
            exception.response?.statusCode == 401) {
          errorModel.responseType = ApiResponseType.unAuthenticated;
          errorModel.errors = [errorMessages.unAuthenticatedErrorMsg];
          return errorModel;
        }

        if (exception.type == DioExceptionType.connectionError) {
          errorModel.responseType = ApiResponseType.noInternet;
          errorModel.errors = [errorMessages.socketErrorMsg];
          return errorModel;
        }
        if (exception.type == DioExceptionType.connectionTimeout ||
            exception.type == DioExceptionType.receiveTimeout ||
            exception.type == DioExceptionType.sendTimeout) {
          errorModel.responseType = ApiResponseType.timeOutError;
          errorModel.errors = [errorMessages.timeoutErrorMsg];
          return errorModel;
        }
        if (exception.type == DioExceptionType.cancel) {
          errorModel.responseType = ApiResponseType.requestCancelled;
          errorModel.errors = [errorMessages.cancelErrorMsg];
          return errorModel;
        }
      }

      errorModel.errors =
          _getErrorFromResponse(errorModel.rawResponse.toString()) ??
              [errorMessages.commonErrorMsg];
      errorModel.responseType = ApiResponseType.unknownError;
      Globals.logger.log(exception.toString(), color: LogColors.yellow);
      return errorModel;
    } else {
      /// The request was not an http exception, check for exceptions when parsing the json
      try {
        dynamic data = method == ApiMethods.fileDownload
            ? response!.data
            : response!.data['data'];
        Map<String, dynamic> formattedData = {};
        formattedData =
            data.runtimeType.toString().contains('Map') ? Map.from(data) : {};

        final T? t = fromJson?.call(formattedData);

        /// 200 Response
        if (response.statusCode!.toString().startsWith('2')) {
          if (method == ApiMethods.fileDownload)
            return _returnFileDownloadSuccessResponse(response);

          int showingCount = 0;
          try {
            showingCount = Ju.gV(response.data, 'data.data').length;
          } catch (_) {}

          bool needApproval = _needApprovalLogic(
              Ju.gV(response.data, 'data.approverRequestId'), method);

          return ApiResponseModel<T>(
            errors: [],
            responseType: ApiResponseType.ok,
            nextUrl: Ju.gV(response.data, 'data.nextPageUrl'),
            currentPage: Ju.gV(response.data, 'data.presentPage') ?? 1,
            totalPage: Ju.gV(response.data, 'data.totalPage') ?? 0,
            totalCount: Ju.gV(response.data, 'data.totalCount') ?? 0,
            needApproval: needApproval,
            showingCount: showingCount,
            request: this,
            rawResponse: response,
            data: t,
            searchText: searchKey,
          );
        }

        /// Other error responses
        return ApiResponseModel<T>(
          errors: _getErrorFromResponse(response.data.toString()) ??
              [errorMessages.commonErrorMsg],
          responseType: ApiResponseType.unknownError,
          nextUrl: null,
          request: this,
          rawResponse: response,
          data: t,
          searchText: searchKey,
        );
      } catch (e, s) {
        debugPrint(e.toString());
        debugPrintStack(stackTrace: s);

        /// Error when parsing response
        return ApiResponseModel<T>(
          errors: [errorMessages.dataTypeErrorMsg],
          responseType: ApiResponseType.dataTypeError,
          nextUrl: null,
          request: this,
          rawResponse: response,
          data: null,
          searchText: searchKey,
        );
      }
    }
  }

  ApiResponseModel<T> _returnFileDownloadSuccessResponse(Response response) {
    String? fileName;
    ApiResponseType responseType = ApiResponseType.ok;
    List<String> errors = [];
    final fileSize =
        FileSize(size: response.data.length, unit: FileSizeUnit.bytes);

    try {
      fileName = response.headers.map['content-disposition']!.first
          .toString()
          .split('filename=')
          .last
          .replaceAll('"', '');
    } catch (_) {}

    if (fileName == null || fileName.trim().isEmpty) {
      responseType = ApiResponseType.noFileName;
      errors = ['Download failed. No filename found in header.'];
    }

    return ApiResponseModel<T>(
      errors: errors,
      responseType: responseType,
      nextUrl: null,
      currentPage: 1,
      totalPage: 0,
      totalCount: 0,
      needApproval: false,
      showingCount: 0,
      request: this,
      rawResponse: response,
      data: response.data,
      searchText: '',
      fileName: fileName,
      fileSize: fileSize,
    );
  }

  /// ----------------------------------------------- REQUEST LOGGING -------------------------------------------------
  void _logRequest(ApiResponseModel responseModel) {
    final Duration time = endTime.difference(startTime);

    final urlLog =
        'URL: ${method.stringName} ${isDummy ? actualAPI : endpoint} (${time.inMilliseconds} ms)${isDummy ? '|| DUMMY - $customFileName' : ''}';
    final headers =
        logHeader ? '\nHEADERS: ${jsonEncode(dio.options.headers)}' : '';
    final String sentData =
        '\nSENT DATA: ${body == null ? null : jsonEncode(getUpdatedBody(body!, method))}';

    String? responseBody;
    try {
      responseBody = jsonEncode(responseModel.rawResponse?.data);
    } catch (_) {}

    final responseData =
        '\nRESPONSE DATA: ${getUpdatedResponseBody(responseBody, method)}';
    final String? responseError = responseModel.responseType.success
        ? null
        : '\nERROR: ${responseModel.errors.firstOrNull}';
    final responseStatusCode =
        '\nSTATUS CODE: ${responseModel.rawResponse?.statusCode ?? ''}';
    final String logData =
        '$urlLog$headers$sentData$responseStatusCode${responseError ?? ''}$responseData';

    Globals.logger.log(logData, logPattern: true);
  }

  Map<String, dynamic> getUpdatedBody(
      Map<String, dynamic> json, ApiMethods method) {
    final Map<String, dynamic> newJson = {};
    newJson.addAll(json);
    if (method == ApiMethods.fileUpload && newJson.keys.contains('files'))
      newJson['files'] = 'File added here.';

    return newJson;
  }

  String? getUpdatedResponseBody(String? responseData, ApiMethods method) {
    String returnString = responseData ?? 'NULL';

    if (method == ApiMethods.fileDownload &&
        responseData != null &&
        responseData.isNotEmpty) {
      FileSize size =
          FileSize(size: responseData.length, unit: FileSizeUnit.bytes);
      returnString =
          'Downloaded bytes here (${size.toMB().toStringAsFixed(2)} MB)';
    }

    return returnString;
  }

  void _setupDummyRequest() {
    if (StaticValues.isProduction && isDummy) isDummy = false;

    if (isDummy) {
      if (method == ApiMethods.post ||
          method == ApiMethods.put ||
          method == ApiMethods.patch ||
          method == ApiMethods.delete) {
        method = ApiMethods.get;
      }

      actualAPI = UrlQuery.getApiWithQueries(api: url.url, filters: queries);

      if (url.privateUrl.endsWith('create/') && customFileName == null) {
        customFileName = '00created.json';
      } else if (url.privateUrl.endsWith('delete_many/') &&
          customFileName == null) {
        customFileName = '00deleted.json';
      } else if (url.privateUrl.endsWith('update/') && customFileName == null) {
        customFileName = '00updated.json';
      } else if (url.privateUrl.endsWith('search/') && customFileName == null) {
        customFileName = '00search.json';
      } else {
        customFileName ??=
            '${url.privateUrl.replaceAll('/', ' ').trim().replaceAll(' ', '_')}.json';
      }

      queries = [
        UrlQuery(key: 'dummy', value: 'true'),
        UrlQuery(key: 'bucket_name', value: 'dummy'),
        UrlQuery(key: 'file_name', value: customFileName),
      ];
      url = Endpoint.fileDownload();
    }
  }

  /// -----------------------------------------------------------------------------------------------------------------
}

const ErrorMessages defaultMessages = ErrorMessages();

List<String>? _getErrorFromResponse(String? response) {
  List<String> errorMsgFromBackend = [];
  try {
    final jsonData = jsonDecode(response!);
    errorMsgFromBackend =
        List<String>.from((jsonData['error'] ?? []).map((x) => x));
  } catch (_) {}

  final List<String> trimmedMsg = [];
  for (final i in errorMsgFromBackend) {
    if (i.trim().isNotEmpty) trimmedMsg.add(i.trim());
  }

  return trimmedMsg.isEmpty ? null : trimmedMsg;
}

bool _needApprovalLogic(dynamic needApproval, ApiMethods method) {
  if (needApproval != null) return true;
  if (StaticValues.needApproval != null &&
      (method == ApiMethods.patch ||
          method == ApiMethods.delete ||
          method == ApiMethods.put ||
          method == ApiMethods.post ||
          method == ApiMethods.fileUpload)) {
    StaticValues.needApproval = !StaticValues.needApproval!;
  }
  return StaticValues.needApproval ?? false;
}
