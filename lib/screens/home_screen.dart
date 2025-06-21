import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter/services.dart';
import 'package:audioplayers/audioplayers.dart';

import 'package:EcoEats/widgets/camera_preview_widget.dart';
import 'package:EcoEats/widgets/category_scroller.dart';
import 'package:EcoEats/widgets/capture_controls.dart';
import 'package:EcoEats/services/camera_service.dart';
import 'package:EcoEats/screens/items_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late CameraController _cameraController;
  late PageController _pageController;
  int selectedIndex = 0;
  bool isFlashOn = false;
  bool isCapturing = false;

  final AudioPlayer _audioPlayer = AudioPlayer();
  final List<String> categories = [
    "Protein",
    "Dairy",
    "Produce",
    "Grains",
    "Fruits",
    "Seafood",
    "Candy",
    "Alcohol",
  ];

  @override
  void initState() {
    super.initState();
    initializeCamera();
    _pageController = PageController(viewportFraction: 0.3);
  }

  Future<void> initializeCamera() async {
    _cameraController = await CameraService.initializeCamera();
    setState(() {});
  }

  @override
  void dispose() {
    _cameraController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          CameraPreviewWidget(controller: _cameraController),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              CaptureControls(
                cameraController: _cameraController,
                isFlashOn: isFlashOn,
                isCapturing: isCapturing,
                onFlashToggle: () async {
                  if (isFlashOn) {
                    await _cameraController.setFlashMode(FlashMode.off);
                  } else {
                    await _cameraController.setFlashMode(FlashMode.torch);
                  }
                  setState(() => isFlashOn = !isFlashOn);
                },
                onCapture: () async {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const ItemsScreen()),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
