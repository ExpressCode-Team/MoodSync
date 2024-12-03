import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:mood_sync/core/config/assets/app_images.dart';
import 'package:shimmer/shimmer.dart';

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

  // Simulasi fungsi untuk mendapatkan songIds berdasarkan emosi
  Future<void> _fetchRecommendations() async {
    // Simulasi delay untuk proses fetching data
    await Future.delayed(const Duration(seconds: 2));

    // Simulasi songId berdasarkan emosi
    List<String> simulatedSongIds = [];
    if (widget.emotion == 'happy') {
      simulatedSongIds = [
        '3U4isOIWM3VvDubwSI3y7a',
        '305WCRhhS10XUcH6AEwZk6',
        '2s25Z079T5KRzfqEQRMQQ4',
      ];
    } else if (widget.emotion == 'sad') {
      simulatedSongIds = [
        '1qUaWLUot3Iik95S09cdSZ',
        '2KSCegx6TosQQEgmhJKNQa',
        '0AG2l0IboWNSwjUkMr2Aq7',
      ];
    } else {
      simulatedSongIds = [
        '6QxTWEvzcJljVZaeTzuHF1',
        '4QdwsME04RG25KPHcPYoox',
        '2rPJcL8gQauA2nBdRyNZZL',
      ];
    }

    setState(() {
      recommendedSongs =
          simulatedSongIds; // Mengupdate dengan list songId yang telah disimulasikan
      _isLoading = false;
    });
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
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
              title: Text('Emotion: ${widget.emotion}'),
              background: CachedNetworkImage(
                imageUrl: getImagePath(widget.emotion),
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  color: Colors.grey,
                ),
                errorWidget: (context, url, error) =>
                    const Icon(Icons.error, color: Colors.red),
              ),
            ),
          ),
          // Jika masih loading, tampilkan shimmer
          if (_isLoading)
            SliverFillRemaining(
              child: _buildShimmer(),
            ),
          // SliverList untuk daftar lagu yang direkomendasikan
          if (!_isLoading)
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final songId = recommendedSongs[index];

                  return FutureBuilder<Map<String, dynamic>>(
                    future: _fetchTrackDetails(songId),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
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
                          icon:
                              const Icon(Icons.play_arrow, color: Colors.green),
                          onPressed: () => print('Play $songId'),
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
