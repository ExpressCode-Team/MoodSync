import 'dart:convert';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

class RecomendationController extends GetxController {
  final accessToken = GetStorage().read('accessToken');
  var isLoading = true.obs;
  var recommendedSongs = <String>[].obs;

  Future<void> fetchRecommendations(String emotion) async {
    const int numSongs = 10;

    final Uri uri = Uri.parse(
        'https://facialexpress.raihanproject.my.id/spotify/recommend-songs/?access_token=$accessToken&emotion=$emotion&num_songs=$numSongs');

    try {
      final http.Response response = await http.post(uri);
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> songs = data['songs'] ?? [];

        recommendedSongs.value =
            songs.map((song) => song['id'] as String).toList();
      } else {
        print('Failed to fetch recommendations c: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Error fetching recommendations d: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<Map<String, dynamic>> fetchTrackDetails(String songId) async {
    if (accessToken == null) {
      throw Exception('Access token not found!');
    }
    final response = await http.get(
      Uri.parse('https://api.spotify.com/v1/tracks/$songId'),
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load track details');
    }
  }
}
