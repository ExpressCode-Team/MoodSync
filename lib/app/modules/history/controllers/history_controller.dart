import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:mood_sync/app/core/consts/constants.dart';
import 'package:mood_sync/app/core/error/app_error.dart';
import 'package:mood_sync/app/data/models/playlist.dart';
import 'package:mood_sync/app/data/models/track.dart';

class HistoryController extends GetxController {
  final String accessToken = GetStorage().read('accessToken');
  var isLoading = true.obs;
  var songHistory = <Track>[].obs;
  var playlistHistory = <Playlist>[].obs;

  final String baseUrl = Constants.BASE_URL_LARAVEL;

  @override
  void onInit() {
    super.onInit();
    fetchHistory();
  }

  Future<Either<AppError, Track>> fetchTrackData(
      String recommendationId) async {
    final response = await http.get(
      Uri.parse('https://api.spotify.com/v1/tracks/$recommendationId'),
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      var trackData = json.decode(response.body);
      return Right(
        Track(
          id: recommendationId,
          title: trackData['name'],
          artist: trackData['artists'].isNotEmpty
              ? trackData['artists'][0]['name']
              : 'Unknown Artist',
          image: trackData['album']['images'].isNotEmpty
              ? trackData['album']['images'][0]['url']
              : 'https://via.placeholder.com/150',
          url: trackData['external_urls']['spotify'],
          type: 'song',
        ),
      );
    } else {
      return Left(AppError('Failed to fetch track: ${response.statusCode}'));
    }
  }

  Future<Either<AppError, Playlist>> fetchPlaylistDataHistory(
      String recommendationId) async {
    final response = await http.get(
      Uri.parse('https://api.spotify.com/v1/playlists/$recommendationId'),
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      var playlistData = json.decode(response.body);
      return Right(Playlist.fromJson(playlistData));
    } else {
      return Left(AppError('Failed to fetch playlist: ${response.statusCode}'));
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
        final trackDataResult = await fetchTrackData(recommendationId);
        trackDataResult.fold(
          (error) => print(error.message),
          (trackData) => songHistory.add(trackData),
        );
      }

      // Fetch playlist data
      for (var recommendationId in playlistIds) {
        final playlistDataResult =
            await fetchPlaylistDataHistory(recommendationId);
        playlistDataResult.fold(
          (error) => print(error.message),
          (playlistData) => playlistHistory.add(playlistData),
        );
      }
    } else {
      print('Failed to fetch history: ${response.statusCode}');
    }

    isLoading.value = false;
  }
}
