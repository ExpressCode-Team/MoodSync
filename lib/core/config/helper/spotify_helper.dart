import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:mood_sync/core/config/env/env_config.dart';
import 'package:spotify_sdk/spotify_sdk.dart';

class SpotifyHelper {
  static const _secureStorage = FlutterSecureStorage();

  static Future<void> fetchAndSaveAccessToken() async {
    try {
      final authenticationToken = await SpotifySdk.getAccessToken(
        clientId: EnvConfig.CLIENT_ID,
        redirectUrl: EnvConfig.REDIRECT_URI,
        scope: EnvConfig.SPOTIFY_GLOBAL_SCOPE,
      );

      final now = DateTime.now();
      await _secureStorage.write(
          key: 'accessToken', value: authenticationToken);
      await _secureStorage.write(
          key: 'tokenTimestamp', value: now.toIso8601String());
    } on PlatformException catch (e) {
      throw Exception('Error fetching access token: $e');
    } on MissingPluginException {
      throw Exception('Spotify SDK not implemented on this platform.');
    }
  }

  static Future<String?> getAccessToken() async {
    return await _secureStorage.read(key: 'accessToken');
  }

  static Future<bool> isAccessTokenExpired() async {
    final tokenTimestamp = await _secureStorage.read(key: 'tokenTimestamp');
    if (tokenTimestamp == null) return true;

    final tokenTime = DateTime.parse(tokenTimestamp);
    final expiryTime = tokenTime.add(const Duration(hours: 1));
    return DateTime.now().isAfter(expiryTime);
  }

  /// Clear access token and timestamp from secure storage.
  static Future<void> clearAccessToken() async {
    await _secureStorage.delete(key: 'accessToken');
    await _secureStorage.delete(key: 'tokenTimestamp');
  }

  /// Try to refresh access token or redirect user to login if unavailable.
  /// Placeholder for backend-based refresh token implementation.
  static Future<void> handleTokenExpiration() async {
    final isExpired = await isAccessTokenExpired();
    if (isExpired) {
      await clearAccessToken();
      // Add logic to redirect to login page or reauthenticate user.
      throw Exception('Access token expired. Please log in again.');
    }
  }

  /// Perform a Spotify API request and handle token expiration.
  static Future<http.Response> makeSpotifyApiRequest(String url,
      {Map<String, String>? headers}) async {
    String? accessToken = await getAccessToken();

    if (accessToken == null || await isAccessTokenExpired()) {
      await fetchAndSaveAccessToken();
      accessToken = await getAccessToken();
    }

    headers ??= {};
    headers['Authorization'] = 'Bearer $accessToken';

    final response = await http.get(Uri.parse(url), headers: headers);

    if (response.statusCode == 401) {
      // Unauthorized, likely due to expired token
      await fetchAndSaveAccessToken();
      accessToken = await getAccessToken();

      headers['Authorization'] = 'Bearer $accessToken';
      return await http.get(Uri.parse(url), headers: headers);
    }

    return response;
  }
}
