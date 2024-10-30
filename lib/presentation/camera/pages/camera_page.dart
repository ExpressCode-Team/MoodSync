import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mood_sync/core/config/assets/app_vectors.dart';
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

  Future<void> initializeCamera() async {
    var cameras = await availableCameras();
    controller = CameraController(cameras[0], ResolutionPreset.medium);
    await controller.initialize();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
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
                  Column(
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height * 0.80,
                        child: CameraPreview(controller),
                      ),
                      Container(
                          width: 70,
                          height: 70,
                          margin: const EdgeInsets.only(top: 30),
                          child: GestureDetector(
                            onTap: () async {
                              if (!controller.value.isTakingPicture) {
                                File? result = await takePicture();
                                if (result != null) {
                                  const Text('Picture button has been pressed');
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ResultPage(
                                          imageFile:
                                              result), // Kirim File langsung
                                    ),
                                  );
                                } else {
                                  const Text('Failed to take picture');
                                }
                              }
                            },
                            child: Container(
                              width: 62,
                              height: 62,
                              decoration: const BoxDecoration(
                                color: Colors
                                    .grey, // Warna latar belakang abu-abu tua
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Container(
                                  width: 56,
                                  height: 56,
                                  decoration: const BoxDecoration(
                                    color: AppColors
                                        .primary, // Warna lingkaran dalam hijau
                                    shape: BoxShape.circle,
                                  ),
                                  child: Center(
                                    child:
                                        SvgPicture.asset(AppVectors.faceRecog),
                                  ),
                                ),
                              ),
                            ),
                          ))
                    ],
                  ),
                  // SizedBox(
                  //   width: MediaQuery.of(context).size.width,
                  //   height: MediaQuery.of(context).size.height * 1.10,
                  //   child: Image.asset(AppImages.guideCover),
                  // ),
                ],
              )
            : const Center(
                child: CircularProgressIndicator(),
              ),
      ),
    );
  }
}
