import 'package:flutter/material.dart';
import '../../themes/app_colors.dart';
import '../../themes/app_typography.dart';
import '../../services/auth_helper.dart';
import '../landing_screen.dart';
import 'privacy_policy_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late final Future<Map<String, dynamic>?> _profileFuture;

  @override
  void initState() {
    super.initState();
    _profileFuture = _loadProfile();
  }

  Future<Map<String, dynamic>?> _loadProfile() async {
    final user = AuthHelper.currentUser;
    if (user == null) {
      return null;
    }

    final metadata = user.userMetadata ?? <String, dynamic>{};
    final firstName = metadata['first_name']?.toString() ?? '';
    final lastName = metadata['last_name']?.toString() ?? '';
    final fullName = metadata['full_name']?.toString() ??
        [firstName, lastName].where((value) => value.isNotEmpty).join(' ').trim();
    final username = metadata['username']?.toString() ??
        user.email?.split('@').first ??
        '-';

    return {
      'username': username,
      'email': user.email ?? '-',
      'display_name': fullName.isNotEmpty ? fullName : username,
    };
  }

  Future<void> _handleLogout() async {
    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Logout'),
        content: const Text('Apakah Anda yakin ingin keluar?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: AppColors.primary),
            child: const Text('Ya, Keluar'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        await AuthHelper.logout();
        if (!mounted) return;
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const LandingScreen()),
          (route) => false,
        );
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Logout gagal. Silakan coba lagi.'),
            backgroundColor: AppColors.primary,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.textDark, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Profil',
          style: AppTypography.title.copyWith(color: AppColors.textDark, fontWeight: FontWeight.w800),
        ),
        centerTitle: true,
      ),
      body: FutureBuilder<Map<String, dynamic>?>(
        future: _profileFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: AppColors.primary));
          }

          if (snapshot.hasError || snapshot.data == null) {
            return Center(
              child: Text(
                'Gagal memuat profil',
                style: AppTypography.body,
              ),
            );
          }

          final profile = snapshot.data!;
          final displayName = profile['display_name'];
          final email = profile['email'];

          return SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 20),
                // Profile Header
                _buildProfileHeader(displayName, email),
                const SizedBox(height: 32),
                
                // Menu Sections
                _buildMenuSection(
                  title: 'Akun',
                  items: [
                    _ProfileMenuItem(
                      icon: Icons.person_outline_rounded,
                      title: 'Edit Profil',
                      onTap: () {},
                    ),
                    _ProfileMenuItem(
                      icon: Icons.notifications_none_rounded,
                      title: 'Notifikasi',
                      onTap: () {},
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildMenuSection(
                  title: 'Keamanan',
                  items: [
                    _ProfileMenuItem(
                      icon: Icons.lock_outline_rounded,
                      title: 'Ganti Kata Sandi',
                      onTap: () {},
                    ),
                    _ProfileMenuItem(
                      icon: Icons.security_outlined,
                      title: 'Kebijakan Privasi',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const PrivacyPolicyScreen()),
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                
                // Logout Button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: OutlinedButton.icon(
                      onPressed: _handleLogout,
                      icon: const Icon(Icons.logout_rounded, size: 20),
                      label: Text('Logout', style: AppTypography.button),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.primary,
                        side: const BorderSide(color: AppColors.primary, width: 2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildProfileHeader(String name, String email) {
    return Column(
      children: [
        Stack(
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.primary, width: 2),
                color: AppColors.secondary,
              ),
              child: const Center(
                child: Icon(Icons.person_rounded, size: 50, color: AppColors.primary),
              ),
            ),
            Positioned(
              right: 0,
              bottom: 0,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.camera_alt_rounded, size: 16, color: Colors.white),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          name,
          style: AppTypography.h3.copyWith(fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 4),
        Text(
          email,
          style: AppTypography.body,
        ),
      ],
    );
  }

  Widget _buildMenuSection({required String title, required List<_ProfileMenuItem> items}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTypography.label.copyWith(
              fontWeight: FontWeight.w800,
              color: AppColors.textGrey,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(
              color: AppColors.cardBg,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.divider),
            ),
            child: Column(
              children: items.asMap().entries.map((entry) {
                final index = entry.key;
                final item = entry.value;
                final isLast = index == items.length - 1;
                
                return Column(
                  children: [
                    ListTile(
                      onTap: item.onTap,
                      leading: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(item.icon, size: 20, color: AppColors.primary),
                      ),
                      title: Text(
                        item.title,
                        style: AppTypography.body.copyWith(
                          color: AppColors.textDark,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      trailing: const Icon(Icons.chevron_right_rounded, color: AppColors.textGrey),
                    ),
                    if (!isLast)
                      const Divider(height: 1, indent: 56, color: AppColors.divider),
                  ],
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileMenuItem {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  _ProfileMenuItem({
    required this.icon,
    required this.title,
    required this.onTap,
  });
}
