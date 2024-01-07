import 'dart:io';
import 'dart:typed_data';

class Services {
  Future<Uint8List> getImageBytes(String imagePath) async {
    File imageFile = File(imagePath);
    if (!imageFile.existsSync()) {
      throw Exception('Image file not found');
    }

    Uint8List imageBytes = await imageFile.readAsBytes();
    return imageBytes;
  }
}
