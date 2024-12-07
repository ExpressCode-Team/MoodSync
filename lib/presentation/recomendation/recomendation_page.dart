import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:mood_sync/core/config/assets/app_images.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';

class ResultRecommendationPage extends StatefulWidget {
  final String emotion; // Emotion diterima sebagai parameter

  const ResultRecommendationPage({super.key, required this.emotion});

  @override
  State<ResultRecommendationPage> createState() =>
      _ResultRecommendationPageState();
}

class _ResultRecommendationPageState extends State<ResultRecommendationPage> {
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  bool _isLoading = true;
  List<String> recommendedSongs =
      []; // List untuk menyimpan songIds hasil rekomendasi

  @override
  void initState() {
    super.initState();
    _fetchRecommendations();
  }

  Future<void> _fetchRecommendations() async {
    final String accessToken =
        await _secureStorage.read(key: 'accessToken') ?? '';
    final String emotion = widget.emotion;
    const int numSongs = 10;

    final Uri uri = Uri.parse(
        'https://facialexpress.raihanproject.my.id/spotify/recommend-songs/?access_token=$accessToken&emotion=$emotion&num_songs=$numSongs');

    try {
      final http.Response response = await http.post(uri);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> songs = data['songs'] ?? [];

        setState(() {
          recommendedSongs = songs.map((song) => song['id'] as String).toList();
          _isLoading = false;
        });
      } else {
        print('Failed to fetch recommendations: ${response.reasonPhrase}');
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error fetching recommendations: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Fungsi untuk shimmer effect saat loading
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

  // Fungsi untuk menampilkan detail lagu berdasarkan songId
  Future<Map<String, dynamic>> _fetchTrackDetails(String songId) async {
    String? accessToken = await _secureStorage.read(key: 'accessToken');
    if (accessToken == null) {
      print('Access token tidak ditemukan!');
    }
    final response = await http.get(
      Uri.parse('https://api.spotify.com/v1/tracks/$songId'),
      headers: {
        'Authorization': 'Bearer $accessToken', // Ganti dengan token yang valid
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load track details');
    }
  }

  void _openSpotifyUrl(String url) {
    // Implementasikan navigasi ke aplikasi Spotify
    print('Opening Spotify URL: $url');
    launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? _buildShimmer()
          : CustomScrollView(
              slivers: [
                // SliverAppBar untuk menampilkan gambar emosi dan info lainnya
                SliverAppBar(
                  leading: IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => context.go('/homepage'),
                  ),
                  expandedHeight: 250.0,
                  floating: false,
                  pinned: true,
                  flexibleSpace: FlexibleSpaceBar(
                    title:
                        Text('Recomendation for your mood: ${widget.emotion}'),
                    background: recommendedSongs.isNotEmpty
                        ? FutureBuilder(
                            future: _fetchTrackDetails(recommendedSongs.first),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Container(color: Colors.grey);
                              }

                              if (snapshot.hasError || !snapshot.hasData) {
                                return const Icon(Icons.error,
                                    color: Colors.red);
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
                // SliverList untuk daftar lagu yang direkomendasikan
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final songId = recommendedSongs[index];

                      return FutureBuilder<Map<String, dynamic>>(
                        future: _fetchTrackDetails(songId),
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
                              placeholder: (context, url) => Container(
                                color: Colors.grey,
                              ),
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.error, color: Colors.red),
                            ),
                            title: Text(trackData['name']),
                            subtitle: Text(trackData['artists'][0]['name']),
                            trailing: IconButton(
                              icon: const Icon(Icons.play_arrow,
                                  color: Colors.green),
                              onPressed: () =>
                                  _openSpotifyUrl(trackData['uri']),
                            ),
                          );
                        },
                      );
                    },
                    childCount: recommendedSongs.length,
                  ),
                ),
              ],
            ),
    );
  }

  String getImagePath(String emotion) {
    switch (emotion.toLowerCase()) {
      case 'angry':
        return AppImages.angerEmot;
      case 'sad':
        return AppImages.sadEmot;
      case 'happy':
        return AppImages.happyEmot;
      default:
        return AppImages.calmEmot;
    }
  }
}
