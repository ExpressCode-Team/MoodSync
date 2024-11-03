import 'package:flutter/material.dart';
import 'package:mood_sync/core/config/theme/app_colors.dart';

class BottomNavbarApp extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const BottomNavbarApp(
      {super.key, required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      height: 60,
      color: AppColors.grayBackground,
      shape: const CircularNotchedRectangle(),
      notchMargin: 5,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          IconButton(
            icon: Icon(
              Icons.home,
              color: currentIndex == 0 ? AppColors.primary : Colors.white,
            ),
            onPressed: () => onTap(0),
          ),
          IconButton(
            icon: Icon(
              Icons.search,
              color: currentIndex == 1 ? AppColors.primary : Colors.white,
            ),
            onPressed: () => onTap(1),
          ),
          const SizedBox(width: 48),
          IconButton(
            icon: Icon(
              Icons.playlist_play,
              color: currentIndex == 2 ? AppColors.primary : Colors.white,
            ),
            onPressed: () => onTap(2),
          ),
          IconButton(
            icon: Icon(
              Icons.person,
              color: currentIndex == 3 ? AppColors.primary : Colors.white,
            ),
            onPressed: () => onTap(3),
          ),
        ],
      ),
    );
  }
}
