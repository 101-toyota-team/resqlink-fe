import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart'; 
import '../../themes/app_colors.dart';
import '../../themes/app_typography.dart';

class EmergencyCallCard extends StatelessWidget {
  const EmergencyCallCard({super.key});

  Future<void> _makeEmergencyCall(BuildContext context) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: '119',
    );

    try {
      if (await canLaunchUrl(launchUri)) {
        await launchUrl(launchUri);
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Tidak dapat membuka aplikasi telepon.')),
          );
        }
      }
    } catch (e) {
      debugPrint("Gagal memicu dialer native: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    const double badgeAreaSize = 130.0; 

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: IntrinsicHeight(
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: AppColors.cardBg,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.divider, width: 1),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Stack(
              children: [
                Positioned.fill(
                  child: Image.asset(
                    'assets/images/medic_pattern.png',
                    fit: BoxFit.cover,
                    opacity: const AlwaysStoppedAnimation(0.8),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 18, 110, 18), 
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min, 
                    children: [
                      Text(
                        'Panggilan Darurat 119',
                        style: AppTypography.title.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Telepon 119 untuk pesan ambulance darurat melalui Public Safety Center (PSC)',
                        style: AppTypography.caption.copyWith(
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 16),

                      GestureDetector(
                        onTap: () => _makeEmergencyCall(context), 
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8), 
                          decoration: BoxDecoration(
                            gradient: AppColors.gradient,
                            borderRadius: BorderRadius.circular(100), 
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFFBD2B12).withValues(alpha: 0.2), 
                                blurRadius: 8,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.phone, 
                                size: 12, 
                                color: Colors.white,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'Hubungi Sekarang',
                                style: AppTypography.buttonSmall,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                Positioned(
                  right: -25, 
                  bottom: -25, 
                  child: SizedBox(
                    width: badgeAreaSize,
                    height: badgeAreaSize,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          width: badgeAreaSize,
                          height: badgeAreaSize,
                          decoration: BoxDecoration(
                            color: const Color(0xFFBD2B12).withValues(alpha: 0.06),
                            shape: BoxShape.circle,
                          ),
                        ),
                        Container(
                          width: badgeAreaSize * 0.78,
                          height: badgeAreaSize * 0.78,
                          decoration: BoxDecoration(
                            color: const Color(0xFFBD2B12).withValues(alpha: 0.15),
                            shape: BoxShape.circle,
                          ),
                        ),
                        Container(
                          width: badgeAreaSize * 0.56,
                          height: badgeAreaSize * 0.56,
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.15),
                                blurRadius: 8,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            '119',
                            style: AppTypography.h3.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w900,
                              fontSize: 24,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}