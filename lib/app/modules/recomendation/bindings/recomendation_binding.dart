import 'package:get/get.dart';

import '../controllers/recomendation_controller.dart';

class RecomendationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RecomendationController>(
      () => RecomendationController(),
    );
  }
}
