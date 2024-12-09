import 'package:flutter_dotenv/flutter_dotenv.dart';

class EnvConfig {
  static String CLIENT_ID = dotenv.env['CLIENT_ID'] ?? 'default_client_id';
  static String CLIENT_SECRET =
      dotenv.env['CLIENT_SECRET'] ?? 'default_client_secret';
  static String REDIRECT_URI =
      dotenv.env['REDIRECT_URI'] ?? 'default_redirect_uri';
  static String SPOTIFY_GLOBAL_SCOPE = 'app-remote-control, '
      'user-read-playback-state, '
      'user-modify-playback-state, '
      'user-read-currently-playing';
  static String BASE_URL = 'https://facialexpress.raihanproject.my.id';
  static String BASE_URL_LARAVEL = 'https://laravelmobile.raihanproject.my.id';
}
