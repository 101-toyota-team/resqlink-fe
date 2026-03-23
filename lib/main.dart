import 'package:flutter/material.dart';
import 'screens/landing_screen.dart';
import 'themes/app_theme.dart';

void main() {
  runApp(const ResQLinkApp());
}

/// ResQLink Application Entry Point
class ResQLinkApp extends StatelessWidget {
  const ResQLinkApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ResQLink',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.theme,
      home: const LandingScreen(),
    );
  }
}