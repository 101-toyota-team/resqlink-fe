import 'package:flutter/material.dart';

// =============================================================
// WARNA & TEMA
// =============================================================
class AppColors {
  static const Color primary = Color(0xFFB5351A);
  static const Color primaryLight = Color(0xFFD94C2B);
  static const Color secondary = Color(0xFFF5ECD7);
  static const Color cardBg = Color(0xFFFDF6EC);
  static const Color darkBrown = Color(0xFF5C2D1A);
  static const Color amber = Color(0xFFC8821A);
  static const Color textDark = Color(0xFF1A1A1A);
  static const Color textGrey = Color(0xFF6B6B6B);
  static const Color white = Colors.white;
  static const Color divider = Color(0xFFE8D5BB);
  static const Color heroBg = Color(0xFFFFF7E9); // #FFF7E980 tanpa opacity (diterapkan di container)
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
              // ── TopBar + Greeting + HeroBanner dalam 1 container ──
              _HeroContainer(),
              // ── Balance Card ──────────────────────────────────────
              _BalanceCard(),
              const SizedBox(height: 16),
              _SearchBar(),
              const SizedBox(height: 16),
              _EmergencyCallCard(),
              const SizedBox(height: 16),
              _AmbulanceTypeTabs(),
              const SizedBox(height: 16),
              _KenaliJenisSection(),
              const SizedBox(height: 16),
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
// HERO CONTAINER  (TopBar + Greeting + HeroBanner)
// Background: #FFF7E9 dengan opacity 80%, ada medic_pattern di atas
// =============================================================
class _HeroContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Color(0xCCFFF7E9), // #FFF7E9 opacity ~80%
      ),
      child: Stack(
        children: [
          // Pattern di layer paling atas container
          Positioned.fill(
            child: Image.asset(
              'assets/images/medic_pattern.png',
              fit: BoxFit.cover,
              opacity: const AlwaysStoppedAnimation(0.15),
            ),
          ),
          // Konten
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _TopBar(),
              _GreetingSection(),
              _HeroBanner(),
            ],
          ),
        ],
      ),
    );
  }
}

// =============================================================
// TOP BAR
// Logo: 136x42px | Notif + Avatar: 36x36px
// =============================================================
class _TopBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Logo — 136 x 42 px
          Image.asset(
            'assets/images/ResQLink_Logo.png',
            width: 136,
            height: 42,
            fit: BoxFit.contain,
          ),
          const Spacer(),
          // Notification icon — 36 x 36 px
          SizedBox(
            width: 36,
            height: 36,
            child: Stack(
              children: [
                Center(
                  child: Icon(
                    Icons.notifications_outlined,
                    color: AppColors.textDark,
                    size: 26,
                  ),
                ),
                // Dot notifikasi
                Positioned(
                  right: 2,
                  top: 2,
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
          ),
          const SizedBox(width: 10),
          // Avatar — 36 x 36 px
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.primary, width: 2),
            ),
            child: ClipOval(
              // Ganti dengan Image.asset('assets/images/avatar.png') jika ada
              child: Container(
                color: const Color(0xFFE8C4A0),
                child: const Icon(Icons.person, color: AppColors.primary, size: 20),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// =============================================================
// GREETING SECTION
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
// HERO BANNER  (emergency image + tombol darurat)
// =============================================================
class _HeroBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
      child: SizedBox(
        width: double.infinity,
        height: 160,
        child: Stack(
          children: [
            // Gambar emergency full area
            Positioned.fill(
              child: Image.asset(
                'assets/images/emergency.png',
                fit: BoxFit.contain,
                alignment: Alignment.bottomLeft,
              ),
            ),
            // Tombol "Butuh Bantuan Darurat!" di kanan atas
            Positioned(
              top: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
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
          ],
        ),
      ),
    );
  }
}

// =============================================================
// BALANCE CARD
// Sesuai gambar: wallet icon + Rp100.000 + eye icon | Top-up | Riwayat | Lainnya
// =============================================================
class _BalanceCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Wallet icon dalam kotak kecil
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: AppColors.secondary,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.account_balance_wallet_outlined,
              color: AppColors.primary,
              size: 18,
            ),
          ),
          const SizedBox(width: 10),
          // Saldo
          const Text(
            'Rp100.000',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(width: 6),
          // Eye icon
          const Icon(
            Icons.visibility_outlined,
            color: AppColors.textGrey,
            size: 16,
          ),
          const Spacer(),
          // Divider vertikal
          Container(
            width: 1,
            height: 30,
            color: AppColors.divider,
          ),
          const SizedBox(width: 14),
          // Top-up
          _ActionButton(icon: Icons.add, label: 'Top-up'),
          const SizedBox(width: 14),
          // Riwayat
          _ActionButton(icon: Icons.history, label: 'Riwayat'),
          const SizedBox(width: 14),
          // Lainnya
          _ActionButton(icon: Icons.more_horiz, label: 'Lainnya'),
        ],
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
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            color: AppColors.secondary,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: AppColors.primary, size: 17),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 9,
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
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
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
              decoration: const BoxDecoration(
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
class _AmbulanceTabData {
  final String label;
  final Color color;
  final Color textColor;
  final Color borderColor;
  final String imagePath;
  const _AmbulanceTabData({
    required this.label,
    required this.color,
    required this.textColor,
    required this.borderColor,
    required this.imagePath,
  });
}

class _AmbulanceTypeTabs extends StatelessWidget {
  final List<_AmbulanceTabData> tabs = const [
    _AmbulanceTabData(
      label: 'Ambulan\nMedis',
      color: Color(0xFFFFE8D6),
      textColor: Color(0xFFD94C2B),
      borderColor: Color(0xFFD94C2B),
      imagePath: 'assets/images/ambulance_medis.png',
    ),
    _AmbulanceTabData(
      label: 'Ambulan\nSosial',
      color: Color(0xFFD6E8FF),
      textColor: Color(0xFF1A5CB5),
      borderColor: Color(0xFF1A5CB5),
      imagePath: 'assets/images/ambulance_sosial.png',
    ),
    _AmbulanceTabData(
      label: 'Ambulan\nJenazah',
      color: Color(0xFFD6F5D6),
      textColor: Color(0xFF1A8A2E),
      borderColor: Color(0xFF1A8A2E),
      imagePath: 'assets/images/ambulance_jenazah.png',
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
          // Label teks di atas
          Text(
            data.label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: data.textColor,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 8),
          // Gambar ambulance di bawah
          Image.asset(
            data.imagePath,
            height: 60,
            fit: BoxFit.contain,
          ),
        ],
      ),
    );
  }
}

// =============================================================
// KENALI JENIS AMBULAN SECTION
// =============================================================
class _AmbulanceTypeData {
  final String name;
  final String desc;
  final bool showButton;
  final String imagePath;
  const _AmbulanceTypeData({
    required this.name,
    required this.desc,
    required this.showButton,
    required this.imagePath,
  });
}

class _KenaliJenisSection extends StatelessWidget {
  final List<_AmbulanceTypeData> types = const [
    _AmbulanceTypeData(
      name: 'Ambulan Darurat',
      desc: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore.',
      showButton: true,
      imagePath: 'assets/images/ambulance_darurat.png',
    ),
    _AmbulanceTypeData(
      name: 'Ambulan Medis',
      desc: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore.',
      showButton: false,
      imagePath: 'assets/images/ambulance_medis.png',
    ),
    _AmbulanceTypeData(
      name: 'Ambulan Sosial',
      desc: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore.',
      showButton: false,
      imagePath: 'assets/images/ambulance_sosial.png',
    ),
    _AmbulanceTypeData(
      name: 'Ambulan Jenazah',
      desc: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore.',
      showButton: false,
      imagePath: 'assets/images/ambulance_jenazah.png',
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
            ...types.map((t) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                  child: _AmbulanceTypeCard(data: t),
                )),
            const SizedBox(height: 14),
          ],
        ),
      ),
    );
  }
}

class _AmbulanceTypeCard extends StatelessWidget {
  final _AmbulanceTypeData data;
  const _AmbulanceTypeCard({required this.data});

  @override
  Widget build(BuildContext context) {
    final isFirst = data.showButton;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: isFirst
          // ── Ambulan Darurat: gambar kiri, teks kanan, tombol full width bawah
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Image.asset(
                      data.imagePath,
                      width: 100,
                      height: 70,
                      fit: BoxFit.contain,
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
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      elevation: 0,
                    ),
                    icon: const Icon(Icons.phone, size: 15),
                    label: const Text(
                      'Hubungi Sekarang',
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ],
            )
          // ── Card lainnya: teks kiri, gambar kanan
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
                Image.asset(
                  data.imagePath,
                  width: 80,
                  height: 65,
                  fit: BoxFit.contain,
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
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            SizedBox(
              width: 100,
              height: 120,
              child: Image.asset(
                'assets/images/dokter.png',
                fit: BoxFit.contain,
                alignment: Alignment.bottomCenter,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
