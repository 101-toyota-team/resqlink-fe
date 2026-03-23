import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../themes/app_theme.dart';
import '../themes/app_theme.dart';
import 'register_screen.dart';
import 'register_provider_screen.dart';

class RegisterTypeScreen extends StatelessWidget {
  const RegisterTypeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final mq     = MediaQuery.of(context);
    final topPad = mq.padding.top;
    final botPad = mq.padding.bottom;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: C.bg,
        body: Column(
          children: [
            // ── Dark header ──────────────────────────────
            Container(
              padding: EdgeInsets.fromLTRB(24, topPad + 14, 24, 28),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [C.bg, Color(0xFF0D3A3F)],
                ),
              ),
              child: Stack(
                children: [
                  // Glow
                  Positioned(
                    right: -40, top: -40,
                    child: Container(
                      width: 180, height: 180,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: C.teal500.withOpacity(0.14),
                      ),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Top row
                      Row(
                        children: [
                          _BackBtn(onTap: () => Navigator.pop(context)),
                          const Spacer(),
                          Image.asset(
                            'assets/images/ResQLink_Logo.png',
                            height: 36,
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      Text('Daftar\nsebagai apa?',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 30,
                            fontWeight: FontWeight.w800,
                            color: C.white,
                            height: 1.1,
                            letterSpacing: -0.9,
                          )),
                      const SizedBox(height: 8),
                      Text(
                          'Pilih tipe akun yang sesuai dengan kebutuhan Anda',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 14,
                            color: C.white60,
                            letterSpacing: -0.1,
                          )),
                    ],
                  ),
                ],
              ),
            ),

            // ── Cards ────────────────────────────────────
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: C.bgSheet,
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(28)),
                ),
                child: SingleChildScrollView(
                  padding:
                      EdgeInsets.fromLTRB(20, 24, 20, botPad + 24),
                  child: Column(
                    children: [
                      // Pill knob
                      Container(
                        width: 40, height: 4,
                        margin: const EdgeInsets.only(bottom: 20),
                        decoration: BoxDecoration(
                          color: const Color(0xFFDDE4E5),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),

                      _TypeCard(
                        icon: Icons.person_rounded,
                        iconColor: C.teal500,
                        iconBg: const Color(0xFFEAF5F6),
                        accentColor: C.teal500,
                        title: 'Pengguna',
                        badge: 'Personal',
                        badgeColor: C.teal500,
                        description:
                            'Butuh ambulans sekarang? Pesan dalam hitungan detik, lacak secara live, dan bayar transparan.',
                        features: const [
                          'Pesan ambulans dalam < 30 detik',
                          'Live tracking hingga tiba',
                          'Riwayat & invoice digital',
                          'Tombol SOS darurat',
                        ],
                        onTap: () => Navigator.push(
                          context,
                          _slide(const RegisterScreen()),
                        ),
                      ),
                      const SizedBox(height: 14),

                      _TypeCard(
                        icon: Icons.local_hospital_rounded,
                        iconColor: C.amber,
                        iconBg: const Color(0xFFFFF0E8),
                        accentColor: C.amber,
                        title: 'Penyedia Layanan',
                        badge: 'Provider / Institusi',
                        badgeColor: C.amber,
                        description:
                            'Rumah sakit, klinik, atau organisasi ambulans? Kelola armada, terima pesanan, dan koordinasi dispatch secara digital.',
                        features: const [
                          'Manajemen armada & driver',
                          'Dashboard dispatch real-time',
                          'Tambah admin & operator',
                          'Laporan & analitik operasional',
                        ],
                        onTap: () => Navigator.push(
                          context,
                          _slide(const RegisterProviderScreen()),
                        ),
                      ),
                      const SizedBox(height: 28),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Sudah punya akun? ',
                              style: GoogleFonts.plusJakartaSans(
                                  fontSize: 14, color: C.ink2)),
                          GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: Text('Masuk',
                                style: GoogleFonts.plusJakartaSans(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: C.teal500)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  PageRouteBuilder _slide(Widget p) => PageRouteBuilder(
        pageBuilder: (_, __, ___) => p,
        transitionsBuilder: (_, a, __, c) => SlideTransition(
          position: Tween(begin: const Offset(1, 0), end: Offset.zero)
              .animate(
                  CurvedAnimation(parent: a, curve: Curves.easeOutCubic)),
          child: c,
        ),
        transitionDuration: const Duration(milliseconds: 320),
      );
}

// ── Type card ─────────────────────────────────────────────────────────────────
class _TypeCard extends StatefulWidget {
  const _TypeCard({
    required this.icon,
    required this.iconColor,
    required this.iconBg,
    required this.accentColor,
    required this.title,
    required this.badge,
    required this.badgeColor,
    required this.description,
    required this.features,
    required this.onTap,
  });

  final IconData icon;
  final Color iconColor, iconBg, accentColor, badgeColor;
  final String title, badge, description;
  final List<String> features;
  final VoidCallback onTap;

  @override
  State<_TypeCard> createState() => _TypeCardState();
}

class _TypeCardState extends State<_TypeCard> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) {
        setState(() => _pressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedScale(
        scale: _pressed ? 0.972 : 1.0,
        duration: const Duration(milliseconds: 110),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: C.bgSheet,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: C.ghostBorder),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 20,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 52, height: 52,
                    decoration: BoxDecoration(
                      color: widget.iconBg,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Icon(widget.icon,
                        color: widget.iconColor, size: 26),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.title,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 17,
                              fontWeight: FontWeight.w800,
                              color: C.ink,
                              letterSpacing: -0.5,
                            )),
                        const SizedBox(height: 3),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: widget.badgeColor.withOpacity(0.10),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(widget.badge,
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                color: widget.badgeColor,
                                letterSpacing: 0.1,
                              )),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 30, height: 30,
                    decoration: BoxDecoration(
                      color: widget.accentColor.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(Icons.arrow_forward_rounded,
                        size: 16, color: widget.accentColor),
                  ),
                ],
              ),

              const SizedBox(height: 16),
              Container(height: 1, color: C.ghostBorder),
              const SizedBox(height: 14),

              Text(widget.description,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 13.5,
                    color: C.ink2,
                    height: 1.55,
                    letterSpacing: -0.1,
                  )),
              const SizedBox(height: 14),

              // Features
              ...widget.features.map((f) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        Container(
                          width: 18, height: 18,
                          decoration: BoxDecoration(
                            color: widget.accentColor.withOpacity(0.10),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(Icons.check_rounded,
                              size: 11,
                              color: widget.accentColor),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(f,
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: C.ink,
                                letterSpacing: -0.1,
                              )),
                        ),
                      ],
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}

class _BackBtn extends StatelessWidget {
  const _BackBtn({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: Container(
          width: 40, height: 40,
          decoration: BoxDecoration(
            color: C.white08,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: C.white20, width: 0.5),
          ),
          child: const Icon(Icons.arrow_back_ios_new_rounded,
              color: Colors.white, size: 16),
        ),
      );
}
