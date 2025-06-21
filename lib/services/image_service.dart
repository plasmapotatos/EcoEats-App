import 'dart:typed_data';
import 'package:image/image.dart' as img;
import 'package:camera/camera.dart';
import 'dart:convert';

class ImageService {
  static Future<String> convertToBase64(XFile image) async {
    final Uint8List bytes = await image.readAsBytes();
    final img.Image decoded = img.decodeImage(bytes)!;
    final img.Image rotated = img.copyRotate(decoded, angle: 360);
    return base64Encode(Uint8List.fromList(img.encodeJpg(rotated)));
  }
}
