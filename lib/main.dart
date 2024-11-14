import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mood_sync/core/config/theme/app_text_style.dart';
import 'package:mood_sync/core/config/theme/app_theme.dart';
import 'package:mood_sync/data/datasources/remote_datasources/auth_remote_datasource.dart';
import 'package:mood_sync/presentation/bloc/bloc/auth_bloc.dart';
import 'package:mood_sync/presentation/router/app_router_configuration.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    AppTextStyle.setBaseFontSize(context);
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AuthBloc(AuthRemoteDatasource())
            ..add(const AuthEvent.checkLoginStatus()),
        ),
      ],
      child: MaterialApp.router(
        title: 'MoodSync',
        theme: AppTheme.darkTheme,
        debugShowCheckedModeBanner: false,
        routerConfig: AppRouter.router,
      ),
    );
  }
}
