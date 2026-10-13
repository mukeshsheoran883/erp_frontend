import 'package:invently/assortment/utils/json_utils.dart';

class LoginModel {
  LoginModel({required this.userName, required this.password});

  final String userName;
  final String password;

  Map<String, dynamic> toJson() => {'email_id': userName, 'password': password};
}

class LoginResponseModel {
  String accessToken;
  String refreshToken;

  LoginResponseModel({required this.accessToken, required this.refreshToken});

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) => LoginResponseModel(
        accessToken: (Ju.gV(json, 'access_token') ?? ''),
        refreshToken: (Ju.gV(json, 'refresh_token') ?? ''),
      );
}
