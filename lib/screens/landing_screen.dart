import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../themes/app_theme.dart';
import 'login_screen.dart';
import 'register_type_screen.dart';

class LandingScreen extends StatefulWidget {
  const LandingScreen({super.key});
  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen>
    with SingleTickerProviderStateMixin {
  late final PageController _pageController;
  late final AnimationController _fadeCtrl;
  late final Animation<double> _fadeAnim;
  int _currentPage = 0;

  final List<_Slide> _slides = const [
    _Slide(
      icon: Icons.electric_bolt_rounded,
      color: Color(0xFFE07B3A),
      title: 'Respons cepat\nsaat dibutuhkan',
      sub: 'Hubungkan dengan ambulans terdekat\ndengan mudah.',
    ),
    _Slide(
      icon: Icons.location_on_rounded,
      color: Color(0xFF1A7F87),
      title: 'Lacak perjalanan\nambulans',
      sub: 'Lihat posisi ambulans secara langsung\nsampai tiba.',
    ),
    _Slide(
      icon: Icons.receipt_long_rounded,
      color: Color(0xFF5FA8AE),
      title: 'Informasi biaya\nyang jelas',
      sub: 'Lihat estimasi biaya sebelum\nmelanjutkan.',
    ),
    _Slide(
      icon: Icons.local_hospital_rounded,
      color: Color(0xFF0F5C63),
      title: 'Terhubung dengan\nfasilitas kesehatan',
      sub: 'Informasi penting dapat diteruskan\nsebelum pasien tiba.',
    ),
  ];

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    _pageController = PageController();
    _fadeCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 600));
    _fadeAnim = CurvedAnimation(parent: _fadeCtrl, curve: Curves.easeOut);
    _fadeCtrl.forward();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _fadeCtrl.dispose();
    super.dispose();
  }

  void _goLogin() => Navigator.pushReplacement(
      context, _fade(const LoginScreen()));

  void _goRegister() => Navigator.push(
      context, _slide(const RegisterTypeScreen()));

  @override
  Widget build(BuildContext context) {
    final mq      = MediaQuery.of(context);
    final screenH = mq.size.height;
    final topPad  = mq.padding.top;
    final botPad  = mq.padding.bottom;

    return Scaffold(
      backgroundColor: AppColors.tealDeep,
      body: FadeTransition(
        opacity: _fadeAnim,
        child: Column(
          children: [
            // ── HERO — teal top 58% ──────────────────────
            SizedBox(
              height: screenH * 0.58,
              child: Stack(
                children: [
                  // Background gradient
                  Positioned.fill(
                    child: Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [AppColors.tealDeep, Color(0xFF1D8E97)],
                        ),
                      ),
                    ),
                  ),

                  // Decorative rings
                  Positioned(
                    right: -50, top: topPad - 60,
                    child: _ring(300, 0.07),
                  ),
                  Positioned(
                    right: 30, top: topPad + 10,
                    child: _ring(140, 0.05),
                  ),
                  Positioned(
                    left: -70, bottom: -50,
                    child: Container(
                      width: 240, height: 240,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.orange.withOpacity(0.13),
                      ),
                    ),
                  ),

                  // Content
                  Positioned.fill(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(28, topPad + 20, 28, 28),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // ── Logo — ASLI, tidak diputihkan ──
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/images/ResQLink_Logo.png',
                                height: 48,
                              ),
                              const SizedBox(width: 12),
                              Text(
                                'ResQLink',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                  letterSpacing: -0.5,
                                ),
                              ),
                            ],
                          ),

                          const Spacer(),

                          // ── Slide area ──
                          SizedBox(
                            height: screenH * 0.27,
                            child: PageView.builder(
                              controller: _pageController,
                              onPageChanged: (i) =>
                                  setState(() => _currentPage = i),
                              itemCount: _slides.length,
                              itemBuilder: (_, i) =>
                                  _SlideWidget(slide: _slides[i]),
                            ),
                          ),
                          const SizedBox(height: 22),

                          // ── Dots ──
                          Row(
                            children: List.generate(
                              _slides.length,
                              (i) => AnimatedContainer(
                                duration: const Duration(milliseconds: 250),
                                margin: const EdgeInsets.only(right: 6),
                                width: i == _currentPage ? 24 : 6,
                                height: 6,
                                decoration: BoxDecoration(
                                  color: i == _currentPage
                                      ? Colors.white
                                      : Colors.white.withOpacity(0.28),
                                  borderRadius: BorderRadius.circular(3),
                                ),
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

            // ── CTA CARD — white bottom 42% ──────────────
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
                ),
                padding: EdgeInsets.fromLTRB(24, 28, 24, botPad + 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Knob
                    Center(
                      child: Container(
                        width: 36, height: 4,
                        margin: const EdgeInsets.only(bottom: 24),
                        decoration: BoxDecoration(
                          color: AppColors.sep,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),

                    Text(
                      'Lebih siap dalam\nsituasi darurat',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 26,
                        fontWeight: FontWeight.w700,
                        color: AppColors.text,
                        height: 1.18,
                        letterSpacing: -0.7,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'ResQLink membantu Anda terhubung dengan layanan '
                      'ambulans secara cepat dan terkoordinasi.',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: AppColors.text2,
                        height: 1.55,
                        letterSpacing: -0.1,
                      ),
                    ),

                    const Spacer(),

                    // Buat akun
                    _Btn(
                      label: 'Buat akun',
                      onTap: _goRegister,
                      filled: true,
                    ),
                    const SizedBox(height: 10),

                    // Masuk
                    _Btn(
                      label: 'Masuk ke akun',
                      onTap: _goLogin,
                      filled: false,
                    ),
                    const SizedBox(height: 16),

                    Center(
                      child: Text(
                        'Dengan melanjutkan, Anda menyetujui Syarat Layanan\n'
                        'dan Kebijakan Privasi',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11.5,
                          color: AppColors.text3,
                          height: 1.6,
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

  Widget _ring(double s, double o) => Container(
        width: s, height: s,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white.withOpacity(o), width: 1),
        ),
      );

  PageRouteBuilder _fade(Widget p) => PageRouteBuilder(
        pageBuilder: (_, __, ___) => p,
        transitionsBuilder: (_, a, __, c) =>
            FadeTransition(opacity: a, child: c),
        transitionDuration: const Duration(milliseconds: 300),
      );

  PageRouteBuilder _slide(Widget p) => PageRouteBuilder(
        pageBuilder: (_, __, ___) => p,
        transitionsBuilder: (_, a, __, c) => SlideTransition(
          position: Tween(begin: const Offset(0, 1), end: Offset.zero)
              .animate(CurvedAnimation(parent: a, curve: Curves.easeOutCubic)),
          child: c,
        ),
        transitionDuration: const Duration(milliseconds: 380),
      );
}

// ── Slide data ────────────────────────────────────────────────────────────────
class _Slide {
  final IconData icon;
  final Color color;
  final String title;
  final String sub;
  const _Slide(
      {required this.icon,
      required this.color,
      required this.title,
      required this.sub});
}

// ── Slide widget ──────────────────────────────────────────────────────────────
class _SlideWidget extends StatelessWidget {
  const _SlideWidget({required this.slide});
  final _Slide slide;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 52, height: 52,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border:
                  Border.all(color: slide.color.withOpacity(0.3), width: 1),
              color: slide.color.withOpacity(0.15),
            ),
            child: Icon(slide.icon, color: Colors.white, size: 26),
          ),
          const SizedBox(height: 18),
          Text(
            slide.title,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 27,
              fontWeight: FontWeight.w700,
              color: Colors.white,
              height: 1.15,
              letterSpacing: -0.6,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            slide.sub,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 14,
              color: Colors.white.withOpacity(0.62),
              height: 1.55,
              letterSpacing: -0.1,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Button ────────────────────────────────────────────────────────────────────
class _Btn extends StatelessWidget {
  const _Btn({required this.label, required this.onTap, required this.filled});
  final String label;
  final VoidCallback onTap;
  final bool filled;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: filled
          ? ElevatedButton(
              onPressed: onTap,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.tealDeep,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
              ),
              child: Text(label,
                  style: GoogleFonts.plusJakartaSans(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      letterSpacing: -0.3)),
            )
          : OutlinedButton(
              onPressed: onTap,
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.tealDeep,
                side: const BorderSide(color: AppColors.sep, width: 1.5),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
              ),
              child: Text(label,
                  style: GoogleFonts.plusJakartaSans(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      letterSpacing: -0.2)),
            ),
    );
  }
}
