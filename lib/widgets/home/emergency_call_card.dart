import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';

class EmergencyCallCard extends StatelessWidget {
  const EmergencyCallCard({super.key});

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
                      const Text(
                        'Panggilan Darurat 911',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textDark,
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'Telepon 911 untuk pesan ambulance darurat melalui Public Safety Center (PSC)',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textGrey,
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 16),
                      
                      GestureDetector(
                        onTap: () {},
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                          decoration: BoxDecoration(
                            gradient: AppColors.gradient,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.05),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              Icon(Icons.phone, size: 14, color: Colors.white),
                              SizedBox(width: 6),
                              Text(
                                'Hubungi Sekarang',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
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
                          child: const Text(
                            '911',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.w900,
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