import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:mood_sync/presentation/auth/choose_genre.dart';
import 'package:spotify_sdk/spotify_sdk.dart';

class LoginSpotify extends StatefulWidget {
  const LoginSpotify({super.key});

  @override
  State<LoginSpotify> createState() => _LoginSpotifyState();
}

class _LoginSpotifyState extends State<LoginSpotify> {
  bool _connected = false;
  String? _accessToken;
  String? _recommendation;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      home: StreamBuilder(
        stream: SpotifySdk.subscribeConnectionStatus(),
        builder: (context, snapshot) {
          _connected = false;
          var data = snapshot.data;
          if (data != null) {
            _connected = data.connected;
          }
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Login with Spotify'),
                  ElevatedButton(
                    onPressed: getAccessToken,
                    child: const Text('Connect'),
                  ),
                  if (_accessToken != null) ...[
                    const SizedBox(height: 20),
                    const Text(
                      'Access Token:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      _accessToken!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 14, color: Colors.green),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: getRecommendations,
                      child: const Text('Get Recommendations'),
                    ),
                  ],
                  if (_recommendation != null) ...[
                    const SizedBox(height: 20),
                    const Text(
                      'Recommendation:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      _recommendation!,
                      textAlign: TextAlign.center,
                      style:
                          const TextStyle(fontSize: 14, color: Colors.orange),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const ChooseGenre()));
                      },
                      child: const Text('Close'),
                    ),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> getAccessToken() async {
    try {
      var authenticationToken = await SpotifySdk.getAccessToken(
        clientId: 'e7c14753755f4e5fb395af3f8e2eb583',
        redirectUrl: 'moodsync://auth',
        scope: 'app-remote-control, '
            'user-read-playback-state, '
            'user-modify-playback-state, '
            'user-read-currently-playing',
      );
      setState(() {
        _accessToken = authenticationToken;
      });
      print(authenticationToken);
    } on PlatformException catch (e) {
      setState(() {
        _accessToken = '$e.code: ${e.message}';
      });
    } on MissingPluginException {
      setState(() {
        _accessToken = 'not implemented';
      });
    }
  }

  Future<void> getRecommendations() async {
    if (_accessToken == null) {
      setState(() {
        _recommendation = 'Please connect to Spotify first.';
      });
      return;
    }

    const url = 'https://api.spotify.com/v1/recommendations';
    final queryParameters = {
      'seed_genres': 'pop',
      'limit': '1',
    };

    try {
      final uri = Uri.parse(url).replace(queryParameters: queryParameters);
      final response = await http.get(
        uri,
        headers: {
          'Authorization': 'Bearer $_accessToken',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final track = data['tracks'][0];
        setState(() {
          _recommendation =
              '${track['name']} by ${track['artists'][0]['name']}';
        });
      } else {
        setState(() {
          _recommendation =
              'Failed to get recommendations: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        _recommendation = 'Error: $e';
      });
    }
  }
}
