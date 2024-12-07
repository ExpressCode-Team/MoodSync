import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:mood_sync/core/config/theme/app_text_style.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';

class PlaylistDetailScreen extends StatefulWidget {
  final String playlistId;

  const PlaylistDetailScreen({super.key, required this.playlistId});

  @override
  State<PlaylistDetailScreen> createState() => _PlaylistDetailScreenState();
}

class _PlaylistDetailScreenState extends State<PlaylistDetailScreen> {
  bool _isLoading = true;
  bool _imagesLoaded = false;
  Map<String, dynamic>? playlistData;
  List<Map<String, dynamic>> tracks = [];
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  @override
  void initState() {
    print('Masuk Detail Playlist');
    super.initState();
    _fetchPlaylistDetails();
  }

  Future<void> _fetchPlaylistDetails() async {
    String? accessToken = await _secureStorage.read(key: 'accessToken');
    if (accessToken == null) {
      print('Access token tidak ditemukan!');
      return;
    }

    try {
      final response = await http.get(
        Uri.parse('https://api.spotify.com/v1/playlists/${widget.playlistId}'),
        headers: {'Authorization': 'Bearer $accessToken'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          playlistData = data;
          tracks = (data['tracks']['items'] as List)
              .map<Map<String, dynamic>>((item) {
            final track = item['track'];
            return {
              'title': track['name'],
              'artist': (track['artists'] as List)
                  .map((artist) => artist['name'])
                  .join(', '),
              'image': track['album']['images'][0]['url'],
              'url': track['external_urls']['spotify'],
            };
          }).toList();
          _isLoading = false;
        });
      } else {
        print('Gagal memuat detail playlist: ${response.statusCode}');
        print('Response: ${response.body}');
      }
    } catch (e) {
      print('Error saat memuat detail playlist: $e');
    }
  }

  void _openSpotifyUrl(String url) {
    // Implementasikan navigasi ke aplikasi Spotify
    print('Opening Spotify URL: $url');
    launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
  }

  Widget _buildShimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[700]!,
      highlightColor: Colors.grey[500]!,
      child: Column(
        children: [
          // Shimmer untuk bagian atas
          Container(
            color: Colors.grey,
            height: 250,
            width: double.infinity,
          ),
          const SizedBox(height: 16),
          // Shimmer untuk daftar lagu
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

  Widget _buildPlayButton() {
    return FloatingActionButton(
      onPressed: () {
        _openSpotifyUrl(playlistData!['external_urls']['spotify']);
      },
      backgroundColor: Colors.green,
      child: const Icon(Icons.play_arrow),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
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
                            playlistData!['name'],
                            style: AppTextStyle.headline1,
                          ),
                          background: Stack(
                            fit: StackFit.expand,
                            children: [
                              CachedNetworkImage(
                                imageUrl: playlistData!['images'][0]['url'],
                                fit: BoxFit.cover,
                                placeholder: (context, url) => Container(
                                  color: Colors.grey,
                                ),
                                errorWidget: (context, url, error) =>
                                    const Icon(
                                  Icons.error,
                                  color: Colors.red,
                                ),
                                cacheKey: playlistData!['images'][0]['url'],
                                fadeInDuration:
                                    const Duration(milliseconds: 300),
                                fadeOutDuration:
                                    const Duration(milliseconds: 300),
                                imageBuilder: (context, imageProvider) {
                                  if (!_imagesLoaded) {
                                    WidgetsBinding.instance
                                        .addPostFrameCallback((_) {
                                      setState(() {
                                        _imagesLoaded = true;
                                      });
                                    });
                                  }

                                  return Container(
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: imageProvider,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  );
                                },
                              ),
                              if (!_imagesLoaded)
                                const LinearProgressIndicator(
                                  backgroundColor: Colors.transparent,
                                ),
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
                          icon:
                              const Icon(Icons.arrow_back, color: Colors.white),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ),
                      SliverPersistentHeader(
                        pinned: true,
                        delegate: StickyPlayButtonDelegate(
                          minHeight: 56,
                          maxHeight: 56,
                          child: Container(
                            color: Colors.black,
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    const Icon(Icons.people,
                                        color: Colors.white),
                                    const SizedBox(width: 8),
                                    Text(
                                      '${playlistData!['followers']['total']} Followers',
                                      style:
                                          const TextStyle(color: Colors.white),
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
                            final track = tracks[index];
                            return ListTile(
                              leading: CachedNetworkImage(
                                imageUrl: track['image'],
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                                placeholder: (context, url) => Container(
                                  color: Colors.grey,
                                ),
                                errorWidget: (context, url, error) =>
                                    const Icon(
                                  Icons.error,
                                  color: Colors.red,
                                ),
                                fadeInDuration:
                                    const Duration(milliseconds: 300),
                                fadeOutDuration:
                                    const Duration(milliseconds: 300),
                              ),
                              title: Text(
                                track['title'],
                                style: const TextStyle(color: Colors.white),
                              ),
                              subtitle: Text(
                                track['artist'],
                                style: const TextStyle(color: Colors.white70),
                              ),
                              trailing: IconButton(
                                icon: const Icon(Icons.play_arrow,
                                    color: Colors.green),
                                onPressed: () => _openSpotifyUrl(track['url']),
                              ),
                            );
                          },
                          childCount: tracks.length,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
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
