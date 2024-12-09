import 'dart:convert';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:mood_sync/common/widgets/card/recap_emotion_card.dart';
import 'package:mood_sync/core/config/assets/app_images.dart';
import 'package:mood_sync/core/config/env/env_config.dart';
import 'package:mood_sync/core/config/theme/app_text_style.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  _StatisticsScreenState createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  final _secureStorage = const FlutterSecureStorage();
  final baseUrl = EnvConfig.BASE_URL_LARAVEL;
  late String apiUrl;
  List<dynamic> jsonData = [];
  bool isLoading = true;
  String errorMessage = '';

  // Pie chart data initialization
  List<int> pieChartValues = [0, 0, 0, 0]; // Initialize with zero values
  int touchedIndex = -1; // Variable to track the touched pie section

  @override
  void initState() {
    super.initState();
    apiUrl = "$baseUrl/api/history-expressions";
    print('apiURL : $apiUrl');
    fetchHistoryExpressions();
  }

  Future<void> fetchHistoryExpressions() async {
    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    try {
      String? accessToken = await _secureStorage.read(key: 'accessToken');
      if (accessToken == null) {
        throw Exception('Access token not found');
      }

      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'access_token': accessToken,
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> decoded = json.decode(response.body);
        final List<dynamic> data = decoded['data'] ?? [];

        if (data.isEmpty) {
          throw Exception('No data returned from API');
        } else {
          print(data);
        }

        // Update pie chart data based on response
        updatePieChartData(data);

        setState(() {
          jsonData = data;
          isLoading = false;
        });
      } else {
        throw Exception(
            'Failed to load data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = "No emotion recorded";
      });
    }
  }

  String formatDate(String timestamp) {
    final date = DateTime.parse(timestamp);
    return DateFormat('HH:mm - dd-MM-yyyy').format(date);
  }

  // Update pie chart values based on emotion data or other logic
  void updatePieChartData(List<dynamic> data) {
    Map<String, int> emotionCount = {
      'Angry': 0,
      'Happy': 0,
      'Sad': 0,
      'Neutral': 0,
    };

    // Map expression_id ke emosi yang sesuai
    Map<int, String> emotionMapping = {
      0: 'Angry',
      1: 'Happy',
      2: 'Sad',
      3: 'Neutral',
    };

    // Hitung jumlah setiap emosi
    for (var item in data) {
      int expressionId = item['expression_id'] ?? -1;
      if (emotionMapping.containsKey(expressionId)) {
        String emotion = emotionMapping[expressionId]!;
        emotionCount[emotion] = emotionCount[emotion]! + 1;
      }
    }

    // Total semua data
    int total = emotionCount.values.fold(0, (sum, value) => sum + value);

    // Hitung persentase dan update pieChartValues
    setState(() {
      pieChartValues = [
        ((emotionCount['Angry']! / total) * 100).round(),
        ((emotionCount['Happy']! / total) * 100).round(),
        ((emotionCount['Sad']! / total) * 100).round(),
        ((emotionCount['Neutral']! / total) * 100).round(),
      ];
    });
  }

  Widget _buildEmotionIndicator(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("History Expressions", style: AppTextStyle.title1),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Pie Chart Display
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey[900],
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        spreadRadius: 2,
                        blurRadius: 5,
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Pie Chart
                      SizedBox(
                        height: 250,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: PieChart(
                            PieChartData(
                              pieTouchData: PieTouchData(
                                touchCallback:
                                    (FlTouchEvent event, pieTouchResponse) {
                                  setState(() {
                                    if (!event.isInterestedForInteractions ||
                                        pieTouchResponse == null ||
                                        pieTouchResponse.touchedSection ==
                                            null) {
                                      touchedIndex = -1;
                                      return;
                                    }
                                    touchedIndex = pieTouchResponse
                                        .touchedSection!.touchedSectionIndex;
                                  });
                                },
                              ),
                              borderData: FlBorderData(show: false),
                              sectionsSpace: 2,
                              centerSpaceRadius: 0,
                              sections: showingSections(),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Emotion Indicators
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _buildEmotionIndicator('Angry', Colors.red),
                            _buildEmotionIndicator('Happy', Colors.yellow),
                            _buildEmotionIndicator('Sad', Colors.blue),
                            _buildEmotionIndicator('Neutral', Colors.green),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),

                const SizedBox(height: 20),
                // Title for the list of emotion cards
                Text(
                  "Mood History",
                  style: AppTextStyle.headline1,
                ),
                const SizedBox(height: 20),
                // Loading or Error Handling
                if (isLoading)
                  const Center(child: CircularProgressIndicator())
                else if (errorMessage.isNotEmpty)
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          errorMessage,
                          style: AppTextStyle.headline2,
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: fetchHistoryExpressions,
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  )
                else
                  // List of RecapEmotionCard
                  ListView.builder(
                    shrinkWrap: true, // To prevent overflow
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: jsonData.length,
                    itemBuilder: (context, index) {
                      var item = jsonData[index];

                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: RecapEmotionCard(
                          expressionId: item['expression_id'],
                          time:
                              formatDate(item['created_at'] ?? 'Unknown Time'),
                          message: item['message'] ?? '',
                          emotion: item['emotion'] ?? 'Unknown',
                        ),
                      );
                    },
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Function to create the sections for the pie chart with badge and hover effects
  List<PieChartSectionData> showingSections() {
    return List.generate(4, (i) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 20.0 : 16.0;
      final radius = isTouched ? 110.0 : 100.0;
      final widgetSize = isTouched ? 55.0 : 40.0;
      const shadows = [Shadow(color: Colors.black, blurRadius: 2)];

      switch (i) {
        case 0:
          return PieChartSectionData(
            color: Colors.red,
            value: pieChartValues[0].toDouble(),
            title: '${pieChartValues[0]}%',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: const Color(0xffffffff),
              shadows: shadows,
            ),
            badgeWidget: _Badge(
              AppImages.angerEmot,
              size: widgetSize,
              borderColor: Colors.black,
            ),
            badgePositionPercentageOffset: .98,
          );
        case 1:
          return PieChartSectionData(
            color: Colors.yellow,
            value: pieChartValues[1].toDouble(),
            title: '${pieChartValues[1]}%',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: const Color(0xffffffff),
              shadows: shadows,
            ),
            badgeWidget: _Badge(
              AppImages.happyEmot,
              size: widgetSize,
              borderColor: Colors.black,
            ),
            badgePositionPercentageOffset: .98,
          );
        case 2:
          return PieChartSectionData(
            color: Colors.green,
            value: pieChartValues[2].toDouble(),
            title: '${pieChartValues[2]}%',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: const Color(0xffffffff),
              shadows: shadows,
            ),
            badgeWidget: _Badge(
              AppImages.calmEmot,
              size: widgetSize,
              borderColor: Colors.black,
            ),
            badgePositionPercentageOffset: .98,
          );
        case 3:
          return PieChartSectionData(
            color: Colors.blue,
            value: pieChartValues[3].toDouble(),
            title: '${pieChartValues[3]}%',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: const Color(0xffffffff),
              shadows: shadows,
            ),
            badgeWidget: _Badge(
              AppImages.sadEmot,
              size: widgetSize,
              borderColor: Colors.black,
            ),
            badgePositionPercentageOffset: .98,
          );
        default:
          throw Error();
      }
    });
  }
}

class _Badge extends StatelessWidget {
  final String imagePath;
  final double size;
  final Color borderColor;

  const _Badge(this.imagePath, {required this.size, required this.borderColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size,
      width: size,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(size / 2),
        border: Border.all(
          color: borderColor,
          width: 2,
        ),
      ),
      child: Image.asset(
        imagePath, // Ganti ini dengan path gambar Anda
        fit: BoxFit.cover, // Pastikan gambar mengisi badge
      ),
    );
  }
}
