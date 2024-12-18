import 'dart:convert';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import '../../../core/consts/constants.dart';

class StatisticController extends GetxController {
  final getStorage = GetStorage();
  final baseUrl = Constants.BASE_URL_LARAVEL;
  late String apiUrl;

  var jsonData = <dynamic>[].obs;
  var isLoading = true.obs;
  var errorMessage = ''.obs;

  // Pie chart data
  var pieChartValues = [0, 0, 0, 0].obs; // Observable list
  var touchedIndex = (-1).obs; // Observable for touched pie section

  @override
  void onInit() {
    super.onInit();
    apiUrl = "$baseUrl/api/history-expressions";
    fetchHistoryExpressions();
  }

  Future<void> fetchHistoryExpressions() async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      final accessToken = getStorage.read('accessToken');
      if (accessToken == null) {
        throw Exception('Access token not found');
      }

      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {'access_token': accessToken},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> decoded = json.decode(response.body);
        final List<dynamic> data = decoded['data'] ?? [];

        if (data.isEmpty) {
          throw Exception('No data returned from API');
        }

        updatePieChartData(data);
        jsonData.assignAll(data); // Update observable list
      } else {
        throw Exception(
            'Failed to load data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      errorMessage.value = "No emotion recorded";
    } finally {
      isLoading.value = false;
    }
  }

  void updatePieChartData(List<dynamic> data) {
    Map<String, int> emotionCount = {
      'Angry': 0,
      'Happy': 0,
      'Sad': 0,
      'Neutral': 0,
    };

    Map<int, String> emotionMapping = {
      0: 'Angry',
      1: 'Happy',
      2: 'Sad',
      3: 'Neutral',
    };

    for (var item in data) {
      int expressionId = item['expression_id'] ?? -1;
      if (emotionMapping.containsKey(expressionId)) {
        String emotion = emotionMapping[expressionId]!;
        emotionCount[emotion] = emotionCount[emotion]! + 1;
      }
    }

    int total = emotionCount.values.fold(0, (sum, value) => sum + value);

    // Update pie chart values
    pieChartValues.assignAll([
      ((emotionCount['Angry']! / total) * 100).round(),
      ((emotionCount['Happy']! / total) * 100).round(),
      ((emotionCount['Sad']! / total) * 100).round(),
      ((emotionCount['Neutral']! / total) * 100).round(),
    ]);
  }
}
