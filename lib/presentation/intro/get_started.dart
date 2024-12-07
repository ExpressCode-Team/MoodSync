import 'dart:async';
import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:mood_sync/common/widgets/button/basic_app_button.dart';
import 'package:mood_sync/core/config/assets/app_images.dart';
import 'package:mood_sync/core/config/assets/app_vectors.dart';
import 'package:mood_sync/core/config/env/env_config.dart';
import 'package:mood_sync/core/config/theme/app_colors.dart';
import 'package:mood_sync/core/config/theme/app_text_style.dart';
import 'package:spotify_sdk/spotify_sdk.dart';

class GetStartedPage extends StatefulWidget {
  const GetStartedPage({super.key});

  @override
  State<GetStartedPage> createState() => _GetStartedPageState();
}

class _GetStartedPageState extends State<GetStartedPage> {
  final bool _connected = false;
  String? _accessToken;
  final _secureStorage = const FlutterSecureStorage();

  List<String> _backgroundImages = [];
  int _currentImageIndex = 0;
  Timer? _imageSwitchTimer;

  @override
  void initState() {
    super.initState();
    _fetchImages();
  }

  @override
  void dispose() {
    _imageSwitchTimer?.cancel();
    super.dispose();
  }

  Future<void> _fetchImages() async {
    try {
      // Fetch access token
      final tokenResponse = await http.get(Uri.parse(
          'https://open.spotify.com/get_access_token?reason=transport&productType=web_player'));
      final tokenData = json.decode(tokenResponse.body);
      final token = tokenData['accessToken'];
      print('non-auth access token: $token');

      // Fetch images
      final response = await http.get(
        Uri.parse(
            'https://api.spotify.com/v1/search?q=genre%3Apop&type=artist&market=ID'),
        headers: {'Authorization': 'Bearer $token'},
      );
      final data = json.decode(response.body);

      final items = data['artists']['items'] as List;
      final images = items
          .where((item) =>
              item['images'] != null &&
              (item['images'] as List).isNotEmpty &&
              item['name'] != "SZA") // filter items yang tidak kosong
          .map<String>((item) => item['images'][0]['url'] as String)
          .toList();

      if (images.isNotEmpty) {
        setState(() {
          _backgroundImages = images;
        });
        _startImageTransition();
      }
    } catch (e) {
      print('Error fetching images: $e');
    }
  }

  void _startImageTransition() {
    _imageSwitchTimer = Timer.periodic(const Duration(seconds: 5), (_) {
      setState(() {
        _currentImageIndex =
            (_currentImageIndex + 1) % _backgroundImages.length;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final backgroundImage = _backgroundImages.isEmpty
        ? const AssetImage(AppImages.introBG)
        : CachedNetworkImageProvider(_backgroundImages[_currentImageIndex]);

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            AnimatedSwitcher(
              duration: const Duration(seconds: 1),
              child: Container(
                key: ValueKey<String>(_backgroundImages.isEmpty
                    ? AppImages.introBG
                    : _backgroundImages[_currentImageIndex]),
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: backgroundImage as ImageProvider,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
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
                  BasicAppButton(
                    onPressed: getAccessToken,
                    title: 'Login with Spotify',
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> getAccessToken() async {
    try {
      var authenticationToken = await SpotifySdk.getAccessToken(
        clientId: EnvConfig.CLIENT_ID,
        redirectUrl: EnvConfig.REDIRECT_URI,
        scope: EnvConfig.SPOTIFY_GLOBAL_SCOPE,
      );
      await _secureStorage.write(
          key: 'accessToken', value: authenticationToken);
      if (!mounted) {
        return; // memastikan widget masih valid sebelum mengakses context
      }
      setState(() {
        _accessToken = authenticationToken;
      });
      print('access_token $authenticationToken');
      context.go('/choose-genre');
    } on PlatformException catch (e) {
      setState(() {
        _accessToken = '$e.code: ${e.message}';
      });
    } on MissingPluginException {
      setState(() {
        _accessToken = 'not implemented';
      });
    }
  }
}
