import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:mood_sync/app/core/consts/constants.dart';
import 'package:mood_sync/app/core/error/app_error.dart';
import 'package:mood_sync/app/data/models/playlist.dart';
import 'package:mood_sync/app/data/models/track.dart';

class HomepageController extends GetxController {
  var isLoading = true.obs;
  var lastHistoryExpression = ''.obs;
  var trackData = <Track>[].obs; // Menggunakan model Track
  var playlistData = <Playlist>[].obs; // Menggunakan model Playlist
  final baseUrl = Constants.BASE_URL_LARAVEL;

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
    } catch (e) {
      print("Error occurred when fetching data: $e");
    } finally {
      isLoading.value = false; // Pastikan loading dinonaktifkan di akhir
    }
  }

  Future<void> fetchLastHistoryExpression() async {
    final String apiUrl = '$baseUrl/api/last-history-expressions';
    String? accessToken = GetStorage().read('accessToken');

    if (accessToken == null) {
      print('Access token tidak ditemukan.');
      return;
    }

    try {
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {'access_token': accessToken},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> decodedResponse = json.decode(response.body);
        final data = decodedResponse['data'];

        if (data != null && data['expression_id'] != null) {
          final int expressionId = data['expression_id'];
          lastHistoryExpression.value = getExpressionLabel(expressionId);
        }
      } else {
        print('Fetch Last History Failed. Status code: ${response.statusCode}');
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

    if (accessToken == null) {
      print('Access token tidak ditemukan.');
      return;
    }

    try {
      final response = await http.get(
        Uri.parse(
            'https://api.spotify.com/v1/search?q=track&type=track&include_external=audio'),
        headers: {'Authorization': 'Bearer $accessToken'},
      );

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        var tracks = data['tracks']['items'];

        trackData.value = tracks.map<Track>((track) {
          return Track(
            id: track['id'],
            title: track['name'],
            artist: track['artists'][0]['name'],
            image: track['album']['images'][0]['url'],
            url: track['external_urls']['spotify'],
            type: 'song',
          );
        }).toList();
      } else {
        print('Failed to load tracks: ${response.statusCode}');
      }
    } catch (e) {
      print("An error occurred: $e");
    }
  }

  Future<Either<AppError, List<Playlist>>> fetchPlaylists() async {
    String? accessToken = GetStorage().read('accessToken');

    if (accessToken == null) {
      return Left(AppError('Access token tidak ditemukan.'));
    }

    var genresList = ['pop'];

    for (String genre in genresList) {
      try {
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

            for (var playlist in playlists) {
              if (playlist != null) {
                playlistData.add(
                    Playlist.fromJson(playlist)); // Menggunakan model Playlist
              }
            }
          }
        } else {
          return Left(AppError(
              'Failed to load playlists for genre $genre: ${response.statusCode}'));
        }
      } catch (e) {
        return Left(AppError('An error occurred: $e'));
      }
    }

    print('playlist home: ${playlistData.first.toString()}');
    return Right(playlistData);
  }
}
