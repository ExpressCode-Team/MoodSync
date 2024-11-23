import 'package:flutter/material.dart';
import 'package:mood_sync/common/widgets/card/recap_emotion_card.dart';
import 'package:mood_sync/core/config/theme/app_colors.dart';
import 'package:mood_sync/core/config/theme/app_text_style.dart';
import 'package:pie_chart/pie_chart.dart';

class StatisticsScreen extends StatelessWidget {
  final Map<String, double> dataMap = {
    "angry": 19,
    "neutral": 32,
    "happy": 29,
    "sad": 12,
  };

  final List<Color> colorList = [
    Colors.red,
    Colors.green,
    Colors.yellow,
    Colors.blue,
  ];

  final List<Map<String, String>> recapData = [
    {
      "emotion": "happy",
      "time": "18:30",
      "message": "You felt happy at that time"
    },
    {
      "emotion": "sad",
      "time": "10:15",
      "message": "You seemed sad at that time"
    },
    {
      "emotion": "angry",
      "time": "20:10",
      "message": "You seemed angry at that time"
    },
    {
      "emotion": "neutral",
      "time": "14:45",
      "message": "You were neutral at that time"
    },
    {
      "emotion": "happy",
      "time": "09:00",
      "message": "You felt happy in the morning"
    },
  ];

  StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(
              MediaQuery.of(context).size.width * 0.06,
              MediaQuery.of(context).size.height * 0.03,
              MediaQuery.of(context).size.width * 0.06,
              0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'History',
                  style: AppTextStyle.title1,
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.grayBackground,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: PieChart(
                    dataMap: dataMap,
                    animationDuration: const Duration(milliseconds: 800),
                    chartRadius: MediaQuery.of(context).size.width / 2.5,
                    colorList: colorList,
                    chartType: ChartType.disc,
                    legendOptions: const LegendOptions(
                      showLegendsInRow: true,
                      legendPosition: LegendPosition.bottom,
                      showLegends: true,
                      legendTextStyle: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    chartValuesOptions: const ChartValuesOptions(
                      showChartValueBackground: true,
                      showChartValuesInPercentage: true,
                      showChartValuesOutside: false,
                      decimalPlaces: 0,
                      chartValueStyle: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'Recap',
                  style: AppTextStyle.headline1,
                ),
                const SizedBox(height: 12),
                // Column(
                //   children: recapData.map((data) {
                //     return RecapEmotionCard(
                //       emotion: data["emotion"]!,
                //       time: data["time"]!,
                //       message: data["message"]!,
                //     );
                //   }).toList(),
                // ),
                Column(
                  children: List.generate(recapData.length, (index) {
                    return Column(
                      children: [
                        RecapEmotionCard(
                          emotion: recapData[index]["emotion"]!,
                          time: recapData[index]["time"]!,
                          message: recapData[index]["message"]!,
                        ),
                        // SizedBox untuk memberikan gap di antara kartu, kecuali pada item terakhir
                        if (index < recapData.length - 1)
                          const SizedBox(height: 12),
                      ],
                    );
                  }),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
