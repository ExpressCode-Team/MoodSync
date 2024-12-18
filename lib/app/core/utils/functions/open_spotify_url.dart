import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:mood_sync/app/core/consts/constants.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> openSpotifyUrl(
    Map<String, dynamic> data, String accessToken) async {
  String type;
  String recommendationId;
  const baseUrl = Constants.BASE_URL_LARAVEL;

  print(data);

  type = data['type'];
  recommendationId = data['id'];

  print('accessToken: $accessToken');
  print('Type: $type');
  print('Id: $recommendationId');

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
  print('$baseUrl/api/history-recomendations');

  if (response.statusCode == 201) {
    print('History saved successfully.');
  } else {
    print('Failed to save history: ${response.body}');
  }

  String spotifyUrl = data['url'];
  await launchUrl(Uri.parse(spotifyUrl));
}
