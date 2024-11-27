import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
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
                      onPressed: getAccessToken,
                      title: 'Login with Spotify',
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    )
                  ],
                )),
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
      context.go('/homepage');
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
