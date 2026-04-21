import 'package:flutter/material.dart';

// =============================================================
// WARNA & TEMA
// =============================================================
class AppColors {
  static const Color primary = Color(0xFFB5351A);    // Merah gelap / maroon
  static const Color primaryLight = Color(0xFFD94C2B); // Merah terang
  static const Color secondary = Color(0xFFF5ECD7);   // Krem/beige background
  static const Color cardBg = Color(0xFFFDF6EC);       // Putih hangat
  static const Color darkBrown = Color(0xFF5C2D1A);    // Coklat gelap (section header)
  static const Color amber = Color(0xFFC8821A);        // Kuning amber
  static const Color textDark = Color(0xFF1A1A1A);
  static const Color textGrey = Color(0xFF6B6B6B);
  static const Color white = Colors.white;
  static const Color divider = Color(0xFFE8D5BB);
}

// =============================================================
// HOME SCREEN
// =============================================================
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondary,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Top Bar ──────────────────────────────────────
              _TopBar(),
              // ── Greeting ─────────────────────────────────────
              _GreetingSection(),
              // ── Hero Banner ───────────────────────────────────
              _HeroBanner(),
              const SizedBox(height: 16),
              // ── Balance & Actions ─────────────────────────────
              _BalanceCard(),
              const SizedBox(height: 16),
              // ── Search Bar ────────────────────────────────────
              _SearchBar(),
              const SizedBox(height: 16),
              // ── Emergency Call Card ───────────────────────────
              _EmergencyCallCard(),
              const SizedBox(height: 16),
              // ── Ambulance Type Tabs ───────────────────────────
              _AmbulanceTypeTabs(),
              const SizedBox(height: 16),
              // ── Kenali Jenis Ambulan Section ──────────────────
              _KenaliJenisSection(),
              const SizedBox(height: 16),
              // ── Health Mobility Service ───────────────────────
              _HealthMobilityCard(),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

// =============================================================
// TOP BAR
// =============================================================
class _TopBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        children: [
          // Logo
          Row(
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.local_hospital, color: Colors.white, size: 20),
              ),
              const SizedBox(width: 8),
              RichText(
                text: const TextSpan(
                  children: [
                    TextSpan(
                      text: 'Res',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w800,
                        fontSize: 22,
                      ),
                    ),
                    TextSpan(
                      text: 'Q',
                      style: TextStyle(
                        color: AppColors.amber,
                        fontWeight: FontWeight.w800,
                        fontSize: 22,
                      ),
                    ),
                    TextSpan(
                      text: 'Link',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w800,
                        fontSize: 22,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Spacer(),
          // Notification bell
          Stack(
            children: [
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.notifications_outlined,
                    color: AppColors.textDark, size: 26),
              ),
              Positioned(
                right: 10,
                top: 10,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
          // Avatar
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.primary, width: 2),
            ),
            child: ClipOval(
              // Ganti dengan Image.asset('assets/avatar.png') jika ada asset
              child: Container(
                color: const Color(0xFFE8C4A0),
                child: const Icon(Icons.person, color: AppColors.primary),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// =============================================================
// GREETING
// =============================================================
class _GreetingSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Selamat Pagi,',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textGrey,
              fontWeight: FontWeight.w400,
            ),
          ),
          Text(
            'Clara',
            style: TextStyle(
              fontSize: 26,
              color: AppColors.textDark,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

// =============================================================
// HERO BANNER
// =============================================================
class _HeroBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Container(
        width: double.infinity,
        height: 160,
        decoration: BoxDecoration(
          color: AppColors.cardBg,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Background decorative circle (kanan atas)
            Positioned(
              right: -20,
              top: -20,
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: AppColors.secondary.withOpacity(0.6),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            // Tombol "Butuh Bantuan Darurat!"
            Positioned(
              top: 16,
              right: 12,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.darkBrown,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'Butuh Bantuan Darurat!',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            // Ilustrasi ambulans / paramedis
            // Ganti dengan Image.asset('assets/hero_banner.png') jika ada
            Positioned(
              left: 0,
              bottom: 0,
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(16),
                ),
                child: Container(
                  width: 230,
                  height: 120,
                  color: Colors.transparent,
                  // Placeholder paramedic illustration
                  child: CustomPaint(
                    painter: _ParamedicIllustrationPainter(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Simple placeholder painter untuk hero (ganti dengan Image.asset)
class _ParamedicIllustrationPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = AppColors.secondary;
    // Gambar placeholder sederhana – ganti dengan Image.asset di production
    final personPaint = Paint()..color = const Color(0xFF8B4513);
    canvas.drawCircle(Offset(size.width * 0.25, size.height * 0.25), 18, personPaint);
    final bodyPaint = Paint()..color = const Color(0xFF1A5276);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(size.width * 0.15, size.height * 0.38, 36, 50),
        const Radius.circular(4),
      ),
      bodyPaint,
    );
    // Stretcher
    final stretcherPaint = Paint()..color = const Color(0xFFAAAAAA);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(size.width * 0.25, size.height * 0.55, 100, 12),
        const Radius.circular(4),
      ),
      stretcherPaint,
    );
    // Patient
    final patientPaint = Paint()..color = const Color(0xFFF0D9A0);
    canvas.drawCircle(Offset(size.width * 0.58, size.height * 0.48), 12, patientPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// =============================================================
// BALANCE CARD
// =============================================================
class _BalanceCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            // Wallet icon + balance
            const Icon(Icons.account_balance_wallet_outlined,
                color: AppColors.primary, size: 22),
            const SizedBox(width: 10),
            const Text(
              'Rp100.000',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(width: 4),
            const Icon(Icons.visibility_outlined,
                color: AppColors.textGrey, size: 16),
            const Spacer(),
            // Action buttons
            _ActionButton(icon: Icons.add, label: 'Top-up'),
            const SizedBox(width: 18),
            _ActionButton(icon: Icons.history, label: 'Riwayat'),
            const SizedBox(width: 18),
            _ActionButton(icon: Icons.more_horiz, label: 'Lainnya'),
          ],
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  const _ActionButton({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: AppColors.secondary,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: AppColors.primary, size: 18),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 10,
            color: AppColors.textGrey,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

// =============================================================
// SEARCH BAR
// =============================================================
class _SearchBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: TextField(
          decoration: InputDecoration(
            hintText: 'Cari',
            hintStyle: const TextStyle(color: AppColors.textGrey, fontSize: 15),
            border: InputBorder.none,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
            suffixIcon: Container(
              margin: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.search, color: Colors.white, size: 22),
            ),
          ),
        ),
      ),
    );
  }
}

// =============================================================
// EMERGENCY CALL CARD
// =============================================================
class _EmergencyCallCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Text content
            Expanded(
              child: Column(
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
                          fontSize: 13, fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            // 911 badge
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: const Text(
                '911',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// =============================================================
// AMBULANCE TYPE TABS
// =============================================================
class _AmbulanceTypeTabs extends StatelessWidget {
  final List<_AmbulanceTabData> tabs = const [
    _AmbulanceTabData(
      label: 'Ambulan\nMedis',
      color: Color(0xFFFFE8D6),
      iconColor: Color(0xFFD94C2B),
      borderColor: Color(0xFFD94C2B),
    ),
    _AmbulanceTabData(
      label: 'Ambulan\nSosial',
      color: Color(0xFFD6E8FF),
      iconColor: Color(0xFF1A5CB5),
      borderColor: Color(0xFF1A5CB5),
    ),
    _AmbulanceTabData(
      label: 'Ambulan\nJenazah',
      color: Color(0xFFD6F5D6),
      iconColor: Color(0xFF1A8A2E),
      borderColor: Color(0xFF1A8A2E),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: tabs
            .map((tab) => Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: _AmbulanceTabCard(data: tab),
                  ),
                ))
            .toList(),
      ),
    );
  }
}

class _AmbulanceTabData {
  final String label;
  final Color color;
  final Color iconColor;
  final Color borderColor;
  const _AmbulanceTabData({
    required this.label,
    required this.color,
    required this.iconColor,
    required this.borderColor,
  });
}

class _AmbulanceTabCard extends StatelessWidget {
  final _AmbulanceTabData data;
  const _AmbulanceTabCard({required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      decoration: BoxDecoration(
        color: data.color,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: data.borderColor, width: 1.5),
      ),
      child: Column(
        children: [
          // Ambulance icon placeholder – ganti dengan Image.asset
          Container(
            height: 48,
            alignment: Alignment.center,
            child: Icon(Icons.airport_shuttle, color: data.iconColor, size: 36),
          ),
          const SizedBox(height: 6),
          Text(
            data.label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: data.iconColor,
              height: 1.3,
            ),
          ),
        ],
      ),
    );
  }
}

// =============================================================
// KENALI JENIS AMBULAN SECTION
// =============================================================
class _KenaliJenisSection extends StatelessWidget {
  final List<_AmbulanceTypeData> types = const [
    _AmbulanceTypeData(
      name: 'Ambulan Darurat',
      desc: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore.',
      showButton: true,
      iconColor: Color(0xFFD94C2B),
      bgColor: Color(0xFFFFF3EE),
    ),
    _AmbulanceTypeData(
      name: 'Ambulan Medis',
      desc: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore.',
      showButton: false,
      iconColor: Color(0xFF1A5CB5),
      bgColor: Color(0xFFEEF3FF),
    ),
    _AmbulanceTypeData(
      name: 'Ambulan Sosial',
      desc: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore.',
      showButton: false,
      iconColor: Color(0xFF1A8A2E),
      bgColor: Color(0xFFEEFFF0),
    ),
    _AmbulanceTypeData(
      name: 'Ambulan Jenazah',
      desc: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore.',
      showButton: false,
      iconColor: Color(0xFF555555),
      bgColor: Color(0xFFF5F5F5),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.darkBrown,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 18, 16, 4),
              child: Column(
                children: const [
                  Text(
                    'Kenali Jenis-Jenis Ambulan',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Pilih ambulans sesuai kebutuhan Anda',
                    style: TextStyle(
                      color: Color(0xFFDDC8A8),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            // Cards
            ...types.map((t) => Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                  child: _AmbulanceTypeCard(data: t),
                )),
            const SizedBox(height: 14),
          ],
        ),
      ),
    );
  }
}

class _AmbulanceTypeData {
  final String name;
  final String desc;
  final bool showButton;
  final Color iconColor;
  final Color bgColor;
  const _AmbulanceTypeData({
    required this.name,
    required this.desc,
    required this.showButton,
    required this.iconColor,
    required this.bgColor,
  });
}

class _AmbulanceTypeCard extends StatelessWidget {
  final _AmbulanceTypeData data;
  const _AmbulanceTypeCard({required this.data});

  @override
  Widget build(BuildContext context) {
    // First card (Ambulan Darurat) has image left, text right + button
    // Others have text left, image right
    final isFirst = data.showButton;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: isFirst
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    // Ambulance image placeholder
                    Container(
                      width: 80,
                      height: 60,
                      decoration: BoxDecoration(
                        color: data.bgColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(Icons.airport_shuttle,
                          color: data.iconColor, size: 40),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            data.name,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textDark,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            data.desc,
                            style: const TextStyle(
                              fontSize: 11,
                              color: AppColors.textGrey,
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                ElevatedButton.icon(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 9),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    elevation: 0,
                  ),
                  icon: const Icon(Icons.phone, size: 15),
                  label: const Text(
                    'Hubungi Sekarang',
                    style:
                        TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            )
          : Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        data.name,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textDark,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        data.desc,
                        style: const TextStyle(
                          fontSize: 11,
                          color: AppColors.textGrey,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                // Ambulance image placeholder
                Container(
                  width: 70,
                  height: 55,
                  decoration: BoxDecoration(
                    color: data.bgColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(Icons.airport_shuttle,
                      color: data.iconColor, size: 36),
                ),
              ],
            ),
    );
  }
}

// =============================================================
// HEALTH MOBILITY SERVICE CARD
// =============================================================
class _HealthMobilityCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 18, 0, 18),
        decoration: BoxDecoration(
          color: AppColors.cardBg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.divider, width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Health Mobility Service',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Sewa dan pesan alat medis dengan mudah untuk mendukung kebutuhan perawatan Anda di mana saja.',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textGrey,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 14),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Pesan Sekarang',
                      style: TextStyle(
                          fontSize: 13, fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            // Doctor illustration placeholder – ganti dengan Image.asset
            SizedBox(
              width: 90,
              height: 110,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Circle background
                  Positioned(
                    bottom: 0,
                    child: Container(
                      width: 70,
                      height: 70,
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.12),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  // Doctor icon
                  const Icon(
                    Icons.medical_services_outlined,
                    size: 50,
                    color: AppColors.primary,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}