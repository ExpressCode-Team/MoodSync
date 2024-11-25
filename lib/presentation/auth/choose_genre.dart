import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:mood_sync/common/widgets/checkbox/checkbox_image_genre.dart';
import 'package:mood_sync/common/widgets/input/search_text_field.dart';
import 'package:mood_sync/core/config/theme/app_text_style.dart';
import 'package:shimmer/shimmer.dart';

class ChooseGenre extends StatefulWidget {
  const ChooseGenre({super.key});

  @override
  State<ChooseGenre> createState() => _ChooseGenreState();
}

class _ChooseGenreState extends State<ChooseGenre> {
  List<bool> isChecked = List.generate(150, (index) => false);

  List<Map<String, dynamic>> genreData = [];

  // to temporarily save filter result
  List<Map<String, dynamic>> filteredGenreData = [];

  // text controller for search
  final TextEditingController _searchController = TextEditingController();

  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  bool _isLoading = true;

  @override
  void initState() {
    print("Masuk ke choose_genre");
    super.initState();
    // filteredGenreData = genreData;
    _loadGenres();
    _searchController.addListener(_filterGenres);
  }

  // Ambil access token dan data genre dari Spotify
  Future<void> _loadGenres() async {
    // Simpan waktu mulai loading
    final startLoading = DateTime.now();

    // Ambil access token dari secure storage
    String? accessToken = await _secureStorage.read(key: 'accessToken');

    if (accessToken == null) {
      print("Access token tidak ditemukan!");
      return;
    } else {
      print("Access token ditemukan: $accessToken");
    }

    final elapsed = DateTime.now().difference(startLoading);
    final remainingTime = const Duration(seconds: 2) - elapsed;

    // Jika belum 2 detik, tunggu waktu sisa
    if (remainingTime > Duration.zero) {
      await Future.delayed(remainingTime);
    }

    // Request ke API Spotify untuk mendapatkan genre
    final response = await http.get(
      Uri.parse(
          'https://api.spotify.com/v1/recommendations/available-genre-seeds'),
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      // Parsing response dari Spotify
      var data = json.decode(response.body);

      // Pastikan Anda mengambil key yang benar sesuai dengan struktur response
      print("hasil data dari api: $data");
      var categories = data['genres']; // Mengambil langsung genres

      if (categories != null) {
        setState(() {
          genreData = categories
              .map<Map<String, dynamic>>((genre) => {
                    'imageUrl':
                        'https://avatar.iran.liara.run/username?username=$genre', // URL gambar
                    'description':
                        genre // Nama genre ditempatkan di 'description'
                  })
              .toList();
          filteredGenreData = genreData;
          _isLoading = false;
        });
      } else {
        print('Genres tidak ditemukan dalam response API!');
      }
    } else {
      print('Gagal memuat genre: ${response.statusCode}');
    }
  }

  void _filterGenres() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      filteredGenreData = genreData
          .where((genre) => genre['description']!.toLowerCase().contains(query))
          .toList();
    });
  }

  int get selectedCount => isChecked.where((checked) => checked).length;

  Future<void> submitCheckedValues() async {
    List<String> checkedGenres = [];
    for (var i = 0; i < isChecked.length; i++) {
      if (isChecked[i]) {
        checkedGenres.add(genreData[i]['description']!);
      }
    }

    await _secureStorage.write(
      key: 'selectedGenres',
      value: json.encode(checkedGenres),
    );

    print('Genre yang dicentang: $checkedGenres');
    context.go('/homepage');
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            MediaQuery.of(context).size.width * 0.06,
            MediaQuery.of(context).size.height * 0.03,
            MediaQuery.of(context).size.width * 0.06,
            0,
          ),
          child: Center(
            child: Column(
              children: [
                Text(
                  'Choose 3 or more genres you like',
                  style: AppTextStyle.headline1,
                ),
                const SizedBox(height: 12),
                SearchTextField(controller: _searchController),
                const SizedBox(height: 24),
                Expanded(
                  child: _isLoading ? _buildShimmerGrid() : _buildGenreGrid(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildShimmerGrid() {
    return GridView.builder(
      itemCount: 15, // Placeholder dengan jumlah item sementara
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 24,
        crossAxisSpacing: 16,
      ),
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey[400]!,
          highlightColor: Colors.grey[200]!,
          child: Column(
            mainAxisSize: MainAxisSize.min, // Sesuaikan dengan widget asli
            children: [
              ClipOval(
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.2,
                  height: MediaQuery.of(context).size.width * 0.2,
                  color: Colors.grey[400], // Placeholder untuk gambar
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.width * 0.02),
              Flexible(
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.15,
                  height: 20,
                  decoration: BoxDecoration(
                    color: Colors.grey[400], // Placeholder untuk teks
                    borderRadius:
                        BorderRadius.circular(15), // Membuat rounded corners
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildGenreGrid() {
    return Stack(children: [
      ScrollConfiguration(
        behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
        child: GridView.builder(
          itemCount: filteredGenreData.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 24,
          ),
          itemBuilder: (context, index) {
            return CheckboxImageGenre(
              imageURL: filteredGenreData[index]['imageUrl']!,
              description: filteredGenreData[index]['description']!,
              initialCheck: isChecked[index],
              onChanged: (bool checked) {
                setState(() {
                  isChecked[index] = checked;
                });
              },
            );
          },
        ),
      ),
      if (selectedCount >= 3)
        Positioned(
          bottom: 16,
          left: 0,
          right: 0,
          child: Center(
            child: ElevatedButton(
              onPressed: () {
                submitCheckedValues();
              },
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(vertical: 21, horizontal: 36),
                backgroundColor: Colors.white,
              ),
              child: const Text(
                'Done',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ),
    ]);
  }
}
