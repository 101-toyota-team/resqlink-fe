import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../themes/app_theme.dart';
import '../../themes/app_widgets.dart';
import '../../utils/page_transitions.dart';
import '../../widgets/common/type_card.dart';
import '../login/login_screen.dart';
import 'register_screen.dart';
import 'register_provider_screen.dart';

/// Screen to select registration type (Customer or Provider)
class RegisterTypeScreen extends StatelessWidget {
  const RegisterTypeScreen({super.key});

  void _navigateToCustomerRegister(BuildContext context) {
    Navigator.push(
      context,
      PageTransitions.slide(const RegisterScreen()),
    );
  }

  void _navigateToProviderRegister(BuildContext context) {
    Navigator.push(
      context,
      PageTransitions.slide(const RegisterProviderScreen()),
    );
  }

  void _navigateToLogin(BuildContext context) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: HeroShell(
        title: 'Daftar\nsebagai apa?',
        subtitle: 'Pilih tipe akun yang sesuai dengan kebutuhan Anda',
        heroFrac: 0.38,
        back: true,
        logoRight: true,
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            children: [
              _buildCustomerCard(context),
              const SizedBox(height: 14),
              _buildProviderCard(context),
              const SizedBox(height: 28),
              _buildLoginPrompt(context),
              const SizedBox(height: 18),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCustomerCard(BuildContext context) => TypeCard(
    icon: Icons.person_rounded,
    iconColor: C.teal500,
    iconBg: const Color(0xFFEAF6F7),
    accentColor: C.teal500,
    title: 'Pengguna',
    badge: 'Personal',
    badgeColor: C.teal500,
    description:
        'Pesan ambulans dengan lebih cepat, lacak perjalanannya, dan lihat informasi biaya dengan jelas.',
    features: const [
      'Pesan ambulans dengan cepat',
      'Lacak perjalanan secara langsung',
      'Riwayat dan invoice digital'
    ],
    onTap: () => _navigateToCustomerRegister(context),
  );

  Widget _buildProviderCard(BuildContext context) => TypeCard(
    icon: Icons.local_hospital_rounded,
    iconColor: C.amber,
    iconBg: const Color(0xFFFFF2EA),
    accentColor: C.amber,
    title: 'Penyedia Layanan',
    badge: 'Provider / Institusi',
    badgeColor: C.amber,
    description:
        'Kelola armada, terima pesanan, dan koordinasikan operasional ambulans dalam satu alur kerja.',
    features: const [
      'Manajemen armada dan driver',
      'Dashboard dispatch',
      'Tambah admin dan operator',
      'Laporan operasional',
    ],
    onTap: () => _navigateToProviderRegister(context),
  );

  Widget _buildLoginPrompt(BuildContext context) => Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text(
        'Sudah punya akun? ',
        style: GoogleFonts.plusJakartaSans(
          fontSize: 14,
          color: C.ink2,
        ),
      ),
      GestureDetector(
        onTap: () => _navigateToLogin(context),
        child: Text(
          'Masuk',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: C.teal500,
          ),
        ),
      ),
    ],
  );
}

