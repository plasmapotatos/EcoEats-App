import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter/services.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:image/image.dart' as img;
import 'package:http/http.dart' as http;
import 'dart:convert';

//TODO: Add a click sound effect :D
Future<void> captureAndSendImage(
    BuildContext context, CameraController controller) async {
  try {
    // Ensure the controller is initialized
    if (!controller.value.isInitialized) {
      print('Camera is not initialized');
      return;
    }

    print("Capturing image...");
    // Capture the image
    final XFile image = await controller.takePicture();

    print("Image captured: ${image.path}");

    // Convert image to bytes
    final Uint8List bytes = await image.readAsBytes();

    // Decode image
    final img.Image capturedImage = img.decodeImage(bytes)!;

    // Rotate image 90 deg counterclockwise
    final img.Image rotatedImage = img.copyRotate(capturedImage, angle: 360);

    // Encode rotated image to bytes
    Uint8List rotatedBytes = Uint8List.fromList(img.encodeJpg(rotatedImage));

    // Encode bytes to base64
    String base64Image = base64Encode(rotatedBytes);

    // Prepare JSON payload
    final Map<String, dynamic> payload = {
      "base64_image": base64Image,
    };

    // Define server URL
    final Uri uri = Uri.parse(
        'http://192.168.1.40:5001/analyze_image'); // Ensure server is running

    print("Sending image to server...");

    // Send HTTP POST request
    final response = await http.post(
      uri,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(payload),
    );

    void _showResponseBottomSheet(Map<String, dynamic> responseData) {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (BuildContext context) {
          return Container(
            padding: EdgeInsets.all(16),
            height: MediaQuery.of(context).size.height * 0.5,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Item: ${responseData['item']}',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text('Category: ${responseData['category']}'),
                SizedBox(height: 8),
                Text(
                    'Carbon Emissions: ${responseData['carbon emissions']} kg CO2-eq/kg'),
                SizedBox(height: 16),
                Text(
                  'Alternatives:',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: responseData['alternatives'].length,
                    itemBuilder: (context, index) {
                      final alternative = responseData['alternatives'][index];
                      return ListTile(
                        title: Text(alternative['item']),
                        subtitle: Text(
                            '${alternative['carbon emissions']} kg CO2-eq/kg - ${alternative['reason']}'),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      );
    }

    if (response.statusCode == 200) {
      // Parse server response
      print('Response: ${response.body}');
      final Map<String, dynamic> responseData =
          jsonDecode(response.body) as Map<String, dynamic>;
      _showResponseBottomSheet(responseData);
    } else {
      print('Failed to upload image: ${response.statusCode}');
    }

    // Send the request
    //final response = await request.send();
    // final response = {
    //   'statusCode': 200, // HTTP status code
    //   'body': {
    //     'item': 'Apple',
    //     'alternatives': [
    //       {
    //         'name': 'Pear',
    //         'info': 'Pears are sweet and rich in fiber.',
    //         'imageUrl':
    //             'https://plus.unsplash.com/premium_photo-1672976699507-521b6bb1f0cb?q=80&w=1848&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    //       },
    //       {
    //         'name': 'Banana',
    //         'info': 'Bananas are rich in potassium and great for energy.',
    //         'imageUrl':
    //             'https://images.unsplash.com/photo-1571771894821-ce9b6c11b08e?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Nnx8YmFuYW5hfGVufDB8fDB8fHww',
    //       },
    //       {
    //         'name': 'Orange',
    //         'info': 'Oranges are high in vitamin C and refreshing.',
    //         'imageUrl':
    //             'https://images.unsplash.com/photo-1580052614034-c55d20bfee3b?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8b3JhbmdlfGVufDB8fDB8fHww',
    //       },
    //     ],
    //   },
    //   'headers': {
    //     'Content-Type': 'application/json',
    //   },
    // };

    // if (response['statusCode'] == 200) {
    //   final Map<String, dynamic> body =
    //       response['body'] as Map<String, dynamic>; // Extract the response body

    //   // Show the response in a popup
    //   showDialog(
    //     context: context,
    //     builder: (BuildContext context) {
    //       return AlertDialog(
    //         title: Text('Detected Item: ${body["item"]}'),
    //         content: SingleChildScrollView(
    //           child: Column(
    //             mainAxisSize: MainAxisSize.min,
    //             children: (body["alternatives"] as List).map((alt) {
    //               return ListTile(
    //                 leading: alt['imageUrl'] != null
    //                     ? Image.network(
    //                         alt['imageUrl'],
    //                         width: 50,
    //                         height: 50,
    //                         fit: BoxFit.cover,
    //                       )
    //                     : Icon(Icons.image),
    //                 title: Text(alt['name']),
    //                 subtitle: Text(alt['info']),
    //               );
    //             }).toList(),
    //           ),
    //         ),
    //         actions: [
    //           TextButton(
    //             onPressed: () => Navigator.of(context).pop(),
    //             child: Text('OK'),
    //           ),
    //         ],
    //       );
    //     },
    //   );
    // } else {
    //   // Handle non-200 status codes
    //   print('Error: ${response['statusCode']}');
    //   showDialog(
    //     context: context,
    //     builder: (BuildContext context) {
    //       return AlertDialog(
    //         title: Text('Error'),
    //         content: Text(
    //             'Failed to process the image. Status Code: ${response['statusCode']}'),
    //         actions: [
    //           TextButton(
    //             onPressed: () => Navigator.of(context).pop(),
    //             child: Text('OK'),
    //           ),
    //         ],
    //       );
    //     },
    //   );
    // }
  } catch (e) {
    print('Error capturing or uploading image: $e');
  }
}

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

                    // Haptic Feedback (Vibration)
                    HapticFeedback.mediumImpact();
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
                                ? Color(0xFFFFFFFF) // Highlighted
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
                      onTap: () =>
                          captureAndSendImage(context, _cameraController),
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
