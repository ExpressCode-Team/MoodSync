import 'dart:convert';

import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:mood_sync/data/dto/requests/auth_dto.dart';
import 'package:mood_sync/data/dto/responses/auth_response.dart';
import 'package:mood_sync/domain/entities/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthLocalDataSource {
  Future<AuthDto> saveAuthData(AuthResponse authResponse) async {
    final Map<String, dynamic> decodedToken = JwtDecoder.decode(
      authResponse.token!,
    );

    final user = User(
      id: decodedToken["id"],
      name: decodedToken["name"],
      email: decodedToken["email"],
    );

    final exp = decodedToken["exp"];
    final expiration =
        exp != null ? DateTime.fromMillisecondsSinceEpoch(exp * 1000) : null;

    final authData = AuthDto(
      token: authResponse.token,
      user: user,
      expiration: expiration,
    );

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("auth_data", authData.toJson().toString());
    return authData;
  }

  Future<void> removeAuthData() async {
    // Remove auth data from local storage
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_data');
  }

  Future<AuthDto?> getAuthData() async {
    // Get auth data from local storage
    final prefs = await SharedPreferences.getInstance();
    final authData = prefs.getString('auth_data');
    if (authData != null) {
      return AuthDto.fromJson(jsonDecode(authData));
    } else {
      return null;
    }
  }

  Future<bool> isUserLoggedIn() async {
    // Check if user is logged in
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey('auth_data');
  }
}
