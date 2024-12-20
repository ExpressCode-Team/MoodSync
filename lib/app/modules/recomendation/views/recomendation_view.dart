import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mood_sync/app/routes/app_pages.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';

import '../controllers/recomendation_controller.dart';

class RecomendationView extends GetView<RecomendationController> {
  final String emotion;

  const RecomendationView({super.key, required this.emotion});

  @override
  Widget build(BuildContext context) {
    final RecomendationController controller =
        Get.put(RecomendationController());

    // Fetch recommendations when the view is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.fetchRecommendations(emotion);
    });

    return Scaffold(
      body: Obx(() {
        if (controller.isLoading.value) {
          return _buildShimmer();
        } else {
          return CustomScrollView(
            slivers: [
              SliverAppBar(
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => Get.offAllNamed(Routes.HOME),
                ),
                expandedHeight: 250.0,
                floating: false,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  title: Text('Recommendation for your mood: $emotion'),
                  background: controller.recommendedSongs.isNotEmpty
                      ? FutureBuilder(
                          future: controller.fetchTrackDetails(
                              controller.recommendedSongs.first),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Container(color: Colors.grey);
                            }
                            if (snapshot.hasError || !snapshot.hasData) {
                              return const Icon(Icons.error, color: Colors.red);
                            }
                            final trackData = snapshot.data!;
                            final imageUrl =
                                trackData['album']['images'][0]['url'];
                            return CachedNetworkImage(
                              imageUrl: imageUrl,
                              fit: BoxFit.cover,
                              placeholder: (context, url) =>
                                  Container(color: Colors.grey),
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.error, color: Colors.red),
                            );
                          },
                        )
                      : Container(color: Colors.grey),
                ),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final songId = controller.recommendedSongs[index];
                    return FutureBuilder<Map<String, dynamic>>(
                      future: controller.fetchTrackDetails(songId),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const ListTile(
                            leading: CircularProgressIndicator(),
                            title: Text('Loading...'),
                          );
                        }
                        if (snapshot.hasError) {
                          return ListTile(
                            title: Text('Error: ${snapshot.error}'),
                          );
                        }
                        final trackData = snapshot.data!;
                        return ListTile(
                          leading: CachedNetworkImage(
                            imageUrl: trackData['album']['images'][0]['url'],
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                            placeholder: (context, url) =>
                                Container(color: Colors.grey),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error, color: Colors.red),
                          ),
                          title: Text(trackData['name']),
                          subtitle: Text(trackData['artists'][0]['name']),
                          trailing: IconButton(
                            icon: const Icon(Icons.play_arrow,
                                color: Colors.green),
                            onPressed: () => _openSpotifyUrl(
                              trackData['uri'],
                            ),
                          ),
                        );
                      },
                    );
                  },
                  childCount: controller.recommendedSongs.length,
                ),
              ),
            ],
          );
        }
      }),
    );
  }

  Widget _buildShimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[700]!,
      highlightColor: Colors.grey[500]!,
      child: Column(
        children: [
          Container(
            color: Colors.grey,
            height: 250,
            width: double.infinity,
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: 6,
              itemBuilder: (context, index) => ListTile(
                leading: Container(
                  width: 50,
                  height: 50,
                  color: Colors.grey,
                ),
                title: Container(
                  height: 16,
                  color: Colors.grey,
                  margin: const EdgeInsets.symmetric(vertical: 4),
                ),
                subtitle: Container(
                  height: 14,
                  color: Colors.grey,
                  margin: const EdgeInsets.symmetric(vertical: 4),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _openSpotifyUrl(String url) {
    launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
  }
}
