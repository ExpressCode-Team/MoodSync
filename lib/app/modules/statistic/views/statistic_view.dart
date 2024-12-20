import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mood_sync/app/core/assets/app_images.dart';
import 'package:mood_sync/app/core/theme/app_colors.dart';
import 'package:mood_sync/app/core/theme/app_text_style.dart';
import 'package:mood_sync/app/modules/statistic/widgets/recap_emotion_card.dart';

import '../controllers/statistic_controller.dart';

class StatisticView extends GetView<StatisticController> {
  const StatisticView({super.key});

  @override
  Widget build(BuildContext context) {
    final StatisticController controller = Get.put(StatisticController());
    return Scaffold(
      appBar: AppBar(
        title: Text("History Expressions", style: AppTextStyle.title1),
      ),
      body: SafeArea(
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          if (controller.errorMessage.isNotEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(controller.errorMessage.value,
                      style: AppTextStyle.headline2),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: controller.fetchHistoryExpressions,
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  PieChartWidget(controller: controller),
                  const SizedBox(height: 20),
                  Text("Mood history", style: AppTextStyle.headline1),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: controller.jsonData.length,
                    itemBuilder: (context, index) {
                      var item = controller.jsonData[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: RecapEmotionCard(
                          expressionId: item['expression_id'],
                          dateTime: DateTime.parse(item['created_at'] ?? ''),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  String formatDate(String timestamp) {
    final date = DateTime.parse(timestamp);
    return DateFormat('HH:mm - dd-MM-yyyy').format(date);
  }
}

class PieChartWidget extends StatelessWidget {
  final StatisticController controller;

  const PieChartWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
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
          SizedBox(
            height: 250,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: PieChart(
                PieChartData(
                  pieTouchData: PieTouchData(
                    touchCallback: (FlTouchEvent event, pieTouchResponse) {
                      if (!event.isInterestedForInteractions ||
                          pieTouchResponse == null ||
                          pieTouchResponse.touchedSection == null) {
                        controller.touchedIndex.value = -1;
                        return;
                      }
                      controller.touchedIndex.value =
                          pieTouchResponse.touchedSection!.touchedSectionIndex;
                    },
                  ),
                  borderData: FlBorderData(show: false),
                  sectionsSpace: 2,
                  centerSpaceRadius: 0,
                  sections: showingSections(controller),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          const EmotionIndicators(),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  List<PieChartSectionData> showingSections(StatisticController controller) {
    return List.generate(4, (i) {
      final isTouched = i == controller.touchedIndex.value;
      final fontSize = isTouched ? 20.0 : 16.0;
      final radius = isTouched ? 110.0 : 100.0;

      switch (i) {
        case 0:
          return PieChartSectionData(
            color: AppColors.angerBg,
            value: controller.pieChartValues[0].toDouble(),
            title: '${controller.pieChartValues[0]}%',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: const Color(0xffffffff),
            ),
            badgeWidget: const _Badge(AppImages.angerEmot,
                size: 40,
                borderColor: Colors.transparent,
                backgroundColor: AppColors.angerBg),
            badgePositionPercentageOffset: .98,
          );
        case 1:
          return PieChartSectionData(
            color: AppColors.happyBg,
            value: controller.pieChartValues[1].toDouble(),
            title: '${controller.pieChartValues[1]}%',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: const Color(0xffffffff),
            ),
            badgeWidget: const _Badge(AppImages.happyEmot,
                size: 40,
                borderColor: Colors.transparent,
                backgroundColor: AppColors.happyBg),
            badgePositionPercentageOffset: .98,
          );
        case 2:
          return PieChartSectionData(
            color: AppColors.calmBg,
            value: controller.pieChartValues[2].toDouble(),
            title: '${controller.pieChartValues[2]}%',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: const Color(0xffffffff),
            ),
            badgeWidget: const _Badge(AppImages.calmEmot,
                size: 40,
                borderColor: Colors.transparent,
                backgroundColor: AppColors.calmBg),
            badgePositionPercentageOffset: .98,
          );
        case 3:
          return PieChartSectionData(
            color: AppColors.sadBg,
            value: controller.pieChartValues[3].toDouble(),
            title: '${controller.pieChartValues[3]}%',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: const Color(0xffffffff),
            ),
            badgeWidget: const _Badge(AppImages.sadEmot,
                size: 40,
                borderColor: Colors.transparent,
                backgroundColor: AppColors.sadBg),
            badgePositionPercentageOffset: .98,
          );
        default:
          throw Error();
      }
    });
  }
}

class EmotionIndicators extends StatelessWidget {
  const EmotionIndicators({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildEmotionIndicator('Angry', AppColors.angerBg),
          _buildEmotionIndicator('Happy', AppColors.happyBg),
          _buildEmotionIndicator('Sad', AppColors.sadBg),
          _buildEmotionIndicator('Neutral', AppColors.calmBg),
        ],
      ),
    );
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
}

class _Badge extends StatelessWidget {
  final String imagePath;
  final double size;
  final Color borderColor;
  final Color backgroundColor;

  const _Badge(this.imagePath,
      {required this.size,
      required this.borderColor,
      required this.backgroundColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size,
      width: size,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(size / 2),
        border: Border.all(
          color: borderColor,
          width: 2,
        ),
      ),
      child: Image.asset(
        imagePath,
        fit: BoxFit.cover,
      ),
    );
  }
}
