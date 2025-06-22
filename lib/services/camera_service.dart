import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:EcoEats/services/image_service.dart';
import 'package:EcoEats/services/api_service.dart';
import 'package:EcoEats/utils/dialog_utils.dart';
import 'dart:convert';

import 'package:EcoEats/providers/food_item_provider.dart';
import 'package:provider/provider.dart';

class CameraService {
  static Future<CameraController> initializeCamera() async {
    final cameras = await availableCameras();
    final controller = CameraController(cameras[0], ResolutionPreset.high);
    await controller.initialize();
    return controller;
  }

  static Future<void> captureAndSendImage(
      BuildContext context, CameraController controller, { required XFile image, }) async {
    try {
      if (!controller.value.isInitialized) return;

      final String base64Image = await ImageService.convertToBase64(image);

      final response = await ApiService.sendPostRequest(
        context,
        Uri.parse('http://localhost:5001/detect_foods'),
        {"base64_image": base64Image},
      );

      if (response == null) return;

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print('Data: $data');
        final List<String> foods = List<String>.from(data["foods"]);

        final foodProvider = Provider.of<FoodItemProvider>(context, listen: false);
        for (final food in foods) {
          foodProvider.addItem(food);
        }
      } else {
        print('Failed: ${response.statusCode}');
      }
    } catch (e) {
      DialogUtils.showErrorDialog(context, 'Capture/Upload error: $e');
    }
  }
}
