import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:mood_sync/app/core/consts/constants.dart';

class CameraController extends GetxController {
  final getStorage = GetStorage();
  final String apiUrl = "${Constants.BASE_URL_ML}/predict/ml/";
  final String storeDataUrl =
      "${Constants.BASE_URL_LARAVEL}/api/history-expressions";

  var isLoading = false.obs;

  Future<Map<String, dynamic>> processImage(File imageFile,
      {bool simulate = false}) async {
    if (simulate) {
      print('Simulation: true');
      return await simulateEmotionRequest();
    } else {
      print('Simulation: false');
      return await sendImageToApi(imageFile);
    }
  }

  Future<Map<String, dynamic>> sendImageToApi(File imageFile) async {
    try {
      var request = http.MultipartRequest('POST', Uri.parse(apiUrl))
        ..files.add(await http.MultipartFile.fromPath('file', imageFile.path))
        ..headers.addAll({'Accept': 'application/json'});

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        Map<String, dynamic> result = jsonDecode(response.body);
        if (result["label"] == "Relevant landmark not detected") {
          throw Exception('No face detected. Please try again.');
        }
        List<int> predictions = List<int>.from(jsonDecode(result["predict"]));
        return {
          "predict": predictions,
          "label": result["label"],
        };
      } else {
        throw Exception('Failed to connect: ${response.statusCode}');
      }
    } catch (e) {
      showError('Error sending image to API: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> simulateEmotionRequest() async {
    await Future.delayed(const Duration(seconds: 1));
    List<String> emotions = ["happy", "sad", "angry", "neutral"];
    String simulatedEmotion = emotions[
        (emotions.length * (DateTime.now().millisecondsSinceEpoch % 100) / 100)
            .floor()];
    List<int> predictions = [1, 2, 3];
    return {
      "predict": predictions,
      "label": simulatedEmotion,
    };
  }

  Future<String> getAccessToken() async {
    String token = getStorage.read('accessToken');
    return token;
  }

  int getExpressionId(String label) {
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

  Future<void> storeDataToApi(String accessToken, int expressionId) async {
    try {
      final response = await http.post(
        Uri.parse(storeDataUrl),
        headers: {'access_token': accessToken},
        body: {'expression_id': expressionId.toString()},
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception(
            "Failed to store data. Status code: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error storing data to API: $e");
    }
  }

  void showError(String message) {
    Get.snackbar(
      "Error",
      message,
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 3),
      backgroundColor: Colors.redAccent,
      colorText: Colors.white,
    );
  }
}
