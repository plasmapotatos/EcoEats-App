import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

class CaptureControls extends StatelessWidget {
  final CameraController cameraController;
  final bool isFlashOn;
  final bool isCapturing;
  final VoidCallback onFlashToggle;
  final VoidCallback onCapture;

  const CaptureControls({
    super.key,
    required this.cameraController,
    required this.isFlashOn,
    required this.isCapturing,
    required this.onFlashToggle,
    required this.onCapture,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 30.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            icon: Icon(isFlashOn ? Icons.flash_on : Icons.flash_off),
            iconSize: 40,
            color: Colors.white,
            onPressed: onFlashToggle,
          ),
          const SizedBox(width: 60),
          GestureDetector(
            onTap: isCapturing ? null : onCapture,
            child: Container(
              width: 70,
              height: 70,
              decoration: const BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: Icon(Icons.camera, color: Colors.white, size: 30),
              ),
            ),
          ),
          const SizedBox(width: 100),
        ],
      ),
    );
  }
}
