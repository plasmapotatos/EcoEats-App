import 'package:EcoEats/providers/alternatives_provider.dart';
import 'package:EcoEats/providers/food_item_provider.dart';
import 'package:flutter/material.dart';
import 'package:EcoEats/screens/home_screen.dart'; // Or your start screen
import 'package:EcoEats/screens/splash_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => FoodItemProvider()),
        ChangeNotifierProvider(create: (_) => AlternativesProvider()),
      ],
      child: const EcoEatsApp(),
    ),
  );}

class EcoEatsApp extends StatelessWidget {
  const EcoEatsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EcoEats',
      theme: ThemeData.light(), // your theme
      home: const SplashWrapper(),
    );
  }
}

class SplashWrapper extends StatefulWidget {
  const SplashWrapper({super.key});

  @override
  State<SplashWrapper> createState() => _SplashWrapperState();
}

class _SplashWrapperState extends State<SplashWrapper> {
  bool _done = false;

  @override
  Widget build(BuildContext context) {
    return _done
        ? const HomeScreen()
        : SplashScreen(
      onFinish: () => setState(() => _done = true),
    );
  }
}
