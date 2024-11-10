import 'package:flutter/material.dart';
import 'package:mood_sync/core/config/theme/app_text_style.dart';

class RecapEmotionCard extends StatelessWidget {
  final String emotion;
  final String time;
  final String message;
  const RecapEmotionCard(
      {super.key,
      required this.emotion,
      required this.time,
      required this.message});

  @override
  Widget build(BuildContext context) {
    Color avatarColor;
    IconData avatarIcon;
    String displayEmotion;

    switch (emotion.toLowerCase()) {
      case 'happy':
        avatarColor = Colors.yellow;
        avatarIcon = Icons.sentiment_satisfied;
        displayEmotion = 'Happy';
        break;
      case 'sad':
        avatarColor = Colors.blue;
        avatarIcon = Icons.sentiment_dissatisfied;
        displayEmotion = 'Sad';
        break;
      case 'angry':
        avatarColor = Colors.red;
        avatarIcon = Icons.sentiment_very_dissatisfied;
        displayEmotion = 'Angry';
        break;
      case 'neutral':
      default:
        avatarColor = Colors.grey;
        avatarIcon = Icons.sentiment_neutral;
        displayEmotion = 'Neutral';
        break;
    }

    return ListTile(
      leading: CircleAvatar(
        backgroundColor: avatarColor,
        child: Icon(avatarIcon, color: Colors.white),
      ),
      title: Text(displayEmotion, style: AppTextStyle.caption1),
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
