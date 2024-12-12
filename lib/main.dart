import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mood_sync/core/config/theme/app_text_style.dart';
import 'package:mood_sync/core/config/theme/app_theme.dart';
import 'package:mood_sync/presentation/router/app_router_configuration.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    AppTextStyle.setBaseFontSize(context);
    return MaterialApp.router(
      title: 'MoodSync',
      theme: AppTheme.darkTheme,
      debugShowCheckedModeBanner: false,
      routerConfig: AppRouter.router,
    );
  }
}
