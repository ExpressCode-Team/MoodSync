import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mood_sync/model/mlconvert.dart';

class Sendimage {
  final String imagePath;

  const Sendimage({
    required this.imagePath
  });
  
  send() async{
    var headers = {
      'accept': 'application/json'
    };
    var request = http.MultipartRequest('POST', Uri.parse('https://facialexpress.raihanproject.my.id/predict/ml/'));
    request.files.add(await http.MultipartFile.fromPath('file', imagePath, filename: imagePath.split('/').last));
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
    var res = await http.Response.fromStream(response);
    var body = imageresultFromJson(res.body);

    if (response.statusCode == 400) {
      return (body.label);
    } else {
      return (body.predict);
    }
  }
}

