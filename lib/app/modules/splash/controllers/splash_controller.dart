import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mood_sync/app/routes/app_pages.dart';

class SplashController extends GetxController {
  //TODO: Implement SplashController
  final getStorage = GetStorage();

  // @override
  // void onInit() {
  //   super.onInit();
  // }

  @override
  void onReady() {
    super.onReady();
    _checkTokenAndNavigate();
  }

  // @override
  // void onClose() {
  //   super.onClose();
  // }

  void _checkTokenAndNavigate() {
    Future.delayed(const Duration(seconds: 3), () {
      final accessToken = getStorage.read('accessToken');
      final expirationTime = getStorage.read('expirationTime');

      if (accessToken != null && expirationTime != null) {
        final currentTime = DateTime.now().millisecondsSinceEpoch;
        final isTokenValid = currentTime < expirationTime;

        print('Access token found. Valid: $isTokenValid');
        if (isTokenValid) {
          Get.offAllNamed(Routes.HOME);
          return;
        }
      }

      Get.offAllNamed(Routes.LOGIN);
    });
  }
}
