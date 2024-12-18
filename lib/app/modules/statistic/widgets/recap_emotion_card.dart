import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mood_sync/app/core/assets/app_images.dart';
import 'package:mood_sync/app/core/theme/app_colors.dart';
import 'package:mood_sync/app/core/theme/app_text_style.dart';

class RecapEmotionCard extends StatelessWidget {
  final int expressionId;
  final DateTime dateTime;

  const RecapEmotionCard({
    super.key,
    required this.expressionId,
    required this.dateTime,
  });

  @override
  Widget build(BuildContext context) {
    Color avatarColor;
    String avatarImage;
    String emotionLabel;

    switch (expressionId) {
      case 1:
        avatarColor = AppColors.happyBg;
        avatarImage = AppImages.happyEmot;
        emotionLabel = 'Happy';
        break;
      case 2:
        avatarColor = AppColors.calmBg;
        avatarImage = AppImages.calmEmot;
        emotionLabel = 'Neutral';
        break;
      case 3:
        avatarColor = AppColors.sadBg;
        avatarImage = AppImages.sadEmot;
        emotionLabel = 'Sad';
        break;
      case 0:
      default:
        avatarColor = AppColors.angerBg;
        avatarImage = AppImages.angerEmot;
        emotionLabel = 'Angry';
        break;
    }

    // Format the date and time for WIB
    String formattedDate = DateFormat('dd MMM yyyy').format(dateTime);
    String formattedTime = DateFormat('HH:mm').format(dateTime);

    return ListTile(
      leading: CircleAvatar(
        backgroundColor: avatarColor,
        child: Image.asset(avatarImage),
      ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(emotionLabel, style: AppTextStyle.caption1),
          Text(formattedDate, style: AppTextStyle.caption1),
        ],
      ),
      subtitle: Text(
        formattedTime,
        style: const TextStyle(color: Colors.white70),
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16.0),
      tileColor: Colors.grey[900],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    );
  }
}
