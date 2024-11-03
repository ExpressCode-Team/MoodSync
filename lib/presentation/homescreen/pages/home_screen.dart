import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mood_sync/common/widgets/card/emotion_card.dart';
import 'package:mood_sync/core/config/assets/app_vectors.dart';
import 'package:mood_sync/core/config/theme/app_colors.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.darkBackground,
        title: Padding(
          padding: EdgeInsets.symmetric(
              vertical: MediaQuery.of(context).size.height * 0.01,
              horizontal: MediaQuery.of(context).size.width * 0.01),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SvgPicture.asset(
                AppVectors.logo,
                height: AppBar().preferredSize.height * 0.7,
              ),
              IconButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('This is settings button')));
                  },
                  icon: const Icon(
                    Icons.more_vert,
                    color: Colors.white,
                  ))
            ],
          ),
        ),
      ),
      body: const Padding(
        padding: EdgeInsets.fromLTRB(32, 16, 32, 0),
        child: Column(
          children: [
            EmotionCard(
              emotion: 'anger',
            ),
            SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}
