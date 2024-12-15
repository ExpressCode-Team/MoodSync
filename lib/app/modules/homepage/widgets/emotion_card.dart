import 'package:flutter/material.dart';
import 'package:mood_sync/app/core/assets/app_images.dart';
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

    switch (emotion.toLowerCase()) {
      case 'happy':
        backgroundColor = const Color.fromARGB(255, 255, 223, 0);
        imageAsset = AppImages.happyEmot;
        break;
      case 'sad':
        backgroundColor = const Color.fromARGB(255, 40, 40, 255);
        imageAsset = AppImages.sadEmot;
        break;
      case 'angry':
        backgroundColor = const Color.fromARGB(255, 255, 0, 0);
        imageAsset = AppImages.angerEmot;
        break;
      default:
        backgroundColor = const Color.fromARGB(255, 128, 128, 128);
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
                color: backgroundColor, //backgroundColor
                borderRadius: const BorderRadius.all(Radius.circular(12)),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * 0.05,
                    vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Your last emotion',
                      style: AppTextStyle.headline1,
                    ),
                    // const SizedBox(
                    //   height: 8,
                    // ),
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
