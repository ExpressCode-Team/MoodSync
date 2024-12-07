import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:mood_sync/presentation/auth/choose_genre.dart';
import 'package:mood_sync/presentation/auth/login_spotify.dart';
import 'package:mood_sync/presentation/auth/register_page.dart';
import 'package:mood_sync/presentation/camera/camera_page.dart';
import 'package:mood_sync/presentation/error/error_page.dart';
import 'package:mood_sync/presentation/home/home_page.dart';
import 'package:mood_sync/presentation/homescreen/playlist_detail_screen.dart';
import 'package:mood_sync/presentation/intro/get_started.dart';
import 'package:mood_sync/presentation/recomendation/recomendation_page.dart';
import 'package:mood_sync/presentation/splash/splash.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/get-started',
    routes: [
      GoRoute(
        path: '/splash',
        name: 'splash',
        pageBuilder: (context, state) {
          return const MaterialPage(child: SplashPage());
        },
      ),
      GoRoute(
        path: '/get-started',
        name: 'get-started',
        pageBuilder: (context, state) {
          return const MaterialPage(child: GetStartedPage());
        },
      ),
      GoRoute(
        path: '/signin',
        name: 'signin',
        pageBuilder: (context, state) {
          return const MaterialPage(child: LoginSpotify());
        },
      ),
      GoRoute(
        path: '/register',
        name: 'register',
        pageBuilder: (context, state) {
          return const MaterialPage(child: RegisterPage());
        },
      ),
      GoRoute(
        path: '/choose-genre',
        name: 'choose-genre',
        pageBuilder: (context, state) {
          return const MaterialPage(child: ChooseGenre());
        },
      ),
      GoRoute(
        path: '/homepage',
        name: 'homepage',
        pageBuilder: (context, state) {
          return const MaterialPage(child: HomePage());
        },
      ),
      GoRoute(
        path: '/playlist/:playlistId', // :playlistId adalah parameter dinamis
        builder: (context, state) {
          final playlistId = state.pathParameters['playlistId']!;
          return PlaylistDetailScreen(playlistId: playlistId);
        },
      ),
      GoRoute(
        path: '/camera-page',
        name: 'camera-page',
        pageBuilder: (context, state) {
          return const MaterialPage(child: CameraPage());
        },
      ),
      GoRoute(
        path: '/result-page/:emotion',
        name: 'result-page',
        builder: (BuildContext context, GoRouterState state) {
          final emotion = state.pathParameters['emotion'] ??
              ''; // Ambil emotion dari queryParameters
          return ResultRecommendationPage(
              emotion: emotion); // Pass emotion ke ResultRecommendationPage
        },
      )

      // test hasil camera
      // GoRoute(
      //   path: '/result-camera',
      //   name: 'result-camera',
      //   pageBuilder: (context, state) {
      //     final imagePath state.extra as String;
      //     return const MaterialPage(child: ResultPage(imageFile: imageFile,));
      //   },
      // ),
    ],
    errorBuilder: (context, state) {
      final errorMessage = state.error?.toString() ?? 'Unknown error occurred';
      return ErrorPage(errorMessage: errorMessage);
    },
    // redirect: (BuildContext context, GoRouterState state) async {
    //   const storage = FlutterSecureStorage();
    //   final accessToken = await storage.read(key: 'accessToken');

    //   if (accessToken == null) {
    //     return null;
    //   }

    //   final prefs = await SharedPreferences.getInstance();
    //   final selectedGenres = prefs.getString('selectedGenres');

    //   if (selectedGenres == null ||
    //       (json.decode(selectedGenres) as List).isEmpty) {
    //     return '/choose-genre';
    //   }

    //   return '/homepage';
    // },
  );
}
