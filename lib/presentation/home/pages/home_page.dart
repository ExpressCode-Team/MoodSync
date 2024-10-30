import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:mood_sync/common/widgets/card/emotion_card.dart';
import 'package:mood_sync/common/widgets/fab/fab_face_reg.dart';
import 'package:mood_sync/common/widgets/navbar/bottom_navbar_app.dart';
import 'package:mood_sync/core/config/assets/app_vectors.dart';
import 'package:mood_sync/core/config/theme/app_colors.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  final List<String> _locations = ['/home', '/search', '/playlist', '/profile'];

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
    context.go(_locations[index]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.darkBackground,
        title: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
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
                        content: Text('this is settings button')));
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
            EmotionCard(),
            SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
      floatingActionButton: FabFaceReg(
        onPressed: () {
          context.push('/camera-page');
          // ScaffoldMessenger.of(context).showSnackBar(
          //   const SnackBar(content: Text('Open Camera')),
          // );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar:
          BottomNavbarApp(currentIndex: _currentIndex, onTap: _onItemTapped),
    );
  }
}

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Search Screen'),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Profile Screen'),
    );
  }
}
