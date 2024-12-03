import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:mood_sync/common/widgets/card/emotion_card.dart';
import 'package:mood_sync/core/config/assets/app_vectors.dart';
import 'package:mood_sync/core/config/theme/app_colors.dart';
import 'package:mood_sync/core/config/theme/app_text_style.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  bool _isLoading = true;
  List<Map<String, dynamic>> trackData = [];
  List<Map<String, dynamic>> playlistData = [];

  @override
  void initState() {
    super.initState();
    _fetchRecommendations();
    _fetchPlaylists();
  }

  Future<void> _fetchRecommendations() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? genresJson = prefs.getString('selectedGenres');
    List<String> genresList;

    if (genresJson != null) {
      genresList = List<String>.from(json.decode(genresJson));
    } else {
      genresList = ['pop']; // Default genre
    }

    String genresParam = genresList.join(',');
    String encodedGenres = Uri.encodeComponent(genresParam);

    print('selectedGenres yang disimpan: $genresList');
    print('encodedGenres: $encodedGenres');

    String? accessToken = await _secureStorage.read(key: 'accessToken');
    if (accessToken == null) {
      print("Access token tidak ditemukan!");
      setState(() {
        _isLoading = false;
      });
      return;
    }

    try {
      final response = await http.get(
        Uri.parse(
            'https://api.spotify.com/v1/recommendations?seed_genres=$encodedGenres&limit=10'),
        headers: {'Authorization': 'Bearer $accessToken'},
      );

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        var tracks = data['tracks'];
        print('tracks: $tracks');

        setState(() {
          trackData = tracks
              .map<Map<String, dynamic>>((track) => {
                    'title': track['name'],
                    'artist': track['artists'][0]['name'],
                    'image': track['album']['images'][0]['url'],
                    'url': track['external_urls']['spotify'],
                  })
              .toList();
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
        });
        print('Gagal memuat track: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print('Error: $e');
    }
  }

  // Future<void> _fetchPlaylists() async {
  //   String? accessToken = await _secureStorage.read(key: 'accessToken');
  //   if (accessToken == null) {
  //     print("Access token tidak ditemukan!");
  //     return;
  //   }

  //   try {
  //     final response = await http.get(
  //       Uri.parse('https://api.spotify.com/v1/browse/featured-playlists'),
  //       headers: {'Authorization': 'Bearer $accessToken'},
  //     );

  //     if (response.statusCode == 200) {
  //       var data = json.decode(response.body);
  //       var playlists = data['playlists']['items'];

  //       setState(() {
  //         playlistData = playlists
  //             .map<Map<String, dynamic>>((playlist) => {
  //                   'name': playlist['name'],
  //                   'id': playlist['id'],
  //                   'description': playlist['description'],
  //                   'image': playlist['images'][0]['url'],
  //                   'url': playlist['external_urls']['spotify'],
  //                 })
  //             .toList();
  //       });
  //     } else {
  //       print('Gagal memuat playlist: ${response.statusCode}');
  //     }
  //   } catch (e) {
  //     print('Error: $e');
  //   }
  // }

  Future<void> _fetchPlaylists() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? genresJson = prefs.getString('selectedGenres');
    List<String> genresList;

    if (genresJson != null) {
      genresList = List<String>.from(json.decode(genresJson));
    } else {
      genresList = ['pop']; // Default genre
    }

    String? accessToken = await _secureStorage.read(key: 'accessToken');
    if (accessToken == null) {
      print("Access token tidak ditemukan!");
      return;
    } else {
      print('Access token: $accessToken');
    }

    List<Map<String, dynamic>> fetchedPlaylists = [];

    try {
      // Ambil satu playlist untuk setiap genre
      for (String genre in genresList) {
        final response = await http.get(
          Uri.parse(
              'https://api.spotify.com/v1/search?q=genre%3A$genre&type=playlist&include_external=audio'),
          headers: {'Authorization': 'Bearer $accessToken'},
        );

        if (response.statusCode == 200) {
          var data = json.decode(response.body);

          // Pastikan data 'playlists' dan 'items' ada di respons
          if (data.containsKey('playlists') &&
              data['playlists']['items'] != null) {
            var playlists = data['playlists']['items'];

            // Ambil hanya satu playlist untuk setiap genre
            if (playlists.isNotEmpty) {
              var playlist = playlists[0]; // Ambil hanya playlist pertama
              fetchedPlaylists.add({
                'name': playlist['name'] ?? 'No title',
                'id': playlist['id'],
                'description':
                    playlist['description'] ?? 'No description available',
                'image': (playlist['images'] != null &&
                        playlist['images'].isNotEmpty &&
                        playlist['images'][0]['url'] != null)
                    ? playlist['images'][0]['url']
                    : null, // Handle image URL if it's available
                'url': playlist['external_urls']['spotify'] ??
                    '', // Ensure URL exists
              });
            } else {
              print('No playlists found for genre $genre.');
            }
          } else {
            print('Playlist data kosong atau tidak valid untuk genre $genre.');
          }
        } else {
          print(
              'Gagal memuat playlist untuk genre $genre: ${response.statusCode}, body: ${response.body}');
          // Jika status code bukan 200, tampilkan pesan error
          setState(() {
            playlistData = [];
          });
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('Gagal memuat playlist untuk genre $genre')));
          return; // Menghentikan proses jika ada error
        }
      }

      // Update UI dengan playlist yang berhasil diambil
      setState(() {
        playlistData = fetchedPlaylists;
      });
    } catch (e) {
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Terjadi kesalahan saat memuat playlist.')));
    }
  }

  Future<void> _openSpotifyTrack(String trackUrl) async {
    try {
      // await SpotifySdk.playTrack(trackUrl);
      print('to Spotify');
    } catch (e) {
      print("Gagal membuka Spotify: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.darkBackground,
        surfaceTintColor: AppColors.darkBackground,
        title: Padding(
          padding: EdgeInsets.symmetric(
            vertical: MediaQuery.of(context).size.height * 0.01,
            horizontal: MediaQuery.of(context).size.width * 0.01,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SvgPicture.asset(
                AppVectors.logo,
                height: AppBar().preferredSize.height * 0.7,
              ),
            ],
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _refreshContent,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(32, 16, 32, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const EmotionCard(emotion: 'anger'),
                  const SizedBox(height: 20),
                  Text('Tuned for you', style: AppTextStyle.headline1),
                  const SizedBox(height: 12),
                  _isLoading
                      ? _buildShimmerCards()
                      : trackData.isEmpty
                          ? const Center(
                              child: Text('Unsuccessful in obtaining data'))
                          : _buildTrackCards(context),
                  const SizedBox(height: 20),
                  Text('Playlist for you', style: AppTextStyle.headline1),
                  const SizedBox(height: 12),
                  _isLoading
                      ? _buildShimmerCards()
                      : playlistData.isEmpty
                          ? const Center(
                              child: Text('Unsuccessful in obtaining data'))
                          : _buildPlaylistCards(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _refreshContent() async {
    setState(() {
      _isLoading = true;
    });
    await _fetchRecommendations();
    await _fetchPlaylists();
    setState(() {
      _isLoading = false;
    });
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

  Widget _buildTrackCards(BuildContext context) {
    double cardWidth = MediaQuery.of(context).size.width * 0.4;
    double cardHeight = cardWidth * 1.5;

    return SizedBox(
      height: cardHeight,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: trackData.length,
        itemBuilder: (context, index) {
          final song = trackData[index];
          return Padding(
            padding: const EdgeInsets.only(right: 16),
            child: GestureDetector(
              onTap: () {
                _openSpotifyTrack(song['url']);
              },
              child: SongCard(
                title: song['title'],
                artist: song['artist'],
                imageUrl: song['image'],
                width: cardWidth,
                height: cardHeight,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildPlaylistCards(BuildContext context) {
    double cardWidth = MediaQuery.of(context).size.width * 0.4;
    double cardHeight = cardWidth * 1.2;

    return SizedBox(
      height: cardHeight + 50, // Menambahkan sedikit ruang untuk deskripsi
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: playlistData.length,
        itemBuilder: (context, index) {
          final playlist = playlistData[index];
          return Padding(
            padding: const EdgeInsets.only(right: 16),
            child: GestureDetector(
              onTap: () {
                // Implementasikan navigasi ke detail playlist jika diperlukan
                final playlist = playlistData[index];
                final playlistId = playlist['id']; // Ambil id playlist
                print('playlistId: $playlistId');
                // final playlistName = playlist['name']; // Ambil nama playlist
                // Gunakan GoRouter untuk navigasi ke halaman detail playlist
                context.push('/playlist/$playlistId');
              },
              child: Container(
                width: cardWidth,
                height: cardHeight +
                    50, // Menambahkan sedikit ruang untuk deskripsi
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: AppColors.darkBackground,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Baris pertama: Gambar Playlist
                    Container(
                      width: cardWidth,
                      height: cardWidth, // Membuat gambar persegi
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        image: DecorationImage(
                          image: NetworkImage(playlist['image']),
                          fit: BoxFit
                              .cover, // Menjaga agar gambar tetap terjaga kualitasnya
                        ),
                      ),
                    ),
                    const SizedBox(height: 8), // Jarak antara gambar dan teks
                    // Baris kedua: Judul dan Deskripsi
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            playlist['name'],
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.white, // Judul berwarna putih
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(
                              height: 4), // Jarak antara judul dan deskripsi
                          Text(
                            playlist['description'] ??
                                'No description available',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey, // Deskripsi berwarna abu-abu
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class SongCard extends StatelessWidget {
  final String title;
  final String artist;
  final String imageUrl;
  final double width;
  final double height;

  const SongCard({
    super.key,
    required this.title,
    required this.artist,
    required this.imageUrl,
    required this.width,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
                    color: Colors.white,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  artist,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.white70,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
