import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:mood_sync/app/core/consts/constants.dart';
import 'package:mood_sync/app/modules/history/controllers/history_controller.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> openSpotifyUrl(Map<String, dynamic> data, String accessToken,
    {String? opsionalUrl, bool saveHistory = true}) async {
  String type = data['type'];
  String recommendationId = data['id'];
  const baseUrl = Constants.BASE_URL_LARAVEL;
  print('url openSpotifyUrl: ${data['url']}');

  // Gunakan opsionalUrl jika ada, jika tidak gunakan data['url']
  String spotifyUrl = opsionalUrl ?? data['url'];

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

  try {
    // Launch the Spotify URL
    bool launched = await launchUrl(Uri.parse(spotifyUrl));
    if (launched) {
      print('Successfully opened Spotify URL.'); // Log successful launch
      // Fetch history again after successful redirection
      final HistoryController historyController = Get.find();
      await historyController.fetchHistory();
    } else {
      print('Failed to open Spotify URL.');
    }
  } catch (e) {
    print('Failed to open Spotify URL: ${e.toString()}');
  }
}
