import 'package:flutter/material.dart';
import 'package:mood_sync/common/widgets/card/genre_card.dart';
import 'package:mood_sync/common/widgets/input/search_text_field.dart';
import 'package:mood_sync/core/config/assets/app_images.dart';
import 'package:mood_sync/core/config/theme/app_text_style.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, String>> filteredGenreData = [];
  List<bool> isChecked = List.generate(15, (index) => false);
  bool isLoading = false; // State for loading

  List<Map<String, String>> genreData = [
    {
      'imageUrl':
          'https://cdns-images.dzcdn.net/images/cover/fb067a7f369363fb6e98470cf10e5fb5/0x1900-000000-80-0-0.jpg',
      'description': 'Rock'
    },
    {
      'imageUrl':
          'https://cdns-images.dzcdn.net/images/cover/fb067a7f369363fb6e98470cf10e5fb5/0x1900-000000-80-0-0.jpg',
      'description': 'Pop'
    },
    {
      'imageUrl':
          'https://cdns-images.dzcdn.net/images/cover/fb067a7f369363fb6e98470cf10e5fb5/0x1900-000000-80-0-0.jpg',
      'description': 'Jazz'
    },
    {
      'imageUrl':
          'https://cdns-images.dzcdn.net/images/cover/fb067a7f369363fb6e98470cf10e5fb5/0x1900-000000-80-0-0.jpg',
      'description': 'Classical'
    },
    {
      'imageUrl':
          'https://cdns-images.dzcdn.net/images/cover/fb067a7f369363fb6e98470cf10e5fb5/0x1900-000000-80-0-0.jpg',
      'description': 'Hip-Hop'
    },
    {
      'imageUrl':
          'https://cdns-images.dzcdn.net/images/cover/fb067a7f369363fb6e98470cf10e5fb5/0x1900-000000-80-0-0.jpg',
      'description': 'Electronic'
    },
    {
      'imageUrl':
          'https://cdns-images.dzcdn.net/images/cover/fb067a7f369363fb6e98470cf10e5fb5/0x1900-000000-80-0-0.jpg',
      'description': 'Country'
    },
    {
      'imageUrl':
          'https://cdns-images.dzcdn.net/images/cover/fb067a7f369363fb6e98470cf10e5fb5/0x1900-000000-80-0-0.jpg',
      'description': 'Blues'
    },
    {
      'imageUrl':
          'https://cdns-images.dzcdn.net/images/cover/fb067a7f369363fb6e98470cf10e5fb5/0x1900-000000-80-0-0.jpg',
      'description': 'Reggae'
    },
    {
      'imageUrl':
          'https://cdns-images.dzcdn.net/images/cover/fb067a7f369363fb6e98470cf10e5fb5/0x1900-000000-80-0-0.jpg',
      'description': 'Latin'
    },
    {
      'imageUrl':
          'https://cdns-images.dzcdn.net/images/cover/fb067a7f369363fb6e98470cf10e5fb5/0x1900-000000-80-0-0.jpg',
      'description': 'Soul'
    },
    {
      'imageUrl':
          'https://cdns-images.dzcdn.net/images/cover/fb067a7f369363fb6e98470cf10e5fb5/0x1900-000000-80-0-0.jpg',
      'description': 'Folk'
    },
    {
      'imageUrl':
          'https://cdns-images.dzcdn.net/images/cover/fb067a7f369363fb6e98470cf10e5fb5/0x1900-000000-80-0-0.jpg',
      'description': 'Metal'
    },
    {
      'imageUrl':
          'https://cdns-images.dzcdn.net/images/cover/fb067a7f369363fb6e98470cf10e5fb5/0x1900-000000-80-0-0.jpg',
      'description': 'Punk'
    },
    {
      'imageUrl':
          'https://cdns-images.dzcdn.net/images/cover/fb067a7f369363fb6e98470cf10e5fb5/0x1900-000000-80-0-0.jpg',
      'description': 'Indie'
    },
  ];

  @override
  void initState() {
    super.initState();
    filteredGenreData = genreData.take(3).toList();
    _searchController.addListener(_filterGenres);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterGenres() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      isLoading = true; // Show loading indicator
    });

    Future.delayed(const Duration(seconds: 1), () {
      // Simulate a delay for fetching data
      setState(() {
        filteredGenreData = genreData
            .where(
                (genre) => genre['description']!.toLowerCase().contains(query))
            .toList();
        isLoading = false; // Hide loading indicator after fetching data
      });
    });
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Search',
                      style: AppTextStyle.title1,
                    ),
                    GestureDetector(
                      child: Image.asset(AppImages.faceRecogIcon),
                      onTap: () {},
                    )
                  ],
                ),
                const SizedBox(height: 12),
                SearchTextField(controller: _searchController),
                const SizedBox(height: 24),
                Expanded(
                  child: Stack(
                    children: [
                      ScrollConfiguration(
                        behavior: ScrollConfiguration.of(context)
                            .copyWith(scrollbars: false),
                        child: GridView.builder(
                          itemCount: filteredGenreData.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            mainAxisSpacing: 24,
                          ),
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                // Navigasi ke halaman detail
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => GenreDetailPage(
                                      genre: filteredGenreData[index],
                                    ),
                                  ),
                                );
                              },
                              child: GenreCard(
                                imageURL: filteredGenreData[index]['imageUrl']!,
                                description: filteredGenreData[index]
                                    ['description']!,
                                genreLink: filteredGenreData[index]
                                    ['imageUrl']!,
                              ),
                            );
                          },
                        ),
                      ),
                      if (isLoading) // Show loading indicator if still loading
                        const Positioned.fill(
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

//
class GenreDetailPage extends StatelessWidget {
  final Map<String, String> genre;

  const GenreDetailPage({super.key, required this.genre});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(genre['description']!),
      ),
      body: Center(
        child: Column(
          children: [
            Image.network(genre['imageUrl']!),
            Text(genre['description']!),
            // Add other details as needed
          ],
        ),
      ),
    );
  }
}
