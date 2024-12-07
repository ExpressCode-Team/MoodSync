import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:mood_sync/core/config/theme/app_colors.dart';
import 'package:mood_sync/core/config/theme/app_text_style.dart';
import 'package:mood_sync/common/widgets/card/recap_emotion_card.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  _StatisticsScreenState createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  final _secureStorage = const FlutterSecureStorage();
  // sesuaikan ip
  final String apiUrl = "http://192.168.0.171:8000/api/history-expressions";
  List<dynamic> jsonData = [];
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
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
        }

        setState(() {
          jsonData = data;
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = e.toString();
      });
    }
  }

  String formatDate(String timestamp) {
    final date = DateTime.parse(timestamp);
    return DateFormat('HH:mm - dd-MM-yyyy').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Statistics"),
        backgroundColor: AppColors.primary,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Mood Statistics",
                style: AppTextStyle.headline1,
              ),
              const SizedBox(height: 20),
              if (isLoading)
                const Center(child: CircularProgressIndicator())
              else if (errorMessage.isNotEmpty)
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Error: $errorMessage',
                      style: const TextStyle(color: Colors.red),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: fetchHistoryExpressions,
                      child: const Text('Retry'),
                    ),
                  ],
                )
              else
                Expanded(
                  child: ListView.builder(
                    itemCount: jsonData.length,
                    itemBuilder: (context, index) {
                      var item = jsonData[index];

                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: RecapEmotionCard(
                          expressionId: item['expression_id'],
                          time: formatDate(item['created_at'] ?? 'Unknown Time'),
                          message: item['message'] ?? '', emotion: '',
                        ),
                      );
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
