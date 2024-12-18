import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/history_controller.dart';

class HistoryView extends StatelessWidget {
  HistoryView({super.key});

  final HistoryController controller = Get.put(HistoryController());

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Number of tabs
      child: Scaffold(
        appBar: AppBar(
          title: const Text('History'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Songs'),
              Tab(text: 'Playlists'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }
              return ListView.builder(
                itemCount: controller.songHistory.length,
                itemBuilder: (context, index) {
                  var song = controller.songHistory[index];
                  return ListTile(
                    title: Text(song[
                        'recommendation_id']), // Replace with actual song data
                    subtitle: Text('ID: ${song['id']}'),
                  );
                },
              );
            }),
            Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }
              return ListView.builder(
                itemCount: controller.playlistHistory.length,
                itemBuilder: (context, index) {
                  var playlist = controller.playlistHistory[index];
                  return ListTile(
                    title: Text(playlist[
                        'recommendation_id']), // Replace with actual playlist data
                    subtitle: Text('ID: ${playlist['id']}'),
                  );
                },
              );
            }),
          ],
        ),
      ),
    );
  }
}
