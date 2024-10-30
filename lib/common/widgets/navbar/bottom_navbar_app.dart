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
            icon: const Icon(
              Icons.menu,
              color: Colors.white,
            ),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Menu button pressed')),
              );
            },
          ),
          IconButton(
            icon: const Icon(
              Icons.search,
              color: Colors.white,
            ),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Search button pressed')),
              );
            },
          ),
          const SizedBox(width: 48),
          IconButton(
            icon: const Icon(
              Icons.playlist_play,
              color: Colors.white,
            ),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Print button pressed')),
              );
            },
          ),
          IconButton(
            icon: const Icon(
              Icons.person,
              color: Colors.white,
            ),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('People button pressed')),
              );
            },
          ),
        ],
      ),
    );
  }
}
