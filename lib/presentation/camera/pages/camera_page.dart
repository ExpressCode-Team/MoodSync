// import 'dart:io';

// import 'package:camera/camera.dart';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:mood_sync/core/config/assets/app_images.dart';
// import 'package:mood_sync/core/config/theme/app_colors.dart';
// import 'package:mood_sync/presentation/camera/pages/result_page.dart';
// import 'package:path_provider/path_provider.dart';

// class CameraPage extends StatefulWidget {
//   const CameraPage({super.key});

//   @override
//   State<CameraPage> createState() => _CameraPageState();
// }

// class _CameraPageState extends State<CameraPage> {
//   late CameraController controller;
//   int selectedCameraIdx = 0;
//   final ImagePicker _picker = ImagePicker();

//   Future<void> initializeCamera() async {
//     var cameras = await availableCameras();
//     controller =
//         CameraController(cameras[selectedCameraIdx], ResolutionPreset.medium);
//     await controller.initialize();
//   }

//   @override
//   void dispose() {
//     controller.dispose();
//     super.dispose();
//   }

//   Future<void> toggleCamera() async {
//     var cameras = await availableCameras();
//     selectedCameraIdx = selectedCameraIdx == 0 ? 1 : 0;

//     controller =
//         CameraController(cameras[selectedCameraIdx], ResolutionPreset.medium);
//     await controller.initialize();
//     setState(() {});
//   }

//   Future<File?> takePicture() async {
//     Directory root = await getTemporaryDirectory();
//     String directoryPath = '${root.path}/Guided_Camera';
//     await Directory(directoryPath).create(recursive: true);
//     String filePath =
//         '$directoryPath/${DateTime.now().microsecondsSinceEpoch}.jpg';

//     try {
//       // await controller.takePicture(filePath);
//       XFile picture = await controller.takePicture();

//       return await File(filePath).writeAsBytes(await picture.readAsBytes());
//     } catch (e) {
//       return null;
//     }
//   }

//   Future<void> pickImageFromGallery() async {
//     final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
//     if (image != null) {
//       Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (context) => ResultPage(imageFile: File(image.path)),
//         ),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       body: FutureBuilder(
//         future: initializeCamera(),
//         builder: (_, snapshot) => (snapshot.connectionState ==
//                 ConnectionState.done)
//             ? Stack(
//                 children: [
//                   SafeArea(
//                     child: SizedBox.expand(
//                       child: CameraPreview(controller),
//                     ),
//                   ),
//                   Positioned(
//                     bottom: 0,
//                     left: 0,
//                     right: 0,
//                     child: Container(
//                       padding: const EdgeInsets.symmetric(
//                           horizontal: 50, vertical: 20),
//                       decoration: BoxDecoration(
//                         color: Colors.black.withOpacity(0.7),
//                       ),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           IconButton(
//                             icon: const Icon(Icons.flip_camera_android,
//                                 color: Colors.white),
//                             iconSize: 36,
//                             onPressed: toggleCamera,
//                           ),
//                           GestureDetector(
//                             onTap: () async {
//                               if (!controller.value.isTakingPicture) {
//                                 File? result = await takePicture();
//                                 if (result != null) {
//                                   Navigator.push(
//                                     context,
//                                     MaterialPageRoute(
//                                       builder: (context) =>
//                                           ResultPage(imageFile: result),
//                                     ),
//                                   );
//                                 } else {
//                                   ScaffoldMessenger.of(context).showSnackBar(
//                                     const SnackBar(
//                                         content:
//                                             Text('Failed to take picture')),
//                                   );
//                                 }
//                               }
//                             },
//                             child: Container(
//                               width: 70,
//                               height: 70,
//                               decoration: const BoxDecoration(
//                                 color: Colors.grey,
//                                 shape: BoxShape.circle,
//                               ),
//                               child: Center(
//                                 child: Container(
//                                   width: 62,
//                                   height: 62,
//                                   decoration: const BoxDecoration(
//                                     color: AppColors.primary,
//                                     shape: BoxShape.circle,
//                                   ),
//                                   child: Center(
//                                     child: Image.asset(AppImages.faceRecogIcon),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ),
//                           IconButton(
//                             icon: const Icon(Icons.photo_library,
//                                 color: Colors.white),
//                             iconSize: 36,
//                             onPressed: pickImageFromGallery,
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ],
//               )
//             : const Center(
//                 child: CircularProgressIndicator(),
//               ),
//       ),
//     );
//   }
// }

import 'dart:io';

import 'package:camerawesome/camerawesome_plugin.dart';
import 'package:flutter/material.dart';
import 'package:mood_sync/presentation/camera/pages/result_page.dart';
import 'package:path_provider/path_provider.dart';

class CameraPage extends StatefulWidget {
  const CameraPage({super.key});

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
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
                buttonTheme: AwesomeButtonTheme(
                  backgroundColor: Colors.black.withOpacity(0.5),
                  iconSize: 20,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.all(16),
                  // Tap visual feedback (ripple, bounce...)
                  buttonBuilder: (child, onTap) {
                    return ClipOval(
                      child: Material(
                        color: Colors.transparent,
                        shape: const CircleBorder(),
                        child: InkWell(
                          splashColor: Colors.cyan,
                          highlightColor: Colors.cyan.withOpacity(0.5),
                          onTap: onTap,
                          child: child,
                        ),
                      ),
                    );
                  },
                ),
              ),
              // Show the filter button on the top part of the screen
              topActionsBuilder: (state) => AwesomeTopActions(
                padding: EdgeInsets.zero,
                state: state,
                children: const [],
              ),
              // Show some Text with same background as the bottom part
              middleContentBuilder: (state) {
                return Column(
                  children: [
                    const Spacer(),
                    // Use a Builder to get a BuildContext below AwesomeThemeProvider widget
                    Builder(builder: (context) {
                      return Container(
                        // Retrieve your AwesomeTheme's background color
                        color: AwesomeThemeProvider.of(context)
                            .theme
                            .bottomActionsBackgroundColor,
                        child: const Align(
                          alignment: Alignment.bottomCenter,
                          child: Padding(
                            padding: EdgeInsets.only(bottom: 10, top: 10),
                            child: Text(
                              "Take your best shot!",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                  ],
                );
              },
              // Show Flash button on the left and Camera switch button on the right
              bottomActionsBuilder: (state) => AwesomeBottomActions(
                state: state,
                left: AwesomeFlashButton(
                  state: state,
                ),
                right: AwesomeCameraSwitchButton(
                  state: state,
                  scale: 1.0,
                  onSwitchTap: (state) {
                    state.switchCameraSensor(
                      aspectRatio: state.sensorConfig.aspectRatio,
                    );
                  },
                ),
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
                debugPrint('Capture Event Status: ${event.status}');
                debugPrint('Is Picture: ${event.isPicture}');
                debugPrint('Is Video: ${event.isVideo}');

                if (event.status == MediaCaptureStatus.success &&
                    event.isPicture) {
                  event.captureRequest.when(
                    single: (single) {
                      final imagePath = single.file?.path;
                      debugPrint('Picture successfully saved at: $imagePath');
                      if (imagePath != null) {
                        // Create a File object from the path and navigate to ResultPage
                        final imageFile = File(imagePath);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ResultPage(imageFile: imageFile),
                          ),
                        );
                      }
                    },
                    multiple: (multiple) {
                      multiple.fileBySensor.forEach((key, value) {
                        debugPrint('Multiple image taken: $key ${value?.path}');
                      });
                    },
                  );
                } else if (event.status == MediaCaptureStatus.failure) {
                  debugPrint('Capture failed: ${event.exception}');
                }
              },
            )),
      ),
    );
  }
}
