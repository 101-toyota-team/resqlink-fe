import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../themes/app_colors.dart';
import '../../themes/app_typography.dart';
import '../../screens/order/order_screen.dart';
import '../../screens/order/ambulance_jenazah_screen.dart';

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
      label: 'Medis',
      color: AppColors.cardBg,
      textColor: AppColors.ambulanceMedis,
      imagePath: 'assets/images/ambulance_medis.svg',
    ),
    _AmbulanceTabData(
      label: 'Sosial',
      color: AppColors.cardBg,
      textColor: AppColors.ambulanceSosial,
      imagePath: 'assets/images/ambulance_sosial.svg',
    ),
    _AmbulanceTabData(
      label: 'Jenazah',
      color: AppColors.cardBg,
      textColor: AppColors.ambulanceJenazah,
      imagePath: 'assets/images/ambulance_jenazah.svg',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: AppColors.divider.withValues(alpha: 0.5), width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 12,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: _tabs
              .map((tab) => Expanded(
                    child: _AmbulanceTabCard(data: tab),
                  ))
              .toList(),
        ),
      ),
    );
  }
}

class _AmbulanceTabCard extends StatelessWidget {
  final _AmbulanceTabData data;

  const _AmbulanceTabCard({
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Widget destination;
        if (data.label.contains('Jenazah')) {
          destination = const AmbulanceJenazahScreen();
        } else {
          destination = const OrderScreen();
        }
        
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => destination,
          ),
        );
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: data.textColor.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: SvgPicture.asset(
              data.imagePath,
              height: 38,
              width: 38,
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            data.label,
            style: AppTypography.caption.copyWith(
              fontWeight: FontWeight.w800,
              color: AppColors.textDark,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            'Ambulan',
            style: AppTypography.captionSmall.copyWith(
              color: AppColors.textGrey,
              fontSize: 9,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
