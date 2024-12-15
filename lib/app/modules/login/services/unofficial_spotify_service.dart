import 'dart:convert';

import 'package:http/http.dart' as http;

class UnofficialSpotifyService {
  Future<String?> getAccessToken() async {
    try {
      final response = await http.get(Uri.parse(
          'https://open.spotify.com/get_access_token?reason=transport&productType=web_player'));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['accessToken'];
      } else {
        throw Exception('Failed to get access token');
      }
    } catch (e) {
      print('Error fetching access token: $e');
    }
    return null;
  }

  Future<List<String>> fetchBackgroundImages(String token) async {
    try {
      final response = await http.get(
        Uri.parse(
            'https://api.spotify.com/v1/search?q=genre%3Apop&type=artist&market=ID'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final items = data['artists']['items'] as List;
        return items
            .where((item) =>
                item['images'] != null &&
                (item['images'] as List).isNotEmpty &&
                item['name'] != "SZA")
            .map<String>((item) => item['images'][0]['url'] as String)
            .toList();
      } else {
        throw Exception('Failed to fetch background images');
      }
    } catch (e) {
      print('Error fetching background images: $e');
    }
    return [];
  }
}
