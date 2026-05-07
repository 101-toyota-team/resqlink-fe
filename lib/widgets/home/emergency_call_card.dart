import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';

class EmergencyCallCard extends StatelessWidget {
  const EmergencyCallCard({super.key});

  @override
  Widget build(BuildContext context) {
    const double badgeAreaSize = 130.0; 

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(36, 16, 20, 0),
      decoration: BoxDecoration(
          color: AppColors.cardBg,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
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
                child: Container(
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/medic_pattern.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 110.0, bottom: 16.0, top: 8.0), 
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 14),
                    ElevatedButton.icon(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        elevation: 0,
                      ),
                      icon: const Icon(Icons.phone, size: 16),
                      label: const Text(
                        'Hubungi Sekarang',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              Positioned(
                right: -35, 
                bottom: -35, 
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
                          color: Colors.red.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                      ),
                      // Lapisan tengah
                      Container(
                        width: badgeAreaSize * 0.8,
                        height: badgeAreaSize * 0.8,
                        decoration: BoxDecoration(
                          color: Colors.red.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        
                      ),
                      Container(
                        width: badgeAreaSize * 0.6,
                        height: badgeAreaSize * 0.6,
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.25),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        alignment: Alignment.center,
                        child: const Text(
                          '911',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 26,
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
    );
  }
}