import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:mood_sync/app/core/assets/app_images.dart';
import 'package:mood_sync/app/core/assets/app_vectors.dart';
import 'package:mood_sync/app/core/theme/app_colors.dart';
import 'package:mood_sync/app/core/theme/app_text_style.dart';

import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Obx(() {
              final backgroundImage = controller.backgroundImages.isEmpty
                  ? const AssetImage(AppImages.introBG)
                  : NetworkImage(controller
                      .backgroundImages[controller.currentImageIndex.value]);
              return AnimatedSwitcher(
                duration: const Duration(seconds: 1),
                child: Container(
                  key: ValueKey<String>(controller.backgroundImages.isEmpty
                      ? AppImages.introBG
                      : controller.backgroundImages[
                          controller.currentImageIndex.value]),
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: backgroundImage as ImageProvider,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              );
            }),
            Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: FractionalOffset.bottomCenter,
                  end: FractionalOffset.topCenter,
                  colors: [
                    Colors.black.withOpacity(0.5),
                    Colors.black.withOpacity(0.5),
                  ],
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 40),
              child: Column(
                children: [
                  SvgPicture.asset(AppVectors.logo),
                  const Spacer(),
                  const Text(
                    'Music for Mood',
                    style: TextStyle(
                      fontSize: 24,
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Connect to a new way of listening—where every song is chosen by your expressions and tuned perfectly to your current vibe.',
                    style: AppTextStyle.bodyText,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: controller.isLoading.value
                        ? null // Disables the button while loading
                        : () async {
                            await controller.getAccesToken();
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      minimumSize: const Size.fromHeight(72),
                      textStyle: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Montserrat',
                          color: Colors.white),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: Obx(() => controller.isLoading.value
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text('Login with Spotify')),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
