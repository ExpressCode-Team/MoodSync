import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mood_sync/core/config/theme/app_text_style.dart';

class GenreCard extends StatelessWidget {
  final String imageURL;
  final String description;
  final String genreLink;
  const GenreCard(
      {super.key,
      required this.imageURL,
      required this.description,
      required this.genreLink});

  @override
  Widget build(BuildContext context) {
    double imageSize = MediaQuery.of(context).size.width * 0.2;
    return GestureDetector(
      onTap: () {
        context.push('/genre-song/$genreLink');
      },
      child: Column(
        children: [
          ClipOval(
            child: Image.network(
              imageURL,
              width: imageSize,
              height: imageSize,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.width * 0.02),
          Text(
            description,
            style: AppTextStyle.headline1,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
