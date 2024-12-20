import 'dart:convert';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:mood_sync/app/data/models/track.dart';

class PlaylistDetailController extends GetxController {
  final getStorage = GetStorage();
  final accessToken = GetStorage().read('accessToken');
  var isLoading = true.obs;
  var playlistData = <String, dynamic>{}.obs;
  var tracks = <Track>[].obs;
  late String url = '';

  Future<void> fetchPlaylistDetails(String playlistId) async {
    isLoading.value = true;

    try {
      final response = await http.get(
        Uri.parse('https://api.spotify.com/v1/playlists/$playlistId'),
        headers: {'Authorization': 'Bearer $accessToken'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        playlistData.value = data;

        url = data['external_urls']['spotify'];

        // Isi variabel tracks dengan data yang diambil
        tracks.value = (data['tracks']['items'] as List).map<Track>((item) {
          final track = item['track'];
          return Track(
            id: track['id'],
            title: track['name'],
            artist: (track['artists'] as List)
                .map((artist) => artist['name'])
                .join(', '),
            image: track['album']['images'][0]['url'],
            url: track['external_urls']['spotify'],
            type: 'song',
          );
        }).toList();
      } else {
        print('Gagal memuat detail playlist: ${response.statusCode}');
      }
    } catch (e) {
      print('Error saat memuat detail playlist: $e');
    } finally {
      isLoading.value = false;
      print('url that make playlist id: $url');
    }
  }
}
