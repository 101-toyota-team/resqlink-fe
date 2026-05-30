import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';

class PesanWelcabSection extends StatelessWidget {
  const PesanWelcabSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      clipBehavior: Clip.none, 
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          
          Container(
            padding: const EdgeInsets.all(1.5),
            decoration: BoxDecoration(
              gradient: AppColors.gradient, 
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFFFDF7EE), 
                borderRadius: BorderRadius.circular(18.5), 
              ),
              child: Row(
                children: [
                  Expanded(
                    flex: 12,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Tag Badge BARU dengan Background Gradient
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                gradient: AppColors.gradient, 
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: const Text(
                                'BARU',
                                style: TextStyle(
                                  fontSize: 9,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              'Toyota Aksesibilitas',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),

                        // Judul Menu
                        const Text(
                          'Layanan Mobil Welcab',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF1A1A1A),
                            letterSpacing: -0.3,
                          ),
                        ),
                        const SizedBox(height: 6),

                        // Deskripsi Ringkas
                        const Text(
                          'Layanan antar-jemput dengan kursi otomatis untuk memudahkan lansia dan penyandang disabilitas naik kendaraan dengan aman dan nyaman.',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.black54,
                            height: 1.35,
                          ),
                        ),
                        const SizedBox(height: 16),

                        GestureDetector(
                          onTap: () {
                          },
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
                                Text(
                                  'Pesan Sekarang',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(width: 6),
                                Icon(
                                  Icons.arrow_forward_rounded,
                                  size: 14,
                                  color: Colors.white,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // Gap Spacer Tengah
                  const SizedBox(width: 12),
                  
                  const Expanded(
                    flex: 7,
                    child: SizedBox(),
                  ),
                ],
              ),
            ),
          ),

          Positioned(
            right: 4,
            bottom: -10, 
            child: Container(
              transform: Matrix4.translationValues(0, 0, 0)..rotateZ(-0.05), 
              child: Image.asset(
                'assets/images/armada_welcab.png',
                height: 135, 
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 100,
                    width: 100,
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.03),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.directions_car, color: Color(0xFFBD2B12), size: 36),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}