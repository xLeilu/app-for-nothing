import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/services.dart';

class Services {
  Future<Uint8List> getImageBytes(String imagePath) async {
    File imageFile = File(imagePath);
    if (!imageFile.existsSync()) {
      throw Exception('Image file not found');
    }

    Uint8List imageBytes = await imageFile.readAsBytes();
    return imageBytes;
  }

  Future<Uint8List> getImageBytesFromAssets(String imagePath) async {
    ByteData data = await rootBundle.load(imagePath);
    return data.buffer.asUint8List();
  }
}
