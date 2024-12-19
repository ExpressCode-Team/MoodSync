import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mood_sync/app/core/theme/app_text_style.dart';
import 'package:mood_sync/app/core/utils/functions/open_spotify_url.dart';
import 'package:shimmer/shimmer.dart';

import '../controllers/playlist_detail_controller.dart';

class PlaylistDetailView extends GetView<PlaylistDetailController> {
  final String playlistId;
  @override
  final PlaylistDetailController controller =
      Get.put(PlaylistDetailController());

  PlaylistDetailView({super.key, required this.playlistId}) {
    controller.fetchPlaylistDetails(playlistId);
  }

  Widget _buildShimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[700]!,
      highlightColor: Colors.grey[500]!,
      child: Column(
        children: [
          Container(color: Colors.grey, height: 250, width: double.infinity),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: 6,
              itemBuilder: (context, index) => ListTile(
                leading: Container(width: 50, height: 50, color: Colors.grey),
                title: Container(
                    height: 16,
                    color: Colors.grey,
                    margin: const EdgeInsets.symmetric(vertical: 4)),
                subtitle: Container(
                    height: 14,
                    color: Colors.grey,
                    margin: const EdgeInsets.symmetric(vertical: 4)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlayButton() {
    return FloatingActionButton(
      onPressed: () {
        final url = controller.playlistData['external_urls']['spotify'];
        openSpotifyUrl(controller.playlistData, controller.accessToken);
      },
      backgroundColor: Colors.green,
      child: const Icon(Icons.play_arrow),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        return controller.isLoading.value
            ? _buildShimmer()
            : SafeArea(
                child: Stack(
                  children: [
                    CustomScrollView(
                      slivers: [
                        SliverAppBar(
                          expandedHeight: 250.0,
                          pinned: true,
                          backgroundColor: Colors.black,
                          flexibleSpace: FlexibleSpaceBar(
                            title: Text(
                              controller.playlistData['name'] ??
                                  'Playlist Name',
                              style: AppTextStyle.headline1,
                            ),
                            background: Stack(
                              fit: StackFit.expand,
                              children: [
                                controller.playlistData['images'] != null &&
                                        controller
                                            .playlistData['images'].isNotEmpty
                                    ? CachedNetworkImage(
                                        imageUrl:
                                            controller.playlistData['images'][0]
                                                    ['url'] ??
                                                '',
                                        fit: BoxFit.cover,
                                        placeholder: (context, url) =>
                                            Container(color: Colors.grey),
                                        errorWidget: (context, url, error) =>
                                            const Icon(Icons.error,
                                                color: Colors.red),
                                      )
                                    : Container(
                                        color: Colors
                                            .grey), // Fallback if no image

                                Container(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        Colors.black.withOpacity(0.8),
                                        Colors.transparent,
                                        Colors.black.withOpacity(0.9),
                                      ],
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          leading: IconButton(
                            icon: const Icon(Icons.arrow_back,
                                color: Colors.white),
                            onPressed: () => Get.back(),
                          ),
                        ),
                        SliverPersistentHeader(
                          pinned: true,
                          delegate: StickyPlayButtonDelegate(
                            minHeight: 56,
                            maxHeight: 56,
                            child: Container(
                              color: Colors.black,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      const Icon(Icons.people,
                                          color: Colors.white),
                                      const SizedBox(width: 8),
                                      Text(
                                        controller.playlistData['followers'] !=
                                                null
                                            ? '${controller.playlistData['followers']['total']} Followers'
                                            : '0 Followers',
                                        style: const TextStyle(
                                            color: Colors.white),
                                      ),
                                    ],
                                  ),
                                  _buildPlayButton(),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              if (index < controller.tracks.length) {
                                final track = controller.tracks[index];
                                return ListTile(
                                  leading: CachedNetworkImage(
                                    imageUrl: track['image'],
                                    width: 50,
                                    height: 50,
                                    fit: BoxFit.cover,
                                    placeholder: (context, url) =>
                                        Container(color: Colors.grey),
                                    errorWidget: (context, url, error) =>
                                        const Icon(Icons.error,
                                            color: Colors.red),
                                  ),
                                  title: Text(
                                    track['title'],
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                  subtitle: Text(
                                    track['artist'],
                                    style:
                                        const TextStyle(color: Colors.white70),
                                  ),
                                  trailing: IconButton(
                                    icon: const Icon(Icons.play_arrow,
                                        color: Colors.green),
                                    onPressed: () => openSpotifyUrl(
                                        track, controller.accessToken),
                                  ),
                                );
                              } else {
                                return const SizedBox
                                    .shrink(); // Return an empty box if index is out of range
                              }
                            },
                            childCount: controller.tracks.length,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
      }),
    );
  }
}

class StickyPlayButtonDelegate extends SliverPersistentHeaderDelegate {
  final double minHeight;
  final double maxHeight;
  final Widget child;

  StickyPlayButtonDelegate({
    required this.minHeight,
    required this.maxHeight,
    required this.child,
  });

  @override
  double get minExtent => minHeight;

  @override
  double get maxExtent => maxHeight;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}
