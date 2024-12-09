import 'dart:convert';
import 'dart:io';

import 'package:camerawesome/camerawesome_plugin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:mood_sync/core/config/assets/app_images.dart';
import 'package:mood_sync/core/config/env/env_config.dart';
import 'package:mood_sync/core/config/theme/app_text_style.dart';
import 'package:path_provider/path_provider.dart';

class CameraPage extends StatefulWidget {
  const CameraPage({super.key});

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  bool _isLoading = false; // Untuk kontrol modal loading
  final String baseUrlLaravel = EnvConfig.BASE_URL_LARAVEL;
  final String baseUrl = EnvConfig.BASE_URL;
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  late String apiUrl;
  late String storeDataUrl;

  @override
  void initState() {
    super.initState();
    // URL API
    apiUrl = "$baseUrl/predict/ml/";
    // Sesuaikan api
    storeDataUrl = "$baseUrlLaravel/api/history-expressions";
    print('baseURLLaravel : $baseUrlLaravel');
    print('baseURL : $baseUrl');
  }

  // Simulasi request API untuk mendapatkan emosi
  Future<Map<String, dynamic>> _simulateEmotionRequest() async {
    await Future.delayed(const Duration(seconds: 2)); // Simulated request delay
    List<String> emotions = ["happy", "sad", "angry", "neutral"];
    String simulatedEmotion = emotions[
        (emotions.length * (DateTime.now().millisecondsSinceEpoch % 100) / 100)
            .floor()];
    List<int> predictions = [1, 2, 3]; // Dummy prediction list
    return {
      "predict": predictions,
      "label": simulatedEmotion,
    };
  }

  Future<Map<String, dynamic>> _sendImageToApi(File imageFile) async {
    // simulasi
    // // Simulasi pengiriman data ke API dengan data dummy
    // await Future.delayed(const Duration(seconds: 1));

    // // Hasil dummy (random predicted value antara 1-4)
    // int predicted = Random().nextInt(4) + 1; // Nilai antara 1-4
    // return {"predicted": predicted};
    // end simualasi

    // aseli
    try {
      // Membuat request multipart
      var request = http.MultipartRequest('POST', Uri.parse(apiUrl))
        ..files.add(await http.MultipartFile.fromPath(
          'file', // Nama field yang diterima API
          imageFile.path,
        ));

      // Menambahkan header 'Accept' untuk menerima JSON
      request.headers.addAll({'Accept': 'application/json'});

      // Kirim permintaan dan tunggu respons
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        // Decode JSON response
        Map<String, dynamic> result = jsonDecode(response.body);
        print("Response JSON: $result");

        // Menangani kasus jika tidak ada wajah yang terdeteksi
        if (result["label"] == "Relevant landmark not detected") {
          throw Exception('No face detected. Please try again.');
        }

        // Parsing the string list to actual integer list
        List<int> predictions = List<int>.from(jsonDecode(result["predict"]));

        return {
          "predict": predictions,
          "label": result["label"], // Menyimpan label emosi yang diterima
        };
      } else {
        throw Exception('Failed to connect: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error sending image to API: $e');
    }
  }

  // aseli
  // Future<void> _onCapture(File imageFile) async {
  //   setState(() {
  //     _isLoading = true;
  //   });

  //   try {
  //     final result = await _sendImageToApi(imageFile);
  //     setState(() {
  //       _isLoading = false;
  //     });

  //     // Menampilkan hasil API
  //     print(result);
  //     _showEmotionResult(result["label"]); // Menampilkan label langsung
  //   } catch (e) {
  //     setState(() {
  //       _isLoading = false;
  //     });

  //     // Menampilkan error
  //     _showErrorDialog("Failed to send image: $e");
  //   }
  // }

  // simulation
  // Future<void> _onCapture(File imageFile) async {
  //   setState(() {
  //     _isLoading = true;
  //   });

  //   try {
  //     // Gunakan fungsi simulasi untuk mendapatkan hasil emosi
  //     final result = await _simulateEmotionRequest();

  //     setState(() {
  //       _isLoading = false;
  //     });

  //     // Menampilkan hasil API
  //     print(result);
  //     _showEmotionResult(result["label"]); // Menampilkan label langsung
  //   } catch (e) {
  //     setState(() {
  //       _isLoading = false;
  //     });

  //     // Menampilkan error
  //     _showErrorDialog("Failed to send image: $e");
  //   }
  // }

  // simulation
  Future<void> _onCapture(File imageFile) async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Gunakan fungsi simulasi untuk mendapatkan hasil emosi
      // final result = await _simulateEmotionRequest();

      final result = await _sendImageToApi(imageFile);

      setState(() {
        _isLoading = false;
      });

      String token = await _getAccessToken();

      if (result["predict"] != null && result["predict"].isNotEmpty) {
        int expressionId = _getExpressionId(result["label"]);
        await _storeDataToApi(token, expressionId);
      }
      _showEmotionResult(result["label"]);
    } catch (e) {
      setState(() {
        _isLoading = false;
      });

      // Menampilkan error
      _showErrorDialog("Failed to send image: $e");
    }
  }

  Future<String> _getAccessToken() async {
    try {
      String? token = await _secureStorage.read(key: 'accessToken');
      if (token == null) {
        throw Exception("Access token is not available.");
      }
      return token;
    } catch (e) {
      throw Exception("Error reading token: $e");
    }
  }

  int _getExpressionId(String label) {
    switch (label.toLowerCase()) {
      case 'angry':
        return 0;
      case 'happy':
        return 1;
      case 'neutral':
        return 2;
      case 'sad':
        return 3;
      default:
        return 2;
    }
  }

  Future<void> _storeDataToApi(String accessToken, int expressionId) async {
    try {
      final response = await http.post(
        Uri.parse(storeDataUrl),
        headers: {
          'access_token': accessToken,
        },
        body: {
          'expression_id': expressionId.toString(),
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        debugPrint("Data stored successfully: ${response.body}");
      } else {
        throw Exception(
            "Failed to store data. Status code: ${response.statusCode}. Response: ${response.body}");
      }
    } catch (e) {
      debugPrint("Error storing data to API: $e");
    }
  }

  // simulation
  void _showEmotionResult(String label) {
    String getImagePath(String emotion) {
      switch (emotion.toLowerCase()) {
        case 'angry':
          return AppImages.angerEmot;
        case 'sad':
          return AppImages.sadEmot;
        case 'happy':
          return AppImages.happyEmot;
        default:
          return AppImages.calmEmot;
      }
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        final screenWidth = MediaQuery.of(context).size.width;
        final imageSize = screenWidth * 0.4;

        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                getImagePath(label),
                height: imageSize,
                width: imageSize,
              ),
              const SizedBox(height: 20),
              Text(
                "Detected expression\n$label",
                style: AppTextStyle.title3,
                textAlign: TextAlign.center,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                context.go('/result-page/$label');
              },
              child: const Text("Next"),
            ),
          ],
        );
      },
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Error"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SafeArea(
            child: Container(
              color: Colors.white,
              child: CameraAwesomeBuilder.awesome(
                previewAlignment: Alignment.center,
                previewFit: CameraPreviewFit.cover,
                progressIndicator: const Center(
                  child: SizedBox(
                    width: 100,
                    height: 100,
                    child: CircularProgressIndicator(),
                  ),
                ),
                theme: AwesomeTheme(
                  bottomActionsBackgroundColor: Colors.black.withOpacity(0.5),
                ),
                topActionsBuilder: (state) => AwesomeTopActions(
                  padding: EdgeInsets.zero,
                  state: state,
                  children: const [],
                ),
                middleContentBuilder: (state) {
                  return Column(
                    children: [
                      const Spacer(),
                      Builder(builder: (context) {
                        return Container(
                          color: AwesomeThemeProvider.of(context)
                              .theme
                              .bottomActionsBackgroundColor,
                          child: const Align(
                            alignment: Alignment.bottomCenter,
                          ),
                        );
                      }),
                    ],
                  );
                },
                bottomActionsBuilder: (state) => AwesomeBottomActions(
                  state: state,
                  left: const SizedBox(width: 20),
                  // right: const SizedBox(width: 20),
                  right: AwesomeFlashButton(state: state),
                ),
                saveConfig: SaveConfig.photo(
                  mirrorFrontCamera: true,
                  pathBuilder: (sensors) async {
                    final Directory extDir = await getTemporaryDirectory();
                    final testDir = await Directory(
                      '${extDir.path}/camerawesome',
                    ).create(recursive: true);
                    final String filePath =
                        '${testDir.path}/${DateTime.now().millisecondsSinceEpoch}.jpg';
                    return SingleCaptureRequest(filePath, sensors.first);
                  },
                ),
                sensorConfig: SensorConfig.single(
                  flashMode: FlashMode.auto,
                  sensor: Sensor.position(
                    SensorPosition.front,
                  ),
                  zoom: 0.0,
                ),
                onMediaCaptureEvent: (event) {
                  if (event.status == MediaCaptureStatus.success &&
                      event.isPicture) {
                    event.captureRequest.when(
                      single: (single) {
                        final imagePath = single.file?.path;
                        if (imagePath != null) {
                          final imageFile = File(imagePath);
                          _onCapture(imageFile);
                        }
                      },
                      multiple: (multiple) {
                        multiple.fileBySensor.forEach((key, value) {
                          debugPrint(
                              'Multiple image taken: $key ${value?.path}');
                        });
                      },
                    );
                  } else if (event.status == MediaCaptureStatus.failure) {
                    debugPrint('Capture failed: ${event.exception}');
                  }
                },
              ),
            ),
          ),
          if (_isLoading)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }
}

// class RecommendationPage extends StatelessWidget {
//   final String emotion;

//   const RecommendationPage({super.key, required this.emotion});

//   Future<void> _fetchRecommendation(
//       BuildContext context, String emotion) async {
//     await Future.delayed(
//         const Duration(seconds: 2)); // Simulasi penundaan 2 detik

//     // Simulasi hasil rekomendasi song ID
//     String simulatedSongId = "3U4isOIWM3VvDubwSI3y7a";

//     // Menampilkan hasil rekomendasi dalam bentuk alert
//     print("Rekomendasi Song ID: $simulatedSongId");

//     // Menampilkan dialog dengan rekomendasi
//     showDialog(
//       context: context,
//       builder: (_) => AlertDialog(
//         title: const Text("Song Recommendation"),
//         content: Text(
//             "Based on your emotion ($emotion), we recommend song ID: $simulatedSongId"),
//         actions: [
//           TextButton(
//             onPressed: () {
//               Navigator.pop(context);
//             },
//             child: const Text("OK"),
//           ),
//         ],
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     // Memanggil fungsi _fetchRecommendation setelah build selesai
//     _fetchRecommendation(context, emotion);

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Song Recommendations"),
//       ),
//       body: Center(
//         child: Text("Fetching recommendations for emotion: $emotion"),
//       ),
//     );
//   }
// }
