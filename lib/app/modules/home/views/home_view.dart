import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('HomeView'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Obx(() {
              return controller.imageUrl.value.isNotEmpty
                  ? CircleAvatar(
                      radius: 50,
                      backgroundImage: NetworkImage(controller.imageUrl.value),
                    )
                  : const CircleAvatar(
                      radius: 50,
                      child: Icon(Icons.person),
                    );
            }),
            const SizedBox(height: 10),
            Obx(() => Text(
                  controller.displayName.value.isNotEmpty
                      ? 'Welcome, ${controller.displayName.value}'
                      : 'Welcome, Guest',
                  style: const TextStyle(fontSize: 20),
                )),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: controller.logout,
              child: const Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }
}
