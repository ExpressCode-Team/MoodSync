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
      body: SafeArea(
        child: Center(
          child: Container(
            width: 300,
            height: 500,
            color: Colors.grey[200],
            child: widget.imageFile.existsSync()
                ? Image.file(
                    widget.imageFile,
                  )
                : const Text('failed to load image'),
          ),
        ),
      ),
    );
  }
}
