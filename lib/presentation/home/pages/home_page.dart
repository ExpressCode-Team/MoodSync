import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mood_sync/common/widgets/fab/fab_face_reg.dart';
import 'package:mood_sync/common/widgets/navbar/bottom_navbar_app.dart';
import 'package:mood_sync/presentation/homescreen/pages/home_screen.dart';
import 'package:mood_sync/presentation/playlistscreen/pages/playlist_screen.dart';
import 'package:mood_sync/presentation/profile/pages/profile_screen.dart';
import 'package:mood_sync/presentation/searchscreen/pages/search_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const HomeScreen(),
    const SearchScreen(),
    const PlaylistScreen(),
    const ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      floatingActionButton: FabFaceReg(
        onPressed: () {
          context.push('/camera-page');
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomNavbarApp(
        currentIndex: _currentIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
