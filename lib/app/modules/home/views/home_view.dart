import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mood_sync/app/modules/history/views/history_view.dart';
import 'package:mood_sync/app/modules/home/widgets/bottom_navbar_app.dart';
import 'package:mood_sync/app/modules/home/widgets/fab_face_reg.dart';
import 'package:mood_sync/app/modules/homepage/views/homepage_view.dart';
import 'package:mood_sync/app/modules/profile/views/profile_view.dart';
import 'package:mood_sync/app/modules/statistic/views/statistic_view.dart';
import 'package:mood_sync/app/routes/app_pages.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});
  final List<Widget> pages = const [
    HomepageView(),
    HistoryView(),
    StatisticView(),
    ProfileView(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() => IndexedStack(
            index: controller.selectedIndex.value,
            children: pages,
          )),
      bottomNavigationBar: Obx(() => BottomNavbarApp(
            currentIndex: controller.selectedIndex.value,
            onTap: (index) => controller.changePage(index),
          )),
      floatingActionButton: FabFaceReg(onPressed: () {
        Get.toNamed(Routes.LOGIN);
      }),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
