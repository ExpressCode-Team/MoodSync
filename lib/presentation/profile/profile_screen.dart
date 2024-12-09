import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:mood_sync/core/config/assets/app_images.dart';
import 'package:mood_sync/core/config/theme/app_colors.dart';
import 'package:mood_sync/core/config/theme/app_text_style.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _secureStorage = const FlutterSecureStorage();
  String userName = 'User'; // Default value

  @override
  void initState() {
    super.initState();
    fetchUserName();
  }

  Future<void> fetchUserName() async {
    try {
      // Retrieve access token from secure storage
      String? accessToken = await _secureStorage.read(key: 'accessToken');
      if (accessToken == null) {
        throw Exception('Access token not found');
      }

      // Make request to Spotify API
      final response = await http.get(
        Uri.parse('https://api.spotify.com/v1/me'),
        headers: {
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          userName = data['display_name'] ?? 'User';
        });
      } else {
        throw Exception('Failed to fetch user data: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching user name: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
          child: SingleChildScrollView(
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
                          colors: [AppColors.primary, Colors.black])),
                ),
                Center(
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 42,
                      ),
                      const Stack(
                        alignment: Alignment.center,
                        children: [
                          CircleAvatar(
                            radius: 60,
                            backgroundImage: AssetImage(AppImages.happyEmot),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        userName,
                        style: AppTextStyle.title1,
                      ),
                      const SizedBox(height: 12),
                      Padding(
                        padding: EdgeInsets.all(
                            MediaQuery.of(context).size.width * 0.08),
                        child: Container(
                          padding: const EdgeInsets.only(top: 14, bottom: 14),
                          decoration: BoxDecoration(
                            color: AppColors.grayBackground,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              _buildMenuItem(
                                icon: Icons.headset_mic,
                                title: 'Contact Us',
                                onTap: () {},
                              ),
                              _buildDivider(),
                              _buildMenuItem(
                                icon: Icons.info_outline,
                                title: 'About Us',
                                onTap: () {},
                              ),
                              _buildDivider(),
                              _buildMenuItem(
                                icon: Icons.privacy_tip_outlined,
                                title: 'Log out',
                                onTap: () {},
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ],
        ),
      )),
    );
  }

  Widget _buildMenuItem(
      {required IconData icon,
      required String title,
      required VoidCallback onTap}) {
    return ListTile(
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
            color: Colors.green.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12)),
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

  Widget _buildDivider() {
    return const Divider(
      color: Colors.grey,
      thickness: 0.5,
      indent: 16,
      endIndent: 16,
    );
  }
}
