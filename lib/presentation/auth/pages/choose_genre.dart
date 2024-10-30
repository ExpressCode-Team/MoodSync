import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mood_sync/common/widgets/checkbox/checkbox_image_genre.dart';
import 'package:mood_sync/common/widgets/input/search_text_field.dart';
import 'package:mood_sync/core/config/theme/app_text_style.dart';

class ChooseGenre extends StatefulWidget {
  const ChooseGenre({super.key});

  @override
  State<ChooseGenre> createState() => _ChooseGenreState();
}

class _ChooseGenreState extends State<ChooseGenre> {
  List<bool> isChecked = List.generate(15, (index) => false);

  // dummy
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

  // to temporarily save filter result
  List<Map<String, String>> filteredGenreData = [];

  // text controller for search
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    filteredGenreData = genreData;
    _searchController.addListener(_filterGenres);
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

  void submitCheckedValues() {
    List<String> checkedGenres = [];
    for (var i = 0; i < isChecked.length; i++) {
      if (isChecked[i]) {
        checkedGenres.add(genreData[i]['description']!);
      }
    }

    print('Genre yang dicentang: $checkedGenres');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
          child: Center(
            child: Column(
              children: [
                const Text(
                  'Choose 3 or more genres you like',
                  style: AppTextStyle.headline1,
                ),
                const SizedBox(height: 12),
                SearchTextField(controller: _searchController),
                const SizedBox(height: 42),
                Expanded(
                  child: Stack(children: [
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
                          return CheckboxImageGenre(
                              imageURL: filteredGenreData[index]['imageUrl']!,
                              description: filteredGenreData[index]
                                  ['description']!,
                              initialCheck: isChecked[index],
                              onChanged: (bool checked) {
                                setState(() {
                                  isChecked[index] = checked;
                                });
                              });
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
                              context.go('/homepage');
                            },
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 21, horizontal: 36),
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
                  ]),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
