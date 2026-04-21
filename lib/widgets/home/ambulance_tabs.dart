import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';

class _AmbulanceTabData {
  final String label;
  final Color color;
  final Color textColor;
  final Color borderColor;
  final String imagePath;
  const _AmbulanceTabData({
    required this.label,
    required this.color,
    required this.textColor,
    required this.borderColor,
    required this.imagePath,
  });
}

class AmbulanceTypeTabs extends StatelessWidget {
  const AmbulanceTypeTabs({super.key});

  final List<_AmbulanceTabData> tabs = const [
    _AmbulanceTabData(
      label: 'Ambulan\nMedis',
      color: Color(0xFFFFE8D6),
      textColor: Color(0xFFD94C2B),
      borderColor: Color(0xFFD94C2B),
      imagePath: 'assets/images/ambulance_medis.png',
    ),
    _AmbulanceTabData(
      label: 'Ambulan\nSosial',
      color: Color(0xFFD6E8FF),
      textColor: Color(0xFF1A5CB5),
      borderColor: Color(0xFF1A5CB5),
      imagePath: 'assets/images/ambulance_sosial.png',
    ),
    _AmbulanceTabData(
      label: 'Ambulan\nJenazah',
      color: Color(0xFFD6F5D6),
      textColor: Color(0xFF1A8A2E),
      borderColor: Color(0xFF1A8A2E),
      imagePath: 'assets/images/ambulance_jenazah.png',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: tabs
            .map((tab) => Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: _AmbulanceTabCard(data: tab),
                  ),
                ))
            .toList(),
      ),
    );
  }
}

class _AmbulanceTabCard extends StatelessWidget {
  final _AmbulanceTabData data;
  const _AmbulanceTabCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      decoration: BoxDecoration(
        color: data.color,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: data.borderColor, width: 1.5),
      ),
      child: Column(
        children: [
          Text(
            data.label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: data.textColor,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 8),
          Image.asset(
            data.imagePath,
            height: 60,
            fit: BoxFit.contain,
          ),
        ],
      ),
    );
  }
}