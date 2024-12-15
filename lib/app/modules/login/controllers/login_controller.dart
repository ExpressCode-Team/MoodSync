import 'dart:async';
import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:mood_sync/app/modules/login/services/unofficial_spotify_service.dart';
import 'package:mood_sync/app/routes/app_pages.dart';
import 'package:spotify_sdk/spotify_sdk.dart';

class LoginController extends GetxController {
  //TODO: Implement LoginController
  final UnofficialSpotifyService _unofficialSpotifyService =
      UnofficialSpotifyService();
  final _secureStorage = const FlutterSecureStorage();
  final getStorage = GetStorage();

  RxBool isConnected = false.obs;
  RxBool isLoading = false.obs;
  RxString accessToken = ''.obs;
  RxList<String> backgroundImages = <String>[].obs;
  RxInt currentImageIndex = 0.obs;

  Timer? _imageSwitchTimer;

  @override
  void onInit() {
    super.onInit();
    fetchImages();
  }

  // @override
  // void onReady() {
  //   super.onReady();
  // }

  @override
  void onClose() {
    _imageSwitchTimer?.cancel();
    super.onClose();
  }

  void startImageTransition() {
    if (backgroundImages.isEmpty) {
      print('No background images found');
      return;
    }
    _imageSwitchTimer = Timer.periodic(const Duration(seconds: 5), (_) {
      currentImageIndex.value =
          (currentImageIndex.value + 1) % backgroundImages.length;
    });
  }

  Future<void> fetchImages() async {
    final token = await _unofficialSpotifyService.getAccessToken();
    if (token != null) {
      final images =
          await _unofficialSpotifyService.fetchBackgroundImages(token);
      // print("Fetched Images: $images");
      if (images.isNotEmpty) {
        backgroundImages.assignAll(images);
        // print("Assigned Images: $backgroundImages");
        startImageTransition();
      } else {
        print("No images found");
      }
    } else {
      print("No access token found");
    }
  }

  Future<void> getAccesToken() async {
    isLoading.value = true;
    try {
      var authentication = await SpotifySdk.getAccessToken(
        clientId: 'e7c14753755f4e5fb395af3f8e2eb583',
        redirectUrl: 'moodsync://auth',
        scope: 'app-remote-control, '
            'user-read-playback-state, '
            'user-modify-playback-state, '
            'user-read-currently-playing',
      );
      accessToken.value = authentication;
      final expirationTimestamp =
          DateTime.now().millisecondsSinceEpoch + 3600 * 1000;

      getStorage.write('accessToken', accessToken.value);
      getStorage.write('expirationTime', expirationTimestamp);

      _fetchUserData(accessToken.value);
    } catch (e) {
      throw Exception('Failed to get access token');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _fetchUserData(String token) async {
    try {
      final response = await http.get(
        Uri.parse('https://api.spotify.com/v1/me'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final displayName = data['display_name'];
        final imageUrl = (data['images'] as List).isNotEmpty
            ? data['images'][0]['url']
            : null;
        final userId = data['id'];

        // print(
        //     'User Data: displayName=$displayName, imageUrl=$imageUrl, userId=$userId');

        getStorage.write('displayName', displayName);
        getStorage.write('imageUrl', imageUrl);
        getStorage.write('userId', userId);

        await Future.delayed(const Duration(milliseconds: 200));
        Get.offAllNamed(Routes.HOME);
      } else {
        throw Exception('Failed to fetch user data');
      }
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }
}
