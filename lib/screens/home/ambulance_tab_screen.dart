import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';

class AmbulanceTabScreen extends StatelessWidget {
  final String title;

  const AmbulanceTabScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: AppColors.primary,
      ),
      body: Center(
        child: Text(
          'Halaman $title masih kosong',
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
