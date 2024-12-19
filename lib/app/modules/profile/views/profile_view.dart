import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mood_sync/app/core/assets/app_images.dart';
import 'package:mood_sync/app/core/consts/constants.dart';
import 'package:mood_sync/app/core/theme/app_colors.dart';
import 'package:mood_sync/app/core/theme/app_text_style.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';

import '../controllers/profile_controller.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final ProfileController controller = Get.put(ProfileController());

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: Text('Profile', style: AppTextStyle.title1),
      ),
      body: Obx(() {
        // Jika sedang loading, tampilkan shimmer
        if (controller.isLoading.value) {
          return const _ShimmerProfile();
        }
        return SafeArea(
          child: Column(
            children: [
              Stack(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height * 0.35,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [AppColors.primary, Colors.black],
                      ),
                    ),
                  ),
                  Center(
                    child: Column(
                      children: [
                        const SizedBox(height: 42),
                        CircleAvatar(
                          radius: 60,
                          backgroundImage: controller.imageUrl.value != null
                              ? NetworkImage(controller.imageUrl.value!)
                              : const AssetImage(AppImages.happyEmot)
                                  as ImageProvider,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          controller.displayName.value,
                          style: AppTextStyle.title1,
                        ),
                        const SizedBox(height: 12),
                        Padding(
                          padding: EdgeInsets.all(
                              MediaQuery.of(context).size.width * 0.08),
                          child: _MenuItems(controller: controller),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      }),
    );
  }
}

class _MenuItems extends StatelessWidget {
  final ProfileController controller;

  const _MenuItems({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 14, bottom: 14),
      decoration: BoxDecoration(
        color: AppColors.grayBackground,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          _MenuItem(
            icon: Icons.headset_mic,
            title: 'Contact Us',
            onTap: () {},
          ),
          _buildDivider(),
          _MenuItem(
            icon: Icons.info_outline,
            title: 'About Us',
            onTap: () {
              launchUrl(Uri.parse(Constants.BASE_URL_LARAVEL),
                  mode: LaunchMode.inAppBrowserView);
            },
          ),
          _buildDivider(),
          _MenuItem(
            icon: Icons.logout,
            title: 'Log out',
            onTap: () {
              controller.logout();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return const Divider(
      color: Colors.grey,
      thickness: 0.5,
      indent: 16,
      endIndent: 16,
    );
  }
}

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _MenuItem({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.green.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(
          icon,
          color: Colors.green,
        ),
      ),
      title: Text(
        title,
        style: AppTextStyle.headline2,
      ),
      trailing: const Icon(
        Icons.arrow_forward_ios,
        color: Colors.grey,
        size: 16,
      ),
      onTap: onTap,
    );
  }
}

class _ShimmerProfile extends StatelessWidget {
  const _ShimmerProfile();

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircleAvatar(
            radius: 60,
            backgroundColor: Colors.white,
          ),
          const SizedBox(height: 12),
          Container(
            width: 150,
            height: 20,
            color: Colors.white,
          ),
          const SizedBox(height: 12),
          Container(
            width: 250,
            height: 20,
            color: Colors.white,
          ),
        ],
      ),
    );
  }
}
