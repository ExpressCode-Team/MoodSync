import 'package:flutter_dotenv/flutter_dotenv.dart';

class EnvConfig {
  static String CLIENT_ID = 'dc17b919b35b4d07b2c649ce6f339061';
  static String CLIENT_SECRET = '3937a7e9c4bd40fc8f9b026970fd193a';
  static String REDIRECT_URI = 'moodsync://auth';
  static String SPOTIFY_GLOBAL_SCOPE = 'app-remote-control, '
      'user-read-playback-state, '
      'user-modify-playback-state, '
      'user-read-currently-playing';
  static String BASE_URL = 'https://facialexpress.raihanproject.my.id';
  static String BASE_URL_LARAVEL = 'https://laravelmobile.raihanproject.my.id';
}
