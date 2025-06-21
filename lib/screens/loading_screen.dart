import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LoadingScreen extends StatefulWidget {
  final String message;
  final String animationAsset;
  final bool isGif;
  final Future<void> Function(BuildContext context) onComplete;

  const LoadingScreen({
    required this.message,
    required this.animationAsset,
    this.isGif = true,
    required this.onComplete,
  });

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      await Future.delayed(Duration(seconds: 2)); // optional delay
      await widget.onComplete(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final animationWidget = widget.isGif
        ? Image.asset(widget.animationAsset, width: 200)
        : Lottie.asset(widget.animationAsset, width: 200);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            animationWidget,
            const SizedBox(height: 20),
            Text(widget.message, style: const TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}
