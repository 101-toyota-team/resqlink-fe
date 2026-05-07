import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../constants/app_colors.dart';
import '../../screens/profile/profile_screen.dart';

class HeroContainer extends StatelessWidget {
  final String userName;

  const HeroContainer({super.key, required this.userName});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(color: AppColors.heroBg),
      child: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/medic_pattern.png',
              fit: BoxFit.cover,
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _TopBar(),
              _GreetingSection(userName: userName),
              const _HeroBanner(),
            ],
          ),
        ],
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      child: Row(
        children: [
          Image.asset('assets/images/ResQLink_Logo.png', width: 136, height: 42, fit: BoxFit.contain),
          const Spacer(),
          _buildNotificationIcon(),
          const SizedBox(width: 10),
          _buildAvatar(context),
        ],
      ),
    );
  }

  Widget _buildNotificationIcon() {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: 42,
          height: 42,
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
          child: const Center(
            child: Icon(
              Icons.notifications_outlined,
              color: Colors.black,
              size: 24,
              fill: 1,
            ),
          ),
        ),

        Positioned(
          right: 2,
          top: 2,
          child: Container(
            width: 10,
            height: 10,
            decoration: const BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
            ),
          ),
        ),
      ],
    );
  }
  Widget _buildAvatar(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const ProfileScreen()),
        );
      },
      child: Container(
        width: 36, height: 36,
        decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: AppColors.primary, width: 2)),
        child: ClipOval(
          child: Container(color: const Color(0xFFE8C4A0), child: const Icon(Icons.person, color: AppColors.primary, size: 20)),
        ),
      ),
    );
  }
}

class _GreetingSection extends StatelessWidget {
  final String userName;

  const _GreetingSection({required this.userName});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Selamat Datang,', style: TextStyle(fontSize: 14, color: AppColors.textGrey)),
          Text(userName, style: const TextStyle(fontSize: 26, color: AppColors.textDark, fontWeight: FontWeight.w800)),
        ],
      ),
    );
  }
}

class _HeroBanner extends StatelessWidget {
  const _HeroBanner();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
      child: SizedBox(
        width: double.infinity,
        height: 160,
        child: SvgPicture.asset(
          'assets/images/emergency-1.svg',
          fit: BoxFit.contain,
          alignment: Alignment.bottomLeft,
        ),
      ),
    );
  }
}