import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter/services.dart';
import 'dart:math';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late CameraController _cameraController;
  late List<CameraDescription> cameras;
  int selectedIndex = 0;
  bool isFlashOn = false;

  late PageController _pageController;

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
    _pageController = PageController(
      initialPage: selectedIndex, // Start with the middle item selected
      viewportFraction: 0.3, // Adjust how much space each item takes
    );
  }

  void initializeCamera() async {
    cameras = await availableCameras();
    _cameraController = CameraController(cameras[0], ResolutionPreset.high);
    await _cameraController.initialize();
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
          // Camera Feed
          _cameraController.value.isInitialized
              ? Positioned.fill(
                  // Ensures the camera takes the full screen
                  child: CameraPreview(_cameraController),
                )
              : Center(child: CircularProgressIndicator()),

          // Overlay elements
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              // Category Scroller with Center Snapping
              Container(
                height: 80,
                child: PageView.builder(
                  controller: _pageController,
                  scrollDirection: Axis.horizontal,
                  itemCount: categories.length,
                  onPageChanged: (index) {
                    setState(() {
                      selectedIndex = index;
                    });
                  },
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        _pageController.animateToPage(
                          index,
                          duration: Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                        setState(() {
                          selectedIndex = index;
                        });
                      },
                      child: Center(
                        child: Text(
                          categories[index],
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: selectedIndex == index
                                ? Color(0xFFFFFFFF) // highlighted
                                : Color(0xFF555555), // Default
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              // Capture Button and Flashlight
              Padding(
                padding: const EdgeInsets.only(bottom: 30.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Flashlight Button
                    IconButton(
                      icon: Icon(Icons.flashlight_on),
                      iconSize: 40,
                      color: Colors.white,
                      onPressed: () async {
                        try {
                          if (isFlashOn) {
                            await _cameraController.setFlashMode(FlashMode.off);
                          } else {
                            await _cameraController
                                .setFlashMode(FlashMode.torch);
                          }
                          setState(() {
                            isFlashOn = !isFlashOn;
                          });
                        } catch (e) {}
                      },
                    ),

                    SizedBox(width: 60),

                    // Capture Button
                    GestureDetector(
                      onTap: () {
                        // Capture image logic here
                      },
                      child: Container(
                        width: 70,
                        height: 70,
                        decoration: BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Icon(
                            Icons.camera,
                            color: Colors.white,
                            size: 30,
                          ),
                        ),
                      ),
                    ),

                    SizedBox(width: 60),

                    // Placeholder for symmetry (optional)
                    SizedBox(width: 40),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: HomeScreen(),
  ));
}
