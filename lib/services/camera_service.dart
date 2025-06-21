import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:EcoEats/services/image_service.dart';
import 'package:EcoEats/services/api_service.dart';
import 'package:EcoEats/utils/dialog_utils.dart';
import 'dart:convert';

class CameraService {
  static Future<CameraController> initializeCamera() async {
    final cameras = await availableCameras();
    final controller = CameraController(cameras[0], ResolutionPreset.high);
    await controller.initialize();
    return controller;
  }

  static Future<void> captureAndSendImage(
      BuildContext context, CameraController controller) async {
    try {
      if (!controller.value.isInitialized) return;

      final XFile image = await controller.takePicture();
      final String base64Image = await ImageService.convertToBase64(image);

      final response = await ApiService.sendPostRequest(
        context,
        Uri.parse('http://192.168.1.40:5001/analyze_image'),
        {"base64_image": base64Image},
      );

      if (response == null) return;

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _showResponseBottomSheet(context, data);
      } else {
        print('Failed: ${response.statusCode}');
      }
    } catch (e) {
      DialogUtils.showErrorDialog(context, 'Capture/Upload error: $e');
    }
  }

  static void _showResponseBottomSheet(
      BuildContext context, Map<String, dynamic> responseData) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => Container(
        padding: const EdgeInsets.all(16),
        height: MediaQuery.of(context).size.height * 0.5,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Item: ${responseData['item']}',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            Text('Category: ${responseData['category']}'),
            Text('Carbon Emissions: ${responseData['carbon emissions']} kg CO2-eq/kg'),
            const SizedBox(height: 16),
            const Text('Alternatives:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            Expanded(
              child: ListView.builder(
                itemCount: responseData['alternatives'].length,
                itemBuilder: (_, i) {
                  final alt = responseData['alternatives'][i];
                  return ListTile(
                    title: Text(alt['item']),
                    subtitle: Text('${alt['carbon emissions']} kg CO2-eq/kg - ${alt['reason']}'),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
