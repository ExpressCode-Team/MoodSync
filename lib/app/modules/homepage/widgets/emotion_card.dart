import 'package:flutter/material.dart';
import 'package:mood_sync/app/core/assets/app_images.dart';
import 'package:mood_sync/app/core/theme/app_colors.dart';
import 'package:mood_sync/app/core/theme/app_text_style.dart';

class EmotionCard extends StatelessWidget {
  final String emotion;
  const EmotionCard({super.key, required this.emotion});

  String capitalize(String s) {
    if (s.isEmpty) return s;
    return s[0].toUpperCase() + s.substring(1).toLowerCase();
  }

  @override
  Widget build(BuildContext context) {
    Color backgroundColor;
    String imageAsset;
    String emotionState = capitalize(emotion);

    // Kondisi untuk "No history recorded yet"
    if (emotion == "No history recorded yet") {
      backgroundColor =
          const Color.fromARGB(255, 192, 192, 192); // Warna netral
      imageAsset = AppImages.calmEmot;

      return SizedBox(
        height: MediaQuery.of(context).size.height * 0.20,
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: const BorderRadius.all(Radius.circular(12)),
          ),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  imageAsset,
                  height: MediaQuery.of(context).size.height * 0.10,
                ),
                const SizedBox(height: 8), // Jarak antar ikon dan teks
                Text(
                  emotion,
                  style: AppTextStyle.caption1,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      );
    }

    // Tampilan default untuk emotion lainnya
    switch (emotion.toLowerCase()) {
      case 'happy':
        backgroundColor = AppColors.happyBg;
        imageAsset = AppImages.happyEmot;
        break;
      case 'sad':
        backgroundColor = AppColors.sadBg;
        imageAsset = AppImages.sadEmot;
        break;
      case 'angry':
        backgroundColor = AppColors.angerBg;
        imageAsset = AppImages.angerEmot;
        break;
      default:
        backgroundColor = AppColors.calmBg;
        imageAsset = AppImages.calmEmot;
        break;
    }

    double cardHeight = MediaQuery.of(context).size.height * 0.20;

    return SizedBox(
      height: cardHeight,
      child: Stack(
        children: [
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: const BorderRadius.all(Radius.circular(12)),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * 0.05,
                  vertical: 16,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Your last emotion',
                      style: AppTextStyle.headline1,
                    ),
                    Text(
                      emotionState,
                      style: AppTextStyle.title1,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: EdgeInsets.only(
                  right: MediaQuery.of(context).size.width * 0.10),
              child: Image.asset(imageAsset),
            ),
          ),
        ],
      ),
    );
  }
}
