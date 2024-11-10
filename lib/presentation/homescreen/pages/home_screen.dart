import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mood_sync/common/widgets/card/emotion_card.dart';
import 'package:mood_sync/core/config/assets/app_vectors.dart';
import 'package:mood_sync/core/config/theme/app_colors.dart';
import 'package:mood_sync/core/config/theme/app_text_style.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.darkBackground,
        surfaceTintColor: AppColors.darkBackground,
        title: Padding(
          padding: EdgeInsets.symmetric(
              vertical: MediaQuery.of(context).size.height * 0.01,
              horizontal: MediaQuery.of(context).size.width * 0.01),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SvgPicture.asset(
                AppVectors.logo,
                height: AppBar().preferredSize.height * 0.7,
              ),
              IconButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('This is settings button')));
                  },
                  icon: const Icon(
                    Icons.more_vert,
                    color: Colors.white,
                  ))
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(32, 16, 32, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const EmotionCard(
                emotion: 'anger',
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                'Tuned for you',
                style: AppTextStyle.headline1,
                textAlign: TextAlign.start,
              ),
              const SizedBox(
                height: 16,
              ),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 3 / 4,
                ),
                itemCount: 4,
                itemBuilder: (context, index) {
                  // Data statis sementara
                  final songData = [
                    {
                      'title': 'Levitating',
                      'artist': 'Dua Lipa',
                      'image':
                          'https://cdns-images.dzcdn.net/images/cover/fb067a7f369363fb6e98470cf10e5fb5/0x1900-000000-80-0-0.jpg'
                    },
                    {
                      'title': 'APT',
                      'artist': 'Rose',
                      'image':
                          'https://cdns-images.dzcdn.net/images/cover/fb067a7f369363fb6e98470cf10e5fb5/0x1900-000000-80-0-0.jpg'
                    },
                    {
                      'title': 'Levitating',
                      'artist': 'Dua Lipa',
                      'image':
                          'https://cdns-images.dzcdn.net/images/cover/fb067a7f369363fb6e98470cf10e5fb5/0x1900-000000-80-0-0.jpg'
                    },
                    {
                      'title': 'APT',
                      'artist': 'Rose',
                      'image':
                          'https://cdns-images.dzcdn.net/images/cover/fb067a7f369363fb6e98470cf10e5fb5/0x1900-000000-80-0-0.jpg'
                    },
                  ][index];

                  return SongCard(
                    title: songData['title']!,
                    artist: songData['artist']!,
                    imageUrl: songData['image']!,
                  );
                },
              ),
              // Expanded(
              //   child: GridView.builder(
              //     gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              //       crossAxisCount: 2,
              //       crossAxisSpacing: 16,
              //       mainAxisSpacing: 16,
              //       childAspectRatio: 3 / 4,
              //     ),
              //     itemCount: 4,
              //     itemBuilder: (context, index) {
              //       // Data statis sementara
              //       final songData = [
              //         {
              //           'title': 'Levitating',
              //           'artist': 'Dua Lipa',
              //           'image':
              //               'https://cdns-images.dzcdn.net/images/cover/fb067a7f369363fb6e98470cf10e5fb5/0x1900-000000-80-0-0.jpg'
              //         },
              //         {
              //           'title': 'APT',
              //           'artist': 'Rose',
              //           'image':
              //               'https://cdns-images.dzcdn.net/images/cover/fb067a7f369363fb6e98470cf10e5fb5/0x1900-000000-80-0-0.jpg'
              //         },
              //         {
              //           'title': 'Levitating',
              //           'artist': 'Dua Lipa',
              //           'image':
              //               'https://cdns-images.dzcdn.net/images/cover/fb067a7f369363fb6e98470cf10e5fb5/0x1900-000000-80-0-0.jpg'
              //         },
              //         {
              //           'title': 'APT',
              //           'artist': 'Rose',
              //           'image':
              //               'https://cdns-images.dzcdn.net/images/cover/fb067a7f369363fb6e98470cf10e5fb5/0x1900-000000-80-0-0.jpg'
              //         },
              //       ][index];

              //       return SongCard(
              //         title: songData['title']!,
              //         artist: songData['artist']!,
              //         imageUrl: songData['image']!,
              //       );
              //     },
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}

class SongCard extends StatelessWidget {
  final String title;
  final String artist;
  final String imageUrl;

  const SongCard({
    super.key,
    required this.title,
    required this.artist,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
              height: 80,
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
                    Colors.black.withOpacity(0.7),
                  ],
                ),
              ),
            ),
          ),
          // Teks judul dan artis
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  artist,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


// sliver
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:mood_sync/common/widgets/card/emotion_card.dart';
// import 'package:mood_sync/core/config/assets/app_vectors.dart';
// import 'package:mood_sync/core/config/theme/app_colors.dart';
// import 'package:mood_sync/core/config/theme/app_text_style.dart';

// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});

//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         surfaceTintColor: AppColors.darkBackground,
//         backgroundColor: AppColors.darkBackground,
//         title: Padding(
//           padding: EdgeInsets.symmetric(
//               vertical: MediaQuery.of(context).size.height * 0.01,
//               horizontal: MediaQuery.of(context).size.width * 0.01),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               SvgPicture.asset(
//                 AppVectors.logo,
//                 height: AppBar().preferredSize.height * 0.7,
//               ),
//               IconButton(
//                   onPressed: () {
//                     ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
//                         content: Text('This is settings button')));
//                   },
//                   icon: const Icon(
//                     Icons.more_vert,
//                     color: Colors.white,
//                   ))
//             ],
//           ),
//         ),
//       ),
//       body: CustomScrollView(
//         slivers: [
//           // EmotionCard section
//           SliverToBoxAdapter(
//             child: Padding(
//               padding: const EdgeInsets.fromLTRB(32, 16, 32, 0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const EmotionCard(
//                     emotion: 'anger',
//                   ),
//                   const SizedBox(height: 24),
//                   Text(
//                     'Tuned for you',
//                     style: AppTextStyle.headline1,
//                   ),
//                   const SizedBox(height: 24),
//                 ],
//               ),
//             ),
//           ),
//           // GridView section
//           SliverPadding(
//             padding: const EdgeInsets.symmetric(horizontal: 32),
//             sliver: SliverGrid(
//               delegate: SliverChildBuilderDelegate(
//                 (context, index) {
//                   // Data statis sementara
//                   final songData = [
//                     {
//                       'title': 'Levitating',
//                       'artist': 'Dua Lipa',
//                       'image':
//                           'https://cdns-images.dzcdn.net/images/cover/fb067a7f369363fb6e98470cf10e5fb5/0x1900-000000-80-0-0.jpg'
//                     },
//                     {
//                       'title': 'APT',
//                       'artist': 'Rose',
//                       'image':
//                           'https://cdns-images.dzcdn.net/images/cover/fb067a7f369363fb6e98470cf10e5fb5/0x1900-000000-80-0-0.jpg'
//                     },
//                     {
//                       'title': 'Levitating',
//                       'artist': 'Dua Lipa',
//                       'image':
//                           'https://cdns-images.dzcdn.net/images/cover/fb067a7f369363fb6e98470cf10e5fb5/0x1900-000000-80-0-0.jpg'
//                     },
//                     {
//                       'title': 'APT',
//                       'artist': 'Rose',
//                       'image':
//                           'https://cdns-images.dzcdn.net/images/cover/fb067a7f369363fb6e98470cf10e5fb5/0x1900-000000-80-0-0.jpg'
//                     },
//                   ][index];

//                   return SongCard(
//                     title: songData['title']!,
//                     artist: songData['artist']!,
//                     imageUrl: songData['image']!,
//                   );
//                 },
//                 childCount: 4,
//               ),
//               gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                 crossAxisCount: 2,
//                 crossAxisSpacing: 16,
//                 mainAxisSpacing: 16,
//                 childAspectRatio: 3 / 4,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class SongCard extends StatelessWidget {
//   final String title;
//   final String artist;
//   final String imageUrl;

//   const SongCard({
//     super.key,
//     required this.title,
//     required this.artist,
//     required this.imageUrl,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(8),
//         color: AppColors.darkBackground,
//         image: DecorationImage(
//           image: NetworkImage(imageUrl),
//           fit: BoxFit.cover,
//         ),
//       ),
//       child: Stack(
//         children: [
//           Align(
//             alignment: Alignment.bottomCenter,
//             child: Container(
//               height: 80,
//               decoration: BoxDecoration(
//                 borderRadius: const BorderRadius.only(
//                   bottomLeft: Radius.circular(8),
//                   bottomRight: Radius.circular(8),
//                 ),
//                 gradient: LinearGradient(
//                   begin: Alignment.topCenter,
//                   end: Alignment.bottomCenter,
//                   colors: [
//                     Colors.transparent,
//                     Colors.black.withOpacity(0.7),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//           // Teks judul dan artis
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.end,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   title,
//                   style: const TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.white,
//                   ),
//                 ),
//                 Text(
//                   artist,
//                   style: const TextStyle(
//                     fontSize: 14,
//                     color: Colors.white70,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
