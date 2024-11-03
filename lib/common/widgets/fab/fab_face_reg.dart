import 'package:flutter/material.dart';
import 'package:mood_sync/core/config/assets/app_images.dart';
import 'package:mood_sync/core/config/theme/app_colors.dart';

class FabFaceReg extends StatelessWidget {
  final VoidCallback onPressed;
  const FabFaceReg({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 62,
        height: 62,
        decoration: const BoxDecoration(
          color: Colors.grey, // Warna latar belakang abu-abu tua
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Container(
            width: 56,
            height: 56,
            decoration: const BoxDecoration(
              color: AppColors.primary, // Warna lingkaran dalam hijau
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Image.asset(AppImages.faceRecogIcon),
            ),
          ),
        ),
      ),
    );
  }
}
