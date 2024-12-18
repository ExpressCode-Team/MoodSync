import 'dart:convert';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:mood_sync/app/core/consts/constants.dart';

class HistoryController extends GetxController {
  final getStorage = GetStorage();
  var isLoading = true.obs;
  var songHistory = <Map<String, dynamic>>[].obs;
  var playlistHistory = <Map<String, dynamic>>[].obs;

  final String baseUrl = Constants.BASE_URL_LARAVEL;

  @override
  void onInit() {
    super.onInit();
    fetchHistory();
  }

  Future<void> fetchHistory() async {
    String? accessToken = GetStorage().read('accessToken');
    print('accessToken on fetchHistory: $accessToken');

    final response = await http.get(
      Uri.parse('$baseUrl/api/history-recommendations'),
      headers: {
        'access_token': '$accessToken',
      },
    );
    print('get history play url : ${response.request?.url}');
    print('response status code fetch history : ${response.statusCode}');
    print('response body code fetch history : ${response.body}');

    if (response.statusCode == 200) {
      var decodedResponse = json.decode(response.body);
      var data = decodedResponse['data'];

      // Clear previous data
      songHistory.clear();
      playlistHistory.clear();

      // Separate songs and playlists
      for (var item in data) {
        if (item['type'] == 'song') {
          songHistory.add(item);
        } else if (item['type'] == 'playlist') {
          playlistHistory.add(item);
        }
      }
    } else {
      print('Failed to fetch history: ${response.statusCode}');
    }

    isLoading.value = false;
  }
}
