import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
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
        backgroundColor: AppColors.surface,
        body: Column(
          children: [
            // ── Header ──────────────────────────────────────
            Container(
              padding: EdgeInsets.fromLTRB(24, topPad + 14, 24, 24),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [AppColors.tealDeep, Color(0xFF1D8E97)],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top row: back + logo
                  Row(
                    children: [
                      _BackBtn(onTap: () => Navigator.pop(context)),
                      const Spacer(),
                      Image.asset(
                        'assets/images/ResQLink_Logo.png',
                        height: 32,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Daftar sebagai',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      letterSpacing: -0.7,
                      height: 1.15,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'Pilih jenis akun yang sesuai kebutuhan Anda',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 14,
                      color: Colors.white.withOpacity(0.65),
                      letterSpacing: -0.1,
                    ),
                  ),
                ],
              ),
            ),

            // ── Cards ────────────────────────────────────────
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(20, 20, 20, botPad + 24),
                child: Column(
                  children: [
                    _TypeCard(
                      icon: Icons.person_rounded,
                      iconBg: AppColors.tealSoft,
                      iconColor: AppColors.teal,
                      accentColor: AppColors.teal,
                      label: 'Pengguna',
                      sublabel: 'Akun Personal',
                      description:
                          'Pesan ambulans, lacak kendaraan secara real-time, dan akses layanan darurat kapan saja.',
                      features: const [
                        'Pemesanan ambulans cepat',
                        'Lacak ambulans live',
                        'Riwayat & pembayaran digital',
                      ],
                      onTap: () => Navigator.push(
                        context,
                        _slideRight(const RegisterScreen()),
                      ),
                    ),
                    const SizedBox(height: 14),

                    _TypeCard(
                      icon: Icons.local_hospital_rounded,
                      iconBg: const Color(0xFFFFF0E8),
                      iconColor: AppColors.orange,
                      accentColor: AppColors.orange,
                      label: 'Penyedia Layanan',
                      sublabel: 'Akun Provider',
                      badge: 'Untuk Institusi',
                      description:
                          'Daftarkan armada ambulans, kelola dispatcher, dan terima pesanan dari pengguna.',
                      features: const [
                        'Manajemen armada & driver',
                        'Dashboard dispatch real-time',
                        'Tambah admin & operator',
                      ],
                      onTap: () => Navigator.push(
                        context,
                        _slideRight(const RegisterProviderScreen()),
                      ),
                    ),
                    const SizedBox(height: 28),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Sudah punya akun? ',
                            style: GoogleFonts.plusJakartaSans(
                                fontSize: 14, color: AppColors.text2)),
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Text('Masuk',
                              style: GoogleFonts.plusJakartaSans(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.teal)),
                        ),
                      ],
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

  PageRouteBuilder _slideRight(Widget p) => PageRouteBuilder(
        pageBuilder: (_, __, ___) => p,
        transitionsBuilder: (_, a, __, c) => SlideTransition(
          position: Tween(begin: const Offset(1, 0), end: Offset.zero)
              .animate(CurvedAnimation(parent: a, curve: Curves.easeOutCubic)),
          child: c,
        ),
        transitionDuration: const Duration(milliseconds: 320),
      );
}

// ── Type card ─────────────────────────────────────────────────────────────────
class _TypeCard extends StatefulWidget {
  const _TypeCard({
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.accentColor,
    required this.label,
    required this.sublabel,
    required this.description,
    required this.features,
    required this.onTap,
    this.badge,
  });

  final IconData icon;
  final Color iconBg, iconColor, accentColor;
  final String label, sublabel, description;
  final List<String> features;
  final VoidCallback onTap;
  final String? badge;

  @override
  State<_TypeCard> createState() => _TypeCardState();
}

class _TypeCardState extends State<_TypeCard> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) { setState(() => _pressed = false); widget.onTap(); },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedScale(
        scale: _pressed ? 0.974 : 1.0,
        duration: const Duration(milliseconds: 110),
        child: Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.sep),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 14,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 50, height: 50,
                    decoration: BoxDecoration(
                      color: widget.iconBg,
                      borderRadius: BorderRadius.circular(13),
                    ),
                    child: Icon(widget.icon,
                        color: widget.iconColor, size: 24),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(widget.label,
                                style: GoogleFonts.plusJakartaSans(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.text,
                                    letterSpacing: -0.4)),
                            if (widget.badge != null) ...[
                              const SizedBox(width: 7),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 7, vertical: 2),
                                decoration: BoxDecoration(
                                  color:
                                      widget.accentColor.withOpacity(0.10),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Text(widget.badge!,
                                    style: GoogleFonts.plusJakartaSans(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w600,
                                        color: widget.accentColor)),
                              ),
                            ],
                          ],
                        ),
                        const SizedBox(height: 2),
                        Text(widget.sublabel,
                            style: GoogleFonts.plusJakartaSans(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: widget.accentColor)),
                      ],
                    ),
                  ),
                  const SizedBox(width: 6),
                  Icon(Icons.arrow_forward_ios_rounded,
                      size: 13, color: AppColors.text3),
                ],
              ),

              const SizedBox(height: 12),
              Divider(color: AppColors.sep, height: 1, thickness: 1),
              const SizedBox(height: 12),

              Text(widget.description,
                  style: GoogleFonts.plusJakartaSans(
                      fontSize: 13,
                      color: AppColors.text2,
                      height: 1.55,
                      letterSpacing: -0.1)),
              const SizedBox(height: 12),

              ...widget.features.map((f) => Padding(
                    padding: const EdgeInsets.only(bottom: 7),
                    child: Row(
                      children: [
                        Container(
                          width: 17, height: 17,
                          decoration: BoxDecoration(
                            color: widget.accentColor.withOpacity(0.12),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(Icons.check_rounded,
                              size: 10, color: widget.accentColor),
                        ),
                        const SizedBox(width: 9),
                        Text(f,
                            style: GoogleFonts.plusJakartaSans(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: AppColors.text,
                                letterSpacing: -0.1)),
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

// ── Shared back button ────────────────────────────────────────────────────────
class _BackBtn extends StatelessWidget {
  const _BackBtn({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 38, height: 38,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.15),
          borderRadius: BorderRadius.circular(11),
          border: Border.all(color: Colors.white.withOpacity(0.2), width: 0.5),
        ),
        child: const Icon(Icons.arrow_back_ios_new_rounded,
            color: Colors.white, size: 16),
      ),
    );
  }
}
