import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mood_sync/app/routes/app_pages.dart';

class HomeController extends GetxController {
  final getStorage = GetStorage();
  RxString accessToken = "".obs;
  RxInt expiredTime = 0.obs;
  RxString displayName = ''.obs;
  RxString imageUrl = ''.obs;
  RxString userId = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _getAndCheckAccessToken();
    _fetchUserData();
  }

  void _getAndCheckAccessToken() {
    accessToken.value = getStorage.read('accessToken') ?? "";
    expiredTime.value = getStorage.read('expirationTime') ?? 0;

    if (accessToken.value.isEmpty || expiredTime.value <= 0) {
      print('Access token is invalid or expired.');
    }

    if (expiredTime.value > 0) {
      final expirationDate =
          DateTime.fromMillisecondsSinceEpoch(expiredTime.value);
      print('Token expires at: $expirationDate');
    }

    // print('GetStorage Content:');
    // print('accessToken: ${accessToken.value}');
    // print('displayName: ${getStorage.read('displayName')}');
    // print('imageUrl: ${getStorage.read('imageUrl')}');
    // print('userId: ${getStorage.read('userId')}');
  }

  void _fetchUserData() {
    displayName.value = getStorage.read('displayName') ?? '';
    imageUrl.value = getStorage.read('imageUrl') ?? '';
    userId.value = getStorage.read('userId') ?? '';

    // print('Saved displayName: ${displayName.value}');
    // print('Saved imageUrl: ${imageUrl.value}');
    // print('Saved userId: ${userId.value}');
  }

  void logout() {
    getStorage.erase();
    Get.offAllNamed(Routes.SPLASH);
  }
}
