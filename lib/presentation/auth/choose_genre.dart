import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mood_sync/common/widgets/checkbox/checkbox_image_genre.dart';
import 'package:mood_sync/common/widgets/input/search_text_field.dart';
import 'package:mood_sync/core/config/theme/app_text_style.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Static genres list
final List<String> staticGenres = [
  'Pop',
  'Rock',
  'Hip-Hop',
  'R&B',
  'Jazz',
  'Classical',
  'Indie',
  'Dangdut',
  'Latin',
  'Dance/Electronic',
  'Reggaeton',
  'EDM',
  'Blues',
  'Punk',
  'Alternative',
  'Soul',
  'Folk',
  'World Music',
  'Metal',
  'Country',
  'Ambient',
  'K-Pop',
  'Afrobeats',
  'Trap',
  'Indie Pop',
  'Lo-Fi Beats',
  'Bossa Nova',
  'Reggae',
  'Jazz Funk',
  'Ska',
  'Techno',
  'House',
  'Pop Rock',
  'Funk',
  'Gospel',
  'Bluegrass',
  'Dubstep',
  'Karaoke',
  'Disco',
  'Salsa',
  'Bhangra',
  'Tango',
  'Psychedelic',
  'Samba',
  'Folk Rock',
  'Grunge',
  'Alt Rock',
  'Experimental',
  'Folk Pop',
  'Celtic',
  'Hard Rock',
  'Electronic Rock',
  'Trap Music',
  'Glitch Hop',
  'Chillwave',
  'Industrial'
];

class ChooseGenre extends StatefulWidget {
  const ChooseGenre({super.key});

  @override
  State<ChooseGenre> createState() => _ChooseGenreState();
}

class _ChooseGenreState extends State<ChooseGenre> {
  // Menggunakan Map untuk menyimpan status checkbox berdasarkan genre
  Map<String, bool> genreCheckedMap = {};

  // Menyimpan data genre yang telah difilter
  List<String> filteredGenreData = staticGenres;

  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_filterGenres);

    // Menginisialisasi map dengan status checkbox untuk setiap genre
    for (var genre in staticGenres) {
      genreCheckedMap[genre] = false;
    }
  }

  // Memfilter genre berdasarkan pencarian
  void _filterGenres() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      filteredGenreData = staticGenres
          .where((genre) => genre.toLowerCase().contains(query))
          .toList();
    });
  }

  int get selectedCount =>
      genreCheckedMap.values.where((checked) => checked).length;

  Future<void> submitCheckedValues() async {
    // Ambil genre yang dipilih berdasarkan Map
    List<String> checkedGenres = genreCheckedMap.entries
        .where((entry) => entry.value)
        .map((entry) => entry.key)
        .toList();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selectedGenres', json.encode(checkedGenres));

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
                  child: _buildGenreGrid(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGenreGrid() {
    return Stack(
      children: [
        GridView.builder(
          itemCount: filteredGenreData.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 24,
          ),
          itemBuilder: (context, index) {
            String genre = filteredGenreData[index];
            return CheckboxImageGenre(
              imageURL: '', // Tidak ada gambar, kosongkan
              description: genre,
              initialCheck: genreCheckedMap[genre] ?? false,
              onChanged: (bool checked) {
                setState(() {
                  genreCheckedMap[genre] = checked;
                });
              },
            );
          },
        ),
        if (selectedCount >= 3)
          Positioned(
            bottom: 16,
            left: 0,
            right: 0,
            child: Center(
              child: ElevatedButton(
                onPressed: submitCheckedValues,
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
      ],
    );
  }
}
