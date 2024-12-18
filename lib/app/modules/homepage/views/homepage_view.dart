import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:mood_sync/app/core/assets/app_vectors.dart';
import 'package:mood_sync/app/core/theme/app_colors.dart';
import 'package:mood_sync/app/core/theme/app_text_style.dart';
import 'package:mood_sync/app/core/utils/functions/open_spotify_url.dart';
import 'package:mood_sync/app/modules/homepage/widgets/emotion_card.dart';
import 'package:mood_sync/app/routes/app_pages.dart';
import 'package:shimmer/shimmer.dart';

import '../controllers/homepage_controller.dart';

class HomepageView extends GetView<HomepageController> {
  const HomepageView({super.key});

  @override
  Widget build(BuildContext context) {
    final double cardWidth = MediaQuery.of(context).size.width * 0.4;
    final double cardHeight = cardWidth * 1.5;
    final HomepageController controller = Get.put(HomepageController());

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.darkBackground,
        title: Padding(
          padding: EdgeInsets.symmetric(
            vertical: MediaQuery.of(context).size.height * 0.01,
            horizontal: MediaQuery.of(context).size.width * 0.01,
          ),
          child: SvgPicture.asset(AppVectors.logo,
              height: AppBar().preferredSize.height * 0.7),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return _buildShimmerBody(context);
        }

        return RefreshIndicator(
          onRefresh: controller.initializeData,
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(32, 16, 32, 0),
            children: [
              controller.lastHistoryExpression.value.isEmpty
                  ? _buildEmotionCard(context) // Pass context here
                  : EmotionCard(
                      emotion: controller.lastHistoryExpression.value,
                    ),
              const SizedBox(height: 20),
              _buildSectionTitle('Playlist for you'),
              controller.playlistData.isEmpty
                  ? _buildShimmerCards()
                  : _buildPlaylistCards(context, cardWidth),
              _buildSectionTitle('Maybe you like'),
              controller.trackData.isEmpty
                  ? _buildNoDataText()
                  : _buildTrackCards(
                      context, cardWidth, cardHeight, controller.accessToken),
              const SizedBox(height: 20),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildShimmerBody(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(32, 16, 32, 0),
      children: [
        _buildEmotionCard(context),
        const SizedBox(height: 20),
        _buildSectionTitle('Playlist for you'),
        _buildShimmerCards(),
        _buildSectionTitle('Maybe you like'),
        _buildShimmerCards(),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: AppTextStyle.headline1),
        const SizedBox(height: 12),
      ],
    );
  }

  Widget _buildEmotionCard(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade700,
      highlightColor: Colors.grey.shade100,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.4,
        height: MediaQuery.of(context).size.width * 0.4 * 1.5,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: AppColors.darkBackground,
          boxShadow: const [BoxShadow(blurRadius: 10)],
        ),
        child: const Center(child: CircularProgressIndicator()),
      ),
    );
  }

  Widget _buildShimmerCards() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 3 / 4,
      ),
      itemCount: 2,
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey.shade700,
          highlightColor: Colors.grey.shade100,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: AppColors.darkBackground,
              boxShadow: const [BoxShadow(blurRadius: 10)],
            ),
            child: const Center(child: CircularProgressIndicator()),
          ),
        );
      },
    );
  }

  Widget _buildTrackCards(BuildContext context, double cardWidth,
      double cardHeight, String accessToken) {
    return _buildHorizontalList(
      context: context,
      itemCount: controller.trackData.length,
      itemBuilder: (context, index) {
        final song = controller.trackData[index];
        return SongCard(
          title: song['title'],
          artist: song['artist'],
          imageUrl: song['image'],
          width: cardWidth,
          height: cardHeight,
          onTap: () => openSpotifyUrl(song, accessToken),
        );
      },
    );
  }

  Widget _buildPlaylistCards(BuildContext context, double cardWidth) {
    return _buildHorizontalList(
      context: context,
      itemCount: controller.playlistData.length,
      itemBuilder: (context, index) {
        final playlist = controller.playlistData[index];
        return GestureDetector(
          onTap: () => Get.toNamed(Routes.PLAYLIST_DETAIL,
              arguments: {"playlistId": playlist['id']}),
          child: Container(
            width: cardWidth,
            height: cardWidth * 1.2 + 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: AppColors.darkBackground,
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
    );
  }

  Widget _buildHorizontalList({
    required BuildContext context,
    required int itemCount,
    required IndexedWidgetBuilder itemBuilder,
  }) {
    return SizedBox(
      height: (MediaQuery.of(context).size.width * 0.4) * 1.5,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: itemCount,
        itemBuilder: (context, index) {
          return Row(
            children: [
              itemBuilder(context, index), // Item
              if (index < itemCount - 1) // Jika bukan item terakhir
                const SizedBox(width: 16), // Atur jarak di sini
            ],
          );
        },
      ),
    );
  }

  Widget _buildPlaylistImage(
      BuildContext context, Map<String, dynamic> playlist) {
    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.width * 0.4,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        image: DecorationImage(
          image: NetworkImage(playlist['image']),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildPlaylistDetails(Map<String, dynamic> playlist) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            playlist['name'],
            style: const TextStyle(
                fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
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

  Widget _buildNoDataText() {
    return const Center(
      child: Text('Unsuccessful in obtaining data',
          style: TextStyle(color: Colors.red)),
    );
  }
}

class SongCard extends StatelessWidget {
  final String title;
  final String artist;
  final String imageUrl;
  final double width;
  final double height;
  final VoidCallback onTap;

  const SongCard({
    super.key,
    required this.title,
    required this.artist,
    required this.imageUrl,
    required this.width,
    required this.height,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: AppColors.darkBackground,
          image: DecorationImage(
            image: NetworkImage(imageUrl),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: height * 0.3,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(8),
                    bottomRight: Radius.circular(8),
                  ),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.9),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    artist,
                    style: const TextStyle(fontSize: 12, color: Colors.white70),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
