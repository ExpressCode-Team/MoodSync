import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mood_sync/app/core/theme/app_text_style.dart';
import 'package:mood_sync/app/global_widgets/playlist_card.dart';
import 'package:mood_sync/app/global_widgets/track_tile.dart';
import 'package:mood_sync/app/routes/app_pages.dart';

import '../controllers/history_controller.dart';

class HistoryView extends StatelessWidget {
  HistoryView({super.key});
  final HistoryController controller = Get.put(HistoryController());

  @override
  Widget build(BuildContext context) {
    final double cardWidth = MediaQuery.of(context).size.width * 0.4;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('History Play', style: AppTextStyle.title1),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Songs'),
              Tab(text: 'Playlists'),
            ],
            indicatorColor: Colors.green,
            labelColor: Colors.green,
            unselectedLabelColor: Colors.white,
          ),
        ),
        body: TabBarView(
          children: [
            Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }
              if (controller.songHistory.isEmpty) {
                return const Center(child: Text('No history play yet'));
              }
              return ListView.builder(
                itemCount: controller.songHistory.length,
                itemBuilder: (context, index) {
                  final track = controller.songHistory[index];
                  return TrackTile(track: track);
                },
              );
            }),
            Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }
              if (controller.playlistHistory.isEmpty) {
                return const Center(child: Text('No history play yet'));
              }
              return _buildPlaylistCards(context, cardWidth);
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaylistCards(BuildContext context, double cardWidth) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 0.75,
        ),
        itemCount: controller.playlistHistory.length,
        itemBuilder: (context, index) {
          final playlist = controller.playlistHistory[index];
          return GestureDetector(
            onTap: () => Get.toNamed(Routes.PLAYLIST_DETAIL,
                arguments: {"playlistId": playlist.id}), // Gunakan playlist.id
            child: PlaylistCard(playlist: playlist), // Gunakan PlaylistTile
          );
        },
      ),
    );
  }
}
