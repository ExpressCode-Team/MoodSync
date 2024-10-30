import 'package:flutter/material.dart';
import 'package:mood_sync/core/config/theme/app_theme.dart';
import 'package:mood_sync/presentation/router/app_router_configuration.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      theme: AppTheme.darkTheme,
      debugShowCheckedModeBanner: false,
      routerConfig: AppRouter.router,
    );
  }
}
