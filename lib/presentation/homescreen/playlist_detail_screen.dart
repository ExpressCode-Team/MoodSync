import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:shimmer/shimmer.dart';

class PlaylistDetailScreen extends StatefulWidget {
  final String playlistId;

  const PlaylistDetailScreen({super.key, required this.playlistId});

  @override
  State<PlaylistDetailScreen> createState() => _PlaylistDetailScreenState();
}

class _PlaylistDetailScreenState extends State<PlaylistDetailScreen> {
  bool _isLoading = true;
  Map<String, dynamic>? playlistData;
  List<Map<String, dynamic>> tracks = [];
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  @override
  void initState() {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? _buildShimmer()
          : CustomScrollView(
              slivers: [
                SliverAppBar(
                  expandedHeight: 250.0,
                  pinned: true,
                  backgroundColor: Colors.black,
                  flexibleSpace: FlexibleSpaceBar(
                    title: Text(
                      playlistData!['name'],
                      style: const TextStyle(color: Colors.white),
                    ),
                    background: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.network(
                          playlistData!['images'][0]['url'],
                          fit: BoxFit.cover,
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
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final track = tracks[index];
                      return ListTile(
                        leading: Image.network(
                          track['image'],
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
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
                          icon:
                              const Icon(Icons.play_arrow, color: Colors.green),
                          onPressed: () => _openSpotifyUrl(track['url']),
                        ),
                      );
                    },
                    childCount: tracks.length,
                  ),
                ),
              ],
            ),
    );
  }
}
