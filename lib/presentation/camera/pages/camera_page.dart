import 'dart:convert';
import 'dart:io';

import 'package:camerawesome/camerawesome_plugin.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class CameraPage extends StatefulWidget {
  const CameraPage({super.key});

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  bool _isLoading = false; // Untuk kontrol modal loading
  // URL API
  final String apiUrl = "https://facialexpress.raihanproject.my.id/predict/ml/";

  Future<Map<String, dynamic>> _sendImageToApi(File imageFile) async {
    // Simulasi pengiriman data ke API dengan data dummy
    // await Future.delayed(const Duration(seconds: 2)); // Simulasi loading API

    // Hasil dummy (random predicted value antara 1-4)
    // int predicted = Random().nextInt(4) + 1; // Nilai antara 1-4
    // return {"predicted": predicted};

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

        // Menangani kasus jika tidak ada wajah yang terdeteksi
        if (result["label"] == "No relevant landmarks detected") {
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

  Future<void> _onCapture(File imageFile) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final result = await _sendImageToApi(imageFile);
      setState(() {
        _isLoading = false;
      });

      // Menampilkan hasil API
      print(result);
      _showEmotionResult(result["label"]); // Menampilkan label langsung
    } catch (e) {
      setState(() {
        _isLoading = false;
      });

      // Menampilkan error
      _showErrorDialog("Failed to send image: $e");
    }
  }

  void _showEmotionResult(String label) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Emotion Result"),
        content: Text("Detected emotion: $label"),
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
                            // child: Padding(
                            //   padding: EdgeInsets.only(bottom: 10, top: 10),
                            //   child: Text(
                            //     "Take your best shot!",
                            //     style: TextStyle(
                            //       color: Colors.white,
                            //       fontWeight: FontWeight.bold,
                            //       fontStyle: FontStyle.italic,
                            //     ),
                            //   ),
                            // ),
                          ),
                        );
                      }),
                    ],
                  );
                },
                bottomActionsBuilder: (state) => AwesomeBottomActions(
                  state: state,
                  left: const SizedBox(width: 20),
                  right: const SizedBox(width: 20),
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
