import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart'; 
import '../../constants/app_colors.dart';
import '../../screens/order/order_screen.dart';

class _AmbulanceTabData {
  final String label;
  final Color color;
  final Color textColor;
  final String imagePath;
  const _AmbulanceTabData({
    required this.label,
    required this.color,
    required this.textColor,
    required this.imagePath,
  });
}

class AmbulanceTypeTabs extends StatelessWidget {
  const AmbulanceTypeTabs({super.key});

  final List<_AmbulanceTabData> _tabs = const [
    _AmbulanceTabData(
      label: 'Ambulan\nMedis',
      color: AppColors.cardBg,
      textColor: AppColors.ambulanceMedis,
      imagePath: 'assets/images/ambulance_medis.svg',
    ),
    _AmbulanceTabData(
      label: 'Ambulan\nSosial',
      color: AppColors.cardBg,
      textColor: AppColors.ambulanceSosial,
      imagePath: 'assets/images/ambulance_sosial.svg',
    ),
    _AmbulanceTabData(
      label: 'Ambulan\nJenazah',
      color: AppColors.cardBg,
      textColor: AppColors.ambulanceJenazah,
      imagePath: 'assets/images/ambulance_jenazah.svg',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: _tabs
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

  const _AmbulanceTabCard({
    required this.data,
  });

  Future<void> _makeCall() async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: '119',
    );
    try {
      if (await canLaunchUrl(launchUri)) {
        await launchUrl(launchUri);
      }
    } catch (e) {
      debugPrint("Gagal memicu dialer telepon: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _makeCall();
        
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => OrderScreen(),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
        decoration: BoxDecoration(
          gradient: AppColors.gradient,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
          decoration: BoxDecoration(
            color: data.color,
            borderRadius: BorderRadius.circular(10),
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
              SvgPicture.asset(
                data.imagePath,
                height: 60,
                fit: BoxFit.contain,
              ),
            ],
          ),
        ),
      ),
    );
  }
}