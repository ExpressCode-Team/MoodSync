import 'dart:convert';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:mood_sync/app/core/consts/constants.dart';

class HomepageController extends GetxController {
  var isLoading = true.obs;
  var lastHistoryExpression = ''.obs;
  var trackData = <Map<String, dynamic>>[].obs;
  var playlistData = <Map<String, dynamic>>[].obs;
  final baseUrl = Constants.BASE_URL_LARAVEL;
  final accessToken = GetStorage().read('accessToken');

  @override
  void onInit() {
    super.onInit();
    initializeData();
  }

  Future<void> initializeData() async {
    try {
      isLoading.value = true;
      await Future.wait([
        fetchRecommendations(),
        fetchPlaylists(),
        fetchLastHistoryExpression(),
      ]);
    } on Exception catch (e) {
      print("error occured when fetching data: $e");
    }
    isLoading.value = false;
  }

  Future<void> fetchLastHistoryExpression() async {
    final String apiUrl = '$baseUrl/api/last-history-expressions';
    String accessToken = GetStorage().read('accessToken');
    print("accessToken: $accessToken");

    print("Requesting last history expression...");
    print("apiUrl $apiUrl");

    try {
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {'access_token': accessToken},
      );

      print("Request completed. Status: ${response.statusCode}");

      if (response.statusCode == 200) {
        final Map<String, dynamic> decodedResponse = json.decode(response.body);
        final data = decodedResponse['data'];

        if (data != null && data['expression_id'] != null) {
          final int expressionId = data['expression_id'];
          lastHistoryExpression.value = getExpressionLabel(expressionId);
        }
      }
      if (response.statusCode == 404) {
        final Map<String, dynamic> decodedResponse = json.decode(response.body);
        if (decodedResponse['message'] ==
            'No history expressions found for this user.') {
          lastHistoryExpression.value =
              'No history expressions found for this user.';
        }
      } else {
        print(
            'Fetch Last History Failed to fetch data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print("An error occurred: $e");
    }
  }

  String getExpressionLabel(int id) {
    switch (id) {
      case 0:
        return 'angry';
      case 1:
        return 'happy';
      case 2:
        return 'neutral';
      case 3:
        return 'sad';
      default:
        return 'neutral';
    }
  }

  Future<void> fetchRecommendations() async {
    String? accessToken = GetStorage().read('accessToken');

    final response = await http.get(
      Uri.parse(
          'https://api.spotify.com/v1/search?q=track&type=track&include_external=audio'),
      headers: {'Authorization': 'Bearer $accessToken'},
    );

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      var tracks = data['tracks']['items'];

      trackData.value = tracks.map<Map<String, dynamic>>((track) {
        return {
          'id': track['id'],
          'title': track['name'],
          'artist': track['artists'][0]['name'],
          'image': track['album']['images'][0]['url'],
          'url': track['external_urls']['spotify'],
          'type': 'song',
        };
      }).toList();
    } else {
      print('Gagal memuat track: ${response.statusCode}');
    }
  }

  Future<void> fetchPlaylists() async {
    String? accessToken = GetStorage().read('accessToken');

    List<Map<String, dynamic>> fetchedPlaylists = [];
    var genresList = ['pop']; // Default genre

    // Fetch playlists based on genres
    for (String genre in genresList) {
      final response = await http.get(
        Uri.parse(
            'https://api.spotify.com/v1/search?q=genre%3A$genre&type=playlist&include_external=audio'),
        headers: {'Authorization': 'Bearer $accessToken'},
      );

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        if (data.containsKey('playlists') &&
            data['playlists']['items'] != null) {
          var playlists = data['playlists']['items'];
          if (playlists.isNotEmpty) {
            var validPlaylist = playlists.first;
            fetchedPlaylists.add({
              'name': validPlaylist['name'] ?? 'No title',
              'id': validPlaylist['id'],
              'description':
                  validPlaylist['description'] ?? 'No description available',
              'image': validPlaylist['images']?.isNotEmpty == true
                  ? validPlaylist['images'][0]['url']
                  : null,
              'url': validPlaylist['external_urls']['spotify'] ?? '',
              'type': 'playlist',
            });
          }
        }
      } else {
        print(
            'Gagal memuat playlist untuk genre $genre: ${response.statusCode}');
      }
    }

    playlistData.value = fetchedPlaylists;
  }
}
