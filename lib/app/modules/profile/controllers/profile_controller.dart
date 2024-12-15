import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mood_sync/app/routes/app_pages.dart';

class ProfileController extends GetxController {
  final getStorage = GetStorage();
  var displayName = ''.obs;
  var imageUrl = Rxn<String>('');
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadUserData();
  }

  void loadUserData() {
    isLoading.value = true;
    displayName.value = getStorage.read('displayName') ?? 'User';
    imageUrl.value = getStorage.read('imageUrl');
    isLoading.value = false;
  }

  logout() {
    getStorage.erase();
    Get.offAllNamed(Routes.SPLASH);
  }
}
