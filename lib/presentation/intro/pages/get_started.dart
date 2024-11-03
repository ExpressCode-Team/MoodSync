import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:mood_sync/common/widgets/button/basic_app_button.dart';
import 'package:mood_sync/core/config/assets/app_images.dart';
import 'package:mood_sync/core/config/assets/app_vectors.dart';
import 'package:mood_sync/core/config/theme/app_colors.dart';
import 'package:mood_sync/core/config/theme/app_text_style.dart';

class GetStartedPage extends StatelessWidget {
  const GetStartedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(
                      AppImages.introBG,
                    ),
                    alignment: Alignment(0.5, 0.0),
                    fit: BoxFit.cover),
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  color: Colors.white,
                  gradient: LinearGradient(
                      begin: FractionalOffset.bottomCenter,
                      end: FractionalOffset.topCenter,
                      colors: [
                        Colors.black.withOpacity(0.9),
                        Colors.transparent,
                      ],
                      stops: const [
                        0.0,
                        1.0,
                      ])),
            ),
            Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 80,
                  horizontal: 40,
                ),
                child: Column(
                  children: [
                    SvgPicture.asset(
                      AppVectors.logo,
                    ),
                    const Spacer(),
                    const Text(
                      'Music for Mood',
                      style: TextStyle(
                        fontSize: 24,
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Text(
                      'Connect to a new way of listening—where every song is chosen by your expressions and tuned perfectly to your current vibe.',
                      style: AppTextStyle.bodyText,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(
                      height: 32,
                    ),
                    BasicAppButton(
                      onPressed: () {
                        context.go('/signin');
                      },
                      title: 'Get Started',
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    )
                  ],
                )),
          ],
        ),
      ),
    );
  }
}
