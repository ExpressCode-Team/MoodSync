import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mood_sync/presentation/auth/pages/choose_genre.dart';
import 'package:mood_sync/presentation/auth/pages/login_page.dart';
import 'package:mood_sync/presentation/auth/pages/register_page.dart';
import 'package:mood_sync/presentation/camera/pages/camera_page.dart';
import 'package:mood_sync/presentation/error/pages/error_page.dart';
import 'package:mood_sync/presentation/home/pages/home_page.dart';
import 'package:mood_sync/presentation/intro/pages/get_started.dart';
import 'package:mood_sync/presentation/splash/pages/splash.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/splash',
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
          return const MaterialPage(child: LoginPage());
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
        path: '/camera-page',
        name: 'camera-page',
        pageBuilder: (context, state) {
          return const MaterialPage(child: CameraPage());
        },
      ),
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
  );
}
