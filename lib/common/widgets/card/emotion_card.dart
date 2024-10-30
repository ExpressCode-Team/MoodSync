import 'package:flutter/material.dart';
import 'package:mood_sync/core/config/assets/app_images.dart';
import 'package:mood_sync/core/config/theme/app_text_style.dart';

class EmotionCard extends StatelessWidget {
  const EmotionCard({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 152,
      child: Stack(
        children: [
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 130,
              width: double.infinity,
              decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 7, 82, 255),
                  borderRadius: BorderRadius.all(Radius.circular(12))),
              child: const Padding(
                padding: EdgeInsets.all(21),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Your mood \nat the moment',
                      style: AppTextStyle.headline1,
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Text(
                      'Netral',
                      style: AppTextStyle.title1,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.only(right: 12),
              child: Image.asset(AppImages.emotionImg),
            ),
          )
        ],
      ),
    );
  }
}
