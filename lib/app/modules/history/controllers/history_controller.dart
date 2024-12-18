import 'dart:convert';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:mood_sync/app/core/consts/constants.dart';

class HistoryController extends GetxController {
  final String accessToken = GetStorage().read('accessToken');
  var isLoading = true.obs;
  var songHistory = <Map<String, dynamic>>[].obs;
  var playlistHistory = <Map<String, dynamic>>[].obs;

  final String baseUrl = Constants.BASE_URL_LARAVEL;

  @override
  void onInit() {
    super.onInit();
    fetchHistory();
  }

  Future<Map<String, dynamic>?> fetchTrackData(String recommendationId) async {
    final response = await http.get(
      Uri.parse('https://api.spotify.com/v1/tracks/$recommendationId'),
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );
    print('recomndation song to fetch: $recommendationId');

    if (response.statusCode == 200) {
      var trackData = json.decode(response.body);

      return {
        'images': trackData['album']['images'].isNotEmpty
            ? trackData['album']['images'][0]['url']
            : null,
        'name': trackData['name'],
        'artist': trackData['artists'].isNotEmpty
            ? trackData['artists'][0]['name']
            : null,
        'url': trackData['external_urls']['spotify'],
        'type': 'song',
      };
    } else {
      print('Failed to fetch track: ${response.statusCode}');
      return null;
    }
  }

  Future<Map<String, dynamic>?> fetchPlaylistDataHistory(
      String recommendationId) async {
    final response = await http.get(
      Uri.parse('https://api.spotify.com/v1/playlists/$recommendationId'),
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      print('Failed to fetch playlist: ${response.statusCode}');
      return null;
    }
  }

  Future<void> fetchHistory() async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/history-recommendations'),
      headers: {
        'access_token': accessToken,
      },
    );

    if (response.statusCode == 200) {
      var decodedResponse = json.decode(response.body);
      var data = decodedResponse['data'];

      songHistory.clear();
      playlistHistory.clear();

      Set<String> songIds = {};
      Set<String> playlistIds = {};

      for (var item in data) {
        if (item['type'] == 'song') {
          songIds.add(item['recommendation_id']);
        } else if (item['type'] == 'playlist') {
          playlistIds.add(item['recommendation_id']);
        }
      }

      // Fetch track data for songs
      for (var recommendationId in songIds) {
        var trackData = await fetchTrackData(recommendationId);
        if (trackData != null) {
          songHistory.add(trackData);
        }
      }

      // Fetch playlist data
      for (var recommendationId in playlistIds) {
        var playlistData = await fetchPlaylistDataHistory(recommendationId);
        if (playlistData != null) {
          playlistHistory.add(playlistData);
        }
      }
    } else {
      print('Failed to fetch history: ${response.statusCode}');
    }

    isLoading.value = false;
  }
}
