import 'dart:io';

import 'package:camerawesome/camerawesome_plugin.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mood_sync/app/core/assets/app_images.dart';
import 'package:mood_sync/app/core/theme/app_text_style.dart';
import 'package:mood_sync/app/modules/camera/controllers/camera_controller.dart';
import 'package:mood_sync/app/routes/app_pages.dart';
import 'package:path_provider/path_provider.dart';

class CameraView extends StatelessWidget {
  const CameraView({super.key});

  @override
  Widget build(BuildContext context) {
    final CameraController controller = Get.put(CameraController());

    return WillPopScope(
      onWillPop: () async {
        // Dispose of the camera resources
        Get.delete<CameraController>();
        return true; // Allow the pop action
      },
      child: Scaffold(
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
                            _onCapture(imageFile, controller);
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
            Obx(() {
              if (controller.isLoading.value) {
                return Container(
                  color: Colors.black.withOpacity(0.5),
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }
              return const SizedBox.shrink(); // No loading overlay
            }),
          ],
        ),
      ),
    );
  }

  void _onCapture(File imageFile, CameraController controller) async {
    controller.isLoading.value = true;

    try {
      final result = await controller.processImage(imageFile, simulate: true);
      String token = await controller.getAccessToken();

      if (result["predict"] != null && result["predict"].isNotEmpty) {
        int expressionId = controller.getExpressionId(result["label"]);
        await controller.storeDataToApi(token, expressionId);
      }
      _showEmotionResult(result["label"]);
    } catch (e) {
      Get.snackbar(
        "Error",
        "Failed to send image: ${e.toString()}",
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    } finally {
      controller.isLoading.value = false;
    }
  }

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
      context: Get.context!,
      barrierDismissible: false,
      builder: (_) {
        final screenWidth = MediaQuery.of(Get.context!).size.width;
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
                Get.offAllNamed(Routes.HOME);
              },
              child: const Text("Next"),
            ),
          ],
        );
      },
    );
  }

  static void _showErrorDialog(String message) {
    showDialog(
      context: Get.context!,
      builder: (_) => AlertDialog(
        title: const Text("Error"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(Get.context!);
            },
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }
}
