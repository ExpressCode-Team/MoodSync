import 'dart:io';

import 'package:flutter/material.dart';

class ResultPage extends StatefulWidget {
  final File imageFile;
  final String result;
  const ResultPage({super.key, required this.imageFile, required this.result});

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
            child: (widget.imageFile != null)
                ? Image.file(
                    widget.imageFile,
                  )
                : const SizedBox(),
          ),
        ),
      ),
    );
  }
}
