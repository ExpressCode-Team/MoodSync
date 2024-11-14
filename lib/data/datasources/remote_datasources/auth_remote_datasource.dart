import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
import 'package:mood_sync/data/datasources/local_datasources/auth_local_datasource.dart';
import 'package:mood_sync/data/dto/requests/auth_dto.dart';
import 'package:mood_sync/data/dto/requests/change_password.dart';
import 'package:mood_sync/data/dto/requests/login_dto.dart';
import 'package:mood_sync/data/dto/responses/auth_response.dart';
import 'package:mood_sync/presentation/router/app_router_constant.dart';

class AuthRemoteDatasource {
  static const baseUrl = AppRouterConstant.baseUrl;
  Future<Either<String, AuthDto>> login(LoginDto params) async {
    final url = Uri.parse('$baseUrl/api/auth/login');
    final response = await http.post(url, body: params.toJson());

    print(response.body);
    print(response.statusCode);
    print(params.email);
    print(params.password);
    print(AuthResponse.fromJson(jsonDecode(response.body)));
    if (response.statusCode == 200) {
      final authResponseModel =
          AuthResponse.fromJson(jsonDecode(response.body));
      final data = await AuthLocalDataSource().saveAuthData(authResponseModel);
      return right(data);
    } else {
      return left('Email or password is incorrect');
    }
  }

  Future<Either<String, String>> changePassword(
      ChangePasswordDto params) async {
    final authData = await AuthLocalDataSource().getAuthData();
    final url = Uri.parse('$baseUrl/api/auth/change-password');
    final response = await http.put(
      url,
      body: jsonEncode(params.toJson()),
      headers: {
        'Authorization': 'Bearer ${authData!.token}',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return right('Successfully changed the password');
    } else {
      return left(
          'Password and confirm password are not the same or less than 6 characters');
    }
  }
}
