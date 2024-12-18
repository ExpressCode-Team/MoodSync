import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:mood_sync/app/core/consts/constants.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> openSpotifyUrl(Map<String, dynamic> data, String accessToken,
    {bool saveHistory = true}) async {
  String type = data['type'];
  String recommendationId = data['id'];
  const baseUrl = Constants.BASE_URL_LARAVEL;
  print('what openSpotifyUrl get from param: $data');

  _showDataDialog(data);

  // If saveHistory is true, perform the API request to save the history
  if (saveHistory) {
    final response = await http.post(
      Uri.parse('$baseUrl/api/history-recommendations'),
      headers: {
        'Content-Type': 'application/json',
        'access_token': accessToken,
      },
      body: jsonEncode({
        'type': type,
        'recommendation_id': recommendationId,
      }),
    );

    print('$baseUrl/api/history-recommendations');

    if (response.statusCode == 201) {
      print('History saved successfully.');
    } else {
      print('Failed to save history: ${response.body}');
      return;
    }
  }

  String spotifyUrl = data['url'];
  try {
    await launchUrl(Uri.parse(spotifyUrl));
  } catch (e) {
    print('Failed to open Spotify URL: ${e.toString()}');
  }
}

Future<void> _showDataDialog(Map<String, dynamic> data) async {
  return Get.defaultDialog(
    title: 'Debug Data',
    middleText: data.toString(),
    onConfirm: () => Get.back(),
    textConfirm: 'OK',
  );
}
