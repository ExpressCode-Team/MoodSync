import 'package:get/get.dart';

import '../modules/camera/bindings/camera_binding.dart';
import '../modules/camera/views/camera_view.dart';
import '../modules/history/bindings/history_binding.dart';
import '../modules/history/views/history_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/homepage/bindings/homepage_binding.dart';
import '../modules/homepage/views/homepage_view.dart';
import '../modules/login/bindings/login_binding.dart';
import '../modules/login/views/login_view.dart';
import '../modules/playlistDetail/bindings/playlist_detail_binding.dart';
import '../modules/playlistDetail/views/playlist_detail_view.dart';
import '../modules/profile/bindings/profile_binding.dart';
import '../modules/profile/views/profile_view.dart';
import '../modules/recomendation/bindings/recomendation_binding.dart';
import '../modules/recomendation/views/recomendation_view.dart';
import '../modules/splash/bindings/splash_binding.dart';
import '../modules/splash/views/splash_view.dart';
import '../modules/statistic/bindings/statistic_binding.dart';
import '../modules/statistic/views/statistic_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.SPLASH;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.SPLASH,
      page: () => const SplashView(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => const LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.HOMEPAGE,
      page: () => const HomepageView(),
      binding: HomepageBinding(),
    ),
    GetPage(
      name: _Paths.PROFILE,
      page: () => const ProfileView(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: _Paths.STATISTIC,
      page: () => const StatisticView(),
      binding: StatisticBinding(),
    ),
    GetPage(
      name: _Paths.HISTORY,
      page: () => HistoryView(),
      binding: HistoryBinding(),
    ),
    GetPage(
      name: _Paths.CAMERA,
      page: () => const CameraView(),
      binding: CameraBinding(),
    ),
    GetPage(
      name: _Paths.PLAYLIST_DETAIL,
      page: () => PlaylistDetailView(playlistId: Get.arguments['playlistId']),
      binding: PlaylistDetailBinding(),
    ),
    GetPage(
      name: _Paths.RECOMENDATION,
      page: () {
        final emotion = Get.arguments;
        return RecomendationView(emotion: emotion);
      },
      binding: RecomendationBinding(),
    ),
  ];
}
