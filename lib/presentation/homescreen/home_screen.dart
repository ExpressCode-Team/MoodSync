import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:mood_sync/common/widgets/card/emotion_card.dart';
import 'package:mood_sync/core/config/assets/app_vectors.dart';
import 'package:mood_sync/core/config/env/env_config.dart';
import 'package:mood_sync/core/config/theme/app_colors.dart';
import 'package:mood_sync/core/config/theme/app_text_style.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  bool _isLoading = true;
  String? _lastHistoryExpression;
  List<Map<String, dynamic>> trackData = [];
  List<Map<String, dynamic>> playlistData = [];
  final baseUrl = EnvConfig.BASE_URL_LARAVEL;

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    setState(() => _isLoading = true);
    await Future.wait([
      _fetchRecommendations(),
      _fetchPlaylists(),
      _fetchLastHistoryExpression(),
    ]);
    setState(() => _isLoading = false);
  }

  Future<void> _fetchLastHistoryExpression() async {
    final String apiUrl = '$baseUrl/api/last-history-expressions';
    print("Try fetching last history expression on  $apiUrl");

    try {
      // Ambil access token dari secure storage
      String? accessToken = await _secureStorage.read(key: 'accessToken');

      if (accessToken == null) {
        throw Exception('Access token not found');
      }

      // Lakukan request ke API
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'access_token': accessToken, // Header untuk autentikasi
        },
      );

      if (response.statusCode == 200) {
        // Parse response body jika berhasil
        final Map<String, dynamic> decodedResponse = json.decode(response.body);

        final data = decodedResponse['data'];

        if (data != null && data['expression_id'] != null) {
          final int expressionId = data['expression_id'];
          print('Expression ID: $expressionId');

          String emotion = _getExpressionLabel(expressionId);
          print('Emotion Label: $emotion');

          setState(() {
            _lastHistoryExpression = emotion;
          });
        } else {
          throw Exception('Expression ID not found in the response');
        }
      } else {
        throw Exception(
            'Failed to fetch data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching last history expression: $e');
    }
  }

  String _getExpressionLabel(int id) {
    switch (id) {
      case 0:
        return 'angry';
      case 1:
        return 'happy';
      case 2:
        return 'neutral';
      case 3:
        return 'sad';
      default:
        return 'neutral';
    }
  }

  Future<void> _fetchRecommendations() async {
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
            'https://api.spotify.com/v1/search?q=track&type=track&include_external=audi'),
        headers: {'Authorization': 'Bearer $accessToken'},
      );

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        var tracks =
            data['tracks']['items']; // Mengambil array items dari response

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
          // debugPrint('data: $data');

          if (data.containsKey('playlists') &&
              data['playlists']['items'] != null) {
            var playlists = data['playlists']['items'];

            Map<String, dynamic>? validPlaylist;
            for (var item in playlists) {
              if (item != null) {
                validPlaylist = item;
                break;
              }
            }

            if (validPlaylist != null) {
              // debugPrint('Top Playlist $genre : $validPlaylist');
              fetchedPlaylists.add({
                'name': validPlaylist['name'] ?? 'No title',
                'id': validPlaylist['id'],
                'description':
                    validPlaylist['description'] ?? 'No description available',
                'image': (validPlaylist['images'] != null &&
                        validPlaylist['images'].isNotEmpty &&
                        validPlaylist['images'][0]['url'] != null)
                    ? validPlaylist['images'][0]['url']
                    : null,
                'url': validPlaylist['external_urls']['spotify'] ?? '',
              });
            } else {
              debugPrint('No valid playlists found for genre $genre.');
            }
          } else {
            debugPrint(
                'Playlist data kosong atau tidak valid untuk genre $genre.');
          }
        } else {
          debugPrint(
              'Gagal memuat playlist untuk genre $genre: ${response.statusCode}, body: ${response.body}');
          setState(() {
            playlistData = [];
          });
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('Gagal memuat playlist untuk genre $genre')));
          return;
        }
      }

      setState(() {
        playlistData = fetchedPlaylists;
      });
    } catch (e, stackTrace) {
      debugPrint('Error: $e\n$stackTrace');
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Terjadi kesalahan saat memuat playlist.')));
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
                  EmotionCard(emotion: _lastHistoryExpression ?? 'neutral'),
                  const SizedBox(height: 20),
                  Text('Playlist for you', style: AppTextStyle.headline1),
                  const SizedBox(height: 12),
                  _isLoading
                      ? _buildShimmerCards()
                      : playlistData.isEmpty
                          ? _buildShimmerCards()
                          : _buildPlaylistCards(context),
                  Text('Maybe you like', style: AppTextStyle.headline1),
                  const SizedBox(height: 12),
                  _isLoading
                      ? _buildShimmerCards()
                      : trackData.isEmpty
                          ? const Center(
                              child: Text('Unsuccessful in obtaining data'))
                          : _buildTrackCards(context),
                  const SizedBox(height: 20),
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
                _openSpotifyUrl(song['url']);
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
                final playlist = playlistData[index];
                final playlistId = playlist['id'];
                print('Navigating to playlist/$playlistId');
                context.push('/playlist/$playlistId');
              },
              child: Container(
                width: cardWidth,
                height: cardHeight + 50,
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
                          const SizedBox(height: 4),
                          Text(
                            playlist['description'] ??
                                'No description available',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
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
