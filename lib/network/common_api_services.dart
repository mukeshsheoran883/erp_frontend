import 'dart:async';

import 'package:invently/assortment/network/api_helper.dart';
import 'package:invently/assortment/network/api_manager_models.dart';
import 'package:invently/assortment/network/endpoints.dart';
import 'package:invently/models/common/file_upload_response_model.dart';
import 'package:invently/models/user/employee_model.dart';
import 'package:invently/models/user/login_model.dart';
import 'package:invently/utils/static_values.dart';
import 'package:flutter/cupertino.dart';

class CommonApiServices {
  static Future<ApiResponseModel<LoginResponseModel>> getNewAccessToken() async {
    return DioHelper(
      url: Endpoint.getNewToken(),
      method: ApiMethods.get,
      fromJson: LoginResponseModel.fromJson,
      headers: StaticValues.defaultHeaders(isRefreshToken: true),
      validateToken: false,
    ).call();
  }

  static Future<ApiResponseModel<LoginResponseModel>> loginUser(LoginModel model) async {
    return await DioHelper(
      method: ApiMethods.post,
      url: Endpoint.login(),
      fromJson: LoginResponseModel.fromJson,
      headers: StaticValues.defaultHeaders(sendToken: false),
      validateToken: false,
      body: model.toJson(),
    ).call();
  }

  static Future<ApiResponseModel<UserModel>> getCurrentUserDetails({String? accessToken, String? employeeCode}) async {
    UrlQuery employeeCodeQuery = Query.employeeCode();
    if (employeeCode != null) employeeCodeQuery.value = employeeCode;

    return DioHelper(
      url: Endpoint.getEmployee(),
      queries: [employeeCodeQuery],
      method: ApiMethods.get,
      fromJson: UserModel.fromJson,
      headers: StaticValues.defaultHeaders(token: accessToken),
    ).call();
  }

  static Future<ApiResponseModel<FileUploadResponseModel>> fileUpload({
    required FileUploadModel model,
    ValueNotifier<double>? progress,
  }) async {
    return await DioHelper(
      method: ApiMethods.fileUpload,
      timeout: const Duration(seconds: 60),
      url: Endpoint.fileUpload(),
      fromJson: FileUploadResponseModel.fromJson,
      sendProgress: progress,
      body: model.toJson(),
    ).call();
  }

  static Future<ApiResponseModel> sendEmailOtp({required String email, required String employeeCode}) async {
    return DioHelper(
      url: Endpoint.forgotPasswordSendEmail(),
      method: ApiMethods.post,
      headers: StaticValues.defaultHeaders(sendToken: false),
      body: {'email': email, 'employee_code': employeeCode},
    ).call();
  }

  static Future<ApiResponseModel> forgotPasswordChange({
    required String email,
    required String otp,
    required String password,
  }) async {
    return DioHelper(
      url: Endpoint.forgotPasswordChange(),
      method: ApiMethods.post,
      headers: StaticValues.defaultHeaders(sendToken: false),
      body: {'email_id': email, 'email_otp': otp, 'new_password': password},
    ).call();
  }

  static Future<ApiResponseModel> activateAccount({
    required String email,
    required String otp,
    required String password,
  }) async {
    return DioHelper(
      url: Endpoint.activateAccount(),
      method: ApiMethods.post,
      headers: StaticValues.defaultHeaders(sendToken: false),
      body: {'email_id': email, 'email_otp': otp, 'password': password},
    ).call();
  }

  static Future<ApiResponseModel> changePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    return await DioHelper(
      url: Endpoint.passwordChange(),
      method: ApiMethods.post,
      body: {'old_password': oldPassword, 'new_password': newPassword},
    ).call();
  }

  static Future<ApiResponseModel> fileDownload({
    required Endpoint endpoint,
    Map<String, dynamic>? body,
    Map<String, dynamic>? headers,
    ValueNotifier<double>? progress,
  }) async {
    return await DioHelper(
      url: endpoint,
      method: ApiMethods.fileDownload,
      body: body,
      headers: headers,
      receiveProgress: progress,
    ).call();
  }
}
