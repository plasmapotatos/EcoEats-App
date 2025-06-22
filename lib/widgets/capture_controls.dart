import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

class CaptureControls extends StatefulWidget {
  final CameraController cameraController;
  final bool isFlashOn;
  final bool isCapturing;
  final VoidCallback onFlashToggle;
  final VoidCallback onCapture;
  final VoidCallback onItemsPressed;

  const CaptureControls({
    super.key,
    required this.cameraController,
    required this.isFlashOn,
    required this.isCapturing,
    required this.onFlashToggle,
    required this.onCapture,
    required this.onItemsPressed,
  });

  @override
  State<CaptureControls> createState() => _CaptureControlsState();
}

class _CaptureControlsState extends State<CaptureControls>
    with SingleTickerProviderStateMixin {
  bool isPressed = false;

  void _handleTap() async {
    if (widget.isCapturing) return;

    setState(() => isPressed = true);
    await Future.delayed(const Duration(milliseconds: 100));
    setState(() => isPressed = false);

    widget.onCapture();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 60.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Flash toggle icon
          IconButton(
            icon: Icon(widget.isFlashOn ? Icons.flash_on : Icons.flash_off),
            iconSize: 32,
            color: Colors.white,
            onPressed: widget.onFlashToggle,
          ),

          // Capture button with animated ring
          GestureDetector(
            onTap: _handleTap,
            child: SizedBox(
              width: 80,
              height: 80,
              child: Center(
                child: AnimatedScale(
                  scale: isPressed ? 0.9 : 1.0,
                  duration: const Duration(milliseconds: 100),
                  child: Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 6),
                      color: Colors.transparent,
                    ),
                  ),
                ),
              ),
            ),
          ),

          IconButton(
            icon: const Icon(Icons.list_alt),
            iconSize: 40,
            color: Colors.white,
            onPressed: widget.onItemsPressed,
          ),
        ],
      ),
    );
  }
}
