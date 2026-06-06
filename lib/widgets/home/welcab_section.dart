import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import '../../themes/app_colors.dart';
import '../../themes/app_typography.dart';
import '../../screens/order/welcab_booking_screen.dart';

class PesanWelcabSection extends StatelessWidget {
  const PesanWelcabSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            decoration: BoxDecoration(
              color: AppColors.white, 
              borderRadius: BorderRadius.circular(28), 
              border: Border.all(
                color: AppColors.divider, 
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(26.5),
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const WelcabBookingScreen()),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 16, 20),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 13,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: const Color(0xFFBD2B12).withValues(alpha: 0.08),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.stars_rounded, size: 12, color: const Color(0xFFBD2B12)),
                                  const SizedBox(width: 4),
                                  Text(
                                    'TOYOTA ACCESSIBILITY',
                                    style: AppTypography.captionSmall.copyWith(
                                      fontSize: 8.5,
                                      fontWeight: FontWeight.w900,
                                      color: const Color(0xFFBD2B12),
                                      letterSpacing: 0.6,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 12),

                            Text(
                              'Pesan Mobil Welcab',
                              style: AppTypography.title.copyWith(
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(height: 6),

                            // DESKRIPSI SINGKAT SOLUSI
                            Text(
                              'Antar-jemput medis dengan kursi otomatis. Praktis, aman, dan ramah disabilitas.',
                              style: AppTypography.caption.copyWith(
                                height: 1.35,
                              ),
                            ),
                            const SizedBox(height: 16),

                            // TOMBOL AKSI INTERNAL (Gojek Quick Pill Button)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                              decoration: BoxDecoration(
                                gradient: AppColors.gradient,
                                borderRadius: BorderRadius.circular(100), // Khas pil button ojol
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xFFBD2B12).withValues(alpha: 0.2),
                                    blurRadius: 8,
                                    offset: const Offset(0, 3),
                                  )
                                ],
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    'Pesan Sekarang',
                                    style: AppTypography.buttonSmall,
                                  ),
                                  const SizedBox(width: 4),
                                  const Icon(Icons.arrow_forward_rounded, size: 12, color: Colors.white),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      // AREA KANAN: Space Kosong untuk Menampung Gambar Pop-Out Canvas
                      const Expanded(
                        flex: 7,
                        child: SizedBox(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // 2. SISI KANAN: POP-OUT VECTOR ART (Menggambar Ilustrasi Armada Welcab Kustom via Canvas)
          Positioned(
            right: 4,
            bottom: 12,
            top: 12,
            child: IgnorePointer(
              child: FutureBuilder<ui.Image>(
                future: _generatePremiumWelcabArt(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
                    return RawImage(
                      image: snapshot.data,
                      width: 110,
                      height: 110,
                      fit: BoxFit.contain,
                    );
                  }
                  return const SizedBox(width: 110);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<ui.Image> _generatePremiumWelcabArt() async {
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder, const Rect.fromLTWH(0, 0, 200, 200));

    final bgGlowPaint = Paint()
      ..shader = ui.Gradient.radial(
        const Offset(100, 100),
        90,
        [const Color(0xFFE65100).withValues(alpha: 0.15), Colors.transparent],
      );
    canvas.drawCircle(const Offset(110, 110), 80, bgGlowPaint);

    final bgCirclePaint = Paint()
      ..shader = ui.Gradient.linear(
        const Offset(40, 40),
        const Offset(160, 160),
        [const Color(0xFFBD2B12), const Color(0xFFE65100)],
      );
    canvas.drawCircle(const Offset(120, 100), 65, bgCirclePaint);

    final carPaint = Paint()..color = Colors.white;
    final Path carPath = Path();
    
    carPath.moveTo(40, 125);   // Bemper Depan
    carPath.lineTo(60, 125);   // Kolong roda depan
    carPath.lineTo(130, 125);  // Kolong roda belakang
    carPath.lineTo(155, 125);  // Bemper belakang
    carPath.lineTo(155, 90);   // Bagasi belakang tegak lurus (Khas Van/Welcab)
    carPath.lineTo(135, 75);   // Atap belakang
    carPath.lineTo(85, 75);    // Atap depan
    carPath.lineTo(55, 95);    // Kaca depan melandai
    carPath.lineTo(40, 105);   // Kap mesin depan
    carPath.close();
    canvas.drawPath(carPath, carPaint);

    final windowPaint = Paint()..color = const Color(0xFF1E1E1E);
    final Path windowPath = Path();
    windowPath.moveTo(60, 96);
    windowPath.lineTo(85, 80);
    windowPath.lineTo(130, 80);
    windowPath.lineTo(150, 92);
    windowPath.lineTo(130, 98);
    windowPath.lineTo(60, 98);
    windowPath.close();
    canvas.drawPath(windowPath, windowPaint);

    final wheelPaint = Paint()..color = const Color(0xFF1E1E1E);
    final wheelInnerPaint = Paint()..color = Colors.grey[400]!;
    canvas.drawCircle(const Offset(65, 125), 14, wheelPaint);
    canvas.drawCircle(const Offset(65, 125), 6, wheelInnerPaint);
    canvas.drawCircle(const Offset(125, 125), 14, wheelPaint);
    canvas.drawCircle(const Offset(125, 125), 6, wheelInnerPaint);

    final textPainter = TextPainter(textDirection: TextDirection.ltr);
    textPainter.text = TextSpan(
      text: String.fromCharCode(Icons.accessible_forward_rounded.codePoint),
      style: TextStyle(
        fontSize: 32,
        fontFamily: Icons.accessible_forward_rounded.fontFamily,
        color: const Color(0xFFBD2B12), 
        fontWeight: FontWeight.bold,
      ),
    );
    textPainter.layout();
    textPainter.paint(canvas, const Offset(88, 95));

    final picture = recorder.endRecording();
    return await picture.toImage(200, 200);
  }
}