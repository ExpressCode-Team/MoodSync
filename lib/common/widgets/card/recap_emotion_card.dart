import 'package:flutter/material.dart';
import 'package:mood_sync/core/config/theme/app_text_style.dart';

class RecapEmotionCard extends StatelessWidget {
  final int expressionId;
  final String time;
  final String message;

  const RecapEmotionCard({
    super.key,
    required this.expressionId,
    required this.time,
    required this.message, required String emotion,
  });

  @override
  Widget build(BuildContext context) {
    Color avatarColor;
    IconData avatarIcon;
    String emotionLabel;

    switch (expressionId) {
      case 1:
        avatarColor = Colors.yellow;
        avatarIcon = Icons.sentiment_satisfied;
        emotionLabel = 'Happy';
        break;
      case 2:
        avatarColor = Colors.blue;
        avatarIcon = Icons.sentiment_dissatisfied;
        emotionLabel = 'Sad';
        break;
      case 3:
        avatarColor = Colors.red;
        avatarIcon = Icons.sentiment_very_dissatisfied;
        emotionLabel = 'Angry';
        break;
      case 0:
      default:
        avatarColor = Colors.grey;
        avatarIcon = Icons.sentiment_neutral;
        emotionLabel = 'Neutral';
        break;
    }

    return ListTile(
      leading: CircleAvatar(
        backgroundColor: avatarColor,
        child: Icon(avatarIcon, color: Colors.white),
      ),
      title: Text(emotionLabel, style: AppTextStyle.caption1),
      subtitle: Text(
        '$time - $message',
        style: const TextStyle(color: Colors.white70),
      ),
      isThreeLine: true,
      contentPadding:
          const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      tileColor: Colors.grey[900],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    );
  }
}
