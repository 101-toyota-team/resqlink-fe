import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../widgets/home/hero_container.dart';
import '../../widgets/home/balance_card.dart';
import '../../widgets/home/search_bar.dart'; // Buat file terpisah untuk widget lainnya
import '../../widgets/home/emergency_call_card.dart';
import '../../widgets/home/ambulance_tabs.dart';
import '../../widgets/home/kenali_jenis_section.dart';
import '../../widgets/home/health_mobility_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HeroContainer(),
              BalanceCard(),
              SizedBox(height: 16),
              SearchCard(), // Sesuaikan nama kelas jika perlu
              SizedBox(height: 16),
              EmergencyCallCard(),
              SizedBox(height: 16),
              AmbulanceTypeTabs(),
              SizedBox(height: 16),
              KenaliJenisSection(),
              SizedBox(height: 16),
              HealthMobilityCard(),
              SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}