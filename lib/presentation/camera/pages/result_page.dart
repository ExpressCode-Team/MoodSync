import 'dart:io';

import 'package:flutter/material.dart';

class ResultPage extends StatefulWidget {
  final File imageFile;
  const ResultPage({super.key, required this.imageFile});

  @override
  State<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 20, bottom: 10),
              width: 300,
              height: 450,
              color: Colors.grey[200],
              child: (widget.imageFile != null)
                  ? Image.file(
                      widget.imageFile,
                    )
                  : const SizedBox(),
            ),
          ],
        ),
      ),
    );
  }
}
