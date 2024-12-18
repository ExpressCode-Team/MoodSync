import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mood_sync/app/core/theme/app_colors.dart';
import 'package:mood_sync/app/core/utils/functions/open_spotify_url.dart';
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
                  var track = controller.songHistory[index];
                  return ListTile(
                    leading: CachedNetworkImage(
                      imageUrl: track['images'],
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                      placeholder: (context, url) =>
                          Container(color: Colors.grey),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error, color: Colors.red),
                    ),
                    title: Text(track['name']),
                    subtitle: Text(track['artist']),
                    trailing: IconButton(
                      icon: const Icon(Icons.play_arrow),
                      onPressed: () => openSpotifyUrl(
                          track, controller.accessToken,
                          saveHistory: false),
                    ),
                  );
                },
              );
            }),
            Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
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
                arguments: {"playlistId": playlist['id']}),
            child: Container(
              width: cardWidth,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: AppColors.darkBackground,
                boxShadow: const [
                  BoxShadow(blurRadius: 5, color: Colors.black26)
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildPlaylistImage(context, playlist),
                  _buildPlaylistDetails(playlist),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildPlaylistImage(
      BuildContext context, Map<String, dynamic> playlist) {
    String imageUrl =
        (playlist['images'] != null && playlist['images'].isNotEmpty)
            ? playlist['images'][0]['url']
            : 'https://via.placeholder.com/150';

    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.width * 0.4,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        image: DecorationImage(
          image: NetworkImage(imageUrl),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildPlaylistDetails(Map<String, dynamic> playlist) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            playlist['name'] ?? 'Unknown Playlist',
            style: const TextStyle(
                fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            playlist['description'] ?? 'No description available',
            style: const TextStyle(fontSize: 12, color: Colors.grey),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
