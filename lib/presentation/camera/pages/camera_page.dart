import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mood_sync/core/config/assets/app_images.dart';
import 'package:mood_sync/core/config/theme/app_colors.dart';
import 'package:mood_sync/presentation/camera/pages/result_page.dart';
import 'package:path_provider/path_provider.dart';

class CameraPage extends StatefulWidget {
  const CameraPage({super.key});

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  late CameraController controller;
  int selectedCameraIdx = 0;
  final ImagePicker _picker = ImagePicker();

  Future<void> initializeCamera() async {
    var cameras = await availableCameras();
    controller =
        CameraController(cameras[selectedCameraIdx], ResolutionPreset.medium);
    await controller.initialize();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Future<void> toggleCamera() async {
    var cameras = await availableCameras();
    selectedCameraIdx = selectedCameraIdx == 0 ? 1 : 0;

    controller =
        CameraController(cameras[selectedCameraIdx], ResolutionPreset.medium);
    await controller.initialize();
    setState(() {});
  }

  Future<File?> takePicture() async {
    Directory root = await getTemporaryDirectory();
    String directoryPath = '${root.path}/Guided_Camera';
    await Directory(directoryPath).create(recursive: true);
    String filePath =
        '$directoryPath/${DateTime.now().microsecondsSinceEpoch}.jpg';

    try {
      // await controller.takePicture(filePath);
      XFile picture = await controller.takePicture();

      return await File(filePath).writeAsBytes(await picture.readAsBytes());
    } catch (e) {
      return null;
    }
  }

  Future<void> pickImageFromGallery() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ResultPage(imageFile: File(image.path)),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: FutureBuilder(
        future: initializeCamera(),
        builder: (_, snapshot) => (snapshot.connectionState ==
                ConnectionState.done)
            ? Stack(
                children: [
                  SafeArea(
                    child: SizedBox.expand(
                      child: CameraPreview(controller),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 50, vertical: 20),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.7),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.flip_camera_android,
                                color: Colors.white),
                            iconSize: 36,
                            onPressed: toggleCamera,
                          ),
                          GestureDetector(
                            onTap: () async {
                              if (!controller.value.isTakingPicture) {
                                File? result = await takePicture();
                                if (result != null) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          ResultPage(imageFile: result),
                                    ),
                                  );
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content:
                                            Text('Failed to take picture')),
                                  );
                                }
                              }
                            },
                            child: Container(
                              width: 70,
                              height: 70,
                              decoration: const BoxDecoration(
                                color: Colors.grey,
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Container(
                                  width: 62,
                                  height: 62,
                                  decoration: const BoxDecoration(
                                    color: AppColors.primary,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Center(
                                    child: Image.asset(AppImages.faceRecogIcon),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.photo_library,
                                color: Colors.white),
                            iconSize: 36,
                            onPressed: pickImageFromGallery,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              )
            : const Center(
                child: CircularProgressIndicator(),
              ),
      ),
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     backgroundColor: Colors.black,
  //     body: FutureBuilder(
  //       future: initializeCamera(),
  //       builder: (_, snapshot) => (snapshot.connectionState ==
  //               ConnectionState.done)
  //           ? Stack(
  //               children: [
  //                 Column(
  //                   children: [
  //                     SizedBox(
  //                       width: MediaQuery.of(context).size.width,
  //                       height: MediaQuery.of(context).size.height * 0.80,
  //                       child: CameraPreview(controller),
  //                     ),
  //                     Container(
  //                         width: 70,
  //                         height: 70,
  //                         margin: const EdgeInsets.only(top: 30),
  //                         child: GestureDetector(
  //                           onTap: () async {
  //                             if (!controller.value.isTakingPicture) {
  //                               File? result = await takePicture();
  //                               if (result != null) {
  //                                 const Text('Picture button has been pressed');
  //                                 Navigator.push(
  //                                   context,
  //                                   MaterialPageRoute(
  //                                     builder: (context) => ResultPage(
  //                                         imageFile:
  //                                             result), // Kirim File langsung
  //                                   ),
  //                                 );
  //                               } else {
  //                                 const Text('Failed to take picture');
  //                               }
  //                             }
  //                           },
  //                           child: Container(
  //                             width: 62,
  //                             height: 62,
  //                             decoration: const BoxDecoration(
  //                               color: Colors
  //                                   .grey, // Warna latar belakang abu-abu tua
  //                               shape: BoxShape.circle,
  //                             ),
  //                             child: Center(
  //                               child: Container(
  //                                 width: 56,
  //                                 height: 56,
  //                                 decoration: const BoxDecoration(
  //                                   color: AppColors
  //                                       .primary, // Warna lingkaran dalam hijau
  //                                   shape: BoxShape.circle,
  //                                 ),
  //                                 child: Center(
  //                                   child: Image.asset(AppImages.faceRecogIcon),
  //                                 ),
  //                               ),
  //                             ),
  //                           ),
  //                         ))
  //                   ],
  //                 ),
  //                 // SizedBox(
  //                 //   width: MediaQuery.of(context).size.width,
  //                 //   height: MediaQuery.of(context).size.height * 1.10,
  //                 //   child: Image.asset(AppImages.guideCover),
  //                 // ),
  //               ],
  //             )
  //           : const Center(
  //               child: CircularProgressIndicator(),
  //             ),
  //     ),
  //   );
  // }
}
