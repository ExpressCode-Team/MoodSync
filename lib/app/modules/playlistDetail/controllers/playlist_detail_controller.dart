import 'dart:convert';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

class PlaylistDetailController extends GetxController {
  final getStorage = GetStorage();
  final accessToken = GetStorage().read('accessToken');
  var isLoading = true.obs;
  var playlistData = <String, dynamic>{}.obs;
  var tracks = <Map<String, dynamic>>[].obs;

  Future<void> fetchPlaylistDetails(String playlistId) async {
    isLoading.value = true;
    String accessToken = getStorage.read('accessToken');

    try {
      final response = await http.get(
        Uri.parse('https://api.spotify.com/v1/playlists/$playlistId'),
        headers: {'Authorization': 'Bearer $accessToken'},
      );

      if (response.statusCode == 200) {
        print(response.body);
        final data = json.decode(response.body);
        playlistData.value = data;
        tracks.value =
            (data['tracks']['items'] as List).map<Map<String, dynamic>>((item) {
          final track = item['track'];
          return {
            'title': track['name'],
            'artist': (track['artists'] as List)
                .map((artist) => artist['name'])
                .join(', '),
            'image': track['album']['images'][0]['url'],
            'url': track['external_urls']['spotify'],
          };
        }).toList();
      } else {
        print('Gagal memuat detail playlist: ${response.statusCode}');
        print('Response: ${response.body}');
      }
    } catch (e) {
      print('Error saat memuat detail playlist: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
